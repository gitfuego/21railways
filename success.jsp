<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Success - Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
            text-align: center;
        }
        
        h2 {
            color: #333;
            margin-top: 50px;
        }

        .message {
            margin: 20px;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            display: inline-block;
            width: 300px;
        }

        .logout-link {
            color: #007bff;
            text-decoration: none;
            font-weight: bold;
        }

        .logout-link:hover {
            text-decoration: underline;
        }

        .login-link {
            color: #e74c3c;
            font-size: 18px;
        }
    </style>
</head>
<body>

<%
    if ((session.getAttribute("user") == null)) {
%>
    <div class="message">
        <h2>You are not logged in</h2>
        <p><a href="login.jsp" class="login-link">Please Login</a></p>
    </div>
<% } else { %>
    <div class="message">
        <h2>Welcome, <%= session.getAttribute("user") %></h2>
        <p><a href="logout.jsp" class="logout-link">Log out</a></p>
    </div>
<%
    }
%>

</body>
</html>