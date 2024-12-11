<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.util.*" %>
<%

    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("manager")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String username = request.getParameter("username");
    String fname = request.getParameter("fname");
    String name = request.getParameter("name");
    String ssn = request.getParameter("ssn");
    String password = request.getParameter("password");

    Connection con = null;
    PreparedStatement ps = null;

    String message = null;
    String errorMessage = null;

    if (request.getMethod().equalsIgnoreCase("POST")) {
        try {
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();

            String sql = "UPDATE Employee SET fname = ?, name = ?, ssn = ?, password = ? WHERE username = ? AND role = 'customer_rep'";
            ps = con.prepareStatement(sql);
            ps.setString(1, fname);
            ps.setString(2, name);
            ps.setString(3, ssn);
            ps.setString(4, password);
            ps.setString(5, username);
            int rowsUpdated = ps.executeUpdate();

            if (rowsUpdated > 0) {
                message = "Customer representative updated successfully.";
            } else {
                errorMessage = "Failed to update customer representative.";
            }
        } catch (SQLException e) {
            errorMessage = "Error updating customer representative: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
        }
    } else {
        try {
            ApplicationDB db = new ApplicationDB();
            con = db.getConnection();
            String sql = "SELECT fname, name, ssn, password FROM Employee WHERE username = ? AND role = 'customer_rep'";
            ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                fname = rs.getString("fname");
                name = rs.getString("name");
                ssn = rs.getString("ssn");
                password = rs.getString("password");
            } else {
                errorMessage = "Customer representative not found.";
            }
            rs.close();
        } catch (SQLException e) {
            errorMessage = "Error fetching customer representative: " + e.getMessage();
        } finally {
            try { if (ps != null) ps.close(); } catch (SQLException e) {}
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Customer Representative</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        table {
            border-collapse: collapse;
            width: 60%;
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
        .message {
            text-align: center;
            margin: 20px;
            font-size: 18px;
            color: red;
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
    <h1>Edit Customer Representative</h1>
    <%
        if (errorMessage != null) {
    %>
        <p style="color: red;"><%= errorMessage %></p>
    <%
        } else if (message != null) {
    %>
        <p style="color: green;"><%= message %></p>
    <%
        } else {
    %>
        <form method="post">
            <label for="fname">First Name:</label>
            <input type="text" id="fname" name="fname" value="<%= fname %>" required><br>
            <label for="name">Last Name:</label>
            <input type="text" id="name" name="name" value="<%= name %>" required><br>
            <label for="ssn">SSN:</label>
            <input type="text" id="ssn" name="ssn" value="<%= ssn %>" required><br>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" value="<%= password %>" required><br>
            <input type="hidden" name="username" value="<%= username %>">
            <button type="submit">Update</button>
        </form>
    <%
        }
    %>
    <a href="manageCustomerRepresentatives.jsp" class="back-link">Back to Manage Customer Representatives</a>
</body>
</html>
