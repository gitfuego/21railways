<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Register</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f4f4f9;
        margin: 0;
        padding: 0;
    }

    h2 {
        text-align: center;
        color: #333;
    }

    form {
        width: 300px;
        margin: 50px auto;
        padding: 20px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }

    input[type="text"], input[type="password"], input[type="email"] {
        width: 100%;
        padding: 10px;
        margin: 10px 0;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 16px;
    }

    input[type="submit"] {
        width: 100%;
        padding: 10px;
        background-color: #4CAF50;
        border: none;
        border-radius: 4px;
        color: white;
        font-size: 16px;
        cursor: pointer;
    }

    input[type="submit"]:hover {
        background-color: #45a049;
    }

    label {
        font-size: 14px;
        margin-bottom: 5px;
        display: block;
        color: #333;
    }
</style>
</head>
<body>
<h2>Create Account</h2>
<form action="createLogin.jsp" method="POST">
    <label for="Username">Enter A Username:</label>
    <input type="text" name="Username" id="Username" required/> <br/>
    
    <label for="Password">Enter A Password:</label>
    <input type="password" name="Password" id="Password" required/> <br/>
    
    <label for="FirstName">Enter Your First Name:</label>
    <input type="text" name="FirstName" id="FirstName" required/> <br/>
    
    <label for="LastName">Enter Your Last Name:</label>
    <input type="text" name="LastName" id="LastName" required/> <br/>
    
    <label for="Email">Enter Your Email:</label>
    <input type="email" name="Email" id="Email" required/> <br/>
    
    <input type="submit" value="Submit"/>
</form>
</body>
</html>