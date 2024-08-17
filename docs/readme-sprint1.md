

# 1. Initialisation de son poste de devops

### Installation de la java jdk 17

lien de téléchargement open jdk 17: https://jdk.java.net/17/

### Installation de Maven

Lien de telechargement maven 3.9 https://maven.apache.org/download.cgi

### installation de git

lien de telechargement sur windows: https://git-scm.com/download/win

Instalation sur linux:

    sudo apt-get install git -y


### installation de git-flow

Installation sur windows:

Generalement l'installation de git installe directement git-flow.
Pour initialiser le git-flow sur notre projet il faut executer la commande

    git flow init

Installation sur linux:

    sudo apt-get install git-flow -y


### Installation d'un IDE vscode

lien de telehargement vscode: https://code.visualstudio.com/download
Se connecter en ssh avec vscode et editer vos scripts: https://aymeric-cucherousset.fr/visual-studio-code-ssh-vscode/

### Génération de la paire de clés ssh


Pour établir des connexions sécurisées à l’aide de SSH, vous devez générer une paire de clés publique et privée. Ces clés permettent d’authentifier et de crypter les communications avec les serveurs distants.

Le serveur distant utilise les clés publiques pour vérifier votre identité sur la base de leurs empreintes de clés SSH. Pendant ce temps, l’ordinateur local stocke les clés privées pour authentifier votre connexion SSH.

Lorsque vous vous connectez à un ordinateur distant, votre machine locale fournit la clé privée. Le serveur la compare ensuite à la clé publique associée pour vous accorder l’accès.

Deux algorithmes sont couramment utilisés pour générer des clés d’authentification :

- RSA – Une clé RSA SSH est considérée comme hautement sécurisée car elle a généralement une taille de clé plus importante, souvent 2048 ou 4096 bits. Elle est également plus compatible avec les anciens systèmes d’exploitation.

- Ed25519 – Un algorithme plus moderne avec une taille de clé standard plus petite de 256 bits. Il est tout aussi sûr et efficace qu’une clé RSA en raison de ses fortes propriétés cryptographiques. La compatibilité est plus faible, mais les systèmes d’exploitation les plus récents le prennent en charge. Il est recommandé de generer la paire de clé sans passphrase.

nous allons utiliser l'outils ssh-keygen en ligne de commande et nous allons utiliser un chiffrement RSA

    ssh-keygen -t rsa -b 4096

Il nous faudra ensuite donner les droits les plus restreints à ce fichier par sécurité et pour les exigences d’OpenSSH :

    chmod 700 ~/.ssh -Rf

deposer la clé public sur le serveur

copier le contenu de la clé public generée dans le repertoire ~/.ssh/id_rsa.pub sur le serveur.

    sous windows copier le contenu du fichier et l'ajouter dans le fichier ~/.ssh/authorized_key  

    ou sous linux  utiliser simplement la cmd ssh-copy-id

    ssh-copy-id username@remote_server

Si l'on dispose de plusieurs clé publics, on peut les rassembler en les copiant dans un seul fichier et utiliser la cmd

    ssh-copy-id -i ~/.ssh/id_rsa_groupeServeurA.pub root@192.168.240.132



se connecter en ssh avec la clé privé et sans mot de passe

    ssh -ri ~/.ssh/id_rsa_groupeServeur root@remote_server

restreindre la connection ssh via login/mdp

     PermitRootLogin no

    //on peut n'autoriser que la connexion avec clé
    PermitRootLogin prohibit-password

Changer le port ssh par defaut
Je vous recommande de changer le port.
Par exemple, utiliser le port 2222, éditer /etc/ssh/sshd_config :


### Installation de docker

Installation de docker sous windows: https://docs.docker.com/desktop/install/windows-install/

Installer docker sur linux
Ajour des dépots mirroirs pour télécharger les dépendances et mise à jour du systeme

    sudo apt-get update -y & sudo apt-get upgrade -y
    sudo apt-get install ca-certificates curl  gnupg lsb-release -y
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update -y & sudo apt-get upgrade -y

    sudo apt-get install docker-ce docker-ce-cli -y

Pour tester l'installation de docker nous lancons le conteneur hello-world qui naturelement affiche hello world

    sudo docker run hello-world

Exécuter Docker en tant qu’utilisateur sans privilège root

Comme vous l’avez vu avec les commandes de terminal, les droits root sont nécessaires pour exécuter Docker. Voilà pourquoi vous devez commencer toutes vos commandes par « sudo ». Lancer Docker en tant qu’utilisateur sans privilèges root peut se faire à condition de créer un groupe Docker dédié.
Nous créons un groupe appelé « Docker » pour y faire figurer les profils utilisateurs concernés avec la commande suivante :

    sudo groupadd docker

Une simple ligne de commande nous permet d’ajouter au groupe Docker tous les profils utilisateurs avec les droits d’exécution de Docker mais sans privilèges root :

    sudo usermod -aG docker $USER

La chaîne $USER remplace ici le nom de l’utilisateur à ajouter, à vous de la remplacer par les profils concernés. Pour enregistrer les modifications, il faudra se déconnecter puis se connecter à nouveau. Nous pouvons ensuite accéder à Docker en tant qu’utilisateur membre du groupe Docker sans avoir à passer par sudo.

### Installation de docker compose

Par défaut, Docker Compose n'est inclus dans aucune des distributions Linux.
Vous pouvez verifier la sortie de la commande docker-compose.

sudo apt  install docker-compose

ou alors
Vous devrez donc le cas echeant télécharger son binaire depuis la page GitHub :

Tout d'abord, téléchargez le binaire de Docker Compose à l'aide de la commande suivante :

    curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url | grep docker-compose-linux-x86_64 | cut -d '"' -f 4 | wget -qi -
Une fois le téléchargement terminé, définissez la permission d'exécution du binaire téléchargé :

    chmod +x docker-compose-linux-x86_64
Ensuite, déplacez le binaire téléchargé dans le chemin du système :

    mv docker-compose-linux-x86_64 /usr/bin/docker-compose
Maintenant, vérifiez l'installation de Docker Compose à l'aide de la commande suivante :

    docker-compose --version


### Connexion au registry docker hub

Connexion au registry docker-hub. Pour se connecter au registry docker nous alons creer un token de connexion avec les droits de lecture et ecriture a partir de la page suivante https://hub.docker.com/settings/security et nous alons l'utiliser comme mot de passe

    docker login -u christus -p token-genere-depuis-linterface-web





# 2. Initialisation du serveur

### Preparation du serveur

    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
    sudo apt-get update  -y & sudo apt-get upgrade  -y
    sudo apt-get install ca-certificates curl  gnupg lsb-release  -y
    sudo apt install net-tools -y


### Installation du serveur ssh

Installer le serveur ssh et configurer l'utilisateur ssh qui va se connecter via sa clé public

    sudo apt install openssh-server -y

### création du compte de service

Ajouter un compte utilisateur sudo

    //en mode interactif
    adduser christus

    // ou en mode imperatif
    useradd christus --home /home/christus/ --create-home -g christus --shell /bin/bash

    // donner ou modifier le mot de passe
    passwd christus

    //Ajouter au group sudo
    usermod -aG sudo christus


### push de la clé public du poste devops sur le serveur

sous windows copier le contenu du fichier et l'ajouter dans le fichier ~/.ssh/authorized_key

ou utiliser simplement la cmd ssh-copy-id(sur linux)

    ssh-copy-id username@remote_server

Si l'on dispose de plusieurs clé publics, on peut les rassembler en les copiant dans un seul fichier et utiliser la cmd

    ssh-copy-id -i ~/.ssh/id_rsa_groupeServeurA.pub root@192.168.240.132

Il nous faudra ensuite donner les droits les plus restreints à ce fichier par sécurité et pour les exigences d’OpenSSH :

    chmod 700 ~/.ssh -Rf

se connecter en ssh avec la clé privé et sans mot de passe

    ssh -ri ~/.ssh/id_rsa_groupeServeur root@remote_server




### Installation de docker

Installation de docker sous windows: https://docs.docker.com/desktop/install/windows-install/

Installer docker sur linux

### Installation de docker

Ajour des dépots mirroirs pour télécharger les dépendances et mise à jour du systeme

    sudo apt-get update & sudo apt-get upgrade
    sudo apt-get install ca-certificates curl  gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update & sudo apt-get upgrade

    apt-get install docker-ce docker-ce-cli -y

Pour tester l'installation de docker nous lancons le conteneur hello-world qui naturelement affiche hello world

    sudo docker run hello-world

Exécuter Docker en tant qu’utilisateur sans privilège root

Comme vous l’avez vu avec les commandes de terminal, les droits root sont nécessaires pour exécuter Docker. Voilà pourquoi vous devez commencer toutes vos commandes par « sudo ». Lancer Docker en tant qu’utilisateur sans privilèges root peut se faire à condition de créer un groupe Docker dédié.
Nous créons un groupe appelé « Docker » pour y faire figurer les profils utilisateurs concernés avec la commande suivante :

    sudo groupadd docker

Une simple ligne de commande nous permet d’ajouter au groupe Docker tous les profils utilisateurs avec les droits d’exécution de Docker mais sans privilèges root :

    sudo usermod -aG docker $USER

La chaîne $USER remplace ici le nom de l’utilisateur à ajouter, à vous de la remplacer par les profils concernés. Pour enregistrer les modifications, il faudra se déconnecter puis se connecter à nouveau. Nous pouvons ensuite accéder à Docker en tant qu’utilisateur membre du groupe Docker sans avoir à passer par sudo.

### Installation de docker compose

Par défaut, Docker Compose n'est inclus dans aucune des distributions Linux.
Vous pouvez verifier la sortie de la commande docker-compose.

Vous devrez donc le cas echeant télécharger son binaire depuis la page GitHub :

Tout d'abord, téléchargez le binaire de Docker Compose à l'aide de la commande suivante :

    curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url | grep docker-compose-linux-x86_64 | cut -d '"' -f 4 | wget -qi -
Une fois le téléchargement terminé, définissez la permission d'exécution du binaire téléchargé :

    chmod +x docker-compose-linux-x86_64
Ensuite, déplacez le binaire téléchargé dans le chemin du système :

    mv docker-compose-linux-x86_64 /usr/bin/docker-compose
Maintenant, vérifiez l'installation de Docker Compose à l'aide de la commande suivante :

    docker-compose --version


### Connexion au registry docker hub

Connexion au registry docker-hub. Pour se connecter au registry docker nous alons creer un token de connexion avec les droits de lecture et ecriture a partir de la page suivante https://hub.docker.com/settings/security et nous alons l'utiliser comme mot de passe

    docker login -u christus -p token-genere-depuis-linterface-web




### Conteneurisation et exécution du serveur Nginx

Nginx est déployé et configurer pour servir nos applications via notre adresse public ou notre nom de domaine public.
Toute la configuration de nginx se trouve dans le repertoire infra/nginx.

- /var/nginx/conf.d:    # repertoire contenant les virtualhosts de nos applications
- /var/nginx/certs     # repertoire contenant les certificats nginx afin de rendre nos application en https(a faire plutart)
- /var/nginx/data-site # repertoire contenant les fichiers statics(html) rendant la page d'acceuil de notre serveur nginx
- /var/nginx/log       # fichier de logs

creer les repertoires de configuration de nginx

    mkdir -p /var/nginx/conf.d /var/nginx/certs /var/nginx/data-site /var/nginx/log
    chmod -R 666 /var/nginx/conf.d /var/nginx/certs /var/nginx/data-site /var/nginx/log  #droit de lecture et ecriture à tous les utilisateurs

copier le contenu du repertoire infra/nginx/data vers les repertoire corespondants sur le serveur

    scp -r /nginx/data/conf.d/* christus@it4innov.fr:/var/nginx/conf.d/
    scp -r /nginx/data/data-site/* christus@it4innov.fr:/var/nginx/data-site/

Pour déployer nginx nous utilisons le conteneur nginx personnalisé dans le docker-compose nginx/data/docker-compose-nginx.yml

    docker-compose -f docker-compose-nginx.yml up -d

Verifier que le conteneur nginx est bien démarré

     docker logs nginx 

Verifier que les configurations de nginx ont bien été pris en compte

    docker exec -it nginx nginx -t

Pour aller en profondeur sur la configuration des reverse proxy avec nginx lire le readme-nginx.md
https://www.youtube.com/watch?v=ZmH1L1QeNHk

# 3. Build de l'artefact & image docker sur le poste devops

### pull du code

Faire un fork du repo https://github.com/christus2024/mkutano-frontend.git

Sur votre poste de devops

creer un repertoire de travail

    mkdir -p ~/devopsinterview/code-frontend
    cd ~/devopsinterview/code-frontend

Recuper le lien de votre repo et le cloner dans ce repertoire

    git clone https://github.com/christus2024/mkutano-frontend.git


Creer la branche feature/sprint1-init sur laquelle vous aller travailler
la branche feature/sprint1 sera la branche qui va porter les correction

    git checkout -b feature/sprint1-init


### build de l'artefact

A la racine du projet
la commande de build du projet (maven) pour le profil dev:

    mvn clean package

Cette commande va generer l'artefact target/code-frontend-$VERSION-runner.jar avec $VERSION la version du projet configurée dans le pom.xml


### Redaction du dockerfile

Le dockerfile est à la racine du projet.
Afin de maitriser la redaction du dockerfile suivre le parcours suivant sur docker: https://www.youtube.com/watch?v=CPS5yXzLBwQ&list=PLYXcqIV23kPnVvMDw1sGYzSBZW1RfDgkZ


### Redaction du docker-compose

Le docker-compose est à la racine du projet.
Afin de maitriser la redaction du docker-compose suivre le parcours suivant sur docker: https://www.youtube.com/watch?v=CPS5yXzLBwQ&list=PLYXcqIV23kPnVvMDw1sGYzSBZW1RfDgkZ

### build de l'image

Se placer à la racine du projet et executer la commande de build de l'image docker de notre µservice code-frontend

    docker build -t code-frontend:1.0.0 --build-arg VERSION=1.0.0-SNAPSHOT .

Afin de maitriser l'utilisation de docker suivre le parcours suivant sur docker: https://www.youtube.com/watch?v=CPS5yXzLBwQ&list=PLYXcqIV23kPnVvMDw1sGYzSBZW1RfDgkZ

# 4. Push de l'image docker du poste de devops vers le registry

### Connexion au registry docker hub

Connexion au registry docker-hub. Pour se connecter au registry docker nous alons creer un token de connexion avec les droits de lecture et ecriture a partir de la page suivante https://hub.docker.com/settings/security et nous alons l'utiliser comme mot de passe

    docker login -u christus -p token-genere-depuis-linterface-web

### push de l'image sur le repository docker hub

    docker push christus/code-frontend:1.0.0


# 5. Execution de notre container sur le serveur

### push du docker-compose sur le serveur

sur le poste de devops

Le fichier docker-compose va nous permettre d'executer notre application sur le serveur
Les infos importantes y configurées sont:
- le nom et la version de l'artefact à deployer
- les ports à exposer
- le nom du conteneur
- le reseau - Ce reseau va permettre à tous nos µservices de communiquer entre eux via leurs noms

verifier que dans le docker compose infra/docker-compose-code-ffrontend.yml
on bien le bon nom et la bonne version de notre artefact à la lignesuivante:

     image: christus/code-frontend:1.0.0

ensuite copier le docker-compose sur notre serveur distant dans le repertoire de travail
/home/christus

    scp  infra/docker-compose-code-ffrontend.yml christus@it4innov.fr:/home/christus/docker-compose/


### Exécution du docker-compose

    docker-compose -f docker-compose-code-ffrontend.yml up -d

Verifier que le conteneur est bien lancé en affichiant tous les conteneurs en cours d'execution

    docker ps

Afficher les logs du conteneur pour voir si l'application a bien demmaré

    docker logs code-frontend -f  # -f pour afficher les logs en continue.

Verifier que l'application est accessible sur le serveur via le ou les ports ouverts

    curl localhost:8080

### pull de l'image du docker-registry vers la PIC

L'image est pull si elle n'existe pas ou si la version à changé  sur le serveur lors de l'execution du docker-compose-code-ffrontend.yml


### Configuration du virtualhost code-frontend sur nginx

lire le readme-nginx.md pour comprendre la configuration de notre virtualhost
qui se trouve dans infra/nginx/data/conf.d/code-frontend.conf

# 6. Test de connexion

Tests utilisateurs