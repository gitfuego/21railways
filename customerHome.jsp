<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Customer Home</title>
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
    if (user == null) {
%>
        <h2>You are not logged in. Please <a href="login.jsp">log in</a>.</h2>
<%
    } else {
%>
        <div class="welcome-message">
            <h1>Welcome, <%= user %>!</h1>
            <p>You are logged in as a customer.</p>
        </div>

        <!-- Future links to add for other customer pages -->
        <a href="viewReservations.jsp" class="nav-link">View Reservations</a>
        <a href="searchSchedules.jsp" class="nav-link">Search Schedules/Book</a>
        <a href="searchQuestions.jsp" class="nav-link">Search Questions</a>
        <a href="sumbitQuestions.jsp" class="nav-link">Sumbit Questions</a>
        <a href="logout.jsp" class="nav-link">Log Out</a>
        
<%
    }
%>
</body>
</html>