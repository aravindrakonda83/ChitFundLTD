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

        JSONArray membersArray = new JSONArray();

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement("SELECT member_id, name FROM members")) {
            
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                JSONObject memberObject = new JSONObject();
                memberObject.put("member_id", rs.getInt("member_id"));
                memberObject.put("name", rs.getString("name"));
                membersArray.put(memberObject);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.getWriter().write(membersArray.toString());
    }
}