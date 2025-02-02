package com.chitFund;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
@WebServlet("/CreateGroupServlet")
public class CreateGroupServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String groupName = request.getParameter("groupName");
        double groupAmount = Double.parseDouble(request.getParameter("groupAmount"));
        String startMonth = request.getParameter("startMonth");
        String endMonth = request.getParameter("endMonth");
        String description = request.getParameter("description");
        int createdBy = 1; // Assuming the creator is user with ID 1 for now (this should come from session or user context)

        // Save the group data to the database
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            // Establishing database connection
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/login_db", "root", "aravind");

            // SQL query to insert a new group
            String query = "INSERT INTO groupss (group_name, amount, start_month, end_month, description, created_by) VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, groupName);
            stmt.setDouble(2, groupAmount);
            stmt.setString(3, startMonth);
            stmt.setString(4, endMonth);
            stmt.setString(5, description);
            stmt.setInt(6, createdBy);

            int rowsAffected = stmt.executeUpdate();

            // If the insertion is successful, redirect to the group details page
            if (rowsAffected > 0) {
                response.sendRedirect("groupDetails.jsp");
            } else {
                // If something goes wrong, show an error message
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create group");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        } finally {
            // Clean up resources
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
