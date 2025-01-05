<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Revenue</title>
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
		String searchTerm = request.getParameter("adminListForRevenue");
		String searchFor = request.getParameter("adminSearchForRevenue");
		
		
		if (searchTerm == null || searchTerm.equals("null") || searchTerm.isEmpty()){
			
%>
Did Not Provide A Search Term. Re-Enter A Search Term
	<script>
		setTimeout(function() {window.location.href = "admin_landing.jsp";}, 1000);
	</script>
<%
		}
		else{
			String sqlSalesReport = "SELECT * FROM sales_report";
			Statement stmtSalesReport = con.createStatement();
			ResultSet resultSalesReport = stmtSalesReport.executeQuery(sqlSalesReport);
			
			out.println("Sales Report Per Month");
			out.print("<table>");
			
			out.print("<tr>");
			out.print("<th>Year</th>");
			out.print("<th>Month</th>");
			out.print("<th>Total Revenue</th>");
			out.print("</tr>");                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

			while (resultSalesReport.next()) {
			  out.print("<tr>");
			  out.print("<td>");
			  out.print(resultSalesReport.getInt("year"));
			  out.print("</td>");
			  out.print("<td>");
			  out.print(resultSalesReport.getInt("month"));
			  out.print("</td>");
			  out.print("<td>");
			  out.print("$" + resultSalesReport.getDouble("total_revenue"));
			  out.print("</td>");
			  out.print("</tr>");
			}

			out.print("</table>");
			out.println("<br><br><br>"); 

			
			String sqlBestCustomer = "SELECT * FROM best_customer LIMIT 1";
			Statement stmtBestCustomer = con.createStatement();
			ResultSet resultBestCustomer = stmtBestCustomer.executeQuery(sqlBestCustomer);
			
			out.println("Best Customer");
			out.print("<table>");
			
			out.print("<tr>");
			out.print("<th>First Name</th>");
			out.print("<th>Last Name</th>");
			out.print("<th>Total Revenue</th>");
			out.print("</tr>");                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

			while (resultBestCustomer.next()) {
			  out.print("<tr>");
			  out.print("<td>");
			  out.print(resultBestCustomer.getString("fname"));
			  out.print("</td>");
			  out.print("<td>");
			  out.print(resultBestCustomer.getString("lname"));
			  out.print("</td>");
			  out.print("<td>");
			  out.print("$" + resultBestCustomer.getDouble("total_revenue"));
			  out.print("</td>");
			  out.print("</tr>");
			}

			out.print("</table>");
			out.println("<br><br><br>"); 

			
			
			ResultSet resultRevenue;
			if (searchFor.equals("customer")){
				String sqlRevenue = "SELECT * FROM customer_revenue WHERE lname = ? AND fname = ?";
				PreparedStatement pstmtRevenue = con.prepareStatement(sqlRevenue);
				String[] nameSep = searchTerm.split(" ");
				pstmtRevenue.setString(1, nameSep[1]);
				pstmtRevenue.setString(2, nameSep[0]);
				resultRevenue = pstmtRevenue.executeQuery();
				
				out.println("Revenue For Search Term");
				out.print("<table>");
				
				out.print("<tr>");
				out.print("<th>First Name</th>");
				out.print("<th>Last Name</th>");
				out.print("<th>Email</th>");
				out.print("<th>Total Revenue</th>");
				out.print("</tr>");

				while (resultRevenue.next()) {
				  out.print("<tr>");
				  out.print("<td>");
				  out.print(resultRevenue.getString("fname"));
				  out.print("</td>");
				  out.print("<td>");
				  out.print(resultRevenue.getString("lname"));
				  out.print("</td>");
				  out.print("<td>");
				  out.print(resultRevenue.getString("email"));
				  out.print("</td>");
				  out.print("<td>");
				  out.print("$" + resultRevenue.getDouble("total_revenue"));
				  out.print("</td>");
				  out.print("</tr>");
				}

				out.print("</table>");
				
			}
			else{
				String sqlRevenue = "SELECT * FROM line_revenue WHERE line_name = ?";
				PreparedStatement pstmtRevenue = con.prepareStatement(sqlRevenue);
				pstmtRevenue.setString(1, searchTerm);
				resultRevenue = pstmtRevenue.executeQuery();
				
				out.println("Revenue For Search Term");
				out.print("<table>");
				
				out.print("<tr>");
				out.print("<th>Line Number</th>");
				out.print("<th>Total Revenue</th>");
				out.print("</tr>");

				while (resultRevenue.next()) {
				  out.print("<tr>");
				  out.print("<td>");
				  out.print(resultRevenue.getString("line_name"));
				  out.print("</td>");
				  out.print("<td>");
				  out.print("$" + resultRevenue.getDouble("total_revenue"));
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