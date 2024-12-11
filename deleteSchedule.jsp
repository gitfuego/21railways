<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.cs336.pkg.ApplicationDB" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Schedule</title>
    <style>
        body { font-family: Arial, sans-serif; text-align:center; margin-top:100px; }
        .container { 
            display: inline-block; 
            background: #f4f4f4; 
            padding: 20px; 
            border-radius: 8px; 
        }
        input[type="submit"] {
            background: #dc3545; 
            color: #fff; 
            border: none; 
            padding: 10px 20px; 
            border-radius: 4px; 
            cursor: pointer;
            margin: 10px;
        }
        input[type="submit"]:hover {
            background: #c82333;
        }
        a.nav-link {
            display: inline-block; 
            margin: 10px; 
            text-decoration: none; 
            background: #007bff; 
            color: #fff; 
            padding: 10px 20px; 
            border-radius:4px; 
        }
        a.nav-link:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
<%
    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if (user == null || !"customer_rep".equals(role)) {
%>
    <h2>You are not authorized to access this page. Please <a href="login.jsp">log in</a>.</h2>
<%
    } else {
        String scheduleIdParam = request.getParameter("schedule_id");
        if (scheduleIdParam == null || scheduleIdParam.trim().isEmpty()) {
%>
        <h2>No schedule selected. <a href="editTrainSchedules.jsp">Go back</a></h2>
<%
        } else {
            int scheduleId = Integer.parseInt(scheduleIdParam);

            // Check if form submitted for deletion
            String confirmDelete = request.getParameter("confirm");
            if (confirmDelete != null && confirmDelete.equals("yes")) {
                // Perform delete
                ApplicationDB db = new ApplicationDB();
                Connection con = null;
                PreparedStatement ps = null;
                try {
                    con = db.getConnection();
                    // If foreign keys exist (e.g. in Stops or Reservation), delete them first if needed
                    // For now, assume direct delete is possible.
                    String delSQL = "DELETE FROM Tschedule WHERE schedule_id=?";
                    ps = con.prepareStatement(delSQL);
                    ps.setInt(1, scheduleId);
                    ps.executeUpdate();
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    if (ps != null) try { ps.close(); } catch(SQLException ignored){}
                    if (con != null) db.closeConnection(con);
                }
%>
                <h2>Schedule Deleted Successfully!</h2>
                <a href="editTrainSchedules.jsp" class="nav-link">Back to Edit Schedules</a>
<%
            } else {
%>
    <div class="container">
        <h2>Are you sure you want to delete schedule ID <%= scheduleId %>?</h2>
        <form method="post">
            <input type="hidden" name="schedule_id" value="<%= scheduleId %>">
            <input type="hidden" name="confirm" value="yes">
            <input type="submit" value="Delete">
        </form>
        <a href="editTrainSchedules.jsp" class="nav-link">Cancel</a>
    </div>
<%
            }
        }
    }
%>
</body>
</html>
