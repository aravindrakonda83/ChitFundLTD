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

@WebServlet("/AuctionServlet")
public class AuctionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String DB_URL = "jdbc:mysql://localhost:3306/login_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "aravind";

    // General method to fetch groups, members, or auctions
    private JSONArray fetchData(Connection conn, String action, String groupId) throws SQLException {
        JSONArray jsonArray = new JSONArray();
        String query = null;

        if ("getGroups".equals(action)) {
            query = "SELECT group_id, group_name FROM groupss";
        } else if ("getMembers".equals(action)) {
            query = "SELECT member_id, name FROM members WHERE group_id = ?";
        } else if ("getAuctions".equals(action)) {
            query = "SELECT auction_id, auction_name FROM auctions";
        }

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            if ("getMembers".equals(action)) {
                stmt.setInt(1, Integer.parseInt(groupId));
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    JSONObject obj = new JSONObject();
                    if ("getGroups".equals(action) || "getAuctions".equals(action)) {
                        obj.put("id", rs.getInt("group_id"));
                        obj.put("name", rs.getString("group_name"));
                    } else if ("getMembers".equals(action)) {
                        obj.put("memberId", rs.getInt("member_id"));
                        obj.put("name", rs.getString("name"));
                    }
                    jsonArray.put(obj);
                }
            }
        }

        return jsonArray;
    }

    // GET method to handle fetching groups, members, or auctions based on the request
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String groupId = request.getParameter("groupId");

        JSONArray jsonArray = new JSONArray();
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            jsonArray = fetchData(conn, action, groupId);
            response.getWriter().write(jsonArray.toString());
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        }
    }

    // POST method to create a new auction
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        JSONObject jsonResponse = new JSONObject();

        String groupId = request.getParameter("groupId");
        String month = request.getParameter("month");
        String auctionAmount = request.getParameter("auctionAmount");
        String memberId = request.getParameter("memberId");

        // Validate input
        if (groupId == null || month == null || auctionAmount == null || memberId == null ||
            groupId.isEmpty() || month.isEmpty() || auctionAmount.isEmpty() || memberId.isEmpty()) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "All fields are required.");
            response.getWriter().write(jsonResponse.toString());
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            // Insert auction details into the auctions table
            String query = "INSERT INTO auctions (group_id, month, auction_amount, member_id) VALUES (?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setInt(1, Integer.parseInt(groupId));
                stmt.setInt(2, Integer.parseInt(month));
                stmt.setBigDecimal(3, new java.math.BigDecimal(auctionAmount));
                stmt.setInt(4, Integer.parseInt(memberId));

                int rowsAffected = stmt.executeUpdate();
                if (rowsAffected > 0) {
                    jsonResponse.put("status", "success");
                    jsonResponse.put("message", "Auction created successfully!");
                } else {
                    jsonResponse.put("status", "error");
                    jsonResponse.put("message", "Failed to create auction. Please try again.");
                }
            }
        } catch (SQLException e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Database error: " + e.getMessage());
        }

        // Return the JSON response
        response.getWriter().write(jsonResponse.toString());
    }
}
