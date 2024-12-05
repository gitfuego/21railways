<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Employee Home</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .welcome-message {
            font-size: 24px;
            color: green;
        }
        .nav-link {
            margin-top: 20px;
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
    // Check if user is logged in
    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    
    if (user == null) {
%>
        <h2>You are not logged in. Please <a href="login.jsp">log in</a>.</h2>
<%
    } else {
%>
        <div class="welcome-message">
            <h1>Welcome, <%= user %>!</h1>
            <p>You are logged in as <%= role %> (Employee).</p>
        </div>

        <!-- Links to employee-related pages -->
        <a href="manageReservations.jsp" class="nav-link">Manage Reservations</a>
        <a href="viewEmployeeSchedule.jsp" class="nav-link">View Employee Schedule</a>
        <a href="logout.jsp" class="nav-link">Log Out</a>
<%
    }
%>
</body>
</html>