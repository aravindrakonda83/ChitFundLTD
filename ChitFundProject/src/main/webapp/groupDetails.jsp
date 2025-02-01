<%@ page import="java.sql.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.temporal.ChronoUnit" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Group Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        .container {
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

    <h1>Group Details</h1>
    
    <div class="container">
        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/login_db", "root", "aravind");
                String query = "SELECT * FROM groupss";
                stmt = conn.createStatement();
                rs = stmt.executeQuery(query);

                while (rs.next()) {
                    String groupName = rs.getString("group_name");
                    double amount = rs.getDouble("amount");
                    String startMonth = rs.getString("start_month");
                    String endMonth = rs.getString("end_month");
                    String description = rs.getString("description") != null ? rs.getString("description") : "No description available";

                    // Calculate duration
                    String[] startParts = startMonth.split("-");
                    String[] endParts = endMonth.split("-");

                    LocalDate startDate = LocalDate.of(Integer.parseInt(startParts[0]), Integer.parseInt(startParts[1]), 1);
                    LocalDate endDate = LocalDate.of(Integer.parseInt(endParts[0]), Integer.parseInt(endParts[1]), 1);
                    long durationInMonths = ChronoUnit.MONTHS.between(startDate, endDate);
        %>
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
