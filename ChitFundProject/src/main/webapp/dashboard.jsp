<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ChitFund Management Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            background: url('https://cdn.pixabay.com/photo/2018/03/21/16/18/investment-3247252_640.jpg') no-repeat center center fixed;
            background-size: cover;
            font-family: 'Roboto', sans-serif;
            color: #ffffff;
            margin: 0;
            padding: 0;
            display: flex;
            height: 100vh;
        }

        /* Top Banner */
        .top-banner {
            background-color: rgba(0, 0, 0, 0.8);
            width: 100%;
            text-align: center;
            padding: 15px 0;
            font-size: 28px;
            font-weight: bold;
            color: #FFD700;
            box-shadow: 0px 5px 10px rgba(0, 0, 0, 0.3);
            text-transform: uppercase;
            letter-spacing: 2px;
            position: fixed;
            top: 0;
            left: 0;
        }

        /* Sidebar Navigation */
        .menu-bar {
            background-color: rgba(0, 0, 0, 0.8);
            padding: 20px;
            width: 250px;
            height: 100vh;
            position: fixed;
            top: 60px; /* Below the banner */
            left: 0;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
        }

        .menu-bar a {
            color: #ffffff;
            margin: 15px 0;
            text-decoration: none;
            font-size: 18px;
            font-weight: bold;
            transition: color 0.3s, transform 0.3s;
        }

        .menu-bar a:hover {
            color: #FFD700;
            text-decoration: underline;
            transform: scale(1.1);
        }

        /* Main Content */
        .container {
            width: 60%;
            margin-left: 300px;
            margin-top: 150px;
            background: rgba(0, 0, 0, 0.6);
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.3);
            text-align: center;
        }

        h2 {
            color: #FFD700;
            font-weight: 700;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.7);
        }

        /* Select Group Section */
        .select-box {
            width: 400px;
            padding: 20px;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 15px;
            text-align: center;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.3);
            margin: auto;
        }

        .select-box label {
            color: #000;
            font-size: 20px;
            font-weight: bold;
            display: block;
            margin-bottom: 10px;
        }

        .select-box select {
            width: 100%;
            padding: 12px;
            font-size: 18px;
            border-radius: 10px;
            border: 2px solid #FFD700;
            background-color: #ffffff;
            color: #000;
            font-weight: bold;
        }

        .btn-success {
            background-color: #28a745;
            padding: 12px;
            border-radius: 10px;
            font-size: 18px;
            width: 100%;
            margin-top: 15px;
            font-weight: bold;
            transition: background-color 0.3s ease, transform 0.3s;
        }

        .btn-success:hover {
            background-color: #218838;
            transform: scale(1.05);
        }

        /* Navigation Buttons */
        .btn-primary, .btn-danger {
            margin-top: 15px;
            padding: 10px 20px;
            border-radius: 10px;
            font-weight: bold;
            transition: transform 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #0056b3;
            transform: scale(1.05);
        }

        .btn-danger:hover {
            background-color: #dc3545;
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <!-- Top Banner -->
    <div class="top-banner">
        Premier ChitFund Management System
    </div>

    <!-- Sidebar Menu -->
    <div class="menu-bar">
        <a href="createGroup.html">Create Chit Group</a>
        <a href="registerMember.html">Register Member</a>
        <a href="auction.html">Auction Menu</a>
        <a href="groupDetails.jsp">Available Chit Plans</a>
        <a href="onGoingChitPlans.html">On Going Chit Plans</a>
        <a href="whyUs.html">Why Us?</a>
        <a href="contactUs.html">Contact Us</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <!-- Main Content -->
    <div class="container">
        <h2>Select a Chit Group</h2>

        <div class="select-box">
            <label for="groupSelect">Select Group:</label>
            <select id="groupSelect" class="form-control">
                <option value="">-- Select Group --</option>
                <%
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/login_db", "root", "aravind");

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
                        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                %>
            </select>

            <button class="btn btn-success" onclick="viewMembers()">View All Members</button>
        </div>

        <div class="d-flex justify-content-center mt-3">
            <a href="login.html" class="btn btn-primary">Go to Home</a>
            <a href="logut.jsp" class="btn btn-danger">Logout</a>
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