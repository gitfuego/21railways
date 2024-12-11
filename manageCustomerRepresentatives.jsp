<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Customer Representatives</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .action-link {
            display: inline-block;
            margin-right: 10px;
            padding: 8px;
            text-decoration: none;
            background-color: lightblue;
            border-radius: 5px;
            color: black;
        }
        .action-link:hover {
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
    <h1>Manage Customer Representatives</h1>
    <!-- <p>Use the options below to add, remove, or update customer representatives.</p> -->
    
    <!-- <a href="addCustomerRepresentative.jsp" class="action-link">Add Representative</a>
    <a href="updateCustomerRepresentative.jsp" class="action-link">Update Representative</a>
    <a href="removeCustomerRepresentative.jsp" class="action-link">Remove Representative</a> -->

    <p><a href="managerHome.jsp">Back to Manager Home</a></p>
<%
    }
%>
</body>
</html>
