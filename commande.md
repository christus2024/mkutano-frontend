
## Etape 0

IDE visual studio code installé

maven installé
    
    sudo apt-get install maven
    mvn -version 3.8.7

version de java installée
    
    java -version

Generer la paire de clé ssh

    ssh-keygen -t rsa -b 4096

Il nous faudra ensuite donner les droits les plus restreints à ce fichier par sécurité et pour les exigences d’OpenSSH :

    chmod 700 ~/.ssh -Rf

Installation de docker deja fait 



## Etape 1

Le serveur openssh est installé par defaut sur notre serveur et permet de nous connecter initialement avec le compte root via login/mdp
Creons le compte de service

    ssh root@85.215.129.28

    groupadd christus
    useradd christus --home /home/myasso/ --create-home -g christus --shell /bin/bash
    usermod -aG sudo christus
    passwd christus

exit  # pour me deconnecter

Push de la clé public du compte de service au compte du developpeur

    ssh-copy-id -i  ~/.ssh/christus_rsa.pub christus@85.215.129.28

je me connecte au serveur avec ma clé privé et sans mot de passe

    ssh -i ~/.ssh/christus_rsa  christus@85.215.129.28

Installation de docker

Installer docker sur linux
Ajour des dépots mirroirs pour télécharger les dépendances et mise à jour du systeme

    sudo apt-get update -y & sudo apt-get upgrade -y
    sudo apt-get install ca-certificates curl  gnupg lsb-release python3-pip -y
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

    sudo usermod -aG docker christus


Installer docker-compose
    
out d'abord, téléchargez le binaire de Docker Compose à l'aide de la commande suivante :

    curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url | grep docker-compose-linux-x86_64 | cut -d '"' -f 4 | wget -qi -
Une fois le téléchargement terminé, définissez la permission d'exécution du binaire téléchargé :

    chmod +x docker-compose-linux-x86_64
Ensuite, déplacez le binaire téléchargé dans le chemin du système :

    sudo mv docker-compose-linux-x86_64 /usr/bin/docker-compose

Maintenant, vérifiez l'installation de Docker Compose à l'aide de la commande suivante :

    docker-compose --version


### conteneurisation et execution du serveur nginx

copier le contenu du repertoire infra/nginx/data vers les repertoire corespondants sur le serveur

    scp -i ~/.ssh/christus_rsa -r infra/nginx/data/* christus@85.215.129.28:~/nginx/
    ssh -i ~/.ssh/christus_rsa christus@85.215.129.28 'mkdir -p ~/docker-compose/'
    scp -i ~/.ssh/christus_rsa -r infra/nginx/docker-compose-nginx.yml christus@85.215.129.28:~/docker-compose/docker-compose-nginx.yml

Connexion au serveur distant pour executer notre conteneur

    ssh -i ~/.ssh/christus_rsa  christus@85.215.129.28

    cd docker-compose

Lancer le conteneur nginx

    docker-compose -f docker-compose-nginx.yml up -d

Consulter les conteneurs lancer à partir du fichier docker-compose
   
    docker-compose -f docker-compose-nginx.yml ps


## Etape 2

clonner le projet

    git clone https://github.com/christus2024/mkutano-frontend.git
    git checkout feature/sprint1

Build de l'artefact .jar avec maven

    mvn clean package

Build de l'image docker
    
    docker build -t code-frontend:1.0.0 --build-arg VERSION=1.0.0-SNAPSHOT .


## Etape 3

Connexion au registry docker hub
 
    docker login -u christus -p dckr_pat_RpXGxTgv6gowU4qVKVamRGb8h5Y

push de l'image sur le repository docker hub

    docker push christus/code-frontend:1.0.0


## Etape 4 & 5

Push du docker-compose sur le serveur

    scp -i ~/.ssh/christus_rsa -r infra/docker-compose-code-frontend.yml christus@85.215.129.28:~/docker-compose/docker-compose-code-frontend.yml

connexion au serveur

    ssh -i ~/.ssh/christus_rsa  christus@85.215.129.28
    
Execution du conteneur
    
    docker-compose -f docker-compose/docker-compose-code-frontend.yml up -d

## Etape 6

Tests utilisateurs