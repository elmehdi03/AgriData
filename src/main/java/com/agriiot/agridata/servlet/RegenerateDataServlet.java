package com.agriiot.agridata.servlet;

import com.agriiot.agridata.dao.CapteurDao;
import com.agriiot.agridata.dao.JpaUtil;
import com.agriiot.agridata.dao.MesureDao;
import com.agriiot.agridata.model.Capteur;
import com.agriiot.agridata.model.Mesure;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

@WebServlet("/api/regenerate")
public class RegenerateDataServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // 1. Vider les tables
            EntityManager em = JpaUtil.getEntityManager();
            em.getTransaction().begin();
            em.createQuery("DELETE FROM Mesure").executeUpdate();
            em.createQuery("DELETE FROM Capteur").executeUpdate();
            em.getTransaction().commit();
            em.close();

            // 2. Créer 5 capteurs
            CapteurDao capteurDao = new CapteurDao();
            List<Capteur> capteurs = new ArrayList<>();
            String[] types = {"Température", "Humidité", "pH", "Luminosité", "Température"};
            String[] localisations = {"Serre Nord", "Serre Sud", "Champ Est", "Champ Ouest", "Réserve"};

            for (int i = 0; i < 5; i++) {
                Capteur c = new Capteur("Capteur0" + (i+1), types[i], localisations[i]);
                c.setStatut("ACTIF");
                capteurDao.save(c);
                capteurs.add(c);
            }

            // 3. Créer 10000 mesures (réduit pour plus rapide)
            MesureDao mesureDao = new MesureDao();
            Random random = new Random();

            for (int i = 0; i < 10000; i++) {
                Capteur capteur = capteurs.get(random.nextInt(capteurs.size()));
                Mesure m = new Mesure(
                    capteur,
                    LocalDateTime.now().minusDays(random.nextInt(30)),
                    capteur.getType(),
                    15.0 + random.nextDouble() * 20.0
                );
                mesureDao.save(m);
            }

            response.getWriter().write("{\"success\": true, \"capteurs\": 5, \"mesures\": 10000}");

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }
}

