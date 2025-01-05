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
	String ans = request.getParameter("answer");
	int id = Integer.parseInt(request.getParameter("id"));
	
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		String sql = "UPDATE forum SET answer = ? WHERE discussionID = ?";
		PreparedStatement pstmt;
		
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, ans);
		pstmt.setInt(2, id);
		
		int affect = pstmt.executeUpdate();
		if (affect > 0){
			response.sendRedirect("forum_rep.jsp");
		} else{
			out.println("Unable to Update");
		}
		

	}catch (Exception e) {
		e.printStackTrace();
	}

%>