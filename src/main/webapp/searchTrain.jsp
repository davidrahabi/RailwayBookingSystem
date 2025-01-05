<%@ page language="java" contentType="text/html; charset=ISO-8859-1" 
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search Train</title>
</head>
<body>
<%
    try {
        
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        
        String origin = request.getParameter("origin");
        String destination = request.getParameter("destination");
        String time = request.getParameter("time");
        String sortColumn = request.getParameter("sortColumn");
        String sortOrder = request.getParameter("sortOrder");
        

     	
        StringBuilder sql = new StringBuilder("SELECT * FROM edit_schedule WHERE 1=1");

        
        List<String> params = new ArrayList<>();

        
        if (origin != null && !origin.isEmpty()) {
            sql.append(" AND origin_name = ?");
            params.add(origin);
        }
        if (destination != null && !destination.isEmpty()) {
            sql.append(" AND destination_name = ?");
            params.add(destination);
        }
        if (time != null && !time.isEmpty()) {
            sql.append(" AND DATE(departure_time) = ?");
            params.add(time);
        }
        
        if ((sortColumn.equals("departure_time") || sortColumn.equals("arrival_time") || sortColumn.equals("fare") || sortColumn.equals("travel_time"))){
        	if (!sortOrder.equals("ASC") && !sortOrder.equals("DESC")){
        		sortOrder = "ASC";
        	}
        	sql.append(" ORDER BY ").append(sortColumn).append(" ").append(sortOrder);
        }

       
        PreparedStatement pstmt = con.prepareStatement(sql.toString());

        
        for (int i = 0; i < params.size(); i++) {
            pstmt.setString(i + 1, params.get(i));
        }


        
        ResultSet rs = pstmt.executeQuery();
        %>
        
        <table border="1">
        	<tr>
        		<th>line_name</th>
        		<th>fare</th>
        		<th>travel_time</th>
        		<th>departure_time</th>
        		<th>arrival_time</th>
        		<th>origin_station</th>
        		<th>destination_station</th>
        		<th>train</th>
        		<th>actions</th>
        	</tr>
        	<% while(rs.next()) {
        		
        		%>
        	<tr>
        		<td><%= rs.getString("line_name") %></td>
        		<td><%= rs.getFloat("fare") %></td>
        		<td><%= rs.getInt("travel_time") %></td>
        		<td><%= rs.getTimestamp("departure_time") %></td>
        		<td><%= rs.getTimestamp("arrival_time") %></td>
        		<td><%= rs.getString("origin_name") %></td>
        		<td><%= rs.getString("destination_name") %></td>
        		<td><%= rs.getInt("train") %></td>
        		<td>
        			<form method="post" action="viewStops.jsp">
        				<input type="hidden" name="train" value="<%= rs.getInt("train") %>">
    					<input type="hidden" name="line_name" value="<%= rs.getString("line_name") %>">
    					<input type="hidden" name="origin_departure_time" value="<%= rs.getString("departure_time") %>">
    					<button type="submit">View Stops</button>
        			</form>
        		</td>
       		</tr>
        		
        		<%
        	}
        	%>
        		
        </table>
        <%
        
        
        con.close();

       
    } catch (Exception ex) {
        out.print("<p>Error: " + ex.getMessage() + "</p>");
        ex.printStackTrace();
    }
		%>
</body>
</html>
