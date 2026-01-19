package com.agriiot.agridata.util;
import com.agriiot.agridata.dao.JpaUtil;
import com.agriiot.agridata.model.Capteur;
import com.agriiot.agridata.model.Mesure;
import jakarta.persistence.EntityManager;
import java.time.LocalDateTime;
import java.util.Random;
public class DataGenerator {
    public static void main(String[] args) {
        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();
        long t0 = System.currentTimeMillis();
        Capteur capteur = new Capteur("Capteur01", "Température", "Serre Nord");
        em.persist(capteur);
        Random rnd = new Random();
        for (int i = 0; i < 10000; i++) {
            Mesure m = new Mesure(
                    LocalDateTime.now().minusMinutes(rnd.nextInt(5000)),
                    15 + rnd.nextDouble() * 10,
                    "Température",
                    capteur
            );
            em.persist(m);
            if (i % 50 == 0) {
                em.flush();
                em.clear();
            }
        }
        em.getTransaction().commit();
        em.close();
        long t1 = System.currentTimeMillis();
        System.out.println("✅ 10 000 mesures insérées en (ms) = " + (t1 - t0));
    }
}