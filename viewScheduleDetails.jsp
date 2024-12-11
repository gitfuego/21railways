<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.cs336.pkg.ApplicationDB" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Schedule Details</title>
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
        String scheduleIdParam = request.getParameter("schedule_id");
        if (scheduleIdParam == null || scheduleIdParam.trim().isEmpty()) {
%>
        <h2>No schedule selected. <a href="searchSchedules.jsp">Go back</a></h2>
<%
        } else {
            int scheduleId = Integer.parseInt(scheduleIdParam);

            ApplicationDB db = new ApplicationDB();
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            
            String transitLine = null;
            double baseFare = 0.0;
            Timestamp originDeparture = null;
            Timestamp destinationArrival = null;
            int originId = 0;
            int destinationId = 0;
            int trainId = 0;

            try {
                con = db.getConnection();
                
                String scheduleSql = "SELECT transit_line, origin_id, destination_id, base_fare, origin_departure, destination_arrival, train_id "
                                   + "FROM Tschedule WHERE schedule_id = ?";
                ps = con.prepareStatement(scheduleSql);
                ps.setInt(1, scheduleId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    transitLine = rs.getString("transit_line");
                    baseFare = rs.getDouble("base_fare");
                    originDeparture = rs.getTimestamp("origin_departure");
                    destinationArrival = rs.getTimestamp("destination_arrival");
                    originId = rs.getInt("origin_id");
                    destinationId = rs.getInt("destination_id");
                    trainId = rs.getInt("train_id");
                }
                rs.close();
                ps.close();

                if (transitLine == null) {
%>
                <h2>Schedule not found. <a href="searchSchedules.jsp">Go back</a></h2>
<%
                } else {
                    // Get origin and destination station names
                    String stationNameSql = "SELECT name, city, state FROM Station WHERE sid = ?";
                    String originName = null;
                    String destinationName = null;

                    ps = con.prepareStatement(stationNameSql);
                    ps.setInt(1, originId);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        originName = rs.getString("name") + " (" + rs.getString("city") + ", " + rs.getString("state") + ")";
                    }
                    rs.close();
                    ps.close();

                    ps = con.prepareStatement(stationNameSql);
                    ps.setInt(1, destinationId);
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        destinationName = rs.getString("name") + " (" + rs.getString("city") + ", " + rs.getString("state") + ")";
                    }
                    rs.close();
                    ps.close();

                    String stopsSql = "SELECT s.stop_sequence_num, st.name, st.city, st.state, s.arrival, s.departure "
                                     + "FROM Stops s JOIN Station st ON s.station_id = st.sid "
                                     + "WHERE s.schedule_id = ? ORDER BY s.stop_sequence_num";
                    ps = con.prepareStatement(stopsSql);
                    ps.setInt(1, scheduleId);
                    rs = ps.executeQuery();
                    
                    List<Map<String,Object>> stops = new ArrayList<>();
                    while (rs.next()) {
                        Map<String,Object> row = new HashMap<>();
                        row.put("seq", rs.getInt("stop_sequence_num"));
                        row.put("station_name", rs.getString("name") + " (" + rs.getString("city") + ", " + rs.getString("state") + ")");
                        row.put("arrival", rs.getTimestamp("arrival"));
                        row.put("departure", rs.getTimestamp("departure"));
                        stops.add(row);
                    }
                    rs.close();
                    ps.close();
%>
        <h1>Schedule Details</h1>
        <h2><%= transitLine %></h2>
        <p style="text-align:center;">
            Train ID: <%= trainId %><br>
            Origin: <%= (originName != null ? originName : "Unknown") %><br>
            Departure Time: <%= originDeparture %><br>
            Destination: <%= (destinationName != null ? destinationName : "Unknown") %><br>
            Arrival Time: <%= destinationArrival %><br>
            Base Fare: $<%= baseFare %>
        </p>

        <h2>Stops on This Route</h2>
        <%
            if (stops.isEmpty()) {
        %>
            <p style="text-align:center;">No intermediate stops recorded.</p>
        <%
            } else {
        %>
            <table>
                <tr>
                    <th>Sequence</th>
                    <th>Station</th>
                    <th>Arrival Time</th>
                    <th>Departure Time</th>
                </tr>
                <%
                    for (Map<String,Object> row : stops) {
                %>
                <tr>
                    <td><%= row.get("seq") %></td>
                    <td><%= row.get("station_name") %></td>
                    <td><%= row.get("arrival") %></td>
                    <td><%= row.get("departure") %></td>
                </tr>
                <%
                    }
                %>
            </table>
        <%
            }
        %>
        <p style="text-align:center;">
            <a href="javascript:history.back()" class="nav-link">Back to Search Results</a>
        </p>
        
<%
                }
            } catch (SQLException e) {
                e.printStackTrace();
%>
                <p style="text-align:center;">Error retrieving schedule details. Please try again later.</p>
<%
            } finally {
                if (rs != null) try { rs.close(); } catch(SQLException ignored){}
                if (ps != null) try { ps.close(); } catch(SQLException ignored){}
                if (con != null) db.closeConnection(con);
            }
        }
    }
%>
</body>
</html>
