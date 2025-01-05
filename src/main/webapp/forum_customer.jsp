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

<%-- 
	BOTH PRIVILEGE
- Forum should be a direct showcase of all questions and answers

	CUSTOMER PRIVILEGE
- Add a "Ask Question" button
- Take this redirect to a different page possiblly, or open up a new text box area for them to type a question
	whichevers easier
 --%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Customer Q&A</title>
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
	<h1>Forum </h1>
	<form method ="get">
		<label for= "keyword">Filter by Keyword:</label>
		<input type ="text" id ="keyword" name ="keyword">
		<input type ="submit" value= "Confirm">
	</form>
	<table>
		<thead>
			<tr>
				<th>Question</th>
                <th>Answer</th>
            </tr>
        </thead>
		<tbody>
			<%
				String keyword = request.getParameter("keyword");
				
				try {
					ApplicationDB db = new ApplicationDB();
					Connection con = db.getConnection();
					PreparedStatement pstmt;
					ResultSet result;
						
					String sql = "SELECT * FROM forum";
					Statement stmt = con.createStatement();
					
					if (keyword != null && !keyword.trim().isEmpty()){
						String sqlF = "SELECT * FROM forum WHERE question LIKE ?";
						pstmt = con.prepareStatement(sqlF);
						pstmt.setString(1, "%" + keyword + "%");
						result = pstmt.executeQuery();
					}else {
						result = stmt.executeQuery(sql);
					}
					
					int row = 0;
					while(result.next()){
						int disID = result.getInt("discussionID");
						String question = result.getString("question");
						String answer = result.getString("answer");
						row++;
			%>	
						<tr id="row<%= row %>">
							<td><%= question %></td>
							<td><%= answer %></td>
						</tr>							
			<%
					}
				sesh.setAttribute("rows", (row + 1));
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			%>
		</tbody>			
	</table>
	<h2>Post A New Question</h2>
		<form method="post" action="forum_post.jsp">
			<textarea name="question" style="height: 100px; width: 500px;"></textarea>
			<input type="hidden" name="id" value="<%= (int)sesh.getAttribute("rows") %>">
			<input type="submit" value= "Post">
		</form>
		
	Logout?
	<br>
		<form method="post" action="logout.jsp">
			<input type="submit" value="Logout">
		</form>
	<br>
	
	<br>
		<form method="post" action="customer_landing.jsp">
			<input type="submit" value="Return to Main Screen">
		</form>
	<br>
	
</body>
</html>