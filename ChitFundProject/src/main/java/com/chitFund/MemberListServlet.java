package com.chitFund;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/MemberListServlet")
public class MemberListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/login_db"; 
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "aravind";  

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String groupId = request.getParameter("groupId"); // Get the selected groupId from the request

        JSONArray membersArray = new JSONArray();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT member_id, name FROM members WHERE group_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(groupId)); // Bind the groupId parameter

            rs = stmt.executeQuery();

            while (rs.next()) {
                JSONObject memberObject = new JSONObject();
                memberObject.put("member_id", rs.getInt("member_id"));
                memberObject.put("name", rs.getString("name"));
                membersArray.put(memberObject);
            }

            response.getWriter().write(membersArray.toString());
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
