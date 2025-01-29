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

@WebServlet("/MemberRegistrationServlet")
public class MemberRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/login_db"; // Update with your DB name
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "aravind";  // Update with your DB password

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String groupId = request.getParameter("groupId");
        String name = request.getParameter("name");
        String id = request.getParameter("id");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (groupId == null || name == null || id == null || email == null || phone == null ||
            groupId.isEmpty() || name.isEmpty() || id.isEmpty() || email.isEmpty() || phone.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "All fields are required.");
            return;
        }

        // Database connection and data insertion
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "INSERT INTO members (group_id, name, member_id, email, phone) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, groupId);
            stmt.setString(2, name);
            stmt.setString(3, id);
            stmt.setString(4, email);
            stmt.setString(5, phone);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("success.html");  // Redirect to success page
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database insertion failed.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
}
