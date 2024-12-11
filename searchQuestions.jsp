<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.cs336.pkg.ApplicationDB" %>
<%
    ResultSet searchResults = null;
    String keyword = request.getParameter("keyword");
    if (keyword != null && !keyword.trim().isEmpty()) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection conn = db.getConnection();
            PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM Questions WHERE question_text LIKE ?");
            pstmt.setString(1, "%" + keyword + "%");
            searchResults = pstmt.executeQuery();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
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
    <table>
        <tr>
            <th>Question</th>
            <th>Asked By</th>
            <th>Date</th>
        </tr>
        <% 
            if (searchResults != null) {
                while (searchResults.next()) {
        %>
        <tr>
            <td><%= searchResults.getString("question_text") %></td>
            <td><%= searchResults.getString("username") %></td>
            <td><%= searchResults.getTimestamp("created_at") %></td>
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
