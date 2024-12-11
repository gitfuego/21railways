<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Generate Reports</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        form {
            margin: 20px;
        }
        label {
            display: inline-block;
            width: 150px;
        }
        select, input[type="date"] {
            margin-bottom: 10px;
        }
        .submit-button {
            background-color: lightblue;
            border: none;
            padding: 10px;
            border-radius: 5px;
        }
        .submit-button:hover {
            background-color: lightcoral;
            cursor: pointer;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
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
<%
    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if (user == null || !"manager".equalsIgnoreCase(role)) {
%>
    <h2>You are not authorized to access this page. Please <a href="login.jsp">log in</a>.</h2>
<%
    } else {
%>
    <h1>Generate Reports</h1>
    

    <p><a href="managerHome.jsp" class="back-link">Back to Manager Home</a></p>
<%
    }
%>
</body>
</html>
