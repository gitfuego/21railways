<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.cs336.pkg.ApplicationDB" %>
<%
    List<Map<String, Object>> questionsList = new ArrayList<>();
    String selectedQuestionId = request.getParameter("questionId");
    String message = "";

    try {
        ApplicationDB db = new ApplicationDB();
        Connection conn = db.getConnection();
        PreparedStatement pstmt = conn.prepareStatement("SELECT question_id, question_text FROM Questions WHERE answered=false");
        ResultSet questions = pstmt.executeQuery();

        while (questions.next()) {
            Map<String, Object> question = new HashMap<>();
            question.put("question_id", questions.getInt("question_id"));
            question.put("question_text", questions.getString("question_text"));
            questionsList.add(question);
        }

        questions.close();
        pstmt.close();
        conn.close();
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
    }

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

            pstmt.close();
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
                for (Map<String, Object> question : questionsList) {
                    int questionId = (int) question.get("question_id");
                    String questionText = (String) question.get("question_text");
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
