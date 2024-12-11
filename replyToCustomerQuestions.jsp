<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.cs336.pkg.ApplicationDB" %>
<%
    String message = "";
    String questionId = request.getParameter("questionId");
    String answer = request.getParameter("answer");

    if (questionId != null && answer != null && !answer.trim().isEmpty()) {
        try {
            ApplicationDB db = new ApplicationDB();
            Connection conn = db.getConnection();

=            PreparedStatement pstmt = conn.prepareStatement("UPDATE Questions SET answer=?, answered=true WHERE question_id=?");
            pstmt.setString(1, answer);
            pstmt.setInt(2, Integer.parseInt(questionId));
            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                message = "Answer has been submitted successfully!";
            } else {
                message = "Error updating the answer. Please try again.";
            }

            conn.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reply to Customer Question</title>
</head>
<body>
    <h1>Reply to Customer Question</h1>

    <form method="POST" action="replyToCustomerQuestions.jsp">
        <label for="answer">Your Answer:</label><br>
        <textarea name="answer" rows="5" required></textarea><br>
        <input type="hidden" name="questionId" value="<%= request.getParameter("questionId") %>">
        <input type="submit" value="Submit Answer">
    </form>

    <p><%= message %></p>
</body>
</html>
