Pour configurer NGINX afin de rediriger les requêtes entrantes à partir de sous-domaines vers des applications conteneurisées tout en servant la page par défaut pour le domaine principal, vous devez créer une configuration NGINX qui associe chaque sous-domaine à un conteneur différent. Cette configuration s'appuie sur le concept de Virtual Hosts (hôtes virtuels) de NGINX.

Voici les étapes pour configurer cela :

1. Configurer les hôtes virtuels (Virtual Hosts) pour chaque sous-domaine
   Créez un fichier de configuration pour NGINX qui définira les hôtes virtuels pour le domaine principal et pour chaque sous-domaine.

2. Exemple de configuration NGINX
   Supposons que vous ayez le domaine example.com et deux sous-domaines app1.example.com et app2.example.com. Vous voulez que :

example.com affiche la page par défaut de NGINX.
app1.example.com redirige vers l'application contenue dans un conteneur sur le port 8081.
app2.example.com redirige vers l'application contenue dans un conteneur sur le port 8082.
Voici comment configurer NGINX pour cela :

a. Créer le fichier de configuration NGINX
Sur votre hôte, créez un fichier de configuration, par exemple /etc/nginx/conf.d/example.conf :

nginx
Copier le code
server {
listen 80;
server_name example.com;

    # Serve the default NGINX page for the main domain
    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}

server {
listen 80;
server_name app1.example.com;

    # Proxy requests to the first application
    location / {
        proxy_pass http://127.0.0.1:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
listen 80;
server_name app2.example.com;

    # Proxy requests to the second application
    location / {
        proxy_pass http://127.0.0.1:8082;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
b. Explications
server_name : Cette directive spécifie le domaine ou le sous-domaine que chaque bloc server doit gérer. NGINX dirigera les requêtes vers le bon serveur virtuel en fonction du Host de la requête.
proxy_pass : Cette directive dit à NGINX de transférer les requêtes entrantes au serveur d'application correspondant. Dans ce cas, app1.example.com redirige les requêtes vers l'application qui écoute sur http://127.0.0.1:8081, et app2.example.com vers http://127.0.0.1:8082.
proxy_set_header : Ces directives sont utilisées pour transmettre les informations du client d'origine (comme l'adresse IP) au serveur d'application.



server {
listen 80;
server_name frontend;
location / {
# This would be the directory where your React app's static files are stored at
root /usr/share/nginx/html;
try_files $uri /index.html;
}

location /services/m {
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-NginX-Proxy true;
proxy_pass http://backend:8080/services/m;
proxy_ssl_session_reuse off;
proxy_set_header Host $http_host;
proxy_cache_bypass $http_upgrade;
proxy_redirect off;
}
}


3. Configurer les conteneurs d'applications
   Assurez-vous que vos conteneurs d'application sont en cours d'exécution et qu'ils écoutent sur les ports appropriés.

Par exemple, vous pourriez lancer vos applications comme suit :

bash
Copier le code
docker run -d --name app1 -p 8081:80 your_app1_image
docker run -d --name app2 -p 8082:80 your_app2_image


4. Tester la configuration
   Après avoir créé et enregistré le fichier de configuration, testez la configuration NGINX pour vous assurer qu'il n'y a pas d'erreurs :

bash
Copier le code
sudo nginx -t
Si la configuration est correcte, rechargez NGINX pour appliquer les changements :

bash
Copier le code
sudo systemctl reload nginx
5. Vérifier les sous-domaines
   Assurez-vous que les enregistrements DNS de app1.example.com et app2.example.com pointent bien vers l'adresse IP de votre serveur NGINX.

6. Accéder à vos applications
   Maintenant, lorsque vous accédez à http://example.com, vous verrez la page par défaut de NGINX. Lorsque vous accédez à http://app1.example.com, NGINX redirigera les requêtes vers l'application à l'intérieur du conteneur qui écoute sur http://127.0.0.1:8081, et http://app2.example.com vers l'application qui écoute sur http://127.0.0.1:8082.

Conclusion
En suivant ces étapes, vous pouvez configurer NGINX pour rediriger les requêtes en fonction des sous-domaines vers les différentes applications conteneurisées sur votre serveur, tout en servant la page par défaut de NGINX pour le domaine principal.