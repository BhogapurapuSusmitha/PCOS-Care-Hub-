<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page language="java" contentType="application/json; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%
    // Get user input from the POST request
    String user_id = request.getParameter("user_id");
    String day = request.getParameter("day");

    // Create response object
    JSONObject response = new JSONObject();

    try {
        // Database connection setup
        String dbUrl = "jdbc:oracle:thin:@localhost:1521:XE";
        String dbUser = "system";
        String dbPassword = "abc123";

        // Create a connection
        Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

        // Check if the day already exists for the user
        String checkQuery = "SELECT * FROM UserDays WHERE user_id = ? AND day = ?";
        PreparedStatement pstmt = conn.prepareStatement(checkQuery);
        pstmt.setString(1, user_id);
        pstmt.setString(2, day);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            // If the day already exists, send a failure response
            response.put("success", false);
            response.put("message", "Day already added.");
        } else {
            // Insert the day into the database
            String insertQuery = "INSERT INTO UserDays (user_id, day) VALUES (?, ?)";
            pstmt = conn.prepareStatement(insertQuery);
            pstmt.setString(1, user_id);
            pstmt.setString(2, day);
            int result = pstmt.executeUpdate();

            if (result > 0) {
                // Successful insertion
                response.put("success", true);
                response.put("message", "Day added successfully.");
            } else {
                // Insertion failed
                response.put("success", false);
                response.put("message", "Error adding day.");
            }
        }

        // Close the resources
        rs.close();
        pstmt.close();
        conn.close();

    } catch (Exception e) {
        e.printStackTrace();
        response.put("success", false);
        response.put("message", "Database error: " + e.getMessage());
    }

    // Send the JSON response
    response.getWriter().write(response.toString());
%>
