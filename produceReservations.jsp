<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Reservations</title>
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
        .back-link {
            display: inline-block;
            margin: 10px;
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
        String groupBy = request.getParameter("groupBy");
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        Map<String, List<Map<String, Object>>> groupedReservations = new LinkedHashMap<>();
        String errorMessage = null;

        if (groupBy != null && (groupBy.equals("transitLine") || groupBy.equals("customerName"))) {
            try {
              ApplicationDB db = new ApplicationDB();
              con = db.getConnection();
                String query = "SELECT r.rid, r.total_fare, r.date_made, r.trip_type, ts.transit_line, CONCAT(c.fname, ' ', c.name) AS customer_name " +
                               "FROM Reservation r " +
                               "JOIN Customer c ON r.passenger = c.username " +
                               "JOIN Tschedule ts ON r.schedule_id = ts.schedule_id " +
                               "JOIN Train t ON ts.train_id = t.tid " +
                               "WHERE r.canceled = FALSE " +
                               "ORDER BY transit_line, customer_name, r.date_made DESC";
                ps = con.prepareStatement(query);
                rs = ps.executeQuery();

                while (rs.next()) {
                    String groupKey = groupBy.equals("transitLine") ? rs.getString("transit_line") : rs.getString("customer_name");
                    Map<String, Object> reservation = new HashMap<>();
                    reservation.put("rid", rs.getInt("rid"));
                    reservation.put("total_fare", rs.getDouble("total_fare"));
                    reservation.put("date_made", rs.getTimestamp("date_made"));
                    reservation.put("trip_type", rs.getString("trip_type"));

                    groupedReservations.computeIfAbsent(groupKey, k -> new ArrayList<>()).add(reservation);
                }
            } catch (SQLException e) {
                errorMessage = "Error fetching reservations: " + e.getMessage();
            } finally {
                try { if (rs != null) rs.close(); } catch (SQLException e) {}
                try { if (ps != null) ps.close(); } catch (SQLException e) {}
            }
        }
%>
    <h1 style="text-align:center;">Produce Reservations</h1>
    <p style="text-align:center;"><a href="managerHome.jsp" class="back-link">Back to Manager Home</a></p>
    <div class="form-container">
        <form method="get">
            <label for="groupBy">Group Reservations By:</label>
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
        } else if (groupedReservations.isEmpty()) {
%>
    <p style="text-align: center;">No reservations found.</p>
<%
        } else {
%>
    <div>
<%
            for (String groupKey : groupedReservations.keySet()) {
                List<Map<String, Object>> reservations = groupedReservations.get(groupKey);
%>
        <h2 style="text-align:center;"><%= groupKey %></h2>
        <table>
            <tr>
                <th>Reservation ID</th>
                <th>Total Fare</th>
                <th>Date Made</th>
                <th>Trip Type</th>
            </tr>
<%
                for (Map<String, Object> row : reservations) {
%>
            <tr>
                <td><%= row.get("rid") %></td>
                <td><%= row.get("total_fare") %></td>
                <td><%= row.get("date_made") %></td>
                <td><%= row.get("trip_type") %></td>
            </tr>
<%
                }
%>
        </table>
<%
            }
%>
    </div>
<%
        }
    }
%>
</body>
</html>
