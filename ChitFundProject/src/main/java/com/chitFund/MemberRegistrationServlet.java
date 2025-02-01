package com.chitFund;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
        String age = request.getParameter("age");
        String gender = request.getParameter("gender");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String occupation = request.getParameter("occupation");
        String address = request.getParameter("address");

        if (groupId == null || name == null || id == null || age == null || gender == null || 
            email == null || phone == null || occupation == null || address == null ||
            groupId.isEmpty() || name.isEmpty() || id.isEmpty() || age.isEmpty() || gender.isEmpty() ||
            email.isEmpty() || phone.isEmpty() || occupation.isEmpty() || address.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "All fields are required.");
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement("INSERT INTO members (group_id, name, member_id, age, gender, email, phone, occupation, address) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)")) {
            
            stmt.setString(1, groupId);
            stmt.setString(2, name);
            stmt.setString(3, id);
            stmt.setInt(4, Integer.parseInt(age));
            stmt.setString(5, gender);
            stmt.setString(6, email);
            stmt.setString(7, phone);
            stmt.setString(8, occupation);
            stmt.setString(9, address);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                response.sendRedirect("success.html"); 
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database insertion failed.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error: " + e.getMessage());
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set the response type as JSON
        response.setContentType("application/json");
        
        // Fetch groups from the database
        List<Group> groups = getGroupsFromDatabase();

        // Convert the list of groups to JSON
        StringBuilder jsonResponse = new StringBuilder();
        jsonResponse.append("[");

        for (int i = 0; i < groups.size(); i++) {
            Group group = groups.get(i);
            jsonResponse.append("{");
            jsonResponse.append("\"groupId\": ").append(group.getGroupId()).append(", ");
            jsonResponse.append("\"groupName\": \"").append(group.getGroupName()).append("\"");
            jsonResponse.append("}");
            if (i < groups.size() - 1) {
                jsonResponse.append(", ");
            }
        }
        jsonResponse.append("]");

        // Write the JSON response
        response.getWriter().write(jsonResponse.toString());
    }

    private List<Group> getGroupsFromDatabase() {
        List<Group> groups = new ArrayList<>();
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "SELECT group_id, group_name FROM groupss";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int groupId = rs.getInt("group_id");
                String groupName = rs.getString("group_name");
                groups.add(new Group(groupId, groupName));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return groups;
    }

    // Group class to store group details
    public static class Group {
        private int groupId;
        private String groupName;

        public Group(int groupId, String groupName) {
            this.groupId = groupId;
            this.groupName = groupName;
        }

        public int getGroupId() {
            return groupId;
        }

        public String getGroupName() {
            return groupName;
        }
    }
}

