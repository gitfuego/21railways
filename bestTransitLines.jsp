<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.cs336.pkg.ApplicationDB" %>
<%
    String message = "";
    List<Map<String, Object>> topTransitLines = new ArrayList<>();

    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");

    if (user == null || !"manager".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        ApplicationDB db = new ApplicationDB();
        conn = db.getConnection();

        String query = "SELECT ts.transit_line AS transit_line, COUNT(r.rid) AS reservation_count " +
                       "FROM Reservation r " +
                       "JOIN Tschedule ts ON r.schedule_id = ts.schedule_id " +
                       "JOIN Train t ON ts.train_id = t.tid " +
                       "WHERE r.canceled = FALSE " +
                       "GROUP BY transit_line " +
                       "ORDER BY reservation_count DESC " +
                       "LIMIT 5";
        ps = conn.prepareStatement(query);
        rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, Object> row = new HashMap<>();
            row.put("transit_line", rs.getString("transit_line"));
            row.put("reservation_count", rs.getInt("reservation_count"));
            topTransitLines.add(row);
        }

        if (topTransitLines.isEmpty()) {
            message = "No data found for transit lines.";
        }
    } catch (Exception e) {
        message = "Error retrieving transit line data: " + e.getMessage();
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Top Transit Lines</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        table {
            border-collapse: collapse;
            width: 60%;
            margin: 20px auto;
        }
        th, td {
            border: 1px solid #999;
            padding: 10px;
            text-align: left;
        }
        th {
            background-color: #eee;
        }
        .message {
            text-align: center;
            margin: 20px;
            font-size: 18px;
            color: red;
        }
        .back-link {
            display: inline-block;
            margin: 20px;
            padding: 8px;
            background-color: lightblue;
            text-decoration: none;
            color: black;
            border-radius: 5px;
        }
        .back-link:hover {
            background-color: lightcoral;
        }
    </style>
</head>
<body>
    <h1 style="text-align:center;">Top 5 Most Active Transit Lines</h1>
    <%
        if (!message.isEmpty()) {
    %>
        <p class="message"><%= message %></p>
    <%
        } else if (!topTransitLines.isEmpty()) {
    %>
        <table>
            <tr>
                <th>Transit Line</th>
                <th>Number of Reservations</th>
            </tr>
    <%
            for (Map<String, Object> row : topTransitLines) {
    %>
            <tr>
                <td><%= row.get("transit_line") %></td>
                <td><%= row.get("reservation_count") %></td>
            </tr>
    <%
            }
    %>
        </table>
    <%
        }
    %>
    <p style="text-align:center;"><a href="managerHome.jsp" class="back-link">Back to Manager Home</a></p>
</body>
</html>
