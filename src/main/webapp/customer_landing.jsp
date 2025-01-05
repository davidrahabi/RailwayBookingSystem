<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
HttpSession sesh = request.getSession(false);
if(sesh == null || sesh.getAttribute("username") == null){
    response.sendRedirect("Start.jsp");
}
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Main Screen</title>
</head>

Search for train schedules
<br>
<form method="post" action = searchTrain.jsp>
<table>
<tr>    
<td><label><input type="checkbox" name="searchCriteria" value="origin"> Search by Origin Station
</label></td><td><input type="text" name="origin" placeholder="Enter Origin Station"></td>
</tr>
<tr>    
<td><label><input type="checkbox" name="searchCriteria" value="destination"> Search by Destination Station
</label></td><td><input type="text" name="destination" placeholder="Enter Destination Station"></td>
</tr>
<tr>
<td><label><input type="checkbox" name="searchCriteria" value="time"> Search by Departure Time
</label></td><td><input type="text" name="time" placeholder="Enter Departure Time"></td>
</tr>
<tr>
<td>Sort By</td>
<td><select name="sortColumn">
		<option>None</option>
		<option value="departure_time">Departure Time</option>
		<option value="arrival_time">Arrival Time</option>
		<option value="fare">Fare</option>
		<option value="travel_time">Travel Time</option>
	</select>
	<select name="sortOrder">
		<option value="ASC">Ascending</option>
		<option value="DESC">Descending</option>
	</select>
</td>
</tr>
</table>
<input type="submit" value="searchTrain">

</form>

<body>
Make a New Reservation:
   <br>
       <form method="post" action="make_reservation.jsp">
           <input type="submit" value="Make New Reservation">
       </form>
   <br>
	
Reservations:
    <br>
        <form method="post" action="view_my_reservations.jsp">
            <input type="submit" value="Reservations">
        </form>
    <br>

Customer Service Forum:
	<br>
		<form method="post" action="forum_customer.jsp">
            <input type="submit" value="Customer Service Forum">
        </form>
	<br>
Logout?
<br>
<form method="post" action="logout.jsp">
<input type="submit" value="Logout">
</form>
<br>


</body>
</html>