<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Login</title>
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
        }
        .login-form {
            margin: 100px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 300px;
        }
        .form-group {
            margin: 15px 0;
        }
        input[type="text"], input[type="password"], select {
            width: 100%;
            margin-top: 5px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .signup-btn {
            margin-top: 15px;
            display: block;
            background-color: #28a745;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
        }
        .signup-btn:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
    <h2>Login</h2>
    <div class="login-form">
        <form action="loginHandler.jsp" method="POST">
            <div class="form-group">
                <label for="Username">Username</label>
                <input type="text" name="Username" required />
            </div>
            <div class="form-group">
                <label for="Password">Password</label>
                <input type="password" name="Password" required />
            </div>
            <div class="form-group">
                <label for="role">Select Role</label>
                <select name="role" required>
                    <option value="customer">Customer</option>
                    <option value="employee">Manager</option>
                    <option value="employee">Customer Representative</option>
                </select>
            </div>
            <input type="submit" value="Login" />
        </form>
        <a href="createAccount.jsp" class="signup-btn">Sign Up</a>
    </div>
</body>
</html>
