<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Login Screen</title>
	</head>
	
	<body>

Enter login credentials:
	<br>
		<form method="post" action="login.jsp">
			<table>
				<tr>    
					<td>Email/SSN</td><td><input type="text" name="emailSSN">
				</tr>
				<tr>    
					<td>Username</td><td><input type="text" name="username">
				</tr>
				<tr>
					<td>Password</td><td><input type="password" name="password">
				</tr>
			</table>
			<input type="submit" value="Login">
		</form>
	<br>
	
Register customer credentials:
<a href="register.jsp">
    <button>Register</button>
</a>
	

</body>
</html>