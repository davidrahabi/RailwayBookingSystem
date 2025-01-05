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

	REP PRIVILEGE
- Only see questions without answers
	then give the option to reply, again open a new text box or redirect to response page idk
- Can you allow one role to click on a question and another role not too with if statements?
	need to figure out a way for there to be a response option availabe only for rep.

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
	.edit-btn {
		display: none;
		margin-left: 10px;
		cursor: pointer;
	}
	tr:hover .edit-btn{
		display: inline-block;
	}
	.edit-form {
    	display: none;
	}
</style>
<script>
	function showEditForm(row) {
		const form = document.getElementById(row);
		form.style.display = (form.style.display === 'none' || form.style.display === '') ? 'table-row' : 'none';
	}

</script>
</head>
<body>
	<h1>Forum </h1>
	<table>
		<thead>
			<tr>
				<th>Discussion ID</th>
                <th>Question</th>
            </tr>
        </thead>
		<tbody>
			<%
				try {
					ApplicationDB db = new ApplicationDB();
					Connection con = db.getConnection();
					PreparedStatement pstmt;
					ResultSet result;
						
					String sql = "SELECT * FROM forum WHERE answer = ?";
					String ques = "Awaiting Response";
					
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, ques);
					
					result = pstmt.executeQuery();
					
					int row = 0;
					while(result.next()){
						int disID = result.getInt("discussionID");
						String question = result.getString("question");
						row++;
			%>	
						<tr id="row<%= row %>">
							<td><%= disID %></td>
							<td><%= question %></td>
							<td>
								<span class="edit-btn" onclick="showEditForm('edit-form-<%= row %>')">Reply</span>
							</td>
						</tr>
						<tr id="edit-form-<%= row %>" class ="edit-form">
							<td colspan="2">
								<form method="post" action="forum_reply.jsp">
									<textarea name="answer" style="height: 100px; width: 500px;"></textarea>
									<input type="hidden" name="id" value="<%= disID %>">
									<input type="submit" value= "Submit">
								</form>
							</td>
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