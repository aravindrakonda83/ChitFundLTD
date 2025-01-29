<%@ page import="java.sql.*" %>
<%
    String groupId = request.getParameter("groupId");
    if (groupId == null || groupId.isEmpty()) {
        out.println("<h3>No group selected!</h3>");
        return;
    }

    // Database Connection
    String url = "jdbc:mysql://localhost:3306/login_db";
    String user = "root";
    String pass = "aravind";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(url, user, pass);
        String query = "SELECT * FROM members WHERE group_id=?";
        PreparedStatement ps = con.prepareStatement(query);
        ps.setString(1, groupId);
        ResultSet rs = ps.executeQuery();
%>

<h2>Members in Group <%= groupId %></h2>
<table border="1">
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Phone</th>
    </tr>

<%
        while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("name") %></td>
        <td><%= rs.getString("email") %></td>
        <td><%= rs.getString("phone") %></td>
    </tr>
<%
        }
        con.close();
    } catch (Exception e) {
        out.println("Database Error: " + e.getMessage());
    }
%>
</table>
