# Gestion du cycle de vie du logiciel avec le gestionnaire de dependance Maven
## 1. Introduction
Le projet Apache Maven est un outil Open source permettant de gérer la configuration:

    * des dépendances,
    * de la construction (build)
    * et de la génération de la documentation et des rapports d'un projet java,
    * le deploiement de l'artefact sur le registry

à partir d'un seul fichier central nommé pom.xml : Project Object Model

## 2. Installation

* Sous Windows :

Télécharge la dernière version de Maven ici.
Décompresse l'archive téléchargée dans un répertoire de ton choix, par exemple C:\maven.
Ajoute la variable d'environnement M2_HOME qui pointe vers ce répertoire.
Ajoute C:\maven\bin à ta variable PATH.

* Sous macOS/Linux :

Utilise un gestionnaire de paquets comme Homebrew pour macOS : 
````bash
brew install maven
````

Sous Linux, tu peux utiliser apt-get : 

````bash
sudo apt-get install maven
````
.
Pour vérifier l'installation, exécute la commande suivante dans ton terminal :

````bash
mvn -v
````

Cela devrait afficher la version de Maven installée et des informations sur Java.

## 3. les goals maven

Maven definit trois objectifs (Goals) à atteindre:

##### - Clean:supprime tous les fichiers générés par le build précédent
##### - default: le plus utilisé, Il est responsable des tâches pour lesquelles maven est connu: compiler, construire, tester, empaqueter, déployer !
##### - Site: génération de la documentation du projet, permet de centraliser différents rapports (documentation, tests, bugs, couverture de code) à un seul endroit.

Les objectifs maven sont découpés en phases et s'exécutent au travers des plugins mavens rajouter à notre fichier pom.xml
Une phase s'exécute au travers de la commande maven `mvn`.
```bash
  mvn clean
```

Nous pouvons combiner l'execution de plusieurs phases maven

```bash
  mvn clean package
```

l'exécution d'une phase maven exécute en plus les phases précédentes du goal maven du cycle de vie du goal

#### Cycle de vie clean

| Phase      | 	Description                                                            |
|------------|-------------------------------------------------------------------------|
| pre-clean  | exécute les processus nécessaires avant le nettoyage effectif du projet |
| clean      | supprime tous les fichiers générés par le build précédent               |
| post-clean | exécute les processus nécessaires à la finalisation du nettoyage        |

#### Cycle de vie default

| Phase                 | 	Description                                                                                                              |
|-----------------------|---------------------------------------------------------------------------------------------------------------------------|
| validate              | valider que le projet est correct et que toutes les informations nécessaires sont disponibles.                            |
| initialize            | initialiser les prérequis du build, par exemple définir les propriétés ou créer les répertoires.                          |
| generate-sources      | 	générer tout code source à inclure dans la compilation. Ex: Le code Lombok                                               |
| process-sources       | 	traiter le code source généré                                                                                            |
| generate-resources    | 	générer des ressources à inclure dans le paquet.                                                                         |
| process-resources     | 	copier les ressources dans le répertoire de destination (target), prêt à l'empaquettage.                                 |
| compile	compiler      | le code source du projet                                                                                                  |
| process-test-classes  | 	post-traiter les fichiers générés par la compilation des tests, par exemple pour améliorer le bytecode des classes Java. |
| test                  | 	exécuter des tests en utilisant un framework de test unitaire approprié.                                                 |
| prepare-package       | 	effectuer toutes les opérations nécessaires pour préparer l'artefact avant l'empaquettage proprement dit.                |
| package               | 	prendre le code compilé et le conditionner dans son format distribuable, tel qu'un JAR.                                  |
| pre-integration-test  | 	effectuer les actions requises avant l'exécution des tests d'intégration.                                                |
| integration-test      | 	Déployer le paquet si nécessaire dans un environnement où les tests d'intégration peuvent être exécutés.                 |
| post-integration-test | 	effectuer les actions requises après l'exécution des tests d'intégration.                                                |
| verify                | 	effectuer tous les contrôles nécessaires pour vérifier que le paquet est valide et répond aux critères de qualité.       |
| install               | 	installer le paquet dans le référentiel local, pour l'utiliser comme dépendance dans d'autres projets locaux.            |
| deploy                | 	copie le paquet final dans le dépôt distant pour le partager avec d'autres développeurs et projets.                      |

#### Cycle de vie site


| Phases       | 	Description                                                                                                |
|--------------|-------------------------------------------------------------------------------------------------------------|
| pre-site     | 	exécute les processus nécessaires avant la création effective du site du projet                            |
| site         | 	générer la documentation du site du projet                                                                 |
| post-site    | 	exécute les processus nécessaires pour finaliser la génération du site, et préparer le déploiement du site |
| site-deploy  | déployer la documentation du site généré sur le serveur web spécifié                                        |

Lorsque vous exécutez `mvn clean package`:

Vous utilisez 2 cycles de vie (clean et default)
toutes les étapes préalables à la phase clean du cycle de vie clean , en plus de celles préalables au package du cycle de vie default seront exécutées.

## Vérifier quelles sont les étapes auxquelles font appel `mvn clean install`

`mvn clean install`

Le résultat à l'écran sera:

```
In pre clean
...
In clean
...
In validate
...
In compile
...
In test
...
In package
...
In Install

```

## 4. Sauter certaines phases pendant l'execution

````bash
mvn install -Dmaven.test.skip=true
````
* -Dmaven.test.skip=true

Permet de sauter la compilation et l'execution des tests
* -DskipTests 

Permet de sauter l'execution des tests