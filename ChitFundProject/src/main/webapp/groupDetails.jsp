<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.time.LocalDate, java.time.temporal.ChronoUnit" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Navigation & Group Details</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
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
            z-index: 1000;
        }

        /* Sidebar Navigation */
        .menu-bar {
            background-color: rgba(0, 0, 0, 0.8);
            width: 250px;
            height: 100vh;
            position: fixed;
            top: 60px;
            left: 0;
            display: flex;
            flex-direction: column;
            padding: 20px;
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

        .container {
            margin-left: 270px;
            margin-top: 100px; /* space for top banner */
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            max-width: 1200px;
            width: 100%;
        }

        .card {
            background-color: #42636a;
            color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 20px;
            display: flex;
            flex-direction: column;
        }

        .card h2 {
            margin: 0;
            font-size: 1.8rem;
        }

        .card p {
            margin: 5px 0;
            line-height: 1.5;
        }

        .card span {
            font-weight: bold;
        }

        .details {
            margin-top: auto;
        }

        .btn-secondary {
            display: block;
            background-color: #6c757d;
            color: white;
            padding: 10px;
            text-align: center;
            border-radius: 5px;
            width: 200px;
            margin: 30px auto 0;
            text-decoration: none;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
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
        <a href="createGroup.jsp">Create Chit Group</a>
        <a href="registerMember.jsp">Register Member</a>
        <a href="auction.jsp">Auction Menu</a>
        <a href="groupDetails.jsp">Available Chit Plans</a>
        <a href="onGoingChitPlans.jsp">On Going Chit Plans</a>
        <a href="whyUs.jsp">Why Us?</a>
        <a href="contactUs.jsp">Contact Us</a>
        <a href="logout.jsp">Logout</a>
    </div>

    <!-- Group Details Section -->
    <div class="container">
        

        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                // Establishing connection to the database
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/login_db", "root", "aravind");

                // Query to fetch group details
                String query = "SELECT * FROM groupss";
                stmt = conn.createStatement();
                rs = stmt.executeQuery(query);

                while (rs.next()) {
                    String groupName = rs.getString("group_name");
                    double amount = rs.getDouble("amount");
                    String startMonth = rs.getString("start_month");
                    String endMonth = rs.getString("end_month");
                    String description = rs.getString("description") != null ? rs.getString("description") : "No description available";

                    // Calculate duration between start and end dates
                    String[] startParts = startMonth.split("-");
                    String[] endParts = endMonth.split("-");

                    LocalDate startDate = LocalDate.of(Integer.parseInt(startParts[0]), Integer.parseInt(startParts[1]), 1);
                    LocalDate endDate = LocalDate.of(Integer.parseInt(endParts[0]), Integer.parseInt(endParts[1]), 1);
                    long durationInMonths = ChronoUnit.MONTHS.between(startDate, endDate);
        %>
        <!-- Group Details Heading -->
        <div class="card">
            <h2>Amount: <%= amount %></h2>
            <p>Location: <%= groupName %>, TELANGANA</p>
            <p><span><%= amount %></span> per Month</p>
            <div class="details">
                <p>Chit Group: <%= groupName %></p>
                <p>Duration: <%= durationInMonths %> months</p>
                <p>Starting from: <%= startMonth %></p>
                <p>End at: <%= endMonth %></p>
                <p>Description: <%= description %></p>
            </div>
        </div>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </div>

    <!-- Back to Home Button -->
    <a href="dashboard.jsp" class="btn-secondary">Back to Home</a>

</body>
</html>
