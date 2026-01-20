<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.agriiot.agridata.model.Capteur" %>
<%@ page import="com.agriiot.agridata.dao.CapteurDao" %>
<%
    CapteurDao dao = new CapteurDao();
    List<Capteur> capteurs = dao.findAll();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Liste des Capteurs - AgriData</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        h1 {
            color: #667eea;
            text-align: center;
            margin-bottom: 30px;
        }
        .back-link {
            display: inline-block;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .back-link:hover { background: #5568d3; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-weight: bold;
        }
        tr:hover { background: #f5f5f5; }
        .badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.85em;
            font-weight: bold;
        }
        .badge-actif { background: #38ef7d; color: white; }
        .badge-inactif { background: #f5576c; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <a href="./" class="back-link">← Retour à l'accueil</a>
        <h1>📡 Liste des Capteurs</h1>
        <p style="text-align:center; color:#666; margin-bottom:20px;">
            Total: <%= capteurs.size() %> capteur(s)
        </p>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nom</th>
                    <th>Type</th>
                    <th>Localisation</th>
                    <th>Statut</th>
                </tr>
            </thead>
            <tbody>
                <% for (Capteur c : capteurs) {
                    String statut = c.getStatut() != null ? c.getStatut() : "ACTIF";
                    String badgeClass = statut.equalsIgnoreCase("actif") ? "badge-actif" : "badge-inactif";
                %>
                <tr>
                    <td><%= c.getId() %></td>
                    <td><strong><%= c.getNom() %></strong></td>
                    <td><%= c.getType() %></td>
                    <td><%= c.getLocalisation() %></td>
                    <td><span class="badge <%= badgeClass %>"><%= statut %></span></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>

