<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, javax.servlet.*"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.util.*" %>
<%
    // Check if the user is a manager
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("manager")) {
        response.sendRedirect("login.jsp"); // Redirect to login if not authorized
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    // List to store customer representative data
    List<Map<String, String>> customerReps = new ArrayList<>();
    String errorMessage = null;

    try {
        ApplicationDB db = new ApplicationDB();
        con = db.getConnection();

        // Fetch all customer representatives
        String sql = "SELECT username, fname, name, ssn FROM Employee WHERE role = 'customer_rep'";
        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> rep = new HashMap<>();
            rep.put("username", rs.getString("username"));
            rep.put("fname", rs.getString("fname"));
            rep.put("name", rs.getString("name"));
            rep.put("ssn", rs.getString("ssn"));
            customerReps.add(rep);
        }
    } catch (SQLException e) {
        errorMessage = "Error fetching customer representatives: " + e.getMessage();
    } finally {
        try { if (rs != null) rs.close(); } catch (SQLException e) {}
        try { if (ps != null) ps.close(); } catch (SQLException e) {}
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Customer Representatives</title>
</head>
<body>
    <h1>Manage Customer Representatives</h1>
    <a href="managerHome.jsp">Back to Manager Home</a>
    <br/>
    <br/>
    <h2>Add New Customer Representative</h2>
    <form method="post" action="addCustomerRep.jsp">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br>
        <label for="fname">First Name:</label>
        <input type="text" id="fname" name="fname" required><br>
        <label for="name">Last Name:</label>
        <input type="text" id="name" name="name" required><br>
        <label for="ssn">SSN:</label>
        <input type="text" id="ssn" name="ssn" required><br>
        <label for="password">Password:</label>
        <input type="text" id="password" name="password" required><br>
        <button type="submit">Add</button>
    </form>
    <br/>
    <h2>Existing Customer Representatives</h2>
    <%
        if (errorMessage != null) {
    %>
        <p style="color: red;"><%= errorMessage %></p>
    <%
        } else if (customerReps.isEmpty()) {
    %>
        <p>No customer representatives found.</p>
    <%
        } else {
    %>
        <table border="1">
            <tr>
                <th>Username</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>SSN</th>
                <th>Actions</th>
            </tr>
            <%
                for (Map<String, String> rep : customerReps) {
            %>
            <tr>
                <td><%= rep.get("username") %></td>
                <td><%= rep.get("fname") %></td>
                <td><%= rep.get("name") %></td>
                <td><%= rep.get("ssn") %></td>
                <td>
                    <!-- Edit action -->
                    <form method="get" action="editCustomerRep.jsp" style="display: inline;">
                        <input type="hidden" name="username" value="<%= rep.get("username") %>">
                        <button type="submit">Edit</button>
                    </form>
                    <!-- Delete action -->
                    <form method="post" action="deleteCustomerRep.jsp" style="display: inline;">
                        <input type="hidden" name="username" value="<%= rep.get("username") %>">
                        <button type="submit" onclick="return confirm('Are you sure you want to delete this representative?');">Delete</button>
                    </form>
                </td>
            </tr>
            <%
                }
            %>
        </table>
    <%
        }
    %>
</body>
</html>