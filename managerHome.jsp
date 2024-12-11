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
            width: fit-content;
            margin-top: 20px;
            padding: 10px;
            background-color: lightblue;
            text-decoration: none;
            color: black;
            border-radius: 5px;
        }
        .nav-link:hover {
            background-color: lightcoral;
        }
        section {
            width: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        #logoutBtn {
            background-color: red;
        }
        #logoutBtn:hover {
            background-color: rgb(205, 0, 0);
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
        <section>
            <a href="manageCustomerRepresentatives.jsp" class="nav-link">Manage Customer Representatives</a>
            <a href="viewSalesReport.jsp" class="nav-link">View Sales Report</a>
            <a href="produceReservations.jsp" class="nav-link">Produce Reservations</a>
            <a href="listRevenue.jsp" class="nav-link">List Revenue</a>
            <a href="bestCustomer.jsp" class="nav-link">Best Customer</a>
            <a href="bestTransitLines.jsp" class="nav-link">Best Transit Lines</a>
            <a href="generateReports.jsp" class="nav-link">Generate Reports</a>
            <a id='logoutBtn' href="logout.jsp" class="nav-link">Log Out</a>
        </section>
<%
    }
%>
</body>
</html>