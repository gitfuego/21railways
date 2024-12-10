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

    // Access form parameters
    String username = request.getParameter("username");
    String fname = request.getParameter("fname");
    String name = request.getParameter("name");
    String ssn = request.getParameter("ssn");
    String password = request.getParameter("password");


    Connection con = null;
    PreparedStatement ps = null;

    String message = null;
    String errorMessage = null;

    if (username != null && fname != null && name != null && ssn != null && password != null) {
        try {
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();

            // Insert new customer representative
            String sql = "INSERT INTO Employee (username, password, ssn, fname, name, role) VALUES (?, ?, ?, ?, ?, 'customer_rep')";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, ssn);
            ps.setString(4, fname);
            ps.setString(5, name);
            int rowsInserted = ps.executeUpdate();

            if (rowsInserted > 0) {
                message = "Customer representative added successfully.";
            } else {
                errorMessage = "Failed to add customer representative.";
            }
        } catch (SQLException e) {
            errorMessage = "Error adding customer representative: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
        }
    } else {
        errorMessage = "All fields are required.";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Customer Representative</title>
</head>
<body>
    <h1>Add Customer Representative</h1>
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
