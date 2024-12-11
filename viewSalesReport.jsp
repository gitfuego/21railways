<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Sales Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        table {
            border-collapse: collapse;
            width: 80%;
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
<%
    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if (user == null || !"manager".equalsIgnoreCase(role)) {
%>
    <h2>You are not authorized to access this page. Please <a href="login.jsp">log in</a>.</h2>
<%
    } else {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        List<Map<String, Object>> revenueData = new ArrayList<>();
        String errorMessage = null;

        try {
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();
            
            String query = "SELECT DATE_FORMAT(date_made, '%Y-%m') AS month, SUM(total_fare) AS revenue " +
                           "FROM Reservation WHERE canceled = FALSE " +
                           "GROUP BY DATE_FORMAT(date_made, '%Y-%m') " +
                           "ORDER BY DATE_FORMAT(date_made, '%Y-%m')";
            ps = con.prepareStatement(query);
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("month", rs.getString("month"));
                row.put("revenue", rs.getDouble("revenue"));
                revenueData.add(row);
            }
        } catch (SQLException e) {
            errorMessage = "Error retrieving revenue data: " + e.getMessage();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
        }
%>
    <h1 style="text-align:center;">Sales Report</h1>
    <p style="text-align:center;"><a href="managerHome.jsp" class="back-link">Back to Manager Home</a></p>
<%
        if (errorMessage != null) {
%>
    <p style="color: red; text-align: center;"><%= errorMessage %></p>
<%
        } else if (revenueData.isEmpty()) {
%>
    <p style="text-align: center;">No revenue data available.</p>
<%
        } else {
%>
    <table>
        <tr>
            <th>Month</th>
            <th>Total Revenue ($)</th>
        </tr>
<%
            for (Map<String, Object> row : revenueData) {
%>
        <tr>
            <td><%= row.get("month") %></td>
            <td><%= row.get("revenue") %></td>
        </tr>
<%
            }
%>
    </table>
<%
        }
    }
%>
</body>
</html>
