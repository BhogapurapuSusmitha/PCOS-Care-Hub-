import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;

public class FoodEntryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String foodInput = request.getParameter("foodInput"); // Capture form data directly

        String[] foodItems = foodInput.split(","); // Split the input by comma for multiple food items

        try (Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@//localhost:1521/yourdb", "username", "password")) {
            Set<String> consumedNutrients = getConsumedNutrients(conn, foodItems);
            Map<String, List<String>> missingNutrients = getMissingNutrientsWithSuggestions(conn, consumedNutrients);

            request.setAttribute("consumedNutrients", consumedNutrients);
            request.setAttribute("missingNutrients", missingNutrients);

            // Forward to JSP for displaying the nutrients data
            request.getRequestDispatcher("/food-entry.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Set<String> getConsumedNutrients(Connection conn, String[] foodItems) throws SQLException {
        Set<String> consumedNutrients = new HashSet<>();
        String query = "SELECT nutrient FROM food_nutrients WHERE food_name = ?";
        PreparedStatement stmt = conn.prepareStatement(query);

        for (String food : foodItems) {
            stmt.setString(1, food.trim());
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                consumedNutrients.add(rs.getString("nutrient"));
            }
        }
        return consumedNutrients;
    }

    private Map<String, List<String>> getMissingNutrientsWithSuggestions(Connection conn, Set<String> consumedNutrients) throws SQLException {
        Map<String, List<String>> missingNutrients = new HashMap<>();
        List<String> requiredNutrients = Arrays.asList("Omega-3", "Vitamin D", "Vitamin B6", "Vitamin B12", "Zinc");

        for (String nutrient : requiredNutrients) {
            if (!consumedNutrients.contains(nutrient)) {
                List<String> suggestions = getFoodSuggestions(conn, nutrient);
                missingNutrients.put(nutrient, suggestions);
            }
        }
        return missingNutrients;
    }

    private List<String> getFoodSuggestions(Connection conn, String nutrient) throws SQLException {
        List<String> suggestions = new ArrayList<>();
        String query = "SELECT food_name FROM food_nutrients WHERE nutrient = ?";
        PreparedStatement stmt = conn.prepareStatement(query);
        stmt.setString(1, nutrient);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            suggestions.add(rs.getString("food_name"));
        }
        return suggestions;
    }
}
