<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Manage Customer Representatives</title>
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
		String ssn = request.getParameter("adminRepModSSN");
		String username = request.getParameter("adminRepModUsername");
		String password = request.getParameter("adminRepModPassword");
		String lname = request.getParameter("adminRepModLname");
		String fname = request.getParameter("adminRepModFname");
		String operation = request.getParameter("adminOperation");
		
		int updateFields = 1;
		int modCols = 0;
			
		if (ssn == null || ssn.equals("null") || ssn.isEmpty()){
		
%>
Did Not Provide An SSN. Re-Enter An SSN
	<script>
		setTimeout(function() {window.location.href = "admin_landing.jsp";}, 1000);
	</script>
<%
		}
		else{
					
			if (operation.equals("add")){
				String sql = "INSERT INTO manage_reps (ssn, username, password, lname, fname, role) VALUES (?, ?, ?, ?, ?, ?)";
				
				PreparedStatement pstmt = con.prepareStatement(sql);
				pstmt.setString(1, ssn);
				pstmt.setString(2, username);
				pstmt.setString(3, password);
				pstmt.setString(4, lname);
				pstmt.setString(5, fname);
				pstmt.setString(6, "Rep");
				
				modCols = pstmt.executeUpdate();
			}
			else if (operation.equals("edit")){
				String sql = "UPDATE manage_reps SET ssn = ?";
				
				if (!(username == null || username.equals("null") || username.isEmpty())){
					sql = sql + ", username = ?";
				}
				
				if (!(password == null || password.equals("null") || password.isEmpty())){
					sql = sql + ", password = ?";
				}
				
				if (!(lname == null || lname.equals("null") || lname.isEmpty())){
					sql = sql + ", lname = ?";
				}
				
				if (!(fname == null || fname.equals("null") || fname.isEmpty())){
					sql = sql + ", fname = ?";
				}
				
				sql = sql + " WHERE ssn = ?";
				
				
				PreparedStatement pstmt = con.prepareStatement(sql);
				pstmt.setString(updateFields++, ssn);

				// Incrementally set the rest of the parameters
				if (!(username == null || username.equals("null") || username.isEmpty())) {
				    pstmt.setString(updateFields++, username);
				}

				if (!(password == null || password.equals("null") || password.isEmpty())) {
				    pstmt.setString(updateFields++, password);
				}

				if (!(lname == null || lname.equals("null") || lname.isEmpty())) {
				    pstmt.setString(updateFields++, lname);
				}

				if (!(fname == null || fname.equals("null") || fname.isEmpty())) {
				    pstmt.setString(updateFields++, fname);
				}

				// Set the WHERE condition parameter
				pstmt.setString(updateFields++, ssn);

				// Execute the update
				modCols = pstmt.executeUpdate();
				
			}
			else if (operation.equals("delete")){
				String sql = "DELETE FROM manage_reps WHERE ssn = ?";
				
				PreparedStatement pstmt = con.prepareStatement(sql);
				pstmt.setString(1, ssn);
				
				modCols = pstmt.executeUpdate();
			}
			
			out.print("Modification Completed With: " + modCols + " Changes");
	
			con.close();
		}
		
} catch (SQLException ex) {
			out.print("An error occurred: " + ex.getMessage());
			ex.printStackTrace();
 }
	%>
</body>
</html>