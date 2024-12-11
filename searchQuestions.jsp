<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.cs336.pkg.ApplicationDB" %>
<%
    List<Map<String, Object>> searchResults = new ArrayList<>();
    String keyword = request.getParameter("keyword");
    if (keyword != null && !keyword.trim().isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            ApplicationDB db = new ApplicationDB();
            conn = db.getConnection();
            pstmt = conn.prepareStatement("SELECT * FROM Questions WHERE question_text LIKE ?");
            pstmt.setString(1, "%" + keyword + "%");
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("question_text", rs.getString("question_text"));
                row.put("username", rs.getString("username"));
                row.put("created_at", rs.getTimestamp("created_at"));
                row.put("answer", rs.getString("answer"));
                searchResults.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) {}
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) {}
            try { if (conn != null) conn.close(); } catch (SQLException e) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Search Questions</title>
</head>
<body>
    <h1>Search Existing Questions</h1>
    <form method="GET" action="searchQuestions.jsp">
        <label for="keyword">Search Keyword:</label><br>
        <input type="text" name="keyword" required><br>
        <input type="submit" value="Search">
    </form>

    <h3>Search Results</h3>
    <table border="1">
        <tr>
            <th>Question</th>
            <th>Asked By</th>
            <th>Date</th>
            <th>Answer</th>
        </tr>
        <% 
            if (!searchResults.isEmpty()) {
                for (Map<String, Object> row : searchResults) {
        %>
        <tr>
            <td><%= row.get("question_text") %></td>
            <td><%= row.get("username") %></td>
            <td><%= row.get("created_at") %></td>
            <td><%=row.get("answer") == null ? "Not Answered" : row.get("answer") %></td>
        </tr>
        <% 
                }
            } else {
        %>
        <tr>
            <td colspan="3">No questions found for this keyword.</td>
        </tr>
        <% } %>
    </table>
</body>
</html>
