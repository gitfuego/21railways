<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.cs336.pkg.ApplicationDB" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Train Schedules</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }

        .nav-link {
            margin: 10px;
            display: inline-block;
            padding: 10px;
            background-color: lightgreen;
            text-decoration: none;
            color: black;
            border-radius: 5px;
        }

        .nav-link:hover {
            background-color: lightyellow;
        }

        table {
            border-collapse: collapse;
            width: 95%;
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

        h1 {
            text-align: center;
        }

        .action-link {
            margin: 0 5px;
            display: inline-block;
            padding: 5px 10px;
            background-color: lightblue;
            text-decoration: none;
            color: black;
            border-radius: 5px;
        }

        .action-link:hover {
            background-color: lightcoral;
        }
    </style>
</head>
<body>
<%
    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if (user == null || !"customer_rep".equals(role)) {
%>
    <h2>You are not authorized to access this page. Please <a href="login.jsp">log in</a>.</h2>
<%
    } else {
        ApplicationDB db = new ApplicationDB();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        List<Map<String, Object>> schedules = new ArrayList<>();

        try {
            con = db.getConnection();
            String sql = "SELECT schedule_id, transit_line, origin_id, destination_id, base_fare, origin_departure, destination_arrival, train_id FROM Tschedule ORDER BY schedule_id";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Map<String,Object> row = new HashMap<>();
                row.put("schedule_id", rs.getInt("schedule_id"));
                row.put("transit_line", rs.getString("transit_line"));
                row.put("origin_id", rs.getInt("origin_id"));
                row.put("destination_id", rs.getInt("destination_id"));
                row.put("base_fare", rs.getDouble("base_fare"));
                row.put("origin_departure", rs.getTimestamp("origin_departure"));
                row.put("destination_arrival", rs.getTimestamp("destination_arrival"));
                row.put("train_id", rs.getInt("train_id"));
                schedules.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch(SQLException ignored){}
            if (ps != null) try { ps.close(); } catch(SQLException ignored){}
            if (con != null) db.closeConnection(con);
        }
%>
    <h1>Manage Train Schedules</h1>
    <p style="text-align:center;"><a href="customerRepHome.jsp" class="nav-link">Back to Home</a></p>

<%
    if (schedules.isEmpty()) {
%>
    <p style="text-align:center;">No schedules found.</p>
<%
    } else {
%>
    <table>
        <tr>
            <th>Schedule ID</th>
            <th>Transit Line</th>
            <th>Origin ID</th>
            <th>Destination ID</th>
            <th>Base Fare</th>
            <th>Origin Departure</th>
            <th>Destination Arrival</th>
            <th>Train ID</th>
            <th>Actions</th>
        </tr>
        <%
            for (Map<String,Object> row : schedules) {
        %>
        <tr>
            <td><%= row.get("schedule_id") %></td>
            <td><%= row.get("transit_line") %></td>
            <td><%= row.get("origin_id") %></td>
            <td><%= row.get("destination_id") %></td>
            <td>$<%= row.get("base_fare") %></td>
            <td><%= row.get("origin_departure") %></td>
            <td><%= row.get("destination_arrival") %></td>
            <td><%= row.get("train_id") %></td>
            <td>
                <a href="updateSchedule.jsp?schedule_id=<%= row.get("schedule_id") %>" class="action-link">Edit</a>
                <a href="deleteSchedule.jsp?schedule_id=<%= row.get("schedule_id") %>" class="action-link">Delete</a>
            </td>
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
