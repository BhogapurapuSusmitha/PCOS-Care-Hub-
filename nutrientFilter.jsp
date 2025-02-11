<%@ page import="java.sql.*, java.util.*" %>  
<%@ page language="java" contentType="text/html; charset=UTF-8"%>  
<%@ page pageEncoding="UTF-8"%>  
<!DOCTYPE html>  
<html lang="en">  
<head>  
    <meta charset="UTF-8">  
    <meta name="viewport" content="width=device-width, initial-scale=1.0">  
    <title>Food Nutrient Evaluation</title>  
    <style>  
        table {  
            width: 80%;  
            border-collapse: collapse;  
            margin: 20px 0;  
        }  
        table, th, td {  
            border: 1px solid black;  
        }  
        th, td {  
            padding: 10px;  
            text-align: left;  
        }  
    </style>  
</head>  
<body>  
    <h2>Food Nutrient Evaluation</h2>  

    <!-- Form to take input for food items -->  
    <form method="post">  
        <label for="foodInput">Enter food items (comma-separated):</label>  
        <input type="text" id="foodInput" name="foodInput" required>  
        <button type="submit">Submit</button>  
    </form>  

    <%
        // Get food input from form
        String foodInput = request.getParameter("foodInput");
        if (foodInput != null && !foodInput.isEmpty()) {
            // Database connection details
            String url = "jdbc:oracle:thin:@localhost:1521:XE";  // Adjust if needed
            String username = "system";
            String password = "abc123";
        
            // Split food items and process
            String[] foods = foodInput.split(",");
        
            // Initialize database connection
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            StringBuilder suggestedFoods = new StringBuilder();
        
            try {
                // Establish connection to Oracle database
                Class.forName("oracle.jdbc.driver.OracleDriver");
                conn = DriverManager.getConnection(url, username, password);
                stmt = conn.createStatement();
                
                // Initialize a map to store the first encountered food for each nutrient type
                Map<String, String> nutrientFoodMap = new LinkedHashMap<>();
                
                // Iterate over food items and fetch the nutrients
                for (String food : foods) {
                    String foodTrimmed = food.trim();
                    String query = "SELECT DISTINCT NUTRIENT_TYPE FROM FoodNutrients WHERE UPPER(FOOD_NAME) = UPPER('" + foodTrimmed + "')";
                    rs = stmt.executeQuery(query);
                    
                    // Add the first encountered food for each nutrient type
                    while (rs.next()) {
                        String nutrient = rs.getString("NUTRIENT_TYPE");
                        
                        // Only add the first food for each nutrient
                        if (!nutrientFoodMap.containsKey(nutrient)) {
                            nutrientFoodMap.put(nutrient, foodTrimmed);
                        }
                    }
                }
                
                // Display the result in a table with one food per nutrient
                out.println("<h3>Suggested Foods and Their Nutrients:</h3>");
                out.println("<table>");
                out.println("<tr><th>Nutrient Type</th><th>Suggested Food</th></tr>");
                
                // Display the food items for each nutrient
                for (String nutrient : nutrientFoodMap.keySet()) {
                    out.println("<tr><td>" + nutrient + "</td>");
                    out.println("<td>" + nutrientFoodMap.get(nutrient) + "</td></tr>");
                }
                
                out.println("</table>");
            
            } catch (ClassNotFoundException e) {
                out.println("<p><b>JDBC Driver not found:</b> " + e.getMessage() + "</p>");
                e.printStackTrace();
            } catch (SQLException e) {
                out.println("<p><b>Database error:</b> " + e.getMessage() + "</p>");
                e.printStackTrace();
            } catch (Exception e) {
                out.println("<p><b>Unexpected error:</b> " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                // Close database resources
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    out.println("<p><b>Error closing database resources:</b> " + e.getMessage() + "</p>");
                    e.printStackTrace();
                }
            }
        }
    %>

    <!-- Back to the previous page button -->
    <button onclick="window.history.back()">Back to Input</button>

</body>  
</html>
