<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*, com.cs336.pkg.ApplicationDB" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Browse and Search Schedules</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .nav-link {
            margin: 10px;
            display: inline-block;
            padding: 10px;
            background-color: lightblue;
            text-decoration: none;
            color: black;
            border-radius: 5px;
        }
        .nav-link:hover {
            background-color: lightcoral;
        }

        .form-container {
            margin: 20px;
        }

        label {
            display: inline-block;
            width: 150px;
            margin-bottom: 10px;
        }

        select, input[type="date"] {
            width: 200px;
            padding: 5px;
        }

        .submit-button {
            padding: 10px 20px;
            background-color: lightgreen;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .submit-button:hover {
            background-color: lightcoral;
        }
    </style>
</head>
<body>
<%
    // Check if manager is logged in
    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if (user == null || !"customer".equalsIgnoreCase(role)) {
%>
    <h2>You are not authorized to access this page. Please <a href="login.jsp">log in</a>.</h2>
<%
    } else {
        // Load stations from the database
        List<String[]> stations = new ArrayList<>();
        ApplicationDB db = new ApplicationDB();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = db.getConnection();
            String sql = "SELECT sid, name, city, state FROM Station ORDER BY name";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                // We'll store each station as an array: [sid, name]
                String sid = String.valueOf(rs.getInt("sid"));
                String stationName = rs.getString("name") + " (" + rs.getString("city") + ", " + rs.getString("state") + ")";
                stations.add(new String[]{sid, stationName});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
            if (con != null) db.closeConnection(con);
        }
%>
    <h1>Browse and Search Train Schedules</h1>

    <div class="form-container">
        <form action="searchSchedules.jsp" method="get">
            <div>
                <label for="origin">Origin Station:</label>
                <select name="origin" id="origin">
                    <option value="">--Select--</option>
                    <%
                        for (String[] st : stations) {
                            %><option value="<%= st[0] %>"><%= st[1] %></option><%
                        }
                    %>
                </select>
            </div>

            <div>
                <label for="destination">Destination Station:</label>
                <select name="destination" id="destination">
                    <option value="">--Select--</option>
                    <%
                        for (String[] st : stations) {
                            %><option value="<%= st[0] %>"><%= st[1] %></option><%
                        }
                    %>
                </select>
            </div>

            <div>
                <label for="travelDate">Date of Travel:</label>
                <input type="date" name="travelDate" id="travelDate">
            </div>

            <div>
                <label for="sortBy">Sort By:</label>
                <select name="sortBy" id="sortBy">
                    <option value="origin_departure">Departure Time</option>
                    <option value="destination_arrival">Arrival Time</option>
                    <option value="base_fare">Fare</option>
                </select>
            </div>

            <div>
                <input type="submit" value="Search" class="submit-button">
            </div>
        </form>
    </div>

    <p><a href="managerHome.jsp" class="nav-link">Back to Manager Home</a></p>
<%
    }
%>
</body>
</html>
