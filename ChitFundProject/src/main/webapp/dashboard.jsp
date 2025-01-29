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
            background-color: #f0f8ff;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .navbar {
            margin-bottom: 30px;
            background-color: #4CAF50;
        }
        .navbar a {
            color: white !important;
        }
        .container {
            margin-top: 30px;
        }
        h1, h2 {
            color: #333;
        }
        .table th, .table td {
            text-align: center;
        }
        .card-header {
            background-color: #6c757d;
            color: white;
        }
        .table-striped tbody tr:nth-child(odd) {
            background-color: #f8f9fa;
        }
        .btn-custom {
            background-color: #007bff;
            color: white;
        }
        .btn-custom:hover {
            background-color: #0056b3;
        }
        .navbar-toggler-icon {
            background-color: #ffffff;
        }
        .tooltip-inner {
            background-color: #6c757d;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <a class="navbar-brand" href="#">Members Management</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ml-auto">
                <li class="nav-item">
                    <a class="nav-link" href="createGroup.html" data-toggle="tooltip" data-placement="bottom" title="Go to Home Page">Create Group</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="registerMember.html" data-toggle="tooltip" data-placement="bottom" title="Register a Member">Register Member</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="logout.jsp" data-toggle="tooltip" data-placement="bottom" title="Logout from your session">Logout</a>
                </li>
            </ul>
        </div>
    </nav>

    <!-- Welcome Message -->
    <div class="container">
        <h1>Welcome, ${sessionScope.name}!</h1>

        <!-- Select Group to View Members -->
        <div class="form-group">
            <label for="groupSelect"><strong>Select Group:</strong></label>
            <select id="groupSelect" class="form-control">
                <option value="">-- Select Group --</option>
                <option value="1">Group 1</option>
                <option value="2">Group 2</option>
                <!-- Add more groups as needed -->
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

    <!-- Bootstrap JS and dependencies -->
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

</body>
</html>
