package com.agriiot.agridata.dao;
import com.agriiot.agridata.model.Capteur;
import jakarta.persistence.EntityManager;
import java.util.List;
public class CapteurDao {
    public void save(Capteur c) {
        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();
        em.persist(c);
        em.getTransaction().commit();
        em.close();
    }
    public List<Capteur> findAll() {
        EntityManager em = JpaUtil.getEntityManager();
        List<Capteur> list = em.createQuery("SELECT c FROM Capteur c", Capteur.class).getResultList();
        em.close();
        return list;
    }
    public Capteur findById(Long id) {
        EntityManager em = JpaUtil.getEntityManager();
        Capteur c = em.find(Capteur.class, id);
        em.close();
        return c;
    }
}