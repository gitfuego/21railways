<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Customer Representative Home</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .welcome-message {
            font-size: 24px;
            color: blue;
        }
        .nav-link {
            margin-top: 20px;
            display: inline-block;
            padding: 10px;
            background-color: lightgreen;
            text-decoration: none;
            color: black;
            border-radius: 5px;
        }
        .nav-link:hover {
            background-color: lightyellow;
        }
    </style>
</head>
<body>
<%
    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    
    if (user == null || !"customer_rep".equals(role)) {
%>
        <h2>You are not authorized to access this page. Please <a href="login.jsp">log in</a>.</h2>
<%
    } else {
%>
        <div class="welcome-message">
            <h1>Welcome, <%= user %>!</h1>
            <p>You are logged in as <%= role %> (Customer Representative).</p>
        </div>

        <!-- Future links to  add for  customer representative-related pages -->
        <a href="editTrainSchedules.jsp" class="nav-link">Edit Train Schedules</a>
        <a href="replyToCustomerQuestions.jsp" class="nav-link">Reply to Customer Questions</a>
        <a href="reviewCustomerReservations.jsp" class="nav-link">View Reservations by Transit Line</a>
        <a href="viewSchedulesByStation.jsp" class="nav-link">View Schedules by Station</a>

        <a href="logout.jsp" class="nav-link">Log Out</a>



<%
    }
%>
</body>
</html>
