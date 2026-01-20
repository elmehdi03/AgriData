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
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Docker n'est pas installe ou n'est pas dans le PATH.
    pause
    exit /b 1
)

REM Vérifier si Docker est en cours d'exécution
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Docker n'est pas en cours d'execution.
    echo Veuillez demarrer Docker Desktop et reessayer.
    pause
    exit /b 1
)

echo [OK] Docker est installe et en cours d'execution
echo.

REM Arrêter et supprimer l'ancien conteneur s'il existe
echo [INFO] Nettoyage des anciens conteneurs...
docker rm -f agridata-mysql >nul 2>&1
timeout /t 2 /nobreak >nul
echo.

REM Créer et démarrer le conteneur MySQL
echo [INFO] Creation et demarrage du conteneur MySQL...
docker run -d ^
    --name agridata-mysql ^
    -e MYSQL_ROOT_PASSWORD=agridata_root ^
    -e MYSQL_DATABASE=agridata ^
    -e MYSQL_USER=agridata_user ^
    -e MYSQL_PASSWORD=agridata_pwd ^
    -p 3307:3306 ^
    mysql:8.0

if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Echec de la creation du conteneur MySQL
    pause
    exit /b 1
)
echo [OK] Conteneur MySQL demarre
echo.

REM Attendre que MySQL soit prêt avec une boucle plus robuste
echo [INFO] Attente que MySQL soit pret...
echo Cela peut prendre 30-60 secondes la premiere fois...
timeout /t 5 /nobreak >nul

set /a count=0
:wait_mysql
docker exec agridata-mysql mysqladmin ping -h localhost -u root -pagridata_root --silent >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo [OK] MySQL est pret !
    goto mysql_ready
)

set /a count+=1
if %count% GEQ 60 (
    echo.
    echo [ERREUR] MySQL n'a pas demarre dans les temps
    echo Logs MySQL:
    docker logs agridata-mysql --tail 20
    pause
    exit /b 1
)

if %count% EQU 15 echo    ... MySQL demarre toujours (15s)...
if %count% EQU 30 echo    ... MySQL demarre toujours (30s)...
if %count% EQU 45 echo    ... MySQL demarre toujours (45s)...

timeout /t 1 /nobreak >nul
goto wait_mysql

:mysql_ready
echo.

REM Initialiser la base de données
echo [INFO] Initialisation de la base de donnees...
timeout /t 2 /nobreak >nul
docker exec -i agridata-mysql mysql -u root -pagridata_root < setup-database.sql >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [AVERTISSEMENT] Initialisation SQL - La base existe peut-etre deja
)
echo [OK] Base de donnees prete
echo.

REM Compiler le projet
echo [INFO] Compilation du projet avec Maven...
call mvnw.cmd clean package -DskipTests -q
if %ERRORLEVEL% NEQ 0 (
    echo [ERREUR] Echec de la compilation
    pause
    exit /b 1
)
echo [OK] Compilation reussie
echo.

REM Générer les données de test
echo [INFO] Generation des donnees de test...
"%JAVA_HOME%\bin\java" -cp "target/classes;target/agridata/WEB-INF/lib/*" com.agriiot.agridata.util.DataGenerator >nul 2>&1
echo [OK] Donnees de test generees
echo.

echo ========================================
echo   Demarrage de l'application web
echo ========================================
echo.
echo [INFO] Lancement du serveur Tomcat...
echo.

REM Lancer Tomcat dans une nouvelle fenêtre
start "AgriData - Serveur Tomcat" cmd /k "cd /d "%~dp0" && mvnw.cmd cargo:run"

REM Attendre et vérifier que Tomcat répond
echo [INFO] Verification du demarrage de l'application...
timeout /t 10 /nobreak >nul

set /a count=0
:check_tomcat
curl -s http://localhost:8080/agridata >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo.
    echo [OK] L'application est prete !
    echo.
    echo Ouverture du navigateur...
    start http://localhost:8080/agridata
    goto :app_ready
)

set /a count+=1
if %count% LSS 20 (
    if %count% EQU 5 echo    ... Tomcat demarre (5s)...
    if %count% EQU 10 echo    ... Tomcat demarre (10s)...
    if %count% EQU 15 echo    ... Tomcat demarre (15s)...
    timeout /t 1 /nobreak >nul
    goto :check_tomcat
)

echo.
echo [INFO] L'application demarre...
echo Ouvrez manuellement: http://localhost:8080/agridata
start http://localhost:8080/agridata


:app_ready
echo.
echo ========================================
echo   Application demarree avec succes !
echo ========================================
echo.
echo URL : http://localhost:8080/agridata
echo.
echo Pour arreter :
echo    - Fermez la fenetre "AgriData - Serveur Tomcat"
echo    - docker stop agridata-mysql
echo.
echo ========================================
pause

