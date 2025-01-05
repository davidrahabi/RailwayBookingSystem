<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
	HttpSession sesh = request.getSession(false);
	if(sesh == null || sesh.getAttribute("username") == null){
	    response.sendRedirect("Start.jsp");
	}
%>

<%-- 
List of Things to do and stuff:
- This is the page you will come to after logging in as customer rep
- From here we should be given some options.
	a) Edit button for train schedules (in case we want to edit/delete info)
	b) Search button for train schedules (initially pressing will just pull up the entire view)
		1) from here have a empty field for filter button by: (station written in answer field) 
			where they can type in the station to filter train schedules by
			
		*you could combine all of this into one view: like a Train Schedules button that brings you to
		all the schedules, then from there, theres a filter button and then also an edit button that lets you do a)
		this is ideal and more clean but idk how hard*
		
		Or this could be for the functionality of forum, as in to respond with these values
		
	c) Forum button to take us to forum page
	d) Reservations button to take you to a page where you initially see all reservations.
		1) from here there should be a filter field where you can filter by a specific transit line and date,
			then it will show all customers who have res for this line/date
 --%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Customer Rep</title>
<style>
	body {
			display: flex;
			justify-content:center;
			align-items:center;
			height:100vh;
			margin:0;
			background-color: #f0f0f0;
		}
		
		.button-container {
			text-align:center;
		}
		
		.button{
			dispaly:block;
			margin:20px auto;
			width:200px;
			height:100px;
			font-size:20px;
			background-color: #42cef5;
			color:white;
			border:none;
			border-radius:10px;
			cursor:pointer;
		}
		
		.button:hover{
			background-color: #71d8f5;
		}
</style>
</head>
<body>
	<div class="button-container">
		<button class="button" onclick="redirectToPage('schedule_landing.jsp')">Train Schedule</button>
		<button class="button" onclick="redirectToPage('forum_rep.jsp')">Customer Forum</button>
		<button class="button" onclick="redirectToPage('reservation_landing.jsp')">View Reservations</button>
		</div>
		
		<script>
			function redirectToPage(page){
				setTimeout(function() {
					window.location.href = page;
				}, 100);
			}
		</script>
		
		Logout?
	<br>
		<form method="post" action="logout.jsp">
			<input type="submit" value="Logout">
		</form>
	<br>
	
</body>
</html>