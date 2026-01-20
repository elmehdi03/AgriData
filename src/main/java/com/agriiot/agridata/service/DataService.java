package com.agriiot.agridata.service;

import com.agriiot.agridata.dao.CapteurDao;
import com.agriiot.agridata.dao.MesureDao;
import com.agriiot.agridata.model.Capteur;
import com.agriiot.agridata.model.Mesure;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class DataService {

    private final CapteurDao capteurDao = new CapteurDao();
    private final MesureDao mesureDao = new MesureDao();

    public long countCapteurs() {
        return capteurDao.compterCapteurs();
    }

    public long countMesures() {
        return mesureDao.compterMesures();
    }

    public List<Capteur> getAllCapteurs() {
        return capteurDao.findAll();
    }

    public List<Object[]> getStatsByType() {
        return mesureDao.getStatsByType();
    }

    public void generateTestData() {
        // Créer 5 capteurs
        String[] types = {"Température", "Humidité", "pH", "Luminosité", "Pression"};
        String[] localisations = {"Serre Nord", "Serre Sud", "Champ Est", "Champ Ouest", "Réserve"};

        List<Capteur> capteurs = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            Capteur c = new Capteur("Capteur0" + (i+1), types[i], localisations[i]);
            c.setStatut("ACTIF");
            capteurDao.save(c);
            capteurs.add(c);
        }

        // Recharger les capteurs pour avoir les IDs
        capteurs = capteurDao.findAll();

        // Créer 5000 mesures (réduit pour la performance)
        Random random = new Random();
        for (int i = 0; i < 5000; i++) {
            Capteur capteur = capteurs.get(random.nextInt(capteurs.size()));
            Mesure m = new Mesure(
                LocalDateTime.now().minusDays(random.nextInt(30)),
                15.0 + random.nextDouble() * 20.0,
                capteur.getType(),
                capteur
            );
            mesureDao.save(m);
        }
    }
}

