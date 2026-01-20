package com.agriiot.agridata.dao;
import com.agriiot.agridata.model.Mesure;
import jakarta.persistence.EntityManager;
import java.util.List;
public class MesureDao {
    public void save(Mesure m) {
        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();
        em.persist(m);
        em.getTransaction().commit();
        em.close();
    }
    public List<Object[]> getStatsByType() {
        EntityManager em = JpaUtil.getEntityManager();
        List<Object[]> results = em.createQuery(
                        "SELECT m.typeMesure, AVG(m.valeur), MIN(m.valeur), MAX(m.valeur) " +
                                "FROM Mesure m GROUP BY m.typeMesure", Object[].class)
                .getResultList();
        em.close();
        return results;
    }

    public long compterMesures() {
        EntityManager em = JpaUtil.getEntityManager();
        Long count = em.createQuery("SELECT COUNT(m) FROM Mesure m", Long.class).getSingleResult();
        em.close();
        return count;
    }
}