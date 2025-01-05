<%@ page language="java" contentType="text/html; charset=ISO-8859-1" 
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Register Customer</title>
</head>
<body>
<%
    try {
        
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String minor = request.getParameter("minor");
        String senior = request.getParameter("senior");
        String disabled = request.getParameter("disabled");

        
        if (email == null || username == null || password == null || fname == null || lname == null ||
            minor == null || senior == null || disabled == null || 
            email.isEmpty() || username.isEmpty() || password.isEmpty() || 
            fname.isEmpty() || lname.isEmpty()) {
            throw new IllegalArgumentException("All fields are required.");
        }

        String sql = "INSERT INTO customers (email, username, password, lname, fname, is_child, is_senior, is_disabled) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement pstmt = con.prepareStatement(sql);

        pstmt.setString(1, email);
        pstmt.setString(2, username);
        pstmt.setString(3, password);
        pstmt.setString(4, lname);
        pstmt.setString(5, fname);
        pstmt.setBoolean(6, Boolean.parseBoolean(minor));
        pstmt.setBoolean(7, Boolean.parseBoolean(senior));
        pstmt.setBoolean(8, Boolean.parseBoolean(disabled));

        
        int rowsAffected = pstmt.executeUpdate();
        con.close();

        if (rowsAffected > 0) {
%>
            <p>Customer registration successful! Redirecting...</p>
            <script>
                setTimeout(function() {
                    window.location.href = "Start.jsp";
                }, 2000);
            </script>
<%
        } else {
            throw new SQLException("Failed to register the customer.");
        }
    } catch (Exception ex) {
        out.print("<p>Error: " + ex.getMessage() + "</p>");
        %>
        
        <script>
            setTimeout(function() {
                window.location.href = "register.jsp";
            }, 2000);
        </script>
		<%     
        ex.printStackTrace();
    }
%>
</body>
</html>
