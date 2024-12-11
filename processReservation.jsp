<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.cs336.pkg.ApplicationDB" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Process Reservation</title>
    <style>
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
    String originStationId = request.getParameter("originStation");
    String destinationStationId = request.getParameter("destinationStation");
    String tripType = request.getParameter("tripType");
    double discount = Double.parseDouble(request.getParameter("discount"));

    String username = (String) session.getAttribute("user");

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    double totalFare = 0;
    String transitLine = "";
    int trainId = 0;
    String departureTime = "";
    String arrivalTime = "";
    String travelDate = "";

    try {
        ApplicationDB db = new ApplicationDB();
        conn = db.getConnection();

        String query = "SELECT ts.base_fare, ts.transit_line, ts.train_id, " +
                       "       s1.departure as origin_departure, s2.arrival as destination_arrival, " +
                       "       ts.origin_departure, ts.destination_arrival " +
                       "FROM Tschedule ts " +
                       "JOIN Stops s1 ON ts.schedule_id = s1.schedule_id " +
                       "JOIN Stops s2 ON ts.schedule_id = s2.schedule_id " +
                       "WHERE ts.schedule_id = ? AND s1.station_id = ? AND s2.station_id = ?";

        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, Integer.parseInt(scheduleId));
        pstmt.setInt(2, Integer.parseInt(originStationId));
        pstmt.setInt(3, Integer.parseInt(destinationStationId));

        rs = pstmt.executeQuery();

        if (rs.next()) {
            transitLine = rs.getString("transit_line");
            trainId = rs.getInt("train_id");
            departureTime = rs.getString("origin_departure");
            arrivalTime = rs.getString("destination_arrival");
            travelDate = rs.getDate("origin_departure").toString();
            double baseFare = rs.getDouble("base_fare");

            String stopSequenceQuery = "SELECT stop_sequence_num FROM Stops " +
                                       "WHERE schedule_id = ? AND station_id = ?";
            pstmt = conn.prepareStatement(stopSequenceQuery);

            pstmt.setInt(1, Integer.parseInt(scheduleId));
            pstmt.setInt(2, Integer.parseInt(originStationId));
            rs = pstmt.executeQuery();
            int originStopSequence = 0;
            if (rs.next()) {
                originStopSequence = rs.getInt("stop_sequence_num");
            }

            pstmt.setInt(2, Integer.parseInt(destinationStationId));
            rs = pstmt.executeQuery();
            int destinationStopSequence = 0;
            if (rs.next()) {
                destinationStopSequence = rs.getInt("stop_sequence_num");
            }

            String highestStopQuery = "SELECT MAX(stop_sequence_num) AS max_stop_sequence FROM Stops " +
                                      "WHERE schedule_id = ?";
            pstmt = conn.prepareStatement(highestStopQuery);
            pstmt.setInt(1, Integer.parseInt(scheduleId));
            rs = pstmt.executeQuery();
            int maxStopSequence = 0;
            if (rs.next()) {
                maxStopSequence = rs.getInt("max_stop_sequence");
            }

            double farePerStop = baseFare / (maxStopSequence - 1);
            int stopDifference = Math.abs(destinationStopSequence - originStopSequence);
            totalFare = farePerStop * stopDifference;

            totalFare -= totalFare * discount;

            if ("round_trip".equalsIgnoreCase(tripType)) {
                totalFare *= 2;
            }

            totalFare = Math.round(totalFare * 100.0) / 100.0;
        }

        String insertReservationQuery = "INSERT INTO Reservation (passenger, date_made, transit_line, train_id, schedule_id, " +
                                        "origin_id, destination_id, travel_date, departure_time, arrival_time, trip_type, total_fare) " +
                                        "VALUES (?, NOW(), ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(insertReservationQuery);
        pstmt.setString(1, username);
        pstmt.setString(2, transitLine);
        pstmt.setInt(3, trainId);
        pstmt.setInt(4, Integer.parseInt(scheduleId));
        pstmt.setInt(5, Integer.parseInt(originStationId));
        pstmt.setInt(6, Integer.parseInt(destinationStationId));
        pstmt.setString(7, travelDate);
        pstmt.setString(8, departureTime);
        pstmt.setString(9, arrivalTime);
        pstmt.setString(10, tripType);
        pstmt.setDouble(11, totalFare);

        pstmt.executeUpdate();
        out.println("<h2>Your reservation has been successfully made!</h2>");
        out.println("<p>Fare: $" + totalFare + "</p>");
        out.println("<p style=\"text-align:center;\"><a href=\"customerHome.jsp\" class=\"nav-link\">Back to Customer Home</a></p>");

    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<h2>Error: " + e.getMessage() + "</h2>");
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) {}
        try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
        try { if (conn != null) conn.close(); } catch (SQLException e) {}
    }
%>

</body>
</html>
