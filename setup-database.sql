-- Script de création de la base de données AgriData
-- Ce script crée la base de données et l'utilisateur nécessaires

-- Créer la base de données si elle n'existe pas
CREATE DATABASE IF NOT EXISTS agridata
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- Créer l'utilisateur et lui donner les permissions
CREATE USER IF NOT EXISTS 'agridata_user'@'localhost' IDENTIFIED BY 'agridata_pwd';
GRANT ALL PRIVILEGES ON agridata.* TO 'agridata_user'@'localhost';
FLUSH PRIVILEGES;

-- Sélectionner la base de données
USE agridata;

-- Les tables seront créées automatiquement par Hibernate (hbm2ddl.auto=update)

