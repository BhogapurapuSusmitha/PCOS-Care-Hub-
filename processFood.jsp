<%@ page import="java.sql.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Nutrient Evaluation Results</title>
    <style>
        body {
            background: linear-gradient(135deg, #A7C5EB, #F8EDEB);
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            height: 100vh;
            box-sizing: border-box;
        }
        
        header {
            background: linear-gradient(90deg, #FFA69E, #861657);
            color: #FFFFFF;
            padding: 70px 0;
            text-align: center;
            position: relative;
        }

        .content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .main-content {
            border: 2px solid rgb(94, 25, 94);
            border-radius: 10px;
            padding: 25px;
            margin: auto;
            background-color: #ffffff;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            width: 100%;
            max-width: 100%;
            text-align: center;
            line-height: 2.0;
            letter-spacing: 0.5px;
        }

        .big-text {
            font-size: 5rem;
            font-style: italic;
            font-family: "Script MT Bold", "Lucida Handwriting", cursive;
            color: #ffffff;
        }

        h1 {
            text-align: center;
            color: rgb(94, 25, 94);
            margin: 20px 0;
        }

        p {
            color: #333;
        }

        #motivation {
            color: #8a0232;
            font-weight: bold;
            font-size: 1.1em;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border-radius: 8px;
            overflow: hidden;
            background-color: #fff;
        }

        th, td {
            text-align: left;
            padding: 15px;
            border: 1px solid #ddd;
        }

        th {
            background-color: #861657;
            color: white;
            font-size: 18px;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .btn {
            display: inline-block;
            background-color: #A020F0;
            color: white;
            padding: 10px 15px;
            margin-top: 20px;
            text-decoration: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: #7a1c93;
        }

        .btn:disabled {
            background-color: #b4a1d1;
            cursor: not-allowed;
        }

        .message {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <header>
        <h1>Food Nutrient Evaluation</h1>
    </header>

    <div class="content">
        <div class="main-content">
            <h2>Food Nutrient Evaluation Results</h2>
            <%
                // Input handling
                String foodInput = request.getParameter("foodInput");
                int loadMoreOffset = Integer.parseInt(request.getParameter("offset") != null ? request.getParameter("offset") : "0");
                int loadLimit = 5;

                // Define important nutrients
                List<String> importantNutrients = Arrays.asList(
                    "Carbohydrate", "Lean Protein", "Fiber", "Omega-3 Fats",
                    "Vitamin D", "Vitamin B1", "Vitamin B2", "Vitamin B3",
                    "Vitamin B6", "Vitamin B7", "Vitamin B9", "Vitamin B12"
                );

                // Database connection details
                String url = "jdbc:oracle:thin:@localhost:1521:XE";
                String username = "system";
                String password = "abc123";

                Set<String> coveredNutrients = new HashSet<>();
                Map<String, List<String>> nutrientFoodsMap = new HashMap<>();
                for (String nutrient : importantNutrients) {
                    nutrientFoodsMap.put(nutrient, new ArrayList<>());
                }

                try (Connection conn = DriverManager.getConnection(url, username, password)) {
                    // Step 1: Determine nutrients covered by the input foods
                    if (foodInput != null && !foodInput.isEmpty()) {
                        String[] foods = foodInput.split(",");
                        String placeholders = String.join(", ", Collections.nCopies(foods.length, "?"));
                        String nutrientQuery = "SELECT DISTINCT NUTRIENT_TYPE FROM FoodNutrients WHERE FOOD_NAME IN (" + placeholders + ")";
                        try (PreparedStatement pstmt = conn.prepareStatement(nutrientQuery)) {
                            for (int i = 0; i < foods.length; i++) {
                                pstmt.setString(i + 1, foods[i].trim());
                            }
                            try (ResultSet rs = pstmt.executeQuery()) {
                                while (rs.next()) {
                                    coveredNutrients.add(rs.getString("NUTRIENT_TYPE"));
                                }
                            }
                        }
                    }

                    // Step 2: Fetch foods for uncovered nutrients
                    for (String nutrient : importantNutrients) {
                        if (!coveredNutrients.contains(nutrient)) {
                            String foodQuery = "SELECT FOOD_NAME FROM FoodNutrients WHERE NUTRIENT_TYPE = ? OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
                            try (PreparedStatement pstmt = conn.prepareStatement(foodQuery)) {
                                pstmt.setString(1, nutrient);
                                pstmt.setInt(2, loadMoreOffset);
                                pstmt.setInt(3, loadLimit);

                                try (ResultSet rs = pstmt.executeQuery()) {
                                    List<String> foods = nutrientFoodsMap.get(nutrient);
                                    while (rs.next()) {
                                        foods.add(rs.getString("FOOD_NAME"));
                                    }
                                }
                            }
                        }
                    }

                    // Step 3: Render output table
                    out.println("<table>");
                    out.println("<thead><tr><th>Nutrient</th><th>Foods</th></tr></thead>");
                    out.println("<tbody>");
                    for (String nutrient : importantNutrients) {
                        List<String> foods = nutrientFoodsMap.get(nutrient);
                        if (!foods.isEmpty()) {
                            out.println("<tr><td>" + nutrient + "</td><td>" + String.join(", ", foods) + "</td></tr>");
                        }
                    }
                    out.println("</tbody>");
                    out.println("</table>");

                    // Pagination controls
                    if (coveredNutrients.size() < importantNutrients.size()) {
                        out.println("<a href=\"?offset=" + (loadMoreOffset + loadLimit) + "\" class=\"btn\">Load More</a>");
                    }
                } catch (SQLException e) {
                    out.println("<div class=\"message\">Error: " + e.getMessage() + "</div>");
                }
            %>
        </div>
    </div>

</body>
</html>
