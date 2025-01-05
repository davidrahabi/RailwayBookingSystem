<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%
	HttpSession sesh = request.getSession(false);
	if(sesh == null || sesh.getAttribute("username") == null){
	    response.sendRedirect("Start.jsp");
	}
%>



<% 
	int trainid = Integer.parseInt(request.getParameter("trainid"));
	String line = request.getParameter("line");
	String dTStr = request.getParameter("departureTime");
	Timestamp depTime = Timestamp.valueOf(dTStr);
	
	
	
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		String sql = "DELETE FROM train_schedule WHERE train = ? AND line_name = ? AND departure_time = ?";
		PreparedStatement pstmt;
		
		pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, trainid);
		pstmt.setString(2, line);
		pstmt.setTimestamp(3, depTime);
		
		int del = pstmt.executeUpdate();
		if (del > 0){
			response.sendRedirect("schedule_landing.jsp");
		} else{
			out.println("Unable to Delete");
		}
		
		
	}catch (Exception e) {
		e.printStackTrace();
	}


%>