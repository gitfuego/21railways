<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.cs336.pkg.ApplicationDB" %>
<%
    String transitLine = request.getParameter("transitLine");
    String reservationDate = request.getParameter("reservationDate");
    ResultSet customerReservations = null;
    String message = "";

    if (transitLine != null && !transitLine.trim().isEmpty() && reservationDate != null && !reservationDate.trim().isEmpty()) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection conn = db.getConnection();

            String query = "SELECT " +
                           "Customer.username, Customer.fname, Customer.name, " +
                           "Reservation.date_made, Tschedule.transit_line " +
                           "FROM Reservation " +
                           "JOIN Tschedule ON Reservation.schedule_id = Tschedule.schedule_id " +
                           "JOIN Customer ON Reservation.passenger = Customer.username " +
                           "WHERE Tschedule.transit_line = ? AND DATE(Reservation.date_made) = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, transitLine);
            pstmt.setString(2, reservationDate);
            customerReservations = pstmt.executeQuery();

        } catch (Exception e) {
            message = "Error: " + e.getMessage();
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Reservations</title>
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
    <h1>Customer Reservations on a Transit Line</h1>
    <form method="GET" action="viewCustomerReservations.jsp">
        <label for="transitLine">Transit Line:</label>
        <input type="text" name="transitLine" required><br>
        <label for="reservationDate">Reservation Date (YYYY-MM-DD):</label>
        <input type="date" name="reservationDate" required><br>
        <input type="submit" value="Search">
    </form>

    <% if (message != "") { %>
        <p><%= message %></p>
    <% } %>

    <% if (customerReservations != null) { %>
        <h2>Reservations for Line: <%= transitLine %> on <%= reservationDate %></h2>
        <table border="1">
            <tr>
                <th>Username</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Reservation Date</th>
                <th>Transit Line</th>
            </tr>
            <% 
                while (customerReservations.next()) { 
            %>
            <tr>
                <td><%= customerReservations.getString("username") %></td>
                <td><%= customerReservations.getString("fname") %></td>
                <td><%= customerReservations.getString("name") %></td>
                <td><%= customerReservations.getTimestamp("date_made") %></td>
                <td><%= customerReservations.getString("transit_line") %></td>
            </tr>
            <% 
                }
            %>
        </table>
    <% } else if (transitLine != null && reservationDate != null) { %>
        <p>No reservations found for the given transit line and date.</p>
    <% } %>
</body>
</html>
