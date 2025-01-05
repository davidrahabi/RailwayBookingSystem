<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Train Schedule</title>
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
	.edit-btn, .delete-btn {
		display: none;
		margin-left: 10px;
		cursor: pointer;
	}
	tr:hover .edit-btn, tr:hover .delete-btn {
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
	
	function deleteRow(row, train, lineNam, depTime){
		if (confirm("Are you sure you want to Delete?")){
	        var deleteUrl = 'schedule_delete.jsp?trainid=' + encodeURIComponent(train) + '&line=' + encodeURIComponent(lineNam) + '&departureTime=' + encodeURIComponent(depTime);
	   
	        window.location.href = deleteUrl;
			document.getElementById(row).remove();
		}
	}

</script>
</head>
<body>
	<h1>Train Schedules </h1>
	<form method ="get">
		<label for= "stationFilter">Filter by Station Name:</label>
		<input type ="text" id ="stationFilter" name ="stationFilter">
		<input type ="submit" value= "Confirm">
	</form>
	<table>
		<thead>
			<tr>
				<th>Line Name</th>
                <th>Train Number</th>
                <th>Origin Station</th>
                <th>Station ID</th>
                <th>Destination Station</th>
                <th>Station ID</th>
                <th>Departure Time</th>
                <th>Arrival Time</th>
                <th>Travel Time (minutes)</th>
                <th>Fare </th>
            </tr>
        </thead>
		<tbody>
			<%
				String stationFilter = request.getParameter("stationFilter");

				try {
					ApplicationDB db = new ApplicationDB();
					Connection con = db.getConnection();
					PreparedStatement pstmt;
					ResultSet result;
						
					Statement stmt = con.createStatement();
					String sql = "SELECT * FROM edit_schedule";
					
					if (stationFilter != null && !stationFilter.trim().isEmpty()) {
						String sqlF = "SELECT * FROM edit_schedule WHERE origin_name = ? OR destination_name = ?";
						pstmt = con.prepareStatement(sqlF);
						pstmt.setString(1, stationFilter);
						pstmt.setString(2, stationFilter);
						result = pstmt.executeQuery();
					} else{
						result = stmt.executeQuery(sql);
					}

					
					int row = 0;
					while(result.next()){
						String line_name = result.getString("line_name");
						String keyLine = line_name;
						int trainid = result.getInt("train");
						int keyTrain = trainid;
						String origin = result.getString("origin_name");
						int originid = result.getInt("origin_station");
						String destination = result.getString("destination_name");
						int destinationid = result.getInt("destination_station");
						Timestamp depTime = result.getTimestamp("departure_time");
						Timestamp keyTime = depTime;
						Timestamp arrTime = result.getTimestamp("arrival_time");
						int travelTime = result.getInt("travel_time");
						float fare = result.getFloat("fare");
						row++;
						
			%>
						
						<tr id="row<%= row %>">
							<td><%= line_name %></td>
							<td><%= trainid %></td>
							<td><%= origin %></td>
							<td><%= originid %></td>
							<td><%= destination %></td>
							<td><%= destinationid %></td>
							<td><%= depTime %></td>
							<td><%= arrTime %></td>
							<td><%= travelTime %></td>
							<td>$<%= fare %></td>
							<td>
								<span class="edit-btn" onclick="showEditForm('edit-form-<%= row %>')">Edit</span>
								<span class="delete-btn" onclick="deleteRow('row<%= row %>', '<%= trainid %>', '<%= line_name %>', '<%= depTime %>')">Delete</span>
							</td>
						</tr>
						<tr id="edit-form-<%= row %>" class ="edit-form">
							<td colspan="10">
								<form method="post" action="schedule_edit.jsp">
									<input type="text" name="line_name" value ="<%= line_name %>" style="width: 125px;">
									<input type="text" name="trainid" value ="<%= trainid %>" style="margin-right: 180px;">
									<input type="text" name="originid" value ="<%= originid %>" style="width: 128px; margin-right: 228px;">
									<input type="text" name="destinationid" value ="<%= destinationid %>" style="width: 128px;">
									<input type="text" name="dep_Time" value ="<%= depTime %>" style="width: 240px; margin-right: 2px;">
									<input type="text" name="arr_Time" value ="<%= arrTime %>" style="width: 240px; margin-right: 2px;">
									<input type="text" name="travel_Time" value ="<%= travelTime %>" style="width: 240px; margin-right: 10px">
									<input type="text" name="fare" value ="<%= fare %>" style="width: 50px;">
									<input type="hidden" name="keyLine" value="<%= keyLine %>">
									<input type="hidden" name="keyTrain" value="<%= keyTrain %>">
									<input type="hidden" name="keyTime" value="<%= keyTime %>">
									<input type="submit" value= "Confirm">
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

