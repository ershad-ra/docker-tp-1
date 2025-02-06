# Docker - TP 1

## Partie 1
Exécuter un serveur web (Nginx) dans un conteneur Docker et à y servir une page HTML statique.

---

## Étapes réalisées

## 1. Clonage du repository et préparation de l'environnement

### Cloner le repository
git clone https://github.com/ershad-ra/docker-tp-1.git

### Se déplacer dans le dossier du projet
cd docker-tp-1



## 2. Récupération de l’image Nginx depuis Docker Hub


### Télécharger l'image Nginx depuis Docker Hub
docker pull nginx

### Vérifier que l'image est bien présente en local
docker images


## 3. Création d’un fichier HTML

### Créer le fichier index.html
touch index.html

### Éditer le fichier avec nano (ou un autre éditeur)
nano index.html

Contenu du fichier index.html :

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

## 4. Démarrage d'un conteneur en montant un volume

### Lancer un conteneur Nginx et monter le fichier index.html
docker run -d -p 8080:80 -v $(pwd)/index.html:/usr/share/nginx/html/index.html nginx


## 5. Vérification de l'accès au serveur web

http://localhost:8080


## 6. Suppression du conteneur

### Lister les conteneurs en cours d'exécution
docker ps

### Arrêter le conteneur en utilisant son ID
docker stop b685995a5f86

### Supprimer le conteneur
docker rm b685995a5f86


## 7. Relancer un conteneur sans volume et copier le fichier HTML avec docker cp

### Lancer un nouveau conteneur Nginx sans volume
docker run -d -p 8080:80 --name mon_nginx nginx

### Copier le fichier index.html dans le conteneur
docker cp index.html mon_nginx:/usr/share/nginx/html/index.html

### Redémarrer le conteneur pour prendre en compte le fichier copié
docker restart mon_nginx


## 8. Vérification de l'accès après la copie

http://localhost:8080


## Partie 2
Exécuter un serveur web (Nginx) dans un conteneur Docker et à y servir une page HTML statique.

---

## Étapes réalisées

