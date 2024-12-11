<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.util.*" %>
<%
    // Check if the user is a manager
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("manager")) {
        response.sendRedirect("login.jsp"); // Redirect to login if not authorized
        return;
    }

  
    String username = request.getParameter("username");

    
    Connection con = null;
    PreparedStatement ps = null;

    String message = null;
    String errorMessage = null;

    if (username != null) {
        try {
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();

            // Delete the customer representative
            String sql = "DELETE FROM Employee WHERE username = ? AND role = 'customer_rep'";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            int rowsDeleted = ps.executeUpdate();

            if (rowsDeleted > 0) {
                message = "Customer representative deleted successfully.";
            } else {
                errorMessage = "Failed to delete customer representative.";
            }
        } catch (SQLException e) {
            errorMessage = "Error deleting customer representative: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
        }
    } else {
        errorMessage = "Invalid customer representative username.";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Customer Representative</title>
</head>
<body>
    <h1>Delete Customer Representative</h1>
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
    <a href="manageCustomerRepresentatives.jsp">Back to Manage Customer Representatives</a>
</body>
</html>
