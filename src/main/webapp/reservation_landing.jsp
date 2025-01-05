<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

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
<title>Reservations</title>
<style>
	table {
		width: 100%;
		border-collapse: collapse;
	}
	th, td {
		padding: 10px;
		border: 1px solid #dddddd;
		width: auto;
	}
	tr:hover {
		background-color: #f1f1f1;
	}
</style>
</head>
<body>
	<h1>Customer Reservations </h1>
	<form method ="get">
		<label>Filter by Transit Line and Date:</label>
		<input type ="text" id ="line" name ="line" placeholder="Line Name">
		<input type ="text" id ="date" name ="date" placeholder="YYYY-MM-DD">
		<input type ="submit" value= "Confirm">
	</form>
	<table>
		<thead>
			<tr>
			    <th>Reservation ID</th>
				<th>Email</th>
				<th>First Name</th>
                <th>Last Name</th>
                <th>Line Name</th>
                <th>Date</th>
            </tr>
        </thead>
		<tbody>
			<%
				String line = request.getParameter("line");
				String date = request.getParameter("date");

				try {
					ApplicationDB db = new ApplicationDB();
					Connection con = db.getConnection();
					PreparedStatement pstmt;
					ResultSet result;
						
					String sql = "SELECT * FROM list_customers";
					Statement stmt = con.createStatement();
					
					if ((line != null && !line.trim().isEmpty()) && ((date != null && !date.trim().isEmpty()))){
						String sqlF = "SELECT * FROM list_customers WHERE line_name = ? AND date_res = ?";
						pstmt = con.prepareStatement(sqlF);
						pstmt.setString(1, line);
						pstmt.setString(2, date);
						result = pstmt.executeQuery();
					}else {
						result = stmt.executeQuery(sql);
					}
										
					int row = 0;
					while(result.next()){
						int resID = result.getInt("reservation_number");
						String email = result.getString("email");
						String fname = result.getString("fname");
						String lname = result.getString("lname");
						String lineN = result.getString("line_name");
						Timestamp tDate = result.getTimestamp("departure_time");
						row++;
			%>	
						<tr id="row<%= row %>">
							<td><%= resID %></td>
							<td><%= email %></td>
							<td><%= fname %></td>
							<td><%= lname %></td>
							<td><%= lineN %></td>
							<td><%= tDate %></td>
						</tr>							
			<%
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			%>
		</tbody>			
	</table>
	Logout?
	<br>
		<form method="post" action="logout.jsp">
			<input type="submit" value="Logout">
		</form>
	<br>
	
	<br>
		<form method="post" action="rep_landing.jsp">
			<input type="submit" value="Return to Main Screen">
		</form>
	<br>
	
</body>
</html>