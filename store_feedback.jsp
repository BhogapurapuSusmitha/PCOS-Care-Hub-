<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%
    // Retrieve form data
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String websiteLike = request.getParameter("websiteLike");
    String difference = request.getParameter("difference");
    String features = request.getParameter("features");
    String improvements = request.getParameter("improvements");
    String lifestyle = request.getParameter("lifestyle");
    String feedback = request.getParameter("feedback");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // Database connection setup
        String dbUrl = "jdbc:oracle:thin:@localhost:1521:XE"; // Update with your Oracle DB connection details
        String dbUser = "system";  // Your DB username
        String dbPassword = "abc123";  // Your DB password

        conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // Insert query
        String query = "INSERT INTO UserFeedback (NAME, EMAIL, WEBSITE_LIKE, DIFFERENCE, FEATURES, IMPROVEMENTS, LIFESTYLE, FEEDBACK) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(query);

        // Set values for each placeholder
        pstmt.setString(1, name);
        pstmt.setString(2, email);
        pstmt.setString(3, websiteLike);
        pstmt.setString(4, difference);
        pstmt.setString(5, features);
        pstmt.setString(6, improvements);
        pstmt.setString(7, lifestyle);
        pstmt.setString(8, feedback);

        int rowsInserted = pstmt.executeUpdate();

        // Return success message
        if (rowsInserted > 0) {
            out.print("Thank you for your feedback! Your response has been recorded.");
        } else {
            out.print("Failed to submit feedback. Please try again later.");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.print("Database error: " + e.getMessage());
    } finally {
        // Clean up resources
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>
