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
	String line = request.getParameter("line_name");
	int origin = Integer.parseInt(request.getParameter("originid"));
	int destination = Integer.parseInt(request.getParameter("destinationid"));
	int travelT = Integer.parseInt(request.getParameter("travel_Time"));
	float fare = Float.parseFloat(request.getParameter("fare"));

	String dTStr = request.getParameter("dep_Time");
	Timestamp depTime = Timestamp.valueOf(dTStr);
	
	String oTStr = request.getParameter("arr_Time");
	Timestamp arrTime = Timestamp.valueOf(oTStr);
	
	int keyTrain = Integer.parseInt(request.getParameter("keyTrain"));
	String keyLine = request.getParameter("keyLine");
	String key = request.getParameter("keyTime");
	Timestamp keyTime = Timestamp.valueOf(key);
	
	
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		String sql = "UPDATE train_schedule SET train = ?, line_name = ?, fare = ?, travel_time = ?, departure_time = ?, arrival_time = ?, origin_station = ?, destination_station = ? WHERE train = ? AND line_name = ? AND departure_time = ?";
		
		PreparedStatement pstmt;
		
		pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, trainid);
		pstmt.setString(2, line);
		pstmt.setFloat(3, fare);
		pstmt.setInt(4, travelT);
		pstmt.setTimestamp(5, depTime);
		pstmt.setTimestamp(6, arrTime);
		pstmt.setInt(7, origin);
		pstmt.setInt(8, destination);
		pstmt.setInt(9, keyTrain);
		pstmt.setString(10, keyLine);
		pstmt.setTimestamp(11, keyTime);
		
		int affect = pstmt.executeUpdate();
		boolean redirect = false;
		
		
		if (affect > 0){
			redirect = true;
		} else{
			out.println("Unable to Update");
		}
		
		//train schedule has all new values
		String sql2 = "SELECT count(*) AS num FROM see_stops WHERE train = ? AND line_name = ? AND departure_time = ?";
		PreparedStatement pstmt2;
		pstmt2 = con.prepareStatement(sql2);
		pstmt2.setInt(1, trainid);
		pstmt2.setString(2, line);
		pstmt2.setTimestamp(3, depTime);
		
		ResultSet rs;
		rs = pstmt2.executeQuery();
		
		int numStops = 0;
		while(rs.next()){
			numStops = rs.getInt("num");
		}
		
		String sql3 = "UPDATE stops SET fare = ? WHERE train = ? AND line_name = ? AND origin_departure_time = ?";
		float stopFare = fare / numStops;
		if (numStops == 0) 
			stopFare = fare;
		else
			stopFare = fare / numStops;
		
		PreparedStatement pstmt3 = con.prepareStatement(sql3);
		pstmt3.setFloat(1, stopFare);
		pstmt3.setInt(2, trainid);
		pstmt3.setString(3, line);
		pstmt3.setTimestamp(4, depTime);
		int retQ = pstmt3.executeUpdate();

		if (redirect && retQ >= 0) {
		    response.sendRedirect("schedule_landing.jsp");
		} else {
		    out.println("<h3>Unable to update stops. Please verify the data and try again.</h3>");
		}
		
		
	}catch (Exception e) {
		e.printStackTrace();
	}


%>

