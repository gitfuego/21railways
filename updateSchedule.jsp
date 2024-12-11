<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.cs336.pkg.ApplicationDB" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Schedule</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .container {
            width: 400px;
            margin: 50px auto;
            background: #f4f4f4;
            padding: 20px;
            border-radius: 8px;
        }
        label { display: block; margin-top: 10px; font-weight: bold; }
        input[type="text"], input[type="number"], input[type="datetime-local"] {
            width: 100%; 
            padding: 8px; 
            margin-top: 5px; 
            margin-bottom: 15px; 
            border: 1px solid #ccc; 
            border-radius: 4px;
        }
        select {
            width: 100%; 
            padding: 8px; 
            margin-top: 5px; 
            margin-bottom: 15px; 
            border: 1px solid #ccc; 
            border-radius: 4px;
        }
        input[type="submit"] {
            background: #007bff; 
            color: #fff; 
            border: none; 
            padding: 10px 20px; 
            border-radius: 4px; 
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background: #0056b3;
        }
        .nav-link {
            display: inline-block; 
            margin-top: 10px; 
            text-decoration: none; 
            color: #007bff;
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

            ApplicationDB db = new ApplicationDB();
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            // Check if form submitted
            String transitLineSubmitted = request.getParameter("transit_line");
            if (transitLineSubmitted != null) {
                // Form submitted, process update
                String transit_line = request.getParameter("transit_line");
                int origin_id = Integer.parseInt(request.getParameter("origin_id"));
                int destination_id = Integer.parseInt(request.getParameter("destination_id"));
                double base_fare = Double.parseDouble(request.getParameter("base_fare"));
                
                String origin_dep_str = request.getParameter("origin_departure");
                String dest_arr_str = request.getParameter("destination_arrival");
                
                int train_id = Integer.parseInt(request.getParameter("train_id"));

                Timestamp origin_dep = null;
                if (origin_dep_str != null && !origin_dep_str.trim().isEmpty()) {
                    origin_dep = Timestamp.valueOf(origin_dep_str.replace("T"," "));
                }

                Timestamp dest_arr = null;
                if (dest_arr_str != null && !dest_arr_str.trim().isEmpty()) {
                    dest_arr = Timestamp.valueOf(dest_arr_str.replace("T"," "));
                }

                try {
                    con = db.getConnection();
                    String updateSql = "UPDATE Tschedule SET transit_line=?, origin_id=?, destination_id=?, base_fare=?, origin_departure=?, destination_arrival=?, train_id=? WHERE schedule_id=?";
                    ps = con.prepareStatement(updateSql);
                    ps.setString(1, transit_line);
                    ps.setInt(2, origin_id);
                    ps.setInt(3, destination_id);
                    ps.setDouble(4, base_fare);
                    if (origin_dep != null) ps.setTimestamp(5, origin_dep); else ps.setNull(5, Types.TIMESTAMP);
                    if (dest_arr != null) ps.setTimestamp(6, dest_arr); else ps.setNull(6, Types.TIMESTAMP);
                    ps.setInt(7, train_id);
                    ps.setInt(8, scheduleId);
                    ps.executeUpdate();
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    if (ps != null) try { ps.close(); } catch(SQLException ignored){}
                    if (con != null) db.closeConnection(con);
                }
%>
                <h2>Schedule Updated Successfully!</h2>
                <a href="editTrainSchedules.jsp" class="nav-link">Back to Edit Schedules</a>
<%
            } else {
                // No form submit, display the current values
                String transitLine = null;
                int originId = 0;
                int destinationId = 0;
                double baseFare = 0.0;
                Timestamp originDeparture = null;
                Timestamp destinationArrival = null;
                int trainId = 0;
                try {
                    con = db.getConnection();
                    String sql = "SELECT transit_line, origin_id, destination_id, base_fare, origin_departure, destination_arrival, train_id FROM Tschedule WHERE schedule_id = ?";
                    ps = con.prepareStatement(sql);
                    ps.setInt(1, scheduleId);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        transitLine = rs.getString("transit_line");
                        originId = rs.getInt("origin_id");
                        destinationId = rs.getInt("destination_id");
                        baseFare = rs.getDouble("base_fare");
                        originDeparture = rs.getTimestamp("origin_departure");
                        destinationArrival = rs.getTimestamp("destination_arrival");
                        trainId = rs.getInt("train_id");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch(SQLException ignored){}
                    if (ps != null) try { ps.close(); } catch(SQLException ignored){}
                    if (con != null) db.closeConnection(con);
                }

                if (transitLine == null) {
%>
                <h2>Schedule not found. <a href="editTrainSchedules.jsp">Go back</a></h2>
<%
                } else {
                    String originDepStr = (originDeparture != null) ? originDeparture.toString().replace(' ', 'T') : "";
                    String destArrStr = (destinationArrival != null) ? destinationArrival.toString().replace(' ', 'T') : "";
%>
    <div class="container">
        <h2>Update Schedule (ID: <%= scheduleId %>)</h2>
        <form method="post">
            <input type="hidden" name="schedule_id" value="<%= scheduleId %>">

            <label for="transit_line">Transit Line</label>
            <input type="text" name="transit_line" id="transit_line" value="<%= transitLine %>" required>

            <label for="origin_id">Origin ID</label>
            <input type="number" name="origin_id" id="origin_id" value="<%= originId %>" required>

            <label for="destination_id">Destination ID</label>
            <input type="number" name="destination_id" id="destination_id" value="<%= destinationId %>" required>

            <label for="base_fare">Base Fare</label>
            <input type="number" step="0.01" name="base_fare" id="base_fare" value="<%= baseFare %>" required>

            <label for="origin_departure">Origin Departure (YYYY-MM-DDTHH:MM:SS)</label>
            <input type="text" name="origin_departure" id="origin_departure" value="<%= originDepStr %>">

            <label for="destination_arrival">Destination Arrival (YYYY-MM-DDTHH:MM:SS)</label>
            <input type="text" name="destination_arrival" id="destination_arrival" value="<%= destArrStr %>">

            <label for="train_id">Train ID</label>
            <input type="number" name="train_id" id="train_id" value="<%= trainId %>" required>

            <input type="submit" value="Update Schedule">
        </form>
        <a href="editTrainSchedules.jsp" class="nav-link">Back to Edit Schedules</a>
    </div>
<%
                }
            }
        }
    }
%>
</body>
</html>
