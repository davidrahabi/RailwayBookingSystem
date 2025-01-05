<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Reservations</title>
</head>
<body>
<%
	HttpSession sesh = request.getSession(false);
	if(sesh == null || sesh.getAttribute("username") == null || !sesh.getAttribute("usertype").equals("Admin")){
		sesh.invalidate();
		response.sendRedirect("Start.jsp");
	}
%>

Logout?
	<br>
		<form method="post" action="logout.jsp">
			<input type="submit" value="Logout">
		</form>
	<br>
	
Return To Main Page?
	<br>
		<form method="post" action="admin_landing.jsp">
			<input type="submit" value="Return To Main">
		</form>
	<br>
	
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Get parameters from the HTML form at the admin_landing.jsp
		String searchTerm = request.getParameter("adminListForReservations");
		String searchFor = request.getParameter("adminSearchForReservations");
		
		
		if (searchTerm == null || searchTerm.equals("null") || searchTerm.isEmpty()){
			
%>
Did Not Provide A Search Term. Re-Enter A Search Term
	<script>
		setTimeout(function() {window.location.href = "admin_landing.jsp";}, 1000);
	</script>
<%
		}
		else{
			String sqlFiveLines = "SELECT * FROM five_lines ORDER BY total_reservations DESC LIMIT 5";
			Statement stmtFiveLines = con.createStatement();
			ResultSet resultFiveLines = stmtFiveLines.executeQuery(sqlFiveLines);
			
			out.println("5 Most Active Transit Lines");
			out.print("<table>");
			
			out.print("<tr>");
			out.print("<th>Line Name</th>");
			out.print("<th>Year</th>");
			out.print("<th>Month</th>");
			out.print("<th>Total Reservations</th>");
			out.print("</tr>");

			while (resultFiveLines.next()) {
			  out.print("<tr>");
			  out.print("<td>");
			  out.print(resultFiveLines.getString("line_name"));
			  out.print("</td>");
			  out.print("<td>");
			  out.print(resultFiveLines.getInt("year"));
			  out.print("</td>");
			  out.print("<td>");
			  out.print(resultFiveLines.getInt("month"));
			  out.print("</td>");
			  out.print("<td>");
			  out.print(resultFiveLines.getLong("total_reservations"));
			  out.print("</td>");
			  out.print("</tr>");
			}

			out.print("</table>");
			out.println("<br><br><br>"); 

			
			ResultSet resultListReservation;
			if (searchFor.equals("customer")){
				String sqlListReservation = "SELECT * FROM list_reservation_customer WHERE lname = ? AND fname = ?";
				PreparedStatement pstmtListReservation = con.prepareStatement(sqlListReservation);
				String[] nameSep = searchTerm.split(" ");
				pstmtListReservation.setString(1, nameSep[1]);
				pstmtListReservation.setString(2, nameSep[0]);
				resultListReservation = pstmtListReservation.executeQuery();
				
				out.println("List Of Reservations For Search Term");
				out.print("<table>");
				
				out.print("<tr>");
				out.print("<th>First Name</th>");
				out.print("<th>Last Name</th>");
				out.print("<th>Email</th>");
				out.print("<th>Reservation Number</th>");
				out.print("<th>Reservation Date</th>");
				out.print("<th>Reservation Type</th>");
				out.print("<th>Fare</th>");
				out.print("</tr>");

				while (resultListReservation.next()) {
				  out.print("<tr>");
				  out.print("<td>");
				  out.print(resultListReservation.getString("fname"));
				  out.print("</td>");
				  out.print("<td>");
				  out.print(resultListReservation.getString("lname"));
				  out.print("</td>");
				  out.print("<td>");
				  out.print(resultListReservation.getString("email"));
				  out.print("</td>");
				  out.print("<td>");
				  out.print(resultListReservation.getInt("reservation_number"));
				  out.print("</td>");
				  out.print("<td>");
				  out.print(resultListReservation.getTimestamp("reservation_date"));
				  out.print("</td>");
				  out.print("<td>");
				  out.print(resultListReservation.getString("reservation_type"));
				  out.print("</td>");
				  out.print("<td>");
				  out.print(resultListReservation.getFloat("fare"));
				  out.print("</td>");
				  out.print("</tr>");
				}

				out.print("</table>");
				
			}
			else{
				String sqlListReservation = "SELECT * FROM list_reservation_line WHERE line_name = ?";
				PreparedStatement pstmtListReservation = con.prepareStatement(sqlListReservation);
				pstmtListReservation.setString(1, searchTerm);
				resultListReservation = pstmtListReservation.executeQuery();
				
				
				out.println("List Of Reservations For Search Term");
				out.print("<table>");
				
				out.print("<tr>");
				out.print("<th>Line Number</th>");
				out.print("<th>Reservation Number</th>");
				out.print("<th>Reservation Date</th>");
				out.print("<th>Reservation Type</th>");
				out.print("<th>Fare</th>");
				out.print("</tr>");

				while (resultListReservation.next()) {
				  out.print("<tr>");
				  out.print("<td>");
				  out.print(resultListReservation.getString("line_name"));
				  out.print("</td>");
				  out.print("<td>");
				  out.print(resultListReservation.getInt("reservation_number"));
				  out.print("</td>");
				  out.print("<td>");
				  out.print(resultListReservation.getTimestamp("reservation_date"));
				  out.print("</td>");
				  out.print("<td>");
				  out.print(resultListReservation.getString("reservation_type"));
				  out.print("</td>");
				  out.print("<td>");
				  out.print(resultListReservation.getFloat("fare"));
				  out.print("</td>");
				  out.print("</tr>");
				}

				out.print("</table>");
				
			}
			
			con.close();
			
		}

		
} catch (SQLException ex) {
			out.print("An error occurred: " + ex.getMessage());
			ex.printStackTrace();
 }
	%>
</body>
</html>