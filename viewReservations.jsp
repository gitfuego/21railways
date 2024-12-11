<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Retrieve the username from the session
    String username = (String) session.getAttribute("user");

    // Check if the user is logged in
    if (username == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return;
    }
    
    // Get the current date (java.sql.Date)
    java.sql.Date sqlDate = new java.sql.Date(System.currentTimeMillis());
    String currentDate = sqlDate.toString(); // Convert to string (yyyy-MM-dd) format
    
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    List<Map<String, Object>> currentReservations = new ArrayList<>();
    List<Map<String, Object>> pastReservations = new ArrayList<>();
    String errorMessage = null;

    try {
        // Establish connection
        ApplicationDB db = new ApplicationDB();
        conn = db.getConnection();

        // Query to fetch current and past reservations for the logged-in user, with additional data about transit line and stations
        String sql = "SELECT r.rid, r.total_fare, r.date_made, r.canceled, r.trip_type, r.travel_date, " +
                     "       t.transit_line, " +
                     "       os.name AS origin_station_name, os.city AS origin_city, " +
                     "       ds.name AS destination_station_name, ds.city AS destination_city, " +
                     "       r.departure_time " +
                     "FROM Reservation r " +
                     "JOIN Tschedule t ON r.schedule_id = t.schedule_id " +
                     "JOIN Station os ON r.origin_id = os.sid " +
                     "JOIN Station ds ON r.destination_id = ds.sid " +
                     "WHERE r.passenger = ? " +
                     "ORDER BY r.date_made DESC";
        ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        rs = ps.executeQuery();

        // Process the result set and separate current and past reservations
        while (rs.next()) {
            Map<String, Object> reservation = new HashMap<>();
            reservation.put("rid", rs.getInt("rid"));
            reservation.put("total_fare", rs.getDouble("total_fare"));
            reservation.put("date_made", rs.getTimestamp("date_made"));
            reservation.put("canceled", rs.getBoolean("canceled"));
            reservation.put("trip_type", rs.getString("trip_type"));
            reservation.put("transit_line", rs.getString("transit_line"));
            reservation.put("origin_station_name", rs.getString("origin_station_name"));
            reservation.put("origin_city", rs.getString("origin_city"));
            reservation.put("destination_station_name", rs.getString("destination_station_name"));
            reservation.put("destination_city", rs.getString("destination_city"));
            reservation.put("travel_date", rs.getString("travel_date"));
            reservation.put("departure_time", rs.getString("departure_time"));
            
            // Separate into current and past reservations
            if (currentDate.compareTo(reservation.get("travel_date").toString()) <= 0) {
                currentReservations.add(reservation);
            } else {
                pastReservations.add(reservation);
            }
        }
    } catch (SQLException e) {
        errorMessage = "Error fetching reservations: " + e.getMessage();
    } finally {
      try {
        if (rs != null) rs.close();
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    } catch (SQLException e) {
        e.printStackTrace();
    }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Reservations</title>
    <style>
        body {
            font-family: Arial, sans-serif;
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

        table {
            border-collapse: collapse;
            width: 90%;
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

        h1, h2 {
            text-align: center;
        }
    </style>
</head>
<body>
    <h1>View Reservations</h1>
    <p style="text-align:center;"><a href="customerHome.jsp" class="nav-link">Back to Customer Home</a></p>
    <%
        if (errorMessage != null) {
    %>
        <p style="color: red;"><%= errorMessage %></p>
    <%
        } else if (currentReservations.isEmpty() && pastReservations.isEmpty()) {
    %>
        <p>No reservations found.</p>
    <%
        } else {
    %>
        <h2>Current Reservations</h2>
        <table border="1">
            <tr>
                <th>Reservation ID</th>
                <th>Transit Line</th>
                <th>Origin Station</th>
                <th>Destination Station</th>
                <th>Total Fare</th>
                <th>Travel Date</th>
                <th>Departure Time</th>
                <th>Trip Type</th>
                <th>Action</th>
            </tr>
            <%
                for (Map<String, Object> reservation : currentReservations) {
                    int rid = (int) reservation.get("rid");
                    double totalFare = (double) reservation.get("total_fare");
                    Timestamp dateMade = (Timestamp) reservation.get("date_made");
                    boolean canceled = (boolean) reservation.get("canceled");
                    String tripType = (String) reservation.get("trip_type");
                    String transitLine = (String) reservation.get("transit_line");
                    String originStation = (String) reservation.get("origin_station_name") + ", " + reservation.get("origin_city");
                    String destinationStation = (String) reservation.get("destination_station_name") + ", " + reservation.get("destination_city");
                    String travelDate = (String) reservation.get("travel_date");
                    String departureTime = (String) reservation.get("departure_time");
            %>
            <tr>
                <td><%= rid %></td>
                <td><%= transitLine %></td>
                <td><%= originStation %></td>
                <td><%= destinationStation %></td>
                <td><%= totalFare %></td>
                <td><%= travelDate %></td>
                <td><%= departureTime %></td>
                <td><%= tripType %></td>
                <td>
                    <%
                        if (!canceled) {
                    %>
                        <form method="post" action="cancelReservation.jsp" style="display: inline;">
                            <input type="hidden" name="rid" value="<%= rid %>">
                            <button type="submit">Cancel</button>
                        </form>
                    <%
                        } else {
                            out.print("Reservation Canceled");
                        }
                    %>
                </td>
            </tr>
            <%
                }
            %>
        </table>

        <h2>Past Reservations</h2>
        <table border="1">
            <tr>
                <th>Reservation ID</th>
                <th>Transit Line</th>
                <th>Origin Station</th>
                <th>Destination Station</th>
                <th>Total Fare</th>
                <th>Travel Date</th>
                <th>Departure Time</th>
                <th>Trip Type</th>
                <th>Action</th>
            </tr>
            <%
                for (Map<String, Object> reservation : pastReservations) {
                    int rid = (int) reservation.get("rid");
                    double totalFare = (double) reservation.get("total_fare");
                    Timestamp dateMade = (Timestamp) reservation.get("date_made");
                    boolean canceled = (boolean) reservation.get("canceled");
                    String tripType = (String) reservation.get("trip_type");
                    String transitLine = (String) reservation.get("transit_line");
                    String originStation = (String) reservation.get("origin_station_name") + ", " + reservation.get("origin_city");
                    String destinationStation = (String) reservation.get("destination_station_name") + ", " + reservation.get("destination_city");
                    String travelDate = (String) reservation.get("travel_date");
                    String departureTime = (String) reservation.get("departure_time");
            %>
            <tr>
                <td><%= rid %></td>
                <td><%= transitLine %></td>
                <td><%= originStation %></td>
                <td><%= destinationStation %></td>
                <td><%= totalFare %></td>
                <td><%= travelDate %></td>
                <td><%= departureTime %></td>
                <td><%= tripType %></td>
                <td>Reservation Passed</td>
            </tr>
            <%
                }
            %>
        </table>
    <%
        }
    %>
</body>
</html>
