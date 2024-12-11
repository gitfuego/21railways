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
    String user = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    if (user == null || !"customer".equalsIgnoreCase(role)) {
%>
    <h2>You are not authorized to view this page. Please <a href="login.jsp">log in</a>.</h2>
<%
    } else {

        String originParam = request.getParameter("origin");
        String destinationParam = request.getParameter("destination");
        String travelDate = request.getParameter("travelDate");
        String sortBy = request.getParameter("sortBy");

%>
    <h1>Search Train Schedules</h1>

    <div class="form-container">
        <form action="searchSchedules.jsp" method="get">
            <div>
                <label for="origin">Origin Station (City + Name):</label>
                <select name="origin" id="origin">
                    <option value="">Select Origin Station</option>
                    <%
                        ApplicationDB db = new ApplicationDB();
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;
                        try {
                            conn = db.getConnection();
                            String query = "SELECT sid, name, city FROM Station ORDER BY city ASC, name ASC";
                            stmt = conn.prepareStatement(query);
                            rs = stmt.executeQuery();
                            while (rs.next()) {
                                String stationName = rs.getString("name");
                                String city = rs.getString("city");
                                int stationId = rs.getInt("sid");
                    %>
                                <option value="<%= stationId %>"><%= city %> - <%= stationName %></option>
                    <%
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch(SQLException ignored){}
                            if (stmt != null) try { stmt.close(); } catch(SQLException ignored){}
                            if (conn != null) db.closeConnection(conn);
                        }
                    %>
                </select>
            </div>

            <div>
                <label for="destination">Destination Station (City + Name):</label>
                <select name="destination" id="destination">
                    <option value="">Select Destination Station</option>
                    <%
                        try {
                            conn = db.getConnection();
                            stmt = conn.prepareStatement("SELECT sid, name, city FROM Station ORDER BY city ASC, name ASC");
                            rs = stmt.executeQuery();
                            while (rs.next()) {
                                String stationName = rs.getString("name");
                                String city = rs.getString("city");
                                int stationId = rs.getInt("sid");
                    %>
                                <option value="<%= stationId %>"><%= city %> - <%= stationName %></option>
                    <%
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        } finally {
                            if (rs != null) try { rs.close(); } catch(SQLException ignored){}
                            if (stmt != null) try { stmt.close(); } catch(SQLException ignored){}
                            if (conn != null) db.closeConnection(conn);
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

<%
    if (sortBy != null && !sortBy.isEmpty()) {
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
            sql.append(" AND DATE(origin_departure) = ? ");
            params.add(travelDate);
        }

        if (sortBy.equals("origin_departure") || sortBy.equals("destination_arrival") || sortBy.equals("base_fare")) {
            sql.append(" ORDER BY ").append(sortBy).append(" DESC");
        } else {
            sql.append(" ORDER BY origin_departure DESC");
        }

        ApplicationDB db2 = new ApplicationDB();
        Connection con = null;
        PreparedStatement ps2 = null;
        ResultSet rs2 = null;

        List<Map<String,Object>> results = new ArrayList<>();

        try {
            con = db2.getConnection();
            ps2 = con.prepareStatement(sql.toString());
            int idx = 1;
            for (Object param : params) {
                if (param instanceof Integer) {
                    ps2.setInt(idx++, (Integer)param);
                } else if (param instanceof String) {
                    ps2.setString(idx++, (String)param);
                }
            }
            rs2 = ps2.executeQuery();

            while (rs2.next()) {
                Map<String,Object> row = new HashMap<>();
                row.put("schedule_id", rs2.getInt("schedule_id"));
                row.put("transit_line", rs2.getString("transit_line"));
                row.put("origin_departure", rs2.getTimestamp("origin_departure"));
                row.put("destination_arrival", rs2.getTimestamp("destination_arrival"));
                row.put("base_fare", rs2.getDouble("base_fare"));
                results.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs2 != null) try { rs2.close(); } catch(SQLException ignored){}
            if (ps2 != null) try { ps2.close(); } catch(SQLException ignored){}
            if (con != null) db.closeConnection(con);
        }

        if (results.isEmpty()) {
%>
        <p style="text-align:center;">No schedules found for the given criteria.</p>
<%
        } else {
%>
        <table>
            <tr>
                <th>Transit Line</th>
                <th>Origin Departure</th>
                <th>Destination Arrival</th>
                <th>Fare</th>
                <th>Details</th>
                <th>Book Reservation</th>
            </tr>
            <%
                for (Map<String,Object> row : results) {
            %>
            <tr>
                <td><%= row.get("transit_line") %></td>
                <td><%= row.get("origin_departure") %></td>
                <td><%= row.get("destination_arrival") %></td>
                <td>$<%= row.get("base_fare") %></td>
                <td><a href="viewScheduleDetails.jsp?schedule_id=<%= row.get("schedule_id") %>">View Details</a></td>
                <td>
                    <a href="bookReservation.jsp?schedule_id=<%= row.get("schedule_id") %>">
                        <button>Book Reservation</button>
                    </a>
                </td>
            </tr>
            <%
                }
            %>
        </table>
<%
        }
    }
%>

    <p style="text-align:center;"><a href="customerHome.jsp" class="nav-link">Back to Customer Home</a></p>

<%
    }
%>
</body>
</html>
