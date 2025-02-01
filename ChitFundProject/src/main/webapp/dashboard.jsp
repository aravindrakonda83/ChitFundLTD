<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChitFund Management Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #ffffff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
        }
        .menu-bar {
            background-color: #4f5d52;
            padding: 20px;
            width: 200px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            display: flex;
            flex-direction: column;
            align-items: left;
        }
        .menu-bar a {
            color: white;
            margin: 15px 0;
            text-decoration: none;
            font-size: 18px;
            font-weight: bold;
            display: block;
        }
        .menu-bar a:hover {
            text-decoration: underline;
        }
        .container {
            margin-left: 220px;
            margin-top: 30px;
            flex-grow: 1;
        }
        h1, h2 {
            color: #333;
        }
        .btn-custom {
            background-color: #007bff;
            color: white;
        }
        .btn-custom:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <!-- Menu Bar -->
    <div class="menu-bar">
        <a href="createGroup.html">Create Chit Group</a>
        <a href="registerMember.html">Register Member</a>
        <a href="auctionMenu.jsp">Auction Menu</a>
        <a href="groupDetails.jsp">Available Chit Plans</a>
        <a href="onGoingChitPlans.html">On Going Chit Plans</a>
        <a href="whyUs.html">Why Us?</a>
        <a href="contactUs.html">Contact Us</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <!-- Welcome Message -->
    <div class="container">
        <h1>Welcome, Admin.!</h1>

        <!-- Select Group to View Members -->
        <div class="form-group">
            <label for="groupSelect"><strong>Select Group:</strong></label>
            <select id="groupSelect" class="form-control">
                <option value="">-- Select Group --</option>
                <%
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    try {
                        // Establish DB connection
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/login_db", "root", "aravind");

                        // Query to fetch groups
                        String sql = "SELECT group_id, group_name FROM groupss";
                        stmt = conn.prepareStatement(sql);
                        rs = stmt.executeQuery();

                        while (rs.next()) {
                            int groupId = rs.getInt("group_id");
                            String groupName = rs.getString("group_name");
                %>
                            <option value="<%= groupId %>"><%= groupName %></option>
                <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </select>
        </div>

        <!-- View Members Button -->
        <button class="btn btn-success" onclick="viewMembers()">View All Members</button>

        <!-- Navigation Buttons -->
        <div class="d-flex justify-content-end mt-3">
            <a href="login.html" class="btn btn-primary">Go to Home</a>
            <a href="logout.jsp" class="btn btn-danger">Logout</a>
        </div>
    </div>

    <script>
        function viewMembers() {
            var selectedGroup = document.getElementById("groupSelect").value;
            if (selectedGroup === "") {
                alert("Please select a group to view members.");
                return;
            }
            window.location.href = "viewMembers.jsp?groupId=" + selectedGroup;
        }
    </script>
</body>
</html>
