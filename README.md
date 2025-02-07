
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

### Récupération des images mysql et phpmyadmin depuis Docker Hub


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

- Pour se connecter au conteneur mysql :
```bash
docker exec -it mysql-container mysql -u root -p
```

> `docker exec -it mysql-container` → Ouvre un terminal interactif dans le conteneur MySQL.


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

```
