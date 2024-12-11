<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%
    String username = request.getParameter("Username");
    String password = request.getParameter("Password");
    String role = request.getParameter("role");
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        if (role.equals("customer")) {
            ps = con.prepareStatement("SELECT * FROM Customer WHERE username=? AND password=?");
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("user", username);
                session.setAttribute("role", "customer"); 
                response.sendRedirect("customerHome.jsp"); 
            } else {
                out.println("Invalid customer credentials! <a href='login.jsp'>Try again</a>");
            }
        } else if (role.equals("employee")) {
            ps = con.prepareStatement("SELECT * FROM Employee WHERE username=? AND password=?");
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                String employeeRole = rs.getString("role");
                session.setAttribute("user", username);
                session.setAttribute("role", employeeRole); 

                if ("Manager".equalsIgnoreCase(employeeRole)) {
                    response.sendRedirect("managerHome.jsp"); 
                } else if ("customer_rep".equalsIgnoreCase(employeeRole)) {
                    response.sendRedirect("customerRepHome.jsp"); 
                } else {
                    out.println("Unknown employee role!");
                }
            } else {
                out.println("Invalid employee credentials! <a href='login.jsp'>Try again</a>");
            }
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        // Close database resources
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>