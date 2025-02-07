
# Docker - TP 1

## Partie 1
Exécuter un serveur web (Nginx) dans un conteneur Docker et à y servir une page HTML statique.

### Récupération de l’image Nginx depuis Docker Hub


- Télécharger l'image Nginx depuis Docker Hub

```bash
docker pull nginx
```

- Vérifier que l'image est bien présente en local
```bash
docker images
```

### Création d’un fichier HTML

- Créer le fichier index.html
```bash
touch index.html
```

- Éditer le fichier avec nano (ou un autre éditeur)
```bash
nano index.html
```
- Contenu du fichier index.html :

```bash

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mon TP Docker</title>
</head>
<body>
    <h1>Bienvenue sur mon serveur Nginx dans Docker !</h1>
</body>
</html>

```
### 1️⃣ Procédure 5 - Méthode 1 : Montage d’un Volume (-v)

On lance un conteneur Nginx en montant un fichier HTML local dans le conteneur à l’aide de l’option -v.

- Lancer un conteneur Nginx et monter le fichier index.html

```bash
docker run -d -p 8080:80 -v $(pwd)/index.html:/usr/share/nginx/html/index.html nginx
```

- Vérification de l'accès au serveur web

```bash
http://localhost:8080
```

### Suppression du conteneur

- Lister les conteneurs en cours d'exécution
```bash
docker ps
```
- Arrêter le conteneur en utilisant son ID

```bash
docker stop b685995a5f86
```
- Supprimer le conteneur

```bash
docker rm b685995a5f86
```


### 2️⃣ Procédure 5 - Méthode 2 : Copie du fichier avec docker cp

On copie manuellement le fichier index.html dans un conteneur en cours d’exécution avec docker cp.

- Lancer un nouveau conteneur Nginx sans volume

```bash
docker run -d -p 8080:80 --name mon_nginx nginx
```
- Copier le fichier index.html dans le conteneur

```bash
docker cp index.html mon_nginx:/usr/share/nginx/html/index.html
```
- Redémarrer le conteneur pour prendre en compte le fichier copié

```bash
docker restart mon_nginx
```

- Vérification de l'accès après la copie
```bash
http://localhost:8080
```

### 3️⃣ Procédure 6 - Méthode 3 : Création d’une Image avec un Dockerfile

On crée une nouvelle image Docker qui contient directement le fichier index.html à l’aide d’un Dockerfile.

- Créer un Dockerfile

```Dockerfile
FROM nginx:latest
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```
- Construire l’image
```bash

docker build -t mon-nginx .
```
- Exécuter l’image
```bash

docker run -d -p 8080:80 mon-nginx
```
## Résultat de la Partie 1
### Procédure 5 (-v et docker cp) :
- Idéale pour le développement, rapide et modifiable sans reconstruire l’image, mais moins portable et non adapté à la production.  
### Procédure 6 (Dockerfile) :
- Plus portable et stable, parfaite pour la production et le déploiement automatisé, mais nécessite un rebuild à chaque modification.
- Dockerfile permet de créer une image avec le fichier index.html dedans, on peut redéployer cette image, elle aura toujours le meme index.html
 ### Conclusion :

### ✅ Développement → -v | ✅ Production → Dockerfile 🚀


## Partie 2

Utiliser une base de données dans un conteneur docker

### Récupération des images `mysql` et `phpmyadmin` depuis Docker Hub


- Télécharger les images depuis Docker Hub

```bash
docker pull mysql:5.7
docker pull phpmyadmin/phpmyadmin

```
- lancer un conteneur MYSQL
```bash
docker run -d --name mysql-container -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=tp_db -p 3306:3306 mysql:5.7
```
 > `--name mysql-container` → Nom du conteneur.  
 > `-e MYSQL_ROOT_PASSWORD=root` → Définit le mot de passe root.  
 > `-e MYSQL_DATABASE=tp_db` → Crée une base de données tp_db.  
 > `-p 3306:3306` → Expose MySQL sur le port 3306.  

- Lancer un conteneur phpMyAdmin
```bash
docker run -d --name phpmyadmin-container --link mysql-container -p 8081:80 -e PMA_HOST=mysql-container phpmyadmin/phpmyadmin
```
> `--link mysql-container` → Connecte phpMyAdmin à MySQL.  
> `-p 8081:80 → phpMyAdmin` est accessible sur http://localhost:8081.  
> `-e PMA_HOST=mysql-container` → Définit l’hôte MySQL.  

- Pour se connecter au conteneur `MySQL` :
```bash
docker exec -it mysql-container mysql -u root -p
```

> `docker exec -it mysql-container` → Ouvre un terminal interactif dans le conteneur MySQL.

### Faire la même chose que précédemment en utilisant un fichier `docker-compose.yml`

- Création du fichier `docker-compose.yml`:
```bash
touch docker-compose.yml
nano docker-compose.yml
```
Ajouter le contenu suivant:
```yaml
services:
  mysql:
    image: mysql:5.7
    container_name: mysql-container
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: tp_db
      MYSQL_USER: user
      MYSQL_PASSWORD: password
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - my_network

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: phpmyadmin-container
    restart: always
    depends_on:
      - mysql
    environment:
      PMA_HOST: mysql
      MYSQL_ROOT_PASSWORD: root
    ports:
      - "8081:80"
    networks:
      - my_network

volumes:
  mysql_data:
    name: my_volume

networks:
  my_network:
    name: my_network
    driver: bridge

```

- Exécute la commande suivante pour démarrer MySQL et phpMyAdmin :

```bash
docker-compose up -d

```
- Cela va démarrer MySQL et phpMyAdmin ensemble, sans avoir besoin d’exécuter plusieurs `docker run`.

### Des notes:
- Si la directive `networks` n'est pas définit, docker crée automatiquement un réseau par défaut pour que les conteneurs d’un même docker-compose.yml puissent communiquer entre eux sans exposer leurs ports sur l’hôte.
- Le volume est un espace de stockage persistant attribué à MySQL. Il permet de conserver les données même si le conteneur est supprimé ou redémarré.
- Pour lister ou supprimer les networks et les volumes :
```bash
docker network ls
docker network inspect my_network
docker network rm my_network
docker volume ls
docker volume inspect my_volume
docker rm my_volume

```
- Par défaut, Docker Compose utilise le nom du dossier contenant le fichier ` docker-compose.yml`  comme préfixe pour les réseaux, volumes et conteneurs.
- Pour éviter les conflits quand plusieurs stacks sont exécutées, Docker Compose nomme les ressources ainsi : `<nom_du_projet>_<nom_de_la_ressource>`
- Si on veut désactiver ce préfixe, on peut spécifier un nom de projet en lançant Docker Compose : `docker-compose -p myproject up -d`
- Un réseau a été créé par Docker Compose pour connecter les services définis dans le fichier ` docker-compose.yml` .

### Détails du réseau

| Champ           | Valeur                 | Explication                                      |
|----------------|-----------------------|--------------------------------------------------|
| **Nom**        | `my_network       `   | Nommé automatiquement d'après le projet (docker-tp-1) |
| **ID**         | ` 2196d5cf0298... `      | Identifiant unique du réseau                     |
| **Type (Driver)** | ` bridge `             | Type de réseau utilisé (isolé du réseau hôte)   |
| **Scope**      | ` local`                  | Réseau local uniquement sur cette machine       |
| **IPv4 Subnet** | ` 172.18.0.0/16  `       | Adresse IP attribuée à ce réseau Docker        |
| **Gateway**    | ` 172.18.0.1 `            | Passerelle du réseau pour communication externe |
| **Attachable** | ` false `                 | Les conteneurs externes ne peuvent pas s'y attacher |
| **Ingress**    | ` false  `                | Pas utilisé pour le load balancing              |

### Deux conteneurs sont attachés :

### Détails des conteneurs

| Conteneur       | Nom                   | Adresse IP    | MAC Address          |
|----------------|----------------------|--------------|----------------------|
| 2fb9ad413683  |  `phpmyadmin-container `  | 172.18.0.3   | 02:42:ac:12:00:03   |
| 5dcfccd654d3  | ` mysql-container    `    | 172.18.0.2   | 02:42:ac:12:00:02   |

- Elles sont attribuées dynamiquement dans le sous-réseau 172.18.0.0/16 par Docker.
- phpMyAdmin et MySQL peuvent communiquer via leurs noms de service (mysql, phpmyadmin) grâce à Docker DNS interne.
3- Vérifier la connectivité dans le réseau :
```bash
docker exec -it phpmyadmin-container bash
apt update && apt install -y iputils-ping
docker exec -it phpmyadmin-container ping mysql

```
Si on veut installer les paquets via le fichier `docker-compose.yml`, on peut ajouter la directive `entrypoint` suivante :
```bash
entrypoint: ["/bin/sh", "-c", "apt update && apt install -y iputils-ping && exec docker-php-entrypoint apache2-foreground"]
```
- On doit inclure `docker-php-entrypoint` et `apache2-foreground`, sinon le conteneur va s’arrêter immédiatement après l’installation des paquets.

- Pourquoi a-t-on besoin de exec docker-php-entrypoint apache2-foreground ?
  - `docker-php-entrypoint` → C'est le script officiel de l'image `phpmyadmin/phpmyadmin`. Il prépare l'environnement avant de lancer Apache.
  - `apache2-foreground` → Démarre Apache en mode "foreground" (au premier plan), permettant au conteneur de continuer à tourner.
  - Sans ce processus actif, Docker considère que le conteneur a terminé son travail et l’arrête.

- Pour supprimer les conteneurs :
```bash
docker compose down -v
```
## Résultat de la Partie 2

- Pourquoi `docker-compose` est intéressant par rapport à `docker run` ?
  - **Simplifie le déploiement** : Un seul fichier (`docker-compose.yml`) pour plusieurs conteneurs.
  - **Automatise les dépendances** : `depends_on` assure l’ordre de démarrage.
  - **Facilite la configuration** : Volumes, réseaux et variables d’environnement en un seul endroit.
  - **Réutilisable** : Facile à partager et à versionner avec `Git`.
- Comment configurer MySQL facilement au lancement ?
  - Avec les variables d’environnement dans `docker-compose.yml` :

## les commandes utils:
```bash
docker pull nginx:latest
docker pull mysql:5.7
docker pull phpmyadmin/phpmyadmin
docker run -d -p 8080:80 --name mon_nginx nginx:latest
docker ps
docker ps -a
docker stop abc123 def456 ghi789
docker rm abc123 def456 ghi789
docker run -d --name phpmyadmin-container --link mysql-container -p 8081:80 -e PMA_HOST=mysql-container phpmyadmin/phpmyadmin
docker exec -it mysql-container mysql -u root -p
docker network ls
docker network inspect my_network
docker network rm my_network
docker-compose up -d
docker-compose down -v
docker exec -it phpmyadmin-container bash
apt update && apt install -y iputils-ping
docker exec -it phpmyadmin-container ping mysql-container
entrypoint: ["/bin/sh", "-c", "apt update && apt install -y iputils-ping && exec docker-php-entrypoint apache2-foreground"]


```
