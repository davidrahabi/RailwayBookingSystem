<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
	HttpSession sesh = request.getSession(false);
	if(sesh == null || sesh.getAttribute("username") == null || !sesh.getAttribute("usertype").equals("Admin")){
		sesh.invalidate();
		response.sendRedirect("Start.jsp");
	}
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Main Screen</title>
	</head>
	
	<body>

Logout?
	<br>
		<form method="post" action="logout.jsp">
			<input type="submit" value="Logout">
		</form>
	<br>
	
Manage Customer Representatives
	<br>
		<form method="post" action="admin_manage_reps.jsp">
			<table>
				<tr>    
				<td>SSN (Required)</td><td><input type="text" name="adminRepModSSN"></td>
				</tr>
				<tr>
				<td>Username</td><td><input type="text" name="adminRepModUsername"></td>
				</tr>
				<tr>
				<td>Password</td><td><input type="text" name="adminRepModPassword"></td>
				</tr>
				<tr>
				<td>Last Name</td><td><input type="text" name="adminRepModLname"></td>
				</tr>
				<tr>
				<td>First Name</td><td><input type="text" name="adminRepModFname"></td>
				</tr>
			</table>
			<select name="adminOperation" size=1>
				<option value="add">Add New Customer Representative</option>
				<option value="edit">Edit Existing Customer Representative</option>
				<option value="delete">Delete Existing Customer Representative</option>
			</select>&nbsp;<br>
		<input type="submit" value="Modify">
		</form>
	<br>

Reservations
	<br>
		<form method="post" action="admin_reservation_overview.jsp">
			<table>
				<tr>    
				<td>Search Term (Required)</td><td><input type="text" name="adminListForReservations"></td>
				</tr>
			</table>
			<select name="adminSearchForReservations" size=1>
				<option value="customer">Search For Customer</option>
				<option value="train">Search For Train Line</option>
			</select>&nbsp;<br>
		<input type="submit" value="Search">
		</form>
	<br>


Revenue
	<br>
		<form method="post" action="admin_revenue_overview.jsp">
			<table>
				<tr>    
				<td>Search Term (Required)</td><td><input type="text" name="adminListForRevenue"></td>
				</tr>
			</table>
			<select name="adminSearchForRevenue" size=1>
				<option value="customer">Search For Customer</option>
				<option value="train">Search For Train Line</option>
			</select>&nbsp;<br>
		<input type="submit" value="Search">
		</form>
	<br>

</body>
</html>