<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.util.*" %>
<%
    // Retrieve the username from the session
    String username = (String) session.getAttribute("user");

    // Check if the user is logged in
    if (username == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return;
    }
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    List<Map<String, Object>> reservations = new ArrayList<>();
    String errorMessage = null;

    try {
        // Establish connection
        ApplicationDB db = new ApplicationDB();
        conn = db.getConnection();

        // Query to fetch current and past reservations for the logged-in user
        String sql = "SELECT rid, total_fare, date_made, canceled, trip_type FROM Reservation " +
                     "WHERE passenger = ? ORDER BY date_made DESC";
        ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        rs = ps.executeQuery();

        // Process the result set
        while (rs.next()) {
            Map<String, Object> reservation = new HashMap<>();
            reservation.put("rid", rs.getInt("rid"));
            reservation.put("total_fare", rs.getDouble("total_fare"));
            reservation.put("date_made", rs.getTimestamp("date_made"));
            reservation.put("canceled", rs.getBoolean("canceled"));
            reservation.put("trip_type", rs.getString("trip_type"));
            reservations.add(reservation);
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
</head>
<body>
    <h1>View Reservations</h1>
    <%
        if (errorMessage != null) {
    %>
        <p style="color: red;"><%= errorMessage %></p>
    <%
        } else if (reservations.isEmpty()) {
    %>
        <p>No reservations found.</p>
    <%
        } else {
    %>
        <table border="1">
            <tr>
                <th>Reservation ID</th>
                <th>Total Fare</th>
                <th>Date Made</th>
                <th>Status</th>
                <th>Trip Type</th>
                <th>Action</th>
            </tr>
            <%
                for (Map<String, Object> reservation : reservations) {
                    int rid = (int) reservation.get("rid");
                    double totalFare = (double) reservation.get("total_fare");
                    Timestamp dateMade = (Timestamp) reservation.get("date_made");
                    boolean canceled = (boolean) reservation.get("canceled");
                    String tripType = (String) reservation.get("trip_type");
            %>
            <tr>
                <td><%= rid %></td>
                <td><%= totalFare %></td>
                <td><%= dateMade %></td>
                <td><%= canceled ? "Canceled" : "Active" %></td>
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
                            out.print("Resevation Passed");
                        }
                    %>
                </td>
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
