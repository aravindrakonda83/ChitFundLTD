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

import org.json.JSONObject;

@WebServlet("/DeclareWinnerServlet")
public class DeclareWinnerServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        JSONObject jsonResponse = new JSONObject();

        String auctionId = request.getParameter("auctionId");

        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/login_db", "root", "aravind")) {
            // Find highest bid
            String getMaxBidSql = "SELECT member_id, bid_amount FROM bids WHERE auction_id = ? ORDER BY bid_amount DESC LIMIT 1";
            PreparedStatement maxBidStmt = conn.prepareStatement(getMaxBidSql);
            maxBidStmt.setInt(1, Integer.parseInt(auctionId));
            ResultSet rs = maxBidStmt.executeQuery();

            if (rs.next()) {
                int winnerId = rs.getInt("member_id");
                double winningBid = rs.getDouble("bid_amount");

                // Update auction winner
                String updateAuctionSql = "UPDATE auctions SET winner_id = ?, winning_bid = ?, status = 'Closed' WHERE auction_id = ?";
                PreparedStatement updateStmt = conn.prepareStatement(updateAuctionSql);
                updateStmt.setInt(1, winnerId);
                updateStmt.setDouble(2, winningBid);
                updateStmt.setInt(3, Integer.parseInt(auctionId));
                updateStmt.executeUpdate();

                jsonResponse.put("status", "success");
                jsonResponse.put("winnerId", winnerId);
                jsonResponse.put("winningBid", winningBid);
            } else {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "No bids found for this auction.");
            }
        } catch (Exception e) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", e.getMessage());
        }
        response.getWriter().write(jsonResponse.toString());
    }
}
