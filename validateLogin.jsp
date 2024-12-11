<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.ApplicationDB,java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Login Validation</title>
</head>
<body>
<%
    String userid = request.getParameter("Username");   
    String pass = request.getParameter("Password");

    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT * FROM Employee WHERE username=? AND password=?");
        ps.setString(1, userid);
        ps.setString(2, pass);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            session.setAttribute("user", userid);
            response.sendRedirect("success.jsp");
        } else {
            out.println("Invalid credentials. <a href='login.jsp'>Try again</a>");
        }

        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
</body>
</html>
