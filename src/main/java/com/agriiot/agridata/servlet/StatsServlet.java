package com.agriiot.agridata.servlet;

import com.agriiot.agridata.service.DataService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/api/stats")
public class StatsServlet extends HttpServlet {

    private final DataService dataService = new DataService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            long nbCapteurs = dataService.countCapteurs();
            long nbMesures = dataService.countMesures();

            String json = String.format(
                "{\"capteurs\": %d, \"mesures\": %d}",
                nbCapteurs, nbMesures
            );

            response.getWriter().write(json);
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}

