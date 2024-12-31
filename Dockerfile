# Étape 1 : Utiliser une image de base avec Maven et OpenJDK
FROM maven:3.8.4-openjdk-17-slim AS build

# Étape 2 : Définir le répertoire de travail dans le container
WORKDIR /app

# Étape 3 : Copier le fichier pom.xml et télécharger les dépendances Maven
COPY pom.xml .

# Étape 4 : Télécharger les dépendances Maven
RUN mvn dependency:go-offline

# Étape 5 : Copier tout le projet dans le container
COPY . .

# Étape 6 : Compiler et construire l'application
RUN mvn clean install

# Étape 7 : Créer une nouvelle image avec une image de runtime Java
FROM openjdk:17-slim

# Étape 8 : Copier l'artefact JAR de l'étape de construction vers l'image finale
COPY --from=build /app/target/projetdebops.jar /usr/app/projetdebops.jar

# Étape 9 : Exposer le port sur lequel l'application sera exécutée
EXPOSE 8080

# Étape 10 : Définir la commande pour exécuter l'application
CMD ["java", "-jar", "/usr/app/projetdebops.jar"]
