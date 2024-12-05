<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*"%>
<%
    String username = request.getParameter("Username");
    String password = request.getParameter("Password");
    String role = request.getParameter("role");
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Initialize database connection
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        if (role.equals("customer")) {
            // Check login in the Customer table
            ps = con.prepareStatement("SELECT * FROM Customer WHERE username=? AND password=?");
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Login success for customer
                session.setAttribute("user", username); // store username in session
                session.setAttribute("role", "customer"); // store user role in session
                response.sendRedirect("customerHome.jsp"); // Redirect to customer home page
            } else {
                out.println("Invalid customer credentials!");
            }
        } else if (role.equals("employee")) {
            // Check login in the Employee table
            ps = con.prepareStatement("SELECT * FROM Employee WHERE username=? AND password=?");
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Login success for employee (admin or customer_rep)
                session.setAttribute("user", username); // store username in session
                session.setAttribute("role", rs.getString("role")); // store user role in session (admin or customer_rep)
                response.sendRedirect("employeeHome.jsp"); // Redirect to employee home page
            } else {
                out.println("Invalid employee credentials!");
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