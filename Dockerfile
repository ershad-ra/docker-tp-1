# Utilisation de l'image Nginx comme base
FROM nginx:latest

# Copie du fichier HTML dans le répertoire de Nginx
COPY index.html /usr/share/nginx/html/index.html

# Exposition du port 80
EXPOSE 80

# Lancement du serveur Nginx
CMD ["nginx", "-g", "daemon off;"]
