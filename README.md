## melos config :

- Installation de **very_good_cli** : 

```
dart pub global activate very_good_cli
```

- Créer un projet dart avec **very_good_cli.**
```
very_good create <your_project_dart> -t dart_pkg
```

- Créer un projet flutter avec **very_good_cli.**
```
very_good create <your_project_flutter> -t flutter_pkg
```

--------------------------

- Installer **melos** globalement sur le pc.
```
dart pub global activate melos
```


- Voir ce qu'il y a dans un dossier :

```
shell > ls
```

- Créer un dossier :

```
shell > mkdir <exemple_packages>
```

- Construire le projet melos - avec les autres packages :
  > melos bs : est comme faire cd à un dossier et après faire dart pub get, dossier par dossier !
```
shell - melos >

melos bs
```

- Si nous voulons lancer les tests sur nos application à partir de melos.

À l'intérieur du **pubspec.yaml** de melos on doit ajouter ces **_scripts:_** et par la suite executer les commande sur le terminal voir plus bas.

- [pubspec.yaml](pubspec.yaml)
```
name: melos
packages:
  - packages/**

command:
  bootstrap:
    usePubspecOverrides: true

scripts:
  test:
    run: melos run test:flutter --no-select | melos run test:dart --no-select
    description: Run all tests in the packages.

  test:flutter:
    run: melos exec --dir-exists="test" -c 1 --fail-fast -- "flutter test --coverage"
    # run: melos exec flutter test
    description: Run test in all flutter packages.
    select-package:
      flutter: true
      dir-exists: test

  test:dart:
    run: melos exec --dir-exists="test" -c 1 --fail-fast -- "dart test"
    # run: melos exec dart test
    description: Run test in all dart packages.
    select-package:
      flutter: false
      dir-exists: test

```

Commande shell>
```
melos exec flutter test

melos exec dart test

melos run test:dart

melos run test:flutter

melos run
```

un git utilisant melos : [doc melos- exemple](https://github.com/NoScopeDevs/bloc_samples).

## utiliser melos à l’intérieur d'un projet avec plusieurs packages.

- juste à changer l'annotation : packages dans **melos.yaml.**

IMPORTANT : melos.yaml doit être au même niveau de votre application!

```
name: melos
packages:
  - /**

command:
  bootstrap:
    usePubspecOverrides: true

scripts:
  test:
    run: melos run test:flutter --no-select | melos run test:dart --no-select
    description: Run all tests in the packages.
```

## - Docker : create une image: 

Connaître les containers sur docker
```
1. docker ps
```
```
2. docker ps -a
```

Installateur Image :

Connaître les images sur docker :
```
3. docker images
```

installer un image de MYSQL sur docker :

```
4. docker pull mysql
```

Créer un DATABASE avec l'image = Création de l'image.
```
5. 

docker run --name dockermysql -p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=easypassword \
-e MYSQL_USER=myuser \
-e MYSQL_PASSWORD=mypassword \
mysql
```

Notez que l'option -e est utilisée pour définir les variables d'environnement dans le conteneur. Vous pouvez spécifier plusieurs options -e pour définir plusieurs variables d'environnement.

## - Dockerfile : Créer un installateur d'un environnement de projet :  

```
docker ps -a
```

Créer un fichier : Dockerfile

```
Le Dockerfile : il va avoir tout les configurations nécessaire pour installer les images à votre projet qui est partager à tout l'équipe ou environnement de travail.
```

exemple : Créer le build de dart_frog build pour créer un container sur docker. voici le Dockerfile

```
# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.17)
FROM dart:stable AS build

WORKDIR /app

# Copy Dependencies

# Install Dependencies

# Resolve app dependencies.
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/


# Start server.
CMD ["/app/bin/server"]
```
```
Dockerfile est comme un installateur de notre projet :
```

Alors : le DockerFile ==> Crée une image de notre projet et grâce à cette image nous pouvons créer plusieurs container/images pour les utilises comme mySQL

De plus, il faut avoir un docker ignore la même chose que git ignore :

```
.dockerignore
Dockerfile
build/
.dart_tool/
.git/
.github/
.gitignore
.idea/
.packages
```

Créer le build pour notre installateur Dockerfile :

```
docker build -t <nom du container> .<dit que ce sur ce folder est >
```

```
docker build -t intela .
```

- Voir si l'image est bien créer : 

```
docker images 
```

* Faire courir cette image : 
```
docker run --name <dart_frog_server> -p 8080:3000 intela
```

* Comment on fait pour rentrer à l'intérieur du Container après création de l'image et l'exécuter :

```
docker exec -it intela bash  
```

* Comment utiliser bash :

lister le dossier :
```
ls -1
```

voir le contenue d'un fichier :
```
cat api_dart_mongo.dart
```

  1. **Comment accéder au container à partir de vscode**. 

installer : [remote-containers](vscode:extension/ms-vscode-remote.remote-containers)

après faire : 
```
Shift + Ctrl + p 
```

chercher : 

```
add Development Container Configuration File..
```
suite après le clip :

```
From 'Dockerfile' : Refer to the existing 'Dockerfile' in the container configuration
```

Cela va créer un nouveau document du nom : devcontainer / devcontainer.json

### - Devcontainer / devcontainer.json.

Savoir plus sur la documentation de [devcontainer/devcontainer.json](https://code.visualstudio.com/docs/devcontainers/containers)

```
//? Cela va créer un fichier de configuration de dépendances pour dire à une autre utilisateur comment installer les dépendances de devcontainer.
// For format details, see https://aka.ms/devcontainer.json. For config options, see the README at:
// https://github.com/microsoft/vscode-dev-containers/tree/v0.245.0/containers/docker-existing-dockerfile
{
    "name": "Existing Dockerfile",
    // Sets the run context to one level up instead of the .devcontainer folder.
    "context": "..",
    // Update the 'dockerFile' property if you aren't using the standard 'Dockerfile' filename.
    "dockerFile": "../Dockerfile",
    // Use 'forwardPorts' to make a list of ports inside the container available locally.
    "forwardPorts": [
        8080
    ],
    // Uncomment the next line to run commands after the container is created - for example installing curl.
    "postCreateCommand": "apt-get update && apt-get install -y zsh",
    // Uncomment when using a ptrace-based debugger like C++, Go, and Rust
    // "runArgs": [ "--cap-add=SYS_PTRACE", "--security-opt", "seccomp=unconfined" ],
    // Uncomment to use the Docker CLI from inside the container. See https://aka.ms/vscode-remote/samples/docker-from-docker.
    // "mounts": [ "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind" ],
    // Uncomment to connect as a non-root user if you've added one. See https://aka.ms/vscode-remote/containers/non-root.
    // "remoteUser": "vscode"
    // add par Sergio :
    "settings": {
        "terminal.integrated.defaultProfile.linux": "zsh",
        "terminal.integrated.profiles.linux": {
            "zsh": {
                "extensionIdentifier": "",
                "id": "",
                "title": "",
                "path": "/bin/zsh"
            }
        }
    }
}
```
_devcontainer.json_ est un installateur pour configurer ton **container** au lieu du _Dockerfile_ qui est un installateur pour la configuration d'une **image**.

Si nous voulons allez encore plus loin avec **Docker** nous pouvons utiliser **_Docker compose_**

### - Docker compose

- _docker-compose.yml_ est un installateur pour configurer plusieurs **containers** dans un seul installateur.

Savoir plus sur la documentation de [Docker-compose](https://docs.docker.com/compose/)

```
# Version de la syntaxe de ce fichier yml.
version: "3.9"  # optional since v1.27.0

# Container execution
# utilisé pour lancer le containers sur la même network et les ports communs.

# info commande sur le terminal manuellement comparaison : docker run -dp 8080:3030 --network flutter_docker -e MYSQL_HOST=mysql -e MYSQL_USER=root -e MYSQL_PASSWORD=secret -e MYSQL_DB=flutter_docker flutter_docker:v2

services:
  flutter_docker:
    image: sergioanino/flutter_docker:v2 #
    Container_name: flutter_docker
    ports:
      - "8080:3333"¸
    build: .
    command: flutter pub get
  db:
    image: mongo #
    Container_name: mymongo
    ports:
      - "27017:27017"¸
    build: .
    command: flutter pub get

    # Exemple : environnemnt : MySql.
    environment:
      MYSQL_HOST: mysql
      MYSQL_USER: root
      MYSQL_PASSWORD: secret
      MYSQL_DB: flutter_docker
    # build: .
    # command:
    # exemple de commande.
    #   - "php"
    #   - "-S"
    #   - "node server"

  # info : docker run -d --network flutter_docker --network-alias mysql -v flutter_docker-mysql-data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=secret -e MYSQL_DATABASE=flutter_docker mysql:5.7
  mysql:
    image: mysql:5.7
    container_name: mysql-5.7
    # ports:
    #     - "8080:3333"
    volumes:
        - ./flutter_docker-mysql-data:/var/lib/mysql 
        # - .:/code
        # - logvolume01:/var/log
    environment:
        MYSQL_ROOT_PASSWORD: "secret"
        MYSQL_DATABASE: flutter_docker
    # depends_on:
    #   - redis
#   redis:
#     image: redis
# volumes:
#   logvolume01: {}
```

- Si jamais nous voulons faire le menage dans nos images container créer : 

```
docker rm <container_id or names>

avant tout ils faut arrêter les containers qu'on veut supprimer :

docker stop <container_id or names>
```

**Si nous voulons partir la commande sur _docker_compose.yml_**.

```
docker-compose up

or docker compose up --build --detach
```

**Si nous voulons lancer la commande _docker_compose** pour la version de production:

```
docker-compose -f docker-compose.prod.yaml up
```

Voici de ou nous avons pris les information sur le contenue de ce [tutorial](https://www.youtube.com/watch?v=SMqdC6g6Y2o&t=4472s&ab_channel=FaztCode).

-----------------------------

# Cours en español sur Docker :

# Section 2 : Les bases de docker.

Guide de raccourcis : 
-----


## **Commande de base :**
-------------

- Télécharger une image.
  ```
  docker pull <image_name>
  docker pull <image_name:tag>
  docker pull postgres
  docker pull postgres: 15.1
  ```

- Mettre en fonctionnement le container : sur le **port 80**, en arrière-plan avec l'image "getting-started".

  ```
  docker container run <image_name>
  docker container run -d -p 80:0 docker/getting-started
  ```

  **_-d_** :  Exécute l'image non liée depuis la console où la commande a été exécutée.

  **_-p 80:80_** :  Fait correspondre le port 80 de notre ordinateur au port 80 du conteneur.

  **_docker/getting-started_** : image à utiliser

### **PRO TIP :** 
- Il est possible de changer de drapeau
  ```
  docker container run -dp 80:80 docker/getting-started

  docker run -dp 80:80 docker/getting-started
  ```

- Alors de l'aide d'une commande :
  ```
  docker <commande> --help
  ```

- Assigner un nom au container :
  ```
  docker container run --name <myName> docker/getting-started
  ```

- Afficher une liste de tous les conteneurs fonctionnant sur cet ordinateur :
  ```
  docker container ls

  docker ps
  ```

- Montrer tous les conteneurs d'installer sur votre pc :
  ```
  docker container ls -a

  docker ps -a
  ```

- Arrêter un container et le supprimer :
  ```
  docker container stop <container-id>

  docker container rm <container-id>
  ```

- Démarrer un conteneur déjà créé :
  
  ```
  docker container start <container-id>
  ```
### **PRO TIP :** 
- Arrêter le(s) conteneur(s) et le(s) retirer de forme forcé :

  ```
  docker container rm -f <container-id> o <ID1 ID2…>
  ```

  **_container-id_** : peut être les 3 premiers chiffres.

- S'authentifier sur [docker.hub](https://hub.docker.com/)
  
  ```
  docker login -u <your_user>
  ```

  **_ou_** bien, vous pouvez également créer des [jetons d'accès spécifiques](https://hub.docker.com/settings/security).

----------

## Créer des Images 

- Construction et attribution d'une balise à l'image : l'objectif de la balise est de faciliter l'identification et la lecture par les humains.

  ```
  docker build -t getting-started .
  ```

  **_-t_** : Attribue le nom de la balise.

  **_._** : Spécifie où chercher le fichier DockerFile dans le répertoire courant. répertoire actuel.

- Renommer une image locale.
  ```
  docker image tag SOURCE[:TAG] TARGET_IMAGE[:TAG]
  docker tag IMAGE NEW_IMAGE
  docker tag <Tag Actual> <USUARIO>/<NUEVO NOMBRE>
  ```
  et le partir 

  ```
  docker tag getting-started YOUR-USERNAME/getting-started
  ```

  Cette commande permet d'afficher des images dans différents journaux.

- Si vous oubliez le numéro de version ou si vous souhaitez le placer.

  ```
  docker image tag IMAGEN IMAGEN:2.0.0
  ```

## Nettoyage d'images.

- Liste de toutes les images.

  ```
  docker images
  ```

- Supprimer une image spécifique
  ```
  docker image rm <image-ID> o <ID1 ID2 ID3…>
  docker rmi IMAGE
  docker rmi getting-started
  ```

- Supprimer les images en suspens.
  ```
  docker image prune
  ```

- Supprimer toutes les images inutilisées.
  ```
  docker image prune -a
  ```
## LOGS et examiner les conteneurs.

- Afficher les journaux d'un conteneur.
  ```
  docker container logs <container id>
  docker container logs --follow CONTAINER
  ```
  **_--follow_** : 

  Suit : Suivre les nouveaux journaux affichés.

- Affiche les statistiques et la consommation de mémoire.
  ```
  docker stats
  ```

- Iniciar un comando shell dentro del contenedor.
  ```
  docker exec -it CONTAINER EXECUTABLE
  docker exec -it web bash
  docker exec -it web /bin/sh
  ```
  **_-it_** : 

  Interactive Terminal

-------------------

EXEMPLE :
----

1. Créer un DATABASE avec **MariaDB**
  ```
  docker container run \
  -e MARIADB_RANDOM_ROOT_PASSWORD=yes \
  -dp 3306:3306 \
  mariadb:jammy
  ```
  ou si vous voulez tout spécifier :

  bash : mac
  ```
  docker container run \
  -dp 3306:3306 \
  --name intela \
  -e MARIADB_USER=sergioanino \
  -e MARIADB_PASSWORD=user123456 \
  -e MARIADB_ROOT_PASSWORD=root123456 \
  -e MARIADB_DATABASE=intela-db \
  mariadb:jammy
  ```
  shell
  ```
  docker container run `
  -dp 3306:3306 `
  --name intela `
  -e MARIADB_USER=sergioanino `
  -e MARIADB_PASSWORD=user123456 `
  -e MARIADB_ROOT_PASSWORD=root123456 `
  -e MARIADB_DATABASE=intela-db `
  mariadb:jammy
  ```

  Ensuite : voir les logs du container avec image de MariaDB 
  ```
  docker container logs mariadb:jammy
  ```
  et rechercher GENERATED ROOT PASSWORD :  ``your password the mariaDB``

  Supprimer la database de **_MariaDB_**
  ```
  docker image ls

  docker image rm mariadb:jammy
  ```
-----------

# Section 3 : Volumes et Networks.

## Cours 20 - introduction

## Les volumes.
-----

```
Il existe trois types de volumes, utilisés pour rendre les données persistantes entre les redémarrages et les changements d'image.
```

**_1. Named Volumes._**

  Il s'agit du volume le plus couramment utilisé.

- Créez un nouveau volume.
  ```
  docker volume create todo-db
  ```

- Liste des volumes créés
  ```
  docker volume ls
  ```

- Vérifier le volume spécifique
  ```
  docker volume inspect todo-db
  ```

- Supprime tous les volumes inutilisés.
  ```
  docker volume prune
  ```

- Supprime un ou plusieurs volumes spécifiés.
  ```
  docker volume rm VOLUME_NAME
  ```

- Utiliser un volume lors de l'exécution d'un conteneur.
  ```
  docker run -v todo-db:/etc/todos getting-started
  ```

**_2. Bind Volumes - Lier les volumes._**

Les volumes liés fonctionnent avec des chemins d'accès absolus.

- Terminal
  ```
  
  ```
- PowerShell
  ```
  
  ```

**_3. anonymous Volumes_**

## EXEMPLE :cours 22
----

1. Créer un DATABASE avec **MariaDB**
  
  shell
  ```
  docker container run `
  -dp 3306:3306 `
  --name intela `
  -e MARIADB_USER=sergioanino `
  -e MARIADB_PASSWORD=user123456 `
  -e MARIADB_ROOT_PASSWORD=root123456 `
  -e MARIADB_DATABASE=intela-db `
  mariadb:jammy
  ```

  Ajouter le query à la database :

  Copier coller : faire 
  1. Ctrl A + Enter = add all queries selected
  2. Ctrl + R = refresh

----

2. cours 23 : Créer un Named Volumes

  ```
  docker volume create intela-db
  ```

  use the volume - exemple 22 :
  shell
  ```
  docker container run `
  -dp 3306:3306 `
  --name intela `
  -e MARIADB_USER=sergioanino `
  -e MARIADB_PASSWORD=user123456 `
  -e MARIADB_ROOT_PASSWORD=root123456 `
  -e MARIADB_DATABASE=intela-db `
  --volume intela-db:/var/lib/mysql `
  mariadb:jammy
  ```
  Ajouter le query à la database :

  Copier coller : faire 
  1. Ctrl A + Enter = add all queries selected
  2. Ctrl + R = refresh

Cette fois-ci, la data va être persistante à cause du volume qui est enregistré sur notre pc sur le : **_intela-db:/var/lib/mysql_**.

----

3. cours 24 :MariaDB et PHPMyAdmin lier avec des network et 
  
  télécharger l'image de phpmyadmin à même temps que de la configurer :

  use the volume - exemple 23 :

  shell
  ```
  docker container run `
  --name phpmyadmin `
  -d `
  -e PMA_ARBITRARY=1 `
  -p 8080:80 `
  phpmyadmin:5.2.0-apache
  ```
  suite à cela, nous pouvons aller sur localhost:8080 et nous pouvons voir le PHPMyAdmin : 

  ```
  IMPORTANT : 
  - Pour pouvoir se connecter nous devons créer un NetWork pour lier la phpmyadmin avec MariaDB - Suite cours 25.
  ```

----

4. cours 25 - Créer la NetWork avec MariaDB et PHPMyAdmin

  [documentation sur le netWork](https://docs.docker.com/engine/tutorials/networkingcontainers/).

  use the volume - exemple 24 :

  shell
  ```
  docker network create intela-network
  ```

  Connection à au network 
  ```
  docker network connect intela-network phpmyadmin
  docker network connect intela-network intela
  ```

  Inspecter le network :
  ```
  docker network inspect intela-network
  ```

----

5. cours 26 : Créer un Named Volumes avec network automatique

  shell
  ```
  docker container run `
  -dp 3306:3306 `
  --name intela `
  -e MARIADB_USER=sergioanino `
  -e MARIADB_PASSWORD=user123456 `
  -e MARIADB_ROOT_PASSWORD=root123456 `
  -e MARIADB_DATABASE=intela-db `
  --volume intela-db:/var/lib/mysql `
  --network intela-network `
  mariadb:jammy

  docker container run `
  --name phpmyadmin `
  -d `
  -e PMA_ARBITRARY=1 `
  -p 8080:80 `
  --network intela-network `
  phpmyadmin:5.2.0-apache
  ```

-----

## Cours 28 &  29 :

## bind Volume

exemple avec une application : NEST-GRAPHQL - todo list : web app.

- Executer cette commande pour créer le bind Volume avec node16 sur docker et notre projet personnel local.
  ```
  docker container run `
  --name nest-app `
  -w /app `
  -p 8081:3000 `
  -v "${pwd}:/app" ` 
  node:16-alpine3.16 `
  sh -c "yarn install && yarn start:dev"
  ```
ou 

-v "${pwd}:/app" ` 
-v "${pwd}:/app" `


## 29 - suite du 28

- Executer cette commande pour créer le bind Volume avec node16 sur docker et notre projet personnel local.
  ```
  docker container run `
  --name nest-app `
  -w /app `
  -dp 8081:3000 `
  -v ${pwd}:/app `
  node:16-alpine3.16 `
  sh -c "yarn install && yarn start:dev"
  ```
  ou 

  -v "${pwd}:/app" ` 
  -v "${pwd}:/app" `

- Connaître les logs du container pour utiliser l -dp
  ```
  docker container logs -f <nest-app>
  ```

```
Si erreur de port suivre les étapes suivante :
```
- trouver les ports ouvert :
  ```
  docker ps -a --format "table {{ .ID }}\t{{ .Names }}\t{{ .Ports }}"
  ```

- Connaître les ...
  ```
  netstat -ano | findstr :80
  ````
-----

## 30 : Terminal interactive.

exemple avec une application : NEST-GRAPHQL - todo list : web app.

1. Faire courir le container de nest-app.
2. rentrer à l'intérieur de la terminal du container docker :
    ```
    docker exec -it nest-app /bin/sh
    ```
3. Navigation dans la terminal :
    ```
    > docker exec -it 2d6 /bin/sh

    /app # 

    /app # cd ..

    / # ls
    app    bin    dev    etc    home   lib    media  mnt    opt    proc   root   run    sbin   srv    sys    tmp    usr    var

    / # cd app

    /app # ls
    README.md            nest-cli.json        package.json         test                 tsconfig.json
    dist                 node_modules         src                  tsconfig.build.json  yarn.lock

    /app # cd src

    /app/src # ls
    app.module.ts  hello-world    main.ts        schema.gql     todo

    /app/src # cd hello-world/

    /app/src/hello-world # ls
    hello-world.module.ts    hello-world.resolver.ts

    /app/src/hello-world # cat hello-world.resolver.ts
    import { Float, Query, Resolver, Int, Args } from '@nestjs/graphql';

    @Resolver()
    export class HelloWorldResolver {

        @Query( () => String, { description: 'Hola Mundo es lo que retorna', name: 'hello' } )
        helloWorld(): string {
            return 'Hola Mundo';
        }

        @Query( () => Float, { name: 'randomNumber' } )
        getRandomNumber(): number {
            return Math.random() * 100;
        }

        // randomFromZeroTo
        @Query( () => Int, { name: 'randomFromZeroTo', description: 'From zero to argument TO (default 6)' } )
        getRandomFromZeroTo(
            @Args('to', { nullable: true, type: () => Int } ) to: number = 6
        ): number {
            return Math.floor( Math.random() * to );
        }

    }

    /app/src/hello-world #
    ```
- Si nous voulons d'éditer à partir de la terminal de docker :
  ```
  vi hello-world.resolver.ts
  ```

- Pour l'éditer : 
  ```
  Faire :

  i
  ```



- Sauvegarde des changement après éditer le container :
  ```
  1. ESC

  2. :wq! + enter 
  ```
- Pour véfirifier si les modifications ce sont bine faits :
  ```
  cat hello-world.resolver.ts
  ```

- SOrtir de la terminal interactive :
  ```
  exit
  ```
## 31 - Faire du ménage dans nos containers, images, networks & volumes.

```
docker <docker_choice> rm -f <ids_names_identifies>
```
---------

# SECTION 4 : Multi-container Apps - Docker Compose.

## Cours 34 - Laboratoire pratique de la section 3.

------

# Docker Hub images
[Postgres](https://hub.docker.com/_/postgres)

[pgAdmin](https://hub.docker.com/r/dpage/pgadmin4)

## 1. Crear un volumen para almacenar la información de la base de datos
docker **COMANDO CREAR** postgres-db

## 2. Montar la imagen de postgres así 
####  OJO: No hay puerto publicado -p, lo que hará imposible acceder a la base de datos con TablePlus
```
docker container run \
-d \
--name postgres-db \
-e POSTGRES_PASSWORD=123456 \
-v postgres-db:/PATH/DE/LA/BASE/DE/DATOS \
postgres:15.1
```
Powershell
```
docker container run `
-d `
--name postgres-db `
-e POSTGRES_PASSWORD=123456 `
-v postgres-db:/PATH/DE/LA/BASE/DE/DATOS `
postgres:15.1
```

## 3. Tomar pgAdmin de aquí
```
docker container run \
--name pgAdmin \
-e PGADMIN_DEFAULT_PASSWORD=123456 \
-e PGADMIN_DEFAULT_EMAIL=superman@google.com \
-dp 8080:80 \
dpage/pgadmin4:6.17
```
Powershell
```
docker container run `
--name pgAdmin `
-e PGADMIN_DEFAULT_PASSWORD=123456 `
-e PGADMIN_DEFAULT_EMAIL=superman@google.com `
-dp 8080:80 `
dpage/pgadmin4:6.17
```

# 4. Ingresar a la web con las credenciales de superman
http://localhost:8080/

# 5. Intentar crear la conexión a la base de datos
1. Click en Servers
2. Click en Register > Server
3. Colocar el nombre de: "SuperHeroesDB"  (el nombre no importa)
4. Ir a la pestaña de connection
5. Colocar el hostname "postgres-db" (el mismo nombre que le dimos al contenedor)
6. Username es "postgres" y el password: 123456
7. Probar la conexión

### 6. Ohhh no!, no vemos la base de datos, se nos olvidó la red

## 7. Crear la red
docker network **ALGO PARA CREAR** postgres-net

## 8. Asignar ambos contenedores a la red
docker container **ALGO PARA LISTAR LOS CONTENEDORES**

## 9. Conectar ambos contenedores
docker network connect postgres-net **ID del contenedor 1**

docker network connect postgres-net **ID del contenedor 2**

## 10. Intentar el paso 4. de nuevo.
Si logra establecer la conexión, todo está correcto, proceder a crear una base de datos, schemas, tablas, insertar registros, lo que sea.

## 11. Saltar de felicidad
<img src="https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif" alt="happy" />

------

## Cours 35 - Solution du Laboratoire pratique 34

## Cours 36 à 38 - Docker compose - Multi-Container Apps.

```
Est-ce que c'est docker-compose ?
```

Docker Compose est un outil qui permet de définir et de lancer des applications multi-conteneurs Docker. Il permet de spécifier les images, les réseaux et les volumes nécessaires pour faire fonctionner une application, ainsi que les configurations spécifiques pour chaque conteneur.

En utilisant Docker Compose, vous pouvez facilement gérer et orchestrer plusieurs conteneurs Docker pour qu'ils fonctionnent ensemble comme une application unique. Vous pouvez spécifier les dépendances entre les conteneurs, les configurations de réseau et les volumes de stockage de données partagées.

Dans un contexte de tutoriel, Docker Compose peut être très utile car il permet de simplifier et d'automatiser la mise en place d'un environnement de développement ou de test. Vous pouvez fournir un fichier de configuration Docker Compose qui définit tous les conteneurs nécessaires pour le tutoriel, ce qui permet aux utilisateurs de démarrer rapidement et facilement avec l'application sans avoir à passer du temps à configurer chaque conteneur individuellement.

En résumé, Docker Compose est un outil pratique pour gérer plusieurs conteneurs Docker et orchestrer leur fonctionnement ensemble comme une application unique. Dans le contexte d'un tutoriel, il peut être utilisé pour simplifier la configuration et la mise en place de l'environnement de développement ou de test, permettant ainsi aux utilisateurs de se concentrer sur l'apprentissage de l'application plutôt que sur la configuration des conteneurs.

## Cours 37 suite du 36 - Utilisation et faire courir le docker-compose

- **Exemple du docker-compose**, l'équivalent au # 34 & 35.
  ----

  ```
  version: '3'

  services:
    db:
      container_name: postgres_database
      image: postgres:15.1
      volumes:
        - postgres-db:/var/lib/postgresql/data
      environment:
        - POSTGRES_PASSWORD=123456

    pgAdmin:
      depends_on:
        - db
      image: dpage/pgadmin4:6.17
      ports:
        - "8081:80"
      environment:
        - PGADMIN_DEFAULT_PASSWORD=123456 
        - PGADMIN_DEFAULT_EMAIL=superman@google.com 

  volumes:
    postgres-db:
      external: true
  ```
- Lancer la création du **Docker-compose**
il faut être du le dossier parents du projet au niveau de docker-compose
  ```
  docker compose up
  ```

  Il est possible d'avoir une erreur : quand nous utilisons un volume dans nos images, il est important d'informer à docker-compose si :
  1. Choisir un nouveau volume :
      ```
      volumes:
        postgres-db:
      ```
  2. Choisir un volume existant :
      ```
      volumes:
        postgres-db:
          external: true
      ```

## Cours 38 suite du 37 - ajouter un volume existant à notre docker-compose.

- Ajouter le volume existant au docker-compose
  ```
  volumes:
    postgres-db:
      external: true
  ```

- SI jamais, le docker-compose ne veut pas ce connecter au bon volume :
  ```
  docker compose down
  ```

- Faire du nettoyage dans docker :
  ```
  docker volume ls 

  docker volume rm postgres-pgadmin_postgres-db
  ```

- refaire cette commande :
  ```
  docker compose down
  ```

- Récréer le docker-compose avec un volume existant :
  ```
  docker compose up
  ```

## Cours 39 - Bind Volumes avec Docker-compose

- Ajouter le bind dans nos volumes et spécifier leur path pour sauvegarder la database :.
  ```
  version: '3'

  services:
    db:
      container_name: postgres_database
      image: postgres:15.1
      volumes:
        # - postgres-db:/var/lib/postgresql/data # 36 à 38
        - ./postgres:/var/lib/postgresql/data  # 39
      environment:
        - POSTGRES_PASSWORD=123456

    pgAdmin:
      depends_on:
        - db
      image: dpage/pgadmin4:6.17
      ports:
        - "8081:80"
      volumes: # 39
        - ./pgadmin:/var/lib/pgadmin
      environment:
        - PGADMIN_DEFAULT_PASSWORD=123456 
        - PGADMIN_DEFAULT_EMAIL=superman@google.com
  ```
- 1er mettre à terre le docker-compose passé :
  ```
  docker compose down
  ```
- Créer le docker compose détacher :
  ```
  docker compose up -d
  ```
- Si nous voulons voir les logs du docker compose up -d :
  ```
  docker compose logs
  ```
- Si nous voulons suivre les logs sur la terminal :
  ```
  docker compose logs -f 
  ```

- Si jamais vous ne êtes pas sur le bon repertoire il y a deux solutions :

  ```
  1: cd : postgres-pgadmin/docker 
  docker > docker compose up

  2 : postgres-pgadmin >
  docker compose -f docker\docker-compose.yml up
  ```

## 41 - Multi-container app - Database de mongoDB.
----

Application Pokemon avec Node.js et mongoDB pour le cours du 41 à 44.
----

- Notre 1er : docker compose up
  
Création d'une database de mongo utilisant le localhost:27017 pour accéder sans authentification :

  ```
  version: '3'

  services:
    db:
      container_name: pokemon_db
      image: mongo:6.0
      volumes:
        - poke-vol:/data/db
      ports:
        - 27017:27017
      restart: always

  volumes:
    poke-vol:
      external: false
  ```

## 42 - Variables d'environnement mongoDB.

- Créer un .env au même niveau de votre docker-compose.yml
  ```
  MONGO_USERNAME=MyUserName
  MONGO_PASSWORD=qwertyuio
  MONGO_DB_NAME=myDBname
  ```

- Ajouter les variables d'environnement de mongoDB.
  ```
  version: '3'

  services:
    db:
      container_name: ${MONGO_DB_NAME}
      image: mongo:6.0
      volumes:
        - poke-vol:/data/db
      ports:
        - 27017:27017
      restart: always
      environment:
        MONGO_INITDB_ROOT_USERNAME: ${MONGO_USERNAME}
        MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD}
      command: ['--auth']

  volumes:
    poke-vol:
      external: false
  ```
Cela ne va pas fonctionner pour ce connecter à une application qui nous montrer le database : ERREUR est que le volumes est déjà créer dans l'exemple 41 alors il est important quand vous d'éliminer le volume.

- Efface le volume créer dans le 41 :
  ```
  docker volume ls

  docker volume rm -f pokemon-app_poke-vol
  ```

- Pour finir et que cela fonctionne - vous avez besoin de la commande de création du docker compose up

  ```
  docker compose up -d
  ```
## 43 - Multi-container app - utiliser les donnée.

- Se connecter au localhost de mongo express.

Ajouts des mongo express dans le docker-compose.yml

  ```
  version: '3'

  services:
    db:
      container_name: ${MONGO_DB_NAME}
      image: mongo:6.0
      volumes:
        - poke-vol:/data/db
      # ports:
      #   - 27017:27017
      restart: always
      environment:
        MONGO_INITDB_ROOT_USERNAME: ${MONGO_USERNAME}
        MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD}
      command: ['--auth']

    mongo-express:
      depends_on:
        - db
      image: mongo-express:1.0.0-alpha.4
      environment:
        ME_CONFIG_MONGODB_ADMINUSERNAME: ${MONGO_USERNAME}
        ME_CONFIG_MONGODB_ADMINPASSWORD: ${MONGO_PASSWORD}
        ME_CONFIG_MONGODB_SERVER: ${MONGO_DB_NAME}
      ports:
        - 8081:8081
      restart: always

  volumes:
    poke-vol:
      external: false
  ```

## 44 - Multi-container app - Application de nest.
- Version final : Ajout du dernier container pour finaliser l'application pokemon. Settings de tous les containers.
  ```
  version: '3'

  services:
    db:
      container_name: ${MONGO_DB_NAME}
      image: mongo:6.0
      volumes:
        - poke-vol:/data/db
      # ports:
      #   - 27017:27017
      restart: always
      environment:
        MONGO_INITDB_ROOT_USERNAME: ${MONGO_USERNAME}
        MONGO_INITDB_ROOT_PASSWORD: ${MONGO_PASSWORD}
      command: ['--auth']

    mongo-express:
      depends_on:
        - db
      image: mongo-express:1.0.0-alpha.4
      environment:
        ME_CONFIG_MONGODB_ADMINUSERNAME: ${MONGO_USERNAME}
        ME_CONFIG_MONGODB_ADMINPASSWORD: ${MONGO_PASSWORD}
        ME_CONFIG_MONGODB_SERVER: ${MONGO_DB_NAME}
      ports:
        - 8081:8081
      restart: always

    poke-app:
      depends_on:
        - db
        - mongo-express
      image: klerith/pokemon-nest-app:1.0.0
      ports:
        - 3000:3000
      environment:
        MONGODB: mongodb://${MONGO_USERNAME}:${MONGO_PASSWORD}@${MONGO_DB_NAME}:27017
        DB_NAME: ${MONGO_DB_NAME}
      restart: always

  volumes:
    poke-vol:
      external: false
  ```

  ensuite :
  ```
  docker compose up -d 
  ```
Faire le nettoyage avant ! 

voir que mongoDB express est update par api :
```
http://localhost:8080/
```

Charger la database avec un seed ajouter des données : 
```
http://localhost:3000/api/v2/seed
```
consulter la liste de pokemon :
```
http://localhost:3000/api/v2/pokemon?limit=20&offset=40
```

Nettoyage : 
```
docker > docker compose down

docker volume ls

docker volume rm docker_poke-vol
```

## 45 - Résumé de la section 4 !

---------

# Section 5 - Dockerfile.

- 48 à 62

Est-ce que c'est le dockerfile

Le '**Dockerfile**' est un fichier texte qui contient une liste d'instructions pour créer une image Docker. Il est utilisé pour automatiser le processus de création d'images Docker reproductibles et prévisibles.

Un '**Dockerfile**' peut être utilisé dans un environnement de développement pour automatiser la configuration et le déploiement de plusieurs conteneurs Docker. Il peut également être utilisé dans un environnement de production pour déployer des applications en production de manière cohérente et reproductible.

Voici quelques raisons pour lesquelles vous pourriez utiliser un '**Dockerfile**' dans un tutoriel :

1. Reproductibilité : En utilisant un Dockerfile, vous pouvez créer une image Docker qui contient tous les outils et dépendances nécessaires pour votre application. Cela garantit que chaque utilisateur qui exécute votre tutoriel utilise exactement le même environnement, ce qui rend votre tutoriel plus reproductible.

2. Facilité d'utilisation : Avec un Dockerfile, vous pouvez facilement créer et configurer plusieurs conteneurs Docker avec des images personnalisées en utilisant des instructions simples. Cela rend l'utilisation de plusieurs conteneurs plus facile et plus rapide.

3. Portabilité : En utilisant un Dockerfile, vous pouvez créer une image Docker qui peut être exécutée sur n'importe quel système d'exploitation prenant en charge Docker. Cela rend votre application plus portable et facilite le déploiement sur différents systèmes.

4. Isolation : En utilisant des conteneurs Docker, vous pouvez isoler votre application et ses dépendances du reste du système d'exploitation. Cela garantit que votre application ne perturbe pas le reste du système, et vice versa.

En résumé, l'utilisation d'un '**Dockerfile**' peut vous aider à créer et à configurer des conteneurs Docker de manière rapide et reproductible, ce qui peut rendre l'exécution de tutoriels plus facile et plus efficace.

## 48 - Cron-Ticker : Créer un application simple avec node.js.

## 49 - **DockerFile** - les premiers pas.

- Commencement du Dockerfile :
```
# /app /usr /lib
FROM node:19.2-alpine3.16

#cd app
WORKDIR /app

#Dest /app
COPY app.js package.json ./

# Install dependencies
RUN npm install

# Commande to run image
CMD [ "node", "app.js" ]
```

## 50 - Suite du 49 - Création de l'image avec le Dockerfile.

- Créer l'image après d'avoir ajouter l'information du Dockerfile création de l'image.

important se trouver au même niveau que le Dockerfile
  ```
  cron_ticker > 
  docker build --tag cron_ticker .
  ```

- Faire courir l'image que nous avons créer :
  ```
  docker container run cron_ticker
  ```

- Le supprimer ce container créer : 
  ```
  docker container rm -f cron_ticker
  ```

## 51 - Reconstruir l'image du cours 50 et faire des modifications.

Pourquoi on veut reconstruire une image sur dockerfile ? 

```
Il y a plusieurs raisons pour lesquelles vous pourriez vouloir reconstruire une image Docker à l'aide d'un fichier Dockerfile :

1. Mettre à jour les dépendances : Si les   dépendances d'une application ont changé, vous devrez reconstruire l'image pour inclure ces mises à jour.

2. Appliquer des correctifs de sécurité : Si une vulnérabilité de sécurité est découverte dans une dépendance ou dans l'image de base, vous devrez reconstruire l'image pour appliquer les correctifs.

3. Modifier la configuration : Si vous devez changer la configuration d'une application, vous pouvez le faire en modifiant le Dockerfile et en reconstruisant l'image.

4. Ajouter de nouvelles fonctionnalités : Si vous souhaitez ajouter de nouvelles fonctionnalités à une application, vous pouvez le faire en modifiant le Dockerfile et en reconstruisant l'image.

En somme, la reconstruction d'une image Docker à l'aide d'un fichier Dockerfile permet de mettre à jour et de modifier facilement une application ou un service en créant une nouvelle image basée sur la configuration et les dépendances les plus récentes
```

Vous avons fait des changement dans notre Dockerfile du 49 à celui-ci  :
```
# /app /usr /lib
FROM node:19.2-alpine3.16

#cd app
WORKDIR /app

#Dest /app
COPY package.json ./

# Install dependencies
RUN npm install

#Dest /app
COPY app.js ./

# Commande to run image
CMD [ "node", "app.js" ]
```
1. Nous avons fait la 1er fois : et fait le changement seulement dans le **Dockerfile.**
   ```
   docker build --tag cron_ticker .
   ```
   et voir la construction de l'image.

2. La 2e fois la même commande 
  ```
  docker build --tag cron_ticker .
  ```
  et voir la construction de l'image avec les caches de Docker..
3. La 3e fois faire des changement dans le [app.js](app.js#L7) :
  ```
  const cron = require('node-cron');

  let times = 0;

  cron.schedule('1-59/5 * * * * *', () => {

      times++;
      console.log('Tick tack every 5 seconds: ', times);

  });

  console.log('Commencement');
  ```
  et partir la commande : 
  ```
  docker build --tag cron_ticker .
  ```

4. la 4e fois partir la même commande mais on voit que à l'étapes 5 est la seule à ce construire et de 1 à 4 sont en caches : 
  ```
  docker build --tag cron_ticker .
  ```

Les méthodes des caches permettent à docker de être plus performant à la reconstruction d'images et d'autres.


Par contre cela créer beaucoup trop de déchet d'image et difficile à repérer et savoir le quelle est lequel : 
```
docker image ls

docker image ls
REPOSITORY                              TAG             IMAGE ID       CREATED          SIZE  
cron_ticker                             latest          000000000004   13 minutes ago   173MB 
<none>                                  <none>          000000000003   14 minutes ago   173MB 
<none>                                  <none>          000000000002   15 minutes ago   173MB 
<none>                                  <none>          000000000001   2 days ago       173MB 
```

Comme on voit c'est les images que vous venons de créer, malheureusement, il est difficile de savoir la quel est la bonne image pour la dépendance de notre projet.

Il est important de mettre des tags à nos images :
```
docker build --tag cron_ticker:1.0.0 .

docker image ls
REPOSITORY                              TAG             IMAGE ID       CREATED          SIZE  
cron_ticker                             1.0.0           000000000004   20 minutes ago   173MB 
cron_ticker                             latest          000000000004   20 minutes ago   173MB 
```
### Rénommer le nom d'une image

Documentation :
```
docker image tag SOURCE[:TAG] TARGET_IMAGE[:TAG]   -> Cette méthode est l'actuel :
docker tag IMAGE NEW_IMAGE
docker tag <Tag Actual> <USER>/<NEW NAME>
```
- Changer le nom de l'image :
  ```
  docker image tag cron_ticker:1.0.0 cron_ticker:bufalo

  REPOSITORY                              TAG             IMAGE ID       CREATED          SIZE 
  cron_ticker                             1.0.0           000000000004   29 minutes ago   173MB
  cron_ticker                             bufalo          000000000004   29 minutes ago   173MB
  cron_ticker                             latest          000000000004   29 minutes ago   173MB
  ```
Nous avons fait un changement dans le app.js et nous recommençons le build du dockerfile :
```
docker build --tag cron_ticker:latest .

REPOSITORY                              TAG             IMAGE ID       CREATED          SIZE
cron_ticker                             latest          000000000005   9 seconds ago    173MB
cron_ticker                             1.0.0           000000000004   32 minutes ago   173MB
cron_ticker                             bufalo          000000000004   32 minutes ago   173MB
```
Nous pouvons voir que la nouveau latest à un id différent !
-----

Si nous savons que nous devons maintenir la version de cette application est et important de lui changer sont nom latest pour un tag :

```
docker image tag cron_ticker cron_ticker:castor

> docker image ls
REPOSITORY                              TAG             IMAGE ID       CREATED          SIZE 
cron_ticker                             castor          000000000005   5 minutes ago    173MB
cron_ticker                             latest          000000000005   5 minutes ago    173MB
cron_ticker                             1.0.0           000000000004   37 minutes ago   173MB
cron_ticker                             bufalo          000000000004   37 minutes ago   173MB
```

- SI nous voulons courir notre version Castor :
  ```
  docker container run cron_ticker:castor

  Commencement

  Tick every 5 seconds:  1
  Tick every 5 seconds:  2
  ```

## 52 - Télécharger notre image dans le docker.hub dans le cloud.

- Version privé une seule image.
- Version public plusieurs images.

1. Se connecter à hub.docker.com.
2. créer un repository - public.
3. Renombre l'image latest pour celle de docker hub.
   ```
   docker image tag cron_tricker sergioanino/cron_ticker
   ```
4. S'authentifier sur hub.docker avec la commande sur le terminal pour être capable de faire de push de notre image au cloud :
   ```
   > docker login

   docker login

    Login with your Docker ID to push and pull images from Docker hub.
    USERNAME :  sergioanino
    PASSWORD :

    Authenticating with existing credentials.
    Login Succeeded.

   > docker logout
   ```
5. Push l'image sur hub.docker avec la version latest.
   ```
   docker push sergioanino/cron_ticker:tagname
   ```
6. Si nous voulons ajouter d'autre version en ligne :
   ```
   docker image tag sergioanino/cron_ticker:latest sergioanino/cron_ticker:castor

   docker image ls

   docker push sergioanino/cron_ticker:castor
   ```
![Image docker cloud](assets/images/image_on_hub_docker.PNG)

## 53 - Construire une image de docker.hub : utiliser notre image de docker hub

1. Faire un nettoyage de nos images inutilisée :
   ```
   docker image ls

   docker image prune

   si nous voulons même ceux avec des noms :
   docker image prune -a
   ```
2. Courir notre image de docker.hub en ligne sur notre pc :
   ```
   docker container run sergioanino/cron_ticker:castor

   docker container run sergioanino/cron_ticker:castor

   Unable to find image 'sergioanino/cron_ticker:castor' locally
   castor: Pulling from sergioanino/cron_ticker
   ************: Already exists
   ************: Already exists
   ************: Already exists
   ************: Already exists
   ************: Already exists
   ************: Already exists
   ************: Already exists
   ************: Already exists

   Digest: sha256:**********************************
   Status: Downloaded newer image for sergioanino/cron_ticker:castor

   Commencement.

   Tick every 5 seconds:  1
   Tick every 5 seconds:  2
   Tick every 5 seconds:  3
   Tick every 5 seconds:  4
   ```
## 54 - Ajouter du testing automatiser à notre code avec npm jest avant de l’implémenter dans l Dockerfile du cours suivant :

1. Installer : jest à node.js
   ```
   pwd : être sur le path du package.json

   npm i jest --save-dev
   ```
2. Nous avons fait des changements dans le [app.js](app.js) :
   ```
   const cron = require('node-cron');
   const { syncDB } = require('./tasks/sync-db');
   
   
   console.log("Commencement de l'application");
   
   cron.schedule('1-59/5 * * * * *', syncDB);
   ```
   et créer un nouveau dossier avec son fichier : tasks\sync-db.js [tasks\sync-db.js](tasks/sync-db.js)
   ```
     let times =0;
     
     const syncDB = () => {
         times++;
         console.log('tick multiple de 5 :', times);
     
         return times;
     }
     
     module.exports ={
         syncDB
     }
   ```
3. Lancer l'application : 
   ```
   npm start

   > cron_ticker_48_62@1.0.0 start
   > node app.js

   Commencement de l'application :

   tick multiple de 5 : 1
   tick multiple de 5 : 2
   ```
5. Créer un nouveau dossier [tests/tasks/sync-db.test.js](tests/tasks/sync-db.test.js)
   ```
   const { syncDB } = require('../../tasks/sync-db');

   describe('Preuve de Sync-DB', () => {
   
       test("iI doit passer ce processus deux fois", () => {
       
           syncDB();
           const times = syncDB();
           expect( times ).toBe( 2);
       });
   
   });
   ```
   et faire le changement dans la [package.json#L7](package.json)
   ```
   "scripts": {
    "test": "jest",
    "start": "node app.js"
   },
   ```
   Lancer le testing :
   ```
   npm run test
   ```
## 55 - Incorporer les testings dans la création d'image docker suite du 54 :

1. ou faire le testing : 
   ```
   # /app /usr /lib
   FROM node:19.2-alpine3.16
   
   # cd app
   WORKDIR /app
   
   # Dest /app
   COPY package.json ./
   
   # Install dependencies
   RUN npm install
   
   # Dest /app
   COPY . .
   
   # Testing :
   RUN npm run test
   
   # Commande to run image
   CMD [ "node", "app.js" ]
   ```
   IMPORTANT : ce n'est pas la méthode la plus eficaces : Elle mets aussi tous nos dossier node_modules, tests & tasks dans notre images : des dossier et fichier que ne sont pas important : 

   Créer un nouveau build pour voir la différence de poids sur l'image.
   ```
   docker image ls 

   docker build -t sergioanino/cron_ticker:mapache .

   docker image ls 
   REPOSITORY                              TAG             IMAGE ID       CREATED          SIZE
   sergioanino/cron_ticker                 mapache         d27ecc908d48   17 seconds ago   259MB
   sergioanino/cron_ticker                 castor          2ee09f1df46a   2 hours ago      173MB
   ```
Vous avez remarque comment l'image est devenu plus grande car il y a des dossier et fichier qui ne devrait être intégrer à l'image.

## 56 - Examiner l'image créer et l'améliorer suite du cours 55

1. Voir le contenue à l'intérieur du container :
   ```
   docker image ls

   docker container run -d sergioanino/cron_ticker:mapache

   docker exec -it mapache /bin/sh 

   > app : ls
   ```

## 57 - Dockerignore.

1. Ajouter le [Dockerignore](.dockerignore) : 

   ```
   node_modules/
   
   Dockerfile
   ```
   Créer le build de cette image :
   ```
    docker build -t sergioanino/cron_ticker:tigre .
  
    REPOSITORY                              TAG             IMAGE ID       CREATED          SIZE
    sergioanino/cron_ticker                 tigre           83bc6e71c19c   35 seconds ago   236MB
    sergioanino/cron_ticker                 mapache         d27ecc908d48   23 minutes ago   259MB
   ```
  Il est déjà possible de voir que le **_poids_** de l'image est descendu.

## 58 - Optimiser l'image avec sa création du Dockerfile la meilleur solution est le multi stage dockerfile seulement la manière est montrer dans la section 6.

1. Optimisation du dockerfile pour qu'il créer le nécessaire en production :
   ```
   # /app /usr /lib
     FROM node:19.2-alpine3.16
     
     # cd app
     WORKDIR /app
     
     # Dest /app
     COPY package.json ./
     
     # Install dependencies
     RUN npm install
     
     # Dest /app
     COPY . .
     
     # Testing :
     RUN npm run test
     
     # delete unless directory to production :
     RUN rm -rf tests && -rf node_modules
     
     # DEP to production :
     RUN npm install --prod
     
     # Commande to run image
     CMD [ "node", "app.js" ]
   ```
2. Créer une nouvelle image avec un nouveau tags et voir la différence :
   ```
   docker build -t sergioanino/cron_ticker:pantera .

   docker image ls
   ```
3. Voir le contenue à l'intérieur du container pour vérifier si les dossier de tests et le node_modules ont vient été supprimer :
   ```
   docker image ls

   docker container run -d sergioanino/cron_ticker:pantera

   docker exec -it pantera /bin/sh 

   > app : ls
   ```
## 59 - Devoir : télécharger notre image pantera 58 sur le cloud de hub.docker

- télécharger l'image pantera
- créer un nouveau tag = latest
- télécharger l'image pantera avec ce tag sur dockerhub.

1. Changer le nom de l'image pantera pour qu'elle soit le latest aussi :
   ```
   docker image tag sergioanino/cron_ticker:pantera `
   sergioanino/cron_ticker

   docker image ls
   ```
2. Télécharger l'image sur docker hub :
   ```
   docker push sergioanino/cron_ticker
   docker push sergioanino/cron_ticker:pantera
   ```

   Les deux c'est la même chose car le id de cette image est la même !
   ```
   > docker image ls

   REPOSITORY                              TAG             IMAGE ID       CREATED          SIZE 
   sergioanino/cron_ticker                 latest          2d9656a88ddf   12 minutes ago   237MB
   sergioanino/cron_ticker                 pantera         2d9656a88ddf   12 minutes ago   237MB
   ```
## 60 - Forcer à un système opérative de ce construir avec un système d’exploitation différent : mac, windows, linux et etc..

1. Ajout du platform sur le dockerfile - choix du build pour les types de plateforme : 
   ```
   # /app /usr /lib
   FROM --platform=linux/amd64 node:19.2-alpine3.16
   ```
   Le seule changement pour spécifier la plateforme !

2. faire le push dans docker hub et voir le tag de la architecture de l'image :
   ```
   docker push sergioanino/cron_ticker
   ```
par contre, si nous enlevons la plateforme du fichier **Dockerfile** celui-ci va écrase notre image ou nous avons spécifier la plateforme : voir la documentation pour utiliser le [buildx](https://docs.docker.com/build/building/multi-platform/#getting-started) qui va nous faciliter la construction des images avec plusieurs architecture.

## 61 - Utilisation du buildx pour la construction images avec plusieurs architecture

1. Lister les buildx sur notre desktop docker :
   ```
   docker buildx ls

   NAME/NODE       DRIVER/ENDPOINT STATUS  BUILDKIT PLATFORMS
   default *       docker
     default       default         running 20.10.24 linux/amd64, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
   desktop-linux   docker
     desktop-linux desktop-linux   running 20.10.24 linux/amd64, linux/arm64, linux/riscv64, linux/ppc64le, linux/s390x, linux/386, linux/arm/v7, linux/arm/v6
   ```

2. Installer un exemple du site de la documentation :
   
   Ceci affiche le pilote intégré par défaut, qui utilise les composants du serveur BuildKit intégrés directement dans le moteur Docker, également connu sous le nom de pilote Docker.

Créez un nouveau constructeur en utilisant le pilote docker-container qui vous donne accès à des fonctionnalités plus complexes comme les constructions multi-plateformes et les exportateurs de cache plus avancés, qui ne sont actuellement pas pris en charge par le pilote docker par défaut :

   ```
   docker buildx create --name mybuilder --driver docker-container --bootstrap
   ```
   Switch to the new builder:
   ```
   docker buildx use mybuilder
   ```
   Inspecter le buildx :
   ```
   docker buildx inspect
   ```
   Cette action fait en sorte que notre mybuilder devient notre constructeur d'image avec tout les architecture pour des différent système de exploitation.

2. Changer le Dockerfile pour ajouter les variables d'environnement du buildx pour des création futur :
   ```
   # /app /usr /lib
   # FROM node:19.2-alpine3.16
   # FROM --platform=linux/amd64 node:19.2-alpine3.16
   FROM --platform=$BUILDPLATFORM node:19.2-alpine3.16
   ```
3. Créer le build ( Buildx) avec pour les architecture par default indiquer par nous !
   ```
   docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 `
   -t <username>/<image>:latest --push .

   docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 `
   -t sergioanino/cron_ticker:latest --push .
   ```
   Nous pouvons vérifier sur notre compte dockerhub qui l'image à bien été télécharger ?

   SI JAMAIS ERREUR : comment effacer un buildx :
   ```
   docker buildx ls

   docker buildx rm mybuilder
   ```

4. Changer le nom de l'image du buildx :
   ```
   docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 `
   -t sergioanino/cron_ticker:oso --push .
   ```

Vérifier sur le site du hub.docker.com : si téléchargement de l'image.

Nous avons utilise la documentation pour tout le long de cette exemple : [buildx](https://docs.docker.com/build/building/multi-platform/#getting-started).


## 62 - Buildx - Construction en multiple architectures base sur la architecture de mon pc !

1. Faire un changement sur le dockerfile pour ne pas spécifier la architecture voulu et que soit celle de mon pc par default :
   ```
   # /app /usr /lib
   FROM node:19.2-alpine3.16
   # FROM --platform=linux/amd64 node:19.2-alpine3.16
   # FROM --platform=$BUILDPLATFORM node:19.2-alpine3.16
   ```

2. Construction multi-plateforme :
   ```
   docker buildx build `
   --platform linux/amd64,linux/arm64,linux/arm/v7 `
   -t sergioanino/cron_ticker:mono --push .
   ```
 Même si nous avons mit **_FROM node:19.2-alpine3.16_** et que doit prendre par default l'architecture de mon système opérative le buildx ont lui spécifier le type de architecture alors il va créer cela sans prendre en compte mon système.
--------

---------

# Section 6 - Multi-Stage Build.

Un Dockerfile avec une construction multi-étapes (multistage build) permet de créer une image Docker plus légère et plus sécurisée en utilisant plusieurs étapes de construction (stages) pour générer l'image finale.

Dans une construction multi-étapes, chaque étape utilise une image de base différente et ne contient que les fichiers nécessaires pour cette étape. Cela permet de réduire la taille de l'image finale en ne gardant que les fichiers nécessaires à l'exécution de l'application, sans inclure les fichiers de construction ou les outils non nécessaires.

Par exemple, une première étape peut inclure un environnement de développement complet avec des outils tels que des compilateurs, des débogueurs, etc. tandis que la deuxième étape peut être utilisée pour copier uniquement les fichiers de l'application nécessaire pour son exécution dans un environnement de production. Ainsi, l'image finale sera beaucoup plus petite que si elle avait été construite à partir d'une seule étape contenant l'ensemble des outils et fichiers.

De plus, cette approche peut améliorer la sécurité en éliminant les outils de développement qui pourraient être utilisés à des fins malveillantes. Les images générées avec une construction multi-étapes sont également plus faciles à maintenir et à mettre à jour, car chaque étape peut être mise à jour ou remplacée individuellement sans affecter les autres étapes.

En résumé, la construction multi-étapes permet de générer des images Docker plus légères, plus sécurisées et plus faciles à maintenir en utilisant des étapes de construction séparées pour optimiser la taille et la sécurité de l'image finale.

## 66 - Continue le projet suite : clone le projet de la section 5 ou du vidéo : 62.

Juste le clone de l'application.

## 67 - Multi-state Build

1. 