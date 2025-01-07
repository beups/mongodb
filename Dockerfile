# Utiliser une version spécifique d'Ubuntu pour éviter les problèmes liés à "latest"
FROM ubuntu:20.04

# Ajouter une étiquette pour remplacer le champ obsolète MAINTAINER
LABEL maintainer="Kimbro Staken"

# Mettre à jour le système et installer les dépendances nécessaires
RUN apt-get update && apt-get install -y \
    gnupg curl apt-utils ca-certificates --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Ajouter la clé GPG pour le dépôt MongoDB (remplace l'ancien apt-key)
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-archive-keyring.gpg

# Ajouter le dépôt MongoDB
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mongodb-archive-keyring.gpg] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" \
    | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

# Mettre à jour la liste des paquets et installer MongoDB
RUN apt-get update && apt-get install -y mongodb-org && rm -rf /var/lib/apt/lists/*

# Exposer le port MongoDB
EXPOSE 27017

# Commande par défaut pour démarrer MongoDB
CMD ["/usr/bin/mongod", "--config", "/etc/mongod.conf"]
