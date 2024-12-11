<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.cs336.pkg.ApplicationDB" %>
<%
    ResultSet questions = null;
    String selectedQuestionId = request.getParameter("questionId");
    String message = "";

    // Retrieve all questions that have not been answered
    try {
        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();
        PreparedStatement pstmt = conn.prepareStatement("SELECT question_id, question_text FROM Questions WHERE answered=false");
        questions = pstmt.executeQuery();
        conn.close();
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    }

    // If the questionId is provided, process the answer submission
    if (selectedQuestionId != null && request.getParameter("answer") != null && !request.getParameter("answer").trim().isEmpty()) {
        try {
            String answer = request.getParameter("answer");
            ApplicationDB db = new ApplicationDB();
            Connection conn = db.getConnection();

            PreparedStatement pstmt = conn.prepareStatement("UPDATE Questions SET answer=?, answered=true WHERE question_id=?");
            pstmt.setString(1, answer);
            pstmt.setInt(2, Integer.parseInt(selectedQuestionId));
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

    <h3>Select a Question to Answer:</h3>
    <form method="GET" action="replyToCustomerQuestions.jsp">
        <label for="questionId">Choose a Question:</label>
        <select name="questionId" required>
            <option value="" disabled selected>Select a Question</option>
            <% 
                while (questions != null && questions.next()) {
                    int questionId = questions.getInt("question_id");
                    String questionText = questions.getString("question_text");
            %>
            <option value="<%= questionId %>"><%= questionText %></option>
            <% 
                }
            %>
        </select>
        <input type="submit" value="Select Question">
    </form>

    <% if (selectedQuestionId != null) { %>
    <h3>Answer the Question</h3>
    <form method="POST" action="replyToCustomerQuestions.jsp">
        <label for="answer">Your Answer:</label><br>
        <textarea name="answer" rows="5" required></textarea><br>
        <input type="hidden" name="questionId" value="<%= selectedQuestionId %>">
        <input type="submit" value="Submit Answer">
    </form>
    <% } %>

    <p><%= message %></p>
</body>
</html>
