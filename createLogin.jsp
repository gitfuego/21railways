<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%@ page import ="java.sql.*" %>
<%
String userid = request.getParameter("Username");   
String pass = request.getParameter("Password");
String firstName = request.getParameter("FirstName");
String lastName = request.getParameter("LastName");
String email = request.getParameter("Email");

try {
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();

    // Check if the username already exists in the database
    PreparedStatement ps = con.prepareStatement("SELECT * FROM Customer WHERE username=?");
    ps.setString(1, userid);
    ResultSet rs = ps.executeQuery();

    if (rs.next()) {
        out.println("Username already exists, <a href='createAccount.jsp'>please try again</a>");
    } else {
       
        PreparedStatement ps2 = con.prepareStatement("INSERT INTO Customer (username, password, email, fname, name) VALUES (?, ?, ?, ?, ?)");
        ps2.setString(1, userid);
        ps2.setString(2, pass);
        ps2.setString(3, email);
        ps2.setString(4, firstName);
        ps2.setString(5, lastName);

        int result = ps2.executeUpdate();

        if (result > 0) {
            session.setAttribute("user", userid); // Store the username in session
            response.sendRedirect("success.jsp");
        } else {
            out.println("Error during account creation. Please try again.");
        }

        ps2.close();
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