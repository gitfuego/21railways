<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.cs336.pkg.ApplicationDB" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Train Schedules</title>
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

        table {
            border-collapse: collapse;
            width: 90%;
            margin: 20px auto;
        }

        th, td {
            border: 1px solid #999;
            padding: 10px;
            text-align: left;
        }

        th {
            background-color: #eee;
        }

        h1, h2 {
            text-align: center;
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
    <h2>You are not authorized to view this page. Please <a href="login.jsp">log in</a>.</h2>
<%
    } else {
        // Retrieve parameters if any
        String originParam = request.getParameter("origin");
        String destinationParam = request.getParameter("destination");
        String travelDate = request.getParameter("travelDate");
        String sortBy = request.getParameter("sortBy");

        // We'll only execute a search if at least one parameter is present or form is submitted
        // Otherwise, we just show the form.
%>
    <h1>Search Train Schedules</h1>

    <div class="form-container">
        <form action="searchSchedules.jsp" method="get">
            <div>
                <label for="origin">Origin Station (ID):</label>
                <input type="text" name="origin" id="origin" placeholder="e.g. 1">
            </div>

            <div>
                <label for="destination">Destination Station (ID):</label>
                <input type="text" name="destination" id="destination" placeholder="e.g. 2">
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

<%
    // If the user submitted the form (e.g., sortBy won't be null after submission)
    if (sortBy != null && !sortBy.isEmpty()) {
        // Build SQL query
        StringBuilder sql = new StringBuilder(
          "SELECT schedule_id, transit_line, origin_id, destination_id, base_fare, origin_departure, destination_arrival "
          + "FROM Tschedule WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (originParam != null && !originParam.trim().isEmpty()) {
            sql.append(" AND origin_id = ? ");
            params.add(Integer.parseInt(originParam));
        }

        if (destinationParam != null && !destinationParam.trim().isEmpty()) {
            sql.append(" AND destination_id = ? ");
            params.add(Integer.parseInt(destinationParam));
        }

        if (travelDate != null && !travelDate.trim().isEmpty()) {
            // Assuming travelDate is in YYYY-MM-DD format
            sql.append(" AND DATE(origin_departure) = ? ");
            params.add(travelDate);
        }

        // Validate sortBy to prevent SQL injection
        if (sortBy.equals("origin_departure") || sortBy.equals("destination_arrival") || sortBy.equals("base_fare")) {
            sql.append(" ORDER BY ").append(sortBy);
        } else {
            sql.append(" ORDER BY origin_departure");
        }

        ApplicationDB db = new ApplicationDB();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        List<Map<String,Object>> results = new ArrayList<>();

        try {
            con = db.getConnection();
            ps = con.prepareStatement(sql.toString());
            // Set parameters
            int idx = 1;
            for (Object param : params) {
                if (param instanceof Integer) {
                    ps.setInt(idx++, (Integer)param);
                } else if (param instanceof String) {
                    ps.setString(idx++, (String)param);
                }
            }
            rs = ps.executeQuery();

            while (rs.next()) {
                Map<String,Object> row = new HashMap<>();
                row.put("schedule_id", rs.getInt("schedule_id"));
                row.put("transit_line", rs.getString("transit_line"));
                row.put("origin_departure", rs.getTimestamp("origin_departure"));
                row.put("destination_arrival", rs.getTimestamp("destination_arrival"));
                row.put("base_fare", rs.getDouble("base_fare"));
                // Add more fields if needed
                results.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch(SQLException ignored){}
            if (ps != null) try { ps.close(); } catch(SQLException ignored){}
            if (con != null) db.closeConnection(con);
        }

        if (results.isEmpty()) {
%>
        <p style="text-align:center;">No schedules found for the given criteria.</p>
<%
        } else {
%>
        <<table>
            <tr>
                <th>Transit Line</th>
                <th>Origin Departure</th>
                <th>Destination Arrival</th>
                <th>Fare</th>
                <th>Details</th>
            </tr>
            <%
                for (Map<String,Object> row : results) {
            %>
            <tr>
                <td><%= row.get("transit_line") %></td>
                <td><%= row.get("origin_departure") %></td>
                <td><%= row.get("destination_arrival") %></td>
                <td>$<%= row.get("base_fare") %></td>
                <!-- Insert the View Details link here, passing the schedule_id as a parameter -->
                <td><a href="viewScheduleDetails.jsp?schedule_id=<%= row.get("schedule_id") %>">View Details</a></td>
            </tr>
            <%
                }
            %>
        </table>
        
<%
        }
    } // end if sortBy != null
%>

    <p style="text-align:center;"><a href="managerHome.jsp" class="nav-link">Back to Manager Home</a></p>

<%
    }
%>
</body>
</html>
