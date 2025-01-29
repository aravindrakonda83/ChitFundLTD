package com.chitFund;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/CreateGroupServlet")
public class CreateGroupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection details
    private static final String DB_URL = "jdbc:mysql://localhost:3306/login_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "aravind";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String groupName = request.getParameter("groupName");
        String groupAmount = request.getParameter("groupAmount");

        // Validate input
        if (groupName == null || groupName.trim().isEmpty() || groupAmount == null || groupAmount.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Group Name and Amount are required.");
            return;
        }

        // Connect to the database and insert group data
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "INSERT INTO groupss (group_name, amount) VALUES (?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, groupName);
            stmt.setBigDecimal(2, new java.math.BigDecimal(groupAmount));

            int result = stmt.executeUpdate();
            if (result > 0) {
                response.sendRedirect("dashboard.jsp?message=Group created successfully.");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while creating the group.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
}
