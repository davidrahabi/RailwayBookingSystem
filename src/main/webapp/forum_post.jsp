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
	String question = request.getParameter("question");
	int id = Integer.parseInt(request.getParameter("id"));
	String ans = "Awaiting Response";
	
	try{
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		String sql = "INSERT INTO forum VALUES (?, ?, ?)";
		PreparedStatement pstmt;
		
		pstmt = con.prepareStatement(sql);
		pstmt.setInt(1, id);
		pstmt.setString(2, question);
		pstmt.setString(3, ans);

		
		int affect = pstmt.executeUpdate();
		if (affect > 0){
			response.sendRedirect("forum_customer.jsp");
		} else{
			out.println("Unable to Insert");
		}
		

	}catch (Exception e) {
		e.printStackTrace();
	}

%>