<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%
    String ridStr = request.getParameter("rid");

    String username = (String) session.getAttribute("user");

    if (username == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if not logged in
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    String message = null;
    String errorMessage = null;

    if (ridStr != null && !ridStr.isEmpty()) {
        int rid = Integer.parseInt(ridStr);

        try {
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();

            String checkSql = "SELECT canceled FROM Reservation WHERE rid = ? AND passenger = ?";
            ps = con.prepareStatement(checkSql);
            ps.setInt(1, rid);
            ps.setString(2, username);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                boolean canceled = rs.getBoolean("canceled");

                if (canceled) {
                    message = "This reservation has already been canceled.";
                } else {
                    String updateSql = "UPDATE Reservation SET canceled = TRUE WHERE rid = ?";
                    ps = con.prepareStatement(updateSql);
                    ps.setInt(1, rid);
                    int rowsUpdated = ps.executeUpdate();

                    if (rowsUpdated > 0) {
                        message = "Reservation canceled successfully.";
                    } else {
                        errorMessage = "Unable to cancel the reservation. Please try again.";
                    }
                }
            } else {
                errorMessage = "Reservation not found or does not belong to you.";
            }

            rs.close();
        } catch (SQLException e) {
            errorMessage = "Error canceling reservation: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
        }
    } else {
        errorMessage = "Invalid reservation ID.";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Cancel Reservation</title>
</head>
<body>
    <h1>Cancel Reservation</h1>
    <%
        if (errorMessage != null) {
    %>
        <p style="color: red;"><%= errorMessage %></p>
    <%
        } else if (message != null) {
    %>
        <p style="color: green;"><%= message %></p>
    <%
        }
    %>
    <a href="viewReservations.jsp">Back to Reservations</a>
</body>
</html>
