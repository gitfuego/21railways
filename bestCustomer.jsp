<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.cs336.pkg.ApplicationDB" %>
<%
    String message = "";
    Map<String, Object> bestCustomer = new HashMap<>();

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

        String query = "SELECT c.username, CONCAT(c.fname, ' ', c.name) AS full_name, SUM(r.total_fare) AS total_paid " +
                       "FROM Reservation r " +
                       "JOIN Customer c ON r.passenger = c.username " +
                       "WHERE r.canceled = FALSE " +
                       "GROUP BY c.username, c.fname, c.name " +
                       "ORDER BY total_paid DESC " +
                       "LIMIT 1";
        ps = conn.prepareStatement(query);
        rs = ps.executeQuery();

        if (rs.next()) {
            bestCustomer.put("username", rs.getString("username"));
            bestCustomer.put("full_name", rs.getString("full_name"));
            bestCustomer.put("total_paid", rs.getDouble("total_paid"));
        } else {
            message = "No customer data found.";
        }
    } catch (Exception e) {
        message = "Error retrieving best customer data: " + e.getMessage();
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
    <title>Best Customer</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        table {
            border-collapse: collapse;
            width: 50%;
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
    </style>
</head>
<body>
    <h1 style="text-align:center;">Best Customer</h1>
    <%
        if (!message.isEmpty()) {
    %>
        <p class="message"><%= message %></p>
    <%
        } else if (!bestCustomer.isEmpty()) {
    %>
        <table>
            <tr>
                <th>Username</th>
                <td><%= bestCustomer.get("username") %></td>
            </tr>
            <tr>
                <th>Full Name</th>
                <td><%= bestCustomer.get("full_name") %></td>
            </tr>
            <tr>
                <th>Total Paid ($)</th>
                <td><%= String.format("%.2f", bestCustomer.get("total_paid")) %></td>
            </tr>
        </table>
    <%
        }
    %>
</body>
</html>
