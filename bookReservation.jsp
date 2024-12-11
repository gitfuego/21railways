<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.cs336.pkg.ApplicationDB" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Reservation</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .form-container {
            margin: 20px;
        }
        label {
            display: inline-block;
            width: 150px;
            margin-bottom: 10px;
        }
        select, input[type="date"] {
            width: 200px;
            padding: 5px;
        }
        .submit-button {
            padding: 10px 20px;
            background-color: lightgreen;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .submit-button:hover {
            background-color: lightcoral;
        }

        .nav-link {
            margin: 10px;
            display: inline-block;
            padding: 10px;
            background-color: lightblue;
            text-decoration: none;
            color: black;
            border-radius: 5px;
        }
        .nav-link:hover {
            background-color: lightcoral;
        }
    </style>
</head>
<body>
<%
    String scheduleId = request.getParameter("schedule_id");

    ApplicationDB db = new ApplicationDB();
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    List<Map<String, String>> stopsList = new ArrayList<>();

    try {
        conn = db.getConnection();
        String stopsSql = "SELECT s.stop_sequence_num, st.sid, st.name, st.city, st.state "
                         + "FROM Stops s "
                         + "JOIN Station st ON s.station_id = st.sid "
                         + "WHERE s.schedule_id = ? "
                         + "ORDER BY s.stop_sequence_num";

        stmt = conn.prepareStatement(stopsSql);
        stmt.setInt(1, Integer.parseInt(scheduleId));
        rs = stmt.executeQuery();

        while (rs.next()) {
            Map<String, String> stop = new HashMap<>();
            stop.put("stop_sequence_num", String.valueOf(rs.getInt("stop_sequence_num")));
            stop.put("station_id", String.valueOf(rs.getInt("sid")));  // Add station_id
            stop.put("station_name", rs.getString("name"));
            stop.put("city", rs.getString("city"));
            stop.put("state", rs.getString("state"));
            stopsList.add(stop);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch(SQLException ignored){}
        if (stmt != null) try { stmt.close(); } catch(SQLException ignored){}
        if (conn != null) db.closeConnection(conn);
    }
%>

<h1>Book Reservation for Schedule ID <%= scheduleId %></h1>

<div class="form-container">
    <form action="processReservation.jsp" method="post">
        <input type="hidden" name="schedule_id" value="<%= scheduleId %>" />

        <label for="originStation">Origin Station:</label>
        <select name="originStation" id="originStation">
            <option value="">Select Origin Station</option>
            <%
                for (Map<String, String> stop : stopsList) {
            %>
                <option value="<%= stop.get("station_id") %>">
                    <%= stop.get("city") %> - <%= stop.get("station_name") %>
                </option>
            <%
                }
            %>
        </select><br><br>

        <label for="destinationStation">Destination Station:</label>
        <select name="destinationStation" id="destinationStation">
            <option value="">Select Destination Station</option>
            <%
                for (Map<String, String> stop : stopsList) {
            %>
                <option value="<%= stop.get("station_id") %>">
                    <%= stop.get("city") %> - <%= stop.get("station_name") %>
                </option>
            <%
                }
            %>
        </select><br><br>

        <label for="tripType">Trip Type:</label>
        <input type="radio" name="tripType" value="oneway" checked> One Way
        <input type="radio" name="tripType" value="roundtrip"> Round Trip<br><br>

        <label for="discount">Select Discount:</label>
        <select name="discount" id="discount">
            <option value="0">None</option>
            <option value="0.25">Children (25%)</option>
            <option value="0.35">Seniors (35%)</option>
            <option value="0.50">Disabled (50%)</option>
        </select><br><br>

        <input type="submit" value="Book Now" class="submit-button">
    </form>
</div>
<p style="text-align:center;">
    <a href="javascript:history.back()" class="nav-link">Back to Search Results</a>
</p>

</body>
</html>
