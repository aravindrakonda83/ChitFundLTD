<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.Month" %>
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
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            max-width: 1200px;
            margin: auto;
        }

        .card {
            background-color: #007f3f;
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

        .card .phone-numbers {
            margin: 10px 0;
        }

        .card .details {
            margin-top: auto;
        }

        .card .details p {
            margin: 3px 0;
        }

        .btn-secondary {
            background-color: #6c757d;
            color: white;
            padding: 10px;
            text-align: center;
            border-radius: 5px;
            width: 100%;
            margin-top: 20px;
            text-decoration: none;
        }
    </style>
</head>
<body>

	<div>
		<h1 class="">Group Details</h1>
    <div class="container">
        
        <%
            // Fetch the group details from the database
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                // Establishing database connection
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/login_db", "root", "aravind");

                // SQL query to get all groups
                String query = "SELECT * FROM groupss";
                stmt = conn.createStatement();
                rs = stmt.executeQuery(query);

                while (rs.next()) {
                    String groupName = rs.getString("group_name");
                    double amount = rs.getDouble("amount");
                    String startMonth = rs.getString("start_month");
                    String endMonth = rs.getString("end_month");
                    String description = rs.getString("description");

                    // Calculate duration
                    // Example: startMonth = "2025-01", endMonth = "2025-12"
                    String[] startParts = startMonth.split("-");
                    String[] endParts = endMonth.split("-");

                    int startYear = Integer.parseInt(startParts[0]);
                    int startMonthValue = Integer.parseInt(startParts[1]);

                    int endYear = Integer.parseInt(endParts[0]);
                    int endMonthValue = Integer.parseInt(endParts[1]);

                    // Create LocalDate instances for start and end month
                    LocalDate startDate = LocalDate.of(startYear, startMonthValue, 1);
                    LocalDate endDate = LocalDate.of(endYear, endMonthValue, 1);

                    // Calculate the difference in months
                    long durationInMonths = ChronoUnit.MONTHS.between(startDate, endDate);
        %>
        <div class="card">
            <h2>Amount: <%= amount %></h2>
            <p>Location: <%= rs.getString("group_name") %>, TELANGANA</p>
            <div class="phone-numbers">
                <p>Contact: 8367630193</p>
                
            </div>
            <p><span> <%= amount %></span> per Month</p>
            <div class="details">
                <p>Chit Group: <%= rs.getString("group_name") %></p>
                <p>Duration: <%= durationInMonths %> months</p>
                <p>Starting from: <%= startMonth %></p>
                <p>End at: <%= endMonth %></p>
                <p>Description: <%= description != null ? description : "No description" %></p>
            </div>
        </div>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                // Clean up resources
                try {
                    if (rs != null) rs.close();
                    if (stmt != null) stmt.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
        <a href="dashboard.jsp" class="btn-secondary">Back to Home</a>
    </div>
    </div>
</body>
</html>
