<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Login Process</title>
</head>
<body>
	<%
	try {

		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();

		//Create a SQL statement
		Statement stmt = con.createStatement();

		//Get parameters from the HTML form at the Start.jsp
		String emailSSN = request.getParameter("emailSSN");
		String username = request.getParameter("username");
		String password = request.getParameter("password");


		String sqlCustomer = "SELECT * FROM customers WHERE username = ? AND password = ? AND email = ?";
		PreparedStatement pstmtCustomer = con.prepareStatement(sqlCustomer);

		
		String sqlEmployee = "SELECT * FROM employees WHERE username = ? AND password = ? AND ssn = ?";
		PreparedStatement pstmtEmployee = con.prepareStatement(sqlEmployee);

		
		ResultSet resultCustomer;
		ResultSet resultEmployee;


		pstmtCustomer.setString(1, username);
		pstmtCustomer.setString(2, password);
		pstmtCustomer.setString(3, emailSSN);
		resultCustomer = pstmtCustomer.executeQuery();

			
		pstmtEmployee.setString(1, username);
		pstmtEmployee.setString(2, password);
		pstmtEmployee.setString(3, emailSSN);
		resultEmployee = pstmtEmployee.executeQuery();
		
		String userType = "";
		
		HttpSession sesh = request.getSession();
		boolean validUser = false;
		if (resultCustomer.next()){
		  	validUser = true;
		  	userType = "Customer";
		} else if (resultEmployee.next()) {
		  validUser = true;
		  userType = resultEmployee.getString("role");
		}
		
		
		con.close();

		if (validUser && userType.equals("Customer")) {
			sesh.setAttribute("email", emailSSN);
			sesh.setAttribute("username", username);
			sesh.setAttribute("usertype", userType);
	%>
	Login Successful. Redirecting...
	<script>
		setTimeout(function() {window.location.href = "customer_landing.jsp";}, 1000);
	</script>
	<%				
		}
		else if (validUser && userType.equals("Admin"))  {
			sesh.setAttribute("ssn", emailSSN);
			sesh.setAttribute("username", username);
			sesh.setAttribute("usertype", userType);
	%>
	Login Successful. Redirecting...
	<script>
		setTimeout(function() {window.location.href = "admin_landing.jsp";}, 1000);
	</script>
	<%		
		}
		else if (validUser && userType.equals("Rep"))  {
			sesh.setAttribute("ssn", emailSSN);
			sesh.setAttribute("username", username);
			sesh.setAttribute("usertype", userType);
	%>
	Login Successful. Redirecting...
	<script>
		setTimeout(function() {window.location.href = "rep_landing.jsp";}, 1000);
	</script>
	<%		
		}
		else {
	%>
	Login Not Valid. Please try again
	<script>
		setTimeout(function() {window.location.href = "Start.jsp";}, 1000);
	</script>
	<%
				}
		
} catch (SQLException ex) {
			out.print("An error occurred: " + ex.getMessage());
			ex.printStackTrace();
 }
	%>
</body>
</html>