<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Revenue</title>
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
        .form-container {
            width: 80%;
            margin: 20px auto;
            text-align: center;
        }
        .form-container select, .form-container button {
            padding: 8px;
            margin: 5px;
        }
        .form-container button {
            background-color: lightblue;
            border: none;
            border-radius: 5px;
        }
        .form-container button:hover {
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
        String groupBy = request.getParameter("groupBy");
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        Map<String, Double> groupedRevenue = new LinkedHashMap<>();
        String errorMessage = null;

        if (groupBy != null && (groupBy.equals("transitLine") || groupBy.equals("customerName"))) {
            try {
                ApplicationDB db = new ApplicationDB();
                con = db.getConnection();
                String selectField = groupBy.equals("transitLine") ? "ts.transit_line" : "CONCAT(c.fname, ' ', c.name)";
                String query = "SELECT " + selectField + " AS group_field, SUM(r.total_fare) AS revenue " +
                               "FROM Reservation r " +
                               "JOIN Customer c ON r.passenger = c.username " +
                               "JOIN Tschedule ts ON r.schedule_id = ts.schedule_id " +
                               "JOIN Train t ON ts.train_id = t.tid " +
                               "WHERE r.canceled = FALSE " +
                               "GROUP BY group_field " +
                               "ORDER BY revenue DESC";
                ps = con.prepareStatement(query);
                rs = ps.executeQuery();

                while (rs.next()) {
                    String groupKey = rs.getString("group_field");
                    double revenue = rs.getDouble("revenue");
                    groupedRevenue.put(groupKey, revenue);
                }
            } catch (SQLException e) {
                errorMessage = "Error fetching revenue data: " + e.getMessage();
            } finally {
                try { if (rs != null) rs.close(); } catch (SQLException e) {}
                try { if (ps != null) ps.close(); } catch (SQLException e) {}
            }
        }
%>
    <h1 style="text-align:center;">View Revenue</h1>
    <div class="form-container">
        <form method="get">
            <label for="groupBy">Group Revenue By:</label>
            <select name="groupBy" id="groupBy">
                <option value="transitLine" <%= "transitLine".equals(groupBy) ? "selected" : "" %>>Transit Line</option>
                <option value="customerName" <%= "customerName".equals(groupBy) ? "selected" : "" %>>Customer Name</option>
            </select>
            <button type="submit">View</button>
        </form>
    </div>
<%
        if (errorMessage != null) {
%>
    <p style="color: red; text-align: center;"><%= errorMessage %></p>
<%
        } else if (groupedRevenue.isEmpty()) {
%>
    <p style="text-align: center;">No revenue data found.</p>
<%
        } else {
%>
    <table>
        <tr>
            <th><%= groupBy.equals("transitLine") ? "Transit Line" : "Customer Name" %></th>
            <th>Total Revenue ($)</th>
        </tr>
<%
            for (Map.Entry<String, Double> entry : groupedRevenue.entrySet()) {
%>
        <tr>
            <td><%= entry.getKey() %></td>
            <td><%= String.format("%.2f", entry.getValue()) %></td>
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
