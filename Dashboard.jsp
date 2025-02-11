<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Entry</title>
</head>
<body>

    <h2>Food Entry Results</h2>
    
    <h3>Nutrients Consumed:</h3>
    <ul>
        <%
            Set<String> consumedNutrients = (Set<String>) request.getAttribute("consumedNutrients");
            if (consumedNutrients != null) {
                for (String nutrient : consumedNutrients) {
                    out.println("<li>" + nutrient + "</li>");
                }
            } else {
                out.println("<p>No nutrients recorded.</p>");
            }
        %>
    </ul>

    <h3>Nutrients Missing and Suggested Foods:</h3>
    <%
        Map<String, List<String>> missingNutrients = (Map<String, List<String>>) request.getAttribute("missingNutrients");
        if (missingNutrients != null && !missingNutrients.isEmpty()) {
            for (Map.Entry<String, List<String>> entry : missingNutrients.entrySet()) {
                out.println("<h4>" + entry.getKey() + ":</h4>");
                out.println("<ul>");
                for (String food : entry.getValue()) {
                    out.println("<li>" + food + "</li>");
                }
                out.println("</ul>");
            }
        } else {
            out.println("<p>All required nutrients are covered.</p>");
        }
    %>

    <a href="diet.html">Back to Diet Plan</a>

</body>
</html>
