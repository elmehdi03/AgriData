package com.agriiot.agridata.servlet;

import com.agriiot.agridata.dao.JpaUtil;
import com.agriiot.agridata.service.DataService;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/api/regenerate")
public class RegenerateDataServlet extends HttpServlet {

    private final DataService dataService = new DataService();

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

            // 2. Générer les données via le service
            dataService.generateTestData();

            response.getWriter().write("{\"success\": true, \"capteurs\": 5, \"mesures\": 5000}");

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }
}

