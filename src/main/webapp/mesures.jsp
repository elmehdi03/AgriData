<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.agriiot.agridata.service.DataService" %>
<%
    DataService dataService = new DataService();
    List<Object[]> stats = dataService.getStatsByType();
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Statistiques des Mesures - AgriData</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
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
            color: #fa709a;
            text-align: center;
            margin-bottom: 30px;
        }
        .back-link {
            display: inline-block;
            padding: 10px 20px;
            background: #fa709a;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .back-link:hover { background: #f75e88; }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: white;
            font-weight: bold;
        }
        tr:hover { background: #fff5f7; }
    </style>
</head>
<body>
    <div class="container">
        <a href="./" class="back-link">← Retour à l'accueil</a>
        <h1>📊 Statistiques des Mesures par Type</h1>
        <table>
            <thead>
                <tr>
                    <th>Type de Mesure</th>
                    <th>Moyenne</th>
                    <th>Minimum</th>
                    <th>Maximum</th>
                </tr>
            </thead>
            <tbody>
                <% for (Object[] row : stats) {
                    String type = (String) row[0];
                    Double avg = (Double) row[1];
                    Double min = (Double) row[2];
                    Double max = (Double) row[3];
                %>
                <tr>
                    <td><strong><%= type %></strong></td>
                    <td><%= String.format("%.2f", avg) %></td>
                    <td><%= String.format("%.2f", min) %></td>
                    <td><%= String.format("%.2f", max) %></td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>

