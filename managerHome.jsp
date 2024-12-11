<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Manager Home</title>
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
    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    
    if (user == null || !"manager".equalsIgnoreCase(role)) {
%>
        <h2>You are not authorized to access this page. Please <a href="login.jsp">log in</a>.</h2>
<%
    } else {
%>
        <div class="welcome-message">
            <h1>Welcome, <%= user %>!</h1>
            <p>You are logged in as <%= role %> (Manager).</p>
        </div>

        <!-- Future possible linkts to add manager-related pages -->
        <a href="manageCustomerRepresentatives.jsp" class="nav-link">Manage Customer Representatives</a>
        <a href="viewSalesReport.jsp" class="nav-link">View Sales Report</a>
        <a href="generateReports.jsp" class="nav-link">Generate Reports</a>
        <a href="browseSchedules.jsp" class="nav-link">Browse Schedules</a>
        <a href="logout.jsp" class="nav-link">Log Out</a>

<%
    }
%>
</body>
</html>