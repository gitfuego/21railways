<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.cs336.pkg.ApplicationDB" %>
<%
    String selectedStation = request.getParameter("stationName");
    ResultSet stations = null;
    ResultSet schedules = null;

    try {
        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();
        
 
        PreparedStatement stmt = conn.prepareStatement("SELECT name FROM Station");
        stations = stmt.executeQuery();

        if (selectedStation != null && !selectedStation.trim().isEmpty()) {
            stmt = conn.prepareStatement(
                "SELECT Tschedule.schedule_id, Tschedule.transit_line, " +
                "Station.name AS station_name, Tschedule.origin_departure, Tschedule.origin_arrival, " +
                "Tschedule.destination_departure, Tschedule.destination_arrival " +
                "FROM Tschedule " +
                "JOIN Station ON (Station.sid = Tschedule.origin_id OR Station.sid = Tschedule.destination_id) " +
                "WHERE Station.name = ?"
            );
            stmt.setString(1, selectedStation);
            schedules = stmt.executeQuery();
        }
        
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>View Schedules by Station</title>
</head>
<body>
    <h1>View Schedules for a Station</h1>

    <!-- Here is the dropdown  to select station name -->
    <form method="GET" action="viewSchedulesByStation.jsp">
        <label for="stationName">Select a Station:</label>
        <select name="stationName" required>
            <option value="" disabled selected>Select Station</option>
            <% 
                while (stations != null && stations.next()) {
                    String station = stations.getString("name");
                    %>
                    <option value="<%= station %>" <%= selectedStation != null && selectedStation.equals(station) ? "selected" : "" %>><%= station %></option>
                    <% 
                }
            %>
        </select><br>
        <input type="submit" value="Search">
    </form>

    <% 
        if (selectedStation != null && !selectedStation.trim().isEmpty()) {
            if (schedules != null) {
                if (schedules.next()) {
    %>
    <h3>Schedules for <%= selectedStation %></h3>
    <table border="1">
        <tr>
            <th>Schedule ID</th>
            <th>Transit Line</th>
            <th>Origin Departure</th>
            <th>Origin Arrival</th>
            <th>Destination Departure</th>
            <th>Destination Arrival</th>
        </tr>
        <% 
            do {
        %>
        <tr>
            <td><%= schedules.getInt("schedule_id") %></td>
            <td><%= schedules.getString("transit_line") %></td>
            <td><%= schedules.getTimestamp("origin_departure") %></td>
            <td><%= schedules.getTimestamp("origin_arrival") %></td>
            <td><%= schedules.getTimestamp("destination_departure") %></td>
            <td><%= schedules.getTimestamp("destination_arrival") %></td>
        </tr>
        <% 
            } while (schedules.next());
        %>
    </table>
    <% 
            } else {
                out.println("<p>No schedules found for this station.</p>");
            }
        }
    }
    %>
</body>
</html>
