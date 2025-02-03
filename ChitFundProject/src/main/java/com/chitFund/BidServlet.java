package com.chitFund;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/BidServlet")
public class BidServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        JSONObject jsonResponse = new JSONObject();

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/login_db", "root", "aravind")) {
            String sql = "SELECT auction_id, auction_name FROM auctions";  // Modify this query based on your database schema
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            JSONArray auctions = new JSONArray();
            while (rs.next()) {
                JSONObject auction = new JSONObject();
                auction.put("id", rs.getInt("auction_id"));
                auction.put("name", rs.getString("auction_name"));
                auctions.put(auction);
            }

            if (auctions.length() > 0) {
                jsonResponse.put("auctions", auctions);
            } else {
                jsonResponse.put("auctions", new JSONArray());  // Return an empty array if no auctions
            }
        } catch (Exception e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", e.getMessage());
        }

        response.getWriter().write(jsonResponse.toString());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        JSONObject jsonResponse = new JSONObject();

        String auctionId = request.getParameter("auctionId");
        String memberId = request.getParameter("memberId");
        String bidAmount = request.getParameter("bidAmount");

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/login_db", "root", "aravind")) {
            String sql = "INSERT INTO bids (auction_id, member_id, bid_amount) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(auctionId));
            stmt.setInt(2, Integer.parseInt(memberId));
            stmt.setDouble(3, Double.parseDouble(bidAmount));

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                jsonResponse.put("status", "success");
            } else {
                jsonResponse.put("status", "error");
            }
        } catch (Exception e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", e.getMessage());
        }

        response.getWriter().write(jsonResponse.toString());
    }
}
