package com.agriiot.agridata.util;

import com.agriiot.agridata.service.DataService;

public class DataGenerator {
    public static void main(String[] args) {
        System.out.println("Génération des données de test...");

        DataService dataService = new DataService();
        dataService.generateTestData();

        System.out.println("Données générées avec succès !");
        System.out.println("5 capteurs et 5000 mesures créés.");
    }
}

