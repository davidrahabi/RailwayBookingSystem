<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Logout Process</title>
</head>
<body>
<%
    HttpSession sesh = request.getSession(false);
    if(sesh !=null ){
        sesh.invalidate();
    }
%>
Logging Out...
 <script>
    	setTimeout(function() {window.location.href = "Start.jsp";}, 1000);
</script>
</body>
</html>