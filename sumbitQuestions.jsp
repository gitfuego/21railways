<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.cs336.pkg.ApplicationDB" %>
<%
    String message = "";
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String questionText = request.getParameter("questionText");
        String username = (String) session.getAttribute("user");  // Get logged-in username

        if (questionText != null && !questionText.trim().isEmpty()) {
            try {
                ApplicationDB db = new ApplicationDB();
                Connection conn = db.getConnection();
                PreparedStatement pstmt = conn.prepareStatement("INSERT INTO Questions (username, question_text) VALUES (?, ?)");
                pstmt.setString(1, username);
                pstmt.setString(2, questionText);
                int rows = pstmt.executeUpdate();

                if (rows > 0) {
                    message = "Your question has been submitted successfully!";
                } else {
                    message = "There was an issue submitting your question. Please try again.";
                }

                conn.close();
            } catch (Exception e) {
                message = "Error: " + e.getMessage();
            }
        } else {
            message = "Question cannot be empty!";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Ask a Question</title>
</head>
<body>
    <h1>Ask a Question</h1>
    <form method="POST" action="sumbitQuestions.jsp">
        <label for="questionText">Your Question:</label><br>
        <textarea name="questionText" rows="5" required></textarea><br>
        <input type="submit" value="Submit Question">
    </form>

    <p><%= message %></p>
</body>
</html>
