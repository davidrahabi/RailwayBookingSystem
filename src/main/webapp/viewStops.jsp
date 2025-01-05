<%@ page language="java" contentType="text/html; charset=ISO-8859-1" 
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>View Stops</title>
</head>
<body>
<%
    try {
        
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        
        String trainID = request.getParameter("train");
        String lineName = request.getParameter("line_name");
        String originDepartureTime = request.getParameter("origin_departure_time");
        

     	
        String sql = "SELECT * FROM stops WHERE train = ? AND line_name = ? AND origin_departure_time = ? ORDER BY stop_number";


        
        PreparedStatement pstmt = con.prepareStatement(sql.toString());
        
        pstmt.setString(1, trainID);
        pstmt.setString(2, lineName);
        pstmt.setString(3, originDepartureTime);


        
        ResultSet rs = pstmt.executeQuery();
        %>
        
        <table border="1">
        	<tr>
        		<th>stop number</th>
        		<th>arrival time</th>
        		<th>departure time</th>
        		<th>station</th>
        		<th>fare</th>
        		<th>train</th>
        	</tr>
        	<% while(rs.next()) {
        		
        		%>
        	<tr>
        		<td><%= rs.getInt("stop_number") %></td>
        		<td><%= rs.getTimestamp("arrival_time") %></td>
        		<td><%= rs.getTimestamp("departure_time") %></td>
        		<td><%= rs.getInt("station") %></td>
        		<td><%= rs.getFloat("fare") %></td>
        		<td><%= rs.getInt("train") %></td>
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
