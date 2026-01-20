# AgriData - Application IoT Agricole

Système de gestion des données de capteurs IoT pour l'agriculture.

## 🚀 Démarrage Ultra-Rapide

**Double-cliquez sur `run-app.bat` - C'est tout !**

Le script fait TOUT automatiquement :
- ✅ Vérifie Docker et Java
- ✅ Crée et démarre MySQL dans Docker (port 3307)
- ✅ Initialise la base de données
- ✅ Compile le projet
- ✅ Génère 5 capteurs et 5000 mesures de test
- ✅ Lance Tomcat 10 avec l'application
- ✅ Ouvre le navigateur automatiquement

## 📋 Prérequis

- **Java 17+** avec JAVA_HOME défini
- **Docker Desktop** installé et lancé
- **Windows** (le script batch est pour Windows)

## 🎯 URLs de l'Application

- **Page d'accueil** : http://localhost:8080/agridata
- **Liste des capteurs** : http://localhost:8080/agridata/capteurs.jsp
- **Statistiques des mesures** : http://localhost:8080/agridata/mesures.jsp
- **API Stats (JSON)** : http://localhost:8080/agridata/api/stats

## 🔧 Architecture

```
├── Service Layer (Logique métier)
│   └── DataService.java - Centralise toute la logique
│
├── DAO Layer (Accès données)
│   ├── CapteurDao.java - CRUD capteurs
│   ├── MesureDao.java - CRUD mesures
│   └── JpaUtil.java - Gestion EntityManager
│
├── Servlet Layer (API REST)
│   ├── StatsServlet.java - GET /api/stats
│   └── RegenerateDataServlet.java - POST /api/regenerate
│
├── Model Layer (Entités JPA)
│   ├── Capteur.java
│   └── Mesure.java
│
└── View Layer (JSP)
    ├── index.html - Page d'accueil
    ├── capteurs.jsp - Liste des capteurs
    └── mesures.jsp - Statistiques
```

## 🗄️ Base de Données MySQL (Docker)

Le script crée automatiquement un conteneur MySQL avec :

```
Conteneur : agridata-mysql
Host : localhost
Port : 3307 (externe) -> 3306 (interne)
Database : agridata
User : agridata_user
Password : agridata_pwd
Root Password : agridata_root
```

### Accéder à MySQL

```bash
# Depuis votre machine
mysql -h 127.0.0.1 -P 3307 -u agridata_user -pagridata_pwd agridata

# Depuis Docker
docker exec -it agridata-mysql mysql -u agridata_user -pagridata_pwd agridata
```

## 🔄 Régénérer les Données

Depuis l'interface web, cliquez sur le bouton **"🔄 Régénérer les Données"** sur la page d'accueil.

Ou manuellement :
```bash
docker exec agridata-mysql mysql -u root -pagridata_root agridata -e "TRUNCATE TABLE Mesure; DELETE FROM Capteur;"
java -cp "target/agridata/WEB-INF/classes;target/agridata/WEB-INF/lib/*" com.agriiot.agridata.util.DataGenerator
```

## 🛑 Arrêter l'Application

1. Fermez la fenêtre "AgriData - Serveur Tomcat" (ou Ctrl+C dedans)
2. Arrêtez MySQL : `docker stop agridata-mysql`

## 🐛 Dépannage

### Docker n'est pas lancé
```bash
# Lancer Docker Desktop depuis le menu Démarrer
# Ou vérifier :
docker info
```

### Port 3307 déjà utilisé
```bash
# Arrêter le conteneur existant
docker stop agridata-mysql
docker rm agridata-mysql
```

### Tomcat ne démarre pas
- Attendez 1-2 minutes la première fois (Cargo télécharge Tomcat 10)
- Vérifiez les logs dans la fenêtre cmd qui s'ouvre
- Vérifiez que le port 8080 est libre : `netstat -ano | findstr :8080`

### Recompiler manuellement
```bash
mvnw.cmd clean package -DskipTests
```

## 📦 Technologies

- **Backend** : Java 17, Jakarta EE 10, Hibernate 6.4
- **Base de données** : MySQL 8.0 (Docker)
- **Serveur** : Tomcat 10 (via Cargo Maven Plugin)
- **Build** : Maven
- **Frontend** : HTML, CSS, JavaScript, JSP

## 📊 Données Générées

Le générateur crée automatiquement :
- **5 capteurs** (Température, Humidité, pH, Luminosité, Pression)
- **5000 mesures** réparties sur 30 jours

## 🎉 C'est Prêt !

```bash
# Une seule commande pour tout lancer :
run-app.bat
```

Attendez que le navigateur s'ouvre automatiquement sur http://localhost:8080/agridata

**Bon développement ! 🚀**

## 📋 Prérequis

- **Java 17** ou supérieur ([OpenJDK](https://adoptium.net/) ou Oracle JDK)
- **Docker Desktop** installé et démarré
- **Apache Tomcat 10.1** ou autre serveur d'applications compatible Jakarta EE 10 (pour le déploiement)
- **Maven** (inclus via wrapper mvnw)

## 🚀 Installation et Démarrage Rapide

### Démarrage automatique (Windows)

**Double-cliquez simplement sur `run-app.bat` !**

Le script s'occupe automatiquement de :
1. ✅ Vérifier Docker et Java
2. ✅ Créer et démarrer un conteneur MySQL 8.0 dans Docker
3. ✅ Initialiser la base de données
4. ✅ Compiler le projet avec Maven
5. ✅ Générer des données de test
6. ✅ Créer le fichier WAR prêt pour le déploiement

**Aucune installation MySQL requise** - tout est géré via Docker !

### Configuration automatique

Le conteneur Docker MySQL est créé avec :
- **Nom du conteneur** : `agridata-mysql`
- **Base de données** : `agridata`
- **Utilisateur** : `agridata_user`
- **Mot de passe** : `agridata_pwd`
- **Port** : `3306`
- Les données persistent entre les redémarrages

Ce script va :
1. Vérifier les prérequis (Java, MySQL)
2. Créer la base de données et l'utilisateur
3. Compiler le projet avec Maven
4. Générer des données de test
5. Créer le fichier WAR prêt à déployer

## 🐳 Gestion du conteneur Docker MySQL

### Commandes utiles

```bash
# Voir les conteneurs en cours
docker ps

# Arrêter le conteneur MySQL
docker stop agridata-mysql

# Redémarrer le conteneur MySQL
docker start agridata-mysql

# Voir les logs du conteneur
docker logs agridata-mysql

# Accéder à MySQL dans le conteneur
docker exec -it agridata-mysql mysql -u agridata_user -pagridata_pwd agridata

# Supprimer complètement le conteneur (⚠️ perte de données)
docker rm -f agridata-mysql
```

### Option alternative: Installation manuelle MySQL

Si vous préférez utiliser MySQL installé localement au lieu de Docker :

#### 1. Configuration de la base de données

Connectez-vous à MySQL et exécutez :

```bash
mysql -u root -p < setup-database.sql
```

Ou manuellement :

```sql
CREATE DATABASE IF NOT EXISTS agridata;
CREATE USER IF NOT EXISTS 'agridata_user'@'localhost' IDENTIFIED BY 'agridata_pwd';
GRANT ALL PRIVILEGES ON agridata.* TO 'agridata_user'@'localhost';
FLUSH PRIVILEGES;
```

#### 2. Compilation du projet

```bash
mvnw.cmd clean package
```

#### 3. Génération des données de test (optionnel)

```bash
java -cp "target/classes;target/agridata/WEB-INF/lib/*" com.agriiot.agridata.util.DataGenerator
```

## 📦 Déploiement

### Sur Apache Tomcat

1. Copiez le fichier `target/agridata.war` dans le dossier `webapps` de Tomcat
2. Démarrez Tomcat :
   ```bash
   cd C:\Path\To\Tomcat\bin
   startup.bat
   ```
3. Accédez à l'application : http://localhost:8080/agridata

### Sur d'autres serveurs d'applications

Le fichier WAR est compatible avec :
- GlassFish 7.x
- WildFly 27+
- Payara 6.x
- TomEE 9.x

## 🏗️ Structure du Projet

```
AgriData/
├── src/main/java/com/agriiot/agridata/
│   ├── model/          # Entités JPA (Capteur, Mesure)
│   ├── dao/            # Couche d'accès aux données
│   └── util/           # Utilitaires (génération de données)
├── src/main/resources/
│   └── META-INF/
│       ├── persistence.xml  # Configuration JPA
│       └── beans.xml        # Configuration CDI
├── pom.xml             # Configuration Maven
├── run-app.bat         # Script de démarrage automatique
├── setup-database.sql  # Script d'initialisation DB
└── README.md           # Ce fichier
```

## 🔧 Configuration

### Base de données

La configuration se trouve dans `src/main/resources/META-INF/persistence.xml` :

- **URL**: `jdbc:mysql://localhost:3306/agridata`
- **Utilisateur**: `agridata_user`
- **Mot de passe**: `agridata_pwd`

### Pool de connexions

Le projet utilise HikariCP pour la gestion efficace des connexions :
- Pool maximum : 10 connexions
- Batch size : 50 pour les insertions

## 📊 Modèle de Données

### Entité Capteur
- `id` : Identifiant unique
- `nom` : Nom du capteur
- `type` : Type de capteur
- `emplacement` : Localisation du capteur

### Entité Mesure
- `id` : Identifiant unique
- `timestamp` : Date et heure de la mesure
- `valeur` : Valeur mesurée
- `unite` : Unité de mesure
- `capteur_id` : Référence au capteur (clé étrangère)

## 🛠️ Technologies Utilisées

- **Backend**: Java 17, Jakarta EE 10
- **ORM**: Hibernate 6.4.1 (JPA)
- **Base de données**: MySQL 8.0
- **Pool de connexions**: HikariCP 5.1.0
- **Serveur Web**: Jakarta Servlet 6.0
- **Build**: Maven 3.x

## 📝 Commandes Utiles

### Compiler sans exécuter les tests
```bash
mvnw.cmd clean package -DskipTests
```

### Nettoyer le projet
```bash
mvnw.cmd clean
```

### Compiler et installer en local
```bash
mvnw.cmd clean install
```

## 🐛 Dépannage

### MySQL n'est pas accessible
- Vérifiez que MySQL est démarré
- Ajoutez le dossier `bin` de MySQL au PATH système
  - Exemple : `C:\Program Files\MySQL\MySQL Server 8.0\bin`

### Erreur de connexion à la base de données
- Vérifiez que l'utilisateur `agridata_user` existe
- Vérifiez que le mot de passe est correct dans `persistence.xml`
- Vérifiez que MySQL écoute sur le port 3306

### Java introuvable
- Définissez la variable d'environnement `JAVA_HOME`
- Exemple : `C:\Program Files\Java\jdk-17`

### Port 8080 déjà utilisé
- Changez le port dans la configuration de Tomcat (`server.xml`)
- Ou arrêtez le processus utilisant le port 8080

## 📄 Licence

Projet éducatif - AgriIoT

## 👥 Auteurs

Équipe AgriData

