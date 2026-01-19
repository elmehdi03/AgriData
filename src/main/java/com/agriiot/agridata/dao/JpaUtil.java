package com.agriiot.agridata.dao;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
public class JpaUtil {
    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("agridataPU");
    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
    public static void close() {
        emf.close();
    }
}