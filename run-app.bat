@echo off
REM ================================================================================
REM Script de démarrage AgriData
REM Ce script initialise la base de données et lance l'application
REM ================================================================================

echo ========================================
echo   AgriData - Demarrage de l'application
echo ========================================
echo.

REM Vérifier que JAVA_HOME est défini
if "%JAVA_HOME%"=="" (
    echo [ERREUR] JAVA_HOME n'est pas defini.
    echo Veuillez installer Java 17 ou superieur et definir JAVA_HOME.
    pause
    exit /b 1
)

echo [INFO] Java Home: %JAVA_HOME%
echo.

REM Vérifier que Docker est accessible
echo [INFO] Verification de Docker...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERREUR] Docker n'est pas accessible.
    echo Veuillez installer Docker Desktop et vous assurer qu'il est demarre.
    pause
    exit /b 1
)
docker --version
echo [OK] Docker est accessible
echo.

REM Vérifier si le conteneur MySQL existe déjà
echo [INFO] Verification du conteneur MySQL...
docker ps -a --filter "name=agridata-mysql" --format "{{.Names}}" | findstr "agridata-mysql" >nul
if %errorlevel% equ 0 (
    echo [INFO] Conteneur MySQL existe deja
    REM Vérifier s'il est en cours d'exécution
    docker ps --filter "name=agridata-mysql" --format "{{.Names}}" | findstr "agridata-mysql" >nul
    if %errorlevel% neq 0 (
        echo [INFO] Demarrage du conteneur MySQL existant...
        docker start agridata-mysql
        echo [OK] Conteneur MySQL demarre
    ) else (
        echo [OK] Conteneur MySQL deja en cours d'execution
    )
) else (
    echo [INFO] Creation et demarrage du conteneur MySQL...
    docker run -d ^
        --name agridata-mysql ^
        -e MYSQL_ROOT_PASSWORD=agridata_root ^
        -e MYSQL_DATABASE=agridata ^
        -e MYSQL_USER=agridata_user ^
        -e MYSQL_PASSWORD=agridata_pwd ^
        -p 3306:3306 ^
        mysql:8.0
    echo [OK] Conteneur MySQL cree et demarre
)
echo.

REM Attendre que MySQL soit prêt
echo [INFO] Attente que MySQL soit pret (30 secondes max)...
set /a count=0
:wait_mysql
docker exec agridata-mysql mysqladmin ping -h localhost --silent >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] MySQL est pret
    goto mysql_ready
)
set /a count+=1
if %count% geq 30 (
    echo [ERREUR] Timeout: MySQL n'est pas devenu pret dans les temps
    pause
    exit /b 1
)
timeout /t 1 /nobreak >nul
goto wait_mysql

:mysql_ready
echo.

REM Initialiser la base de données
echo [INFO] Initialisation de la base de donnees...
docker exec -i agridata-mysql mysql -u root -pagridata_root < setup-database.sql
if %errorlevel% neq 0 (
    echo [ERREUR] Echec de l'initialisation de la base de donnees
    pause
    exit /b 1
)
echo [OK] Base de donnees initialisee avec succes
echo.

REM Compiler le projet
echo [INFO] Compilation du projet avec Maven...
call mvnw.cmd clean package -DskipTests
if %errorlevel% neq 0 (
    echo [ERREUR] Echec de la compilation du projet.
    pause
    exit /b 1
)
echo [OK] Compilation reussie
echo.

REM Générer les données de test
echo [INFO] Generation des donnees de test...
"%JAVA_HOME%\bin\java" -cp "target/classes;target/agridata/WEB-INF/lib/*" com.agriiot.agridata.util.DataGenerator
if %errorlevel% neq 0 (
    echo [AVERTISSEMENT] Echec de la generation des donnees de test.
    echo L'application peut quand meme fonctionner.
)
echo.

REM Instructions pour le déploiement
echo ========================================
echo   Compilation terminee avec succes!
echo ========================================
echo.
echo Le fichier WAR est pret: target\agridata.war
echo.
echo Pour deployer l'application:
echo.
echo 1. TOMCAT (recommande):
echo    - Copiez target\agridata.war dans le dossier webapps de Tomcat
echo    - Demarrez Tomcat (startup.bat dans le dossier bin de Tomcat)
echo    - Acces: http://localhost:8080/agridata
echo.
echo 2. MAVEN TOMCAT PLUGIN (developpement):
echo    - Ajoutez le plugin Tomcat dans pom.xml
echo    - Executez: mvnw.cmd tomcat7:run
echo.
echo 3. SERVEUR D'APPLICATIONS:
echo    - Deployez target\agridata.war sur votre serveur d'applications
echo    (GlassFish, WildFly, Payara, etc.)
echo.
echo ========================================
pause

