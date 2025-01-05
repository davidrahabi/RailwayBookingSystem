<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%
    HttpSession sesh = request.getSession(false);
    if(sesh == null || sesh.getAttribute("username") == null){
        response.sendRedirect("Start.jsp");
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
        <title>Finalize Reservation</title>
    </head>
    <body>
        <%
        try {
            ApplicationDB db = new ApplicationDB();    
            Connection con = db.getConnection();
            
            String username = (String)session.getAttribute("username");
            
            String emailQuery = "SELECT email FROM customers WHERE username = ?";
            PreparedStatement emailPs = con.prepareStatement(emailQuery);
            emailPs.setString(1, username);
            ResultSet emailRs = emailPs.executeQuery();
            emailRs.next();
            String userEmail = emailRs.getString("email");
            
            Statement stmt = con.createStatement();
            ResultSet maxRes = stmt.executeQuery("SELECT MAX(reservation_number) as max_res FROM reservation");
            maxRes.next();
            int reservationNumber = maxRes.getInt("max_res") + 1;
            int returnReservationNumber = reservationNumber + 1;
            
            String tripType = request.getParameter("tripType");
            
            String outboundTrain = request.getParameter("outboundTrain");
            String[] outboundParts = outboundTrain.split("_");
            int trainId = Integer.parseInt(outboundParts[0]);
            String lineName = outboundParts[1];
            Timestamp departureTime = Timestamp.valueOf(outboundParts[2]);
            float outboundFare = Float.parseFloat(outboundParts[3]);
            
            float totalFare = outboundFare;
            
            String insertRes = "INSERT INTO reservation (reservation_number, reservation_date, reservation_type, fare, is_active, email, train, line_name, departure_time, pair_id) VALUES (?, NOW(), ?, ?, true, ?, ?, ?, ?, ?)";
            PreparedStatement insertPs = con.prepareStatement(insertRes);
            insertPs.setInt(1, reservationNumber);
            if(tripType.equals("Round Trip")) {
                insertPs.setInt(8, returnReservationNumber);  
            } else {
                insertPs.setNull(8, java.sql.Types.INTEGER); 
            }
            insertPs.setString(2, tripType);
            insertPs.setFloat(3, outboundFare);
            insertPs.setString(4, userEmail);
            insertPs.setInt(5, trainId);
            insertPs.setString(6, lineName);
            insertPs.setTimestamp(7, departureTime);
            insertPs.executeUpdate();
            
            if(tripType.equals("Round Trip")) {
                String returnTrain = request.getParameter("returnTrain");
                String[] returnParts = returnTrain.split("_");
                int returnTrainId = Integer.parseInt(returnParts[0]);
                String returnLineName = returnParts[1];
                Timestamp returnDepartureTime = Timestamp.valueOf(returnParts[2]);
                float returnFare = Float.parseFloat(returnParts[3]);
                
                insertPs = con.prepareStatement(insertRes);
                insertPs.setInt(1, returnReservationNumber);
                insertPs.setInt(8, reservationNumber);  
                insertPs.setString(2, tripType);
                insertPs.setFloat(3, returnFare);
                insertPs.setString(4, userEmail);
                insertPs.setInt(5, returnTrainId);
                insertPs.setString(6, returnLineName);
                insertPs.setTimestamp(7, returnDepartureTime);
                insertPs.executeUpdate();
                
                totalFare += returnFare;
            }
            
            stmt.close();
            maxRes.close();
            emailRs.close();
            emailPs.close();
            insertPs.close();
            con.close();
            %>
            <h2>Reservation Successful!</h2>
            <p>Your reservation has been confirmed.</p>
            <p>Outbound Reservation Number: <%=reservationNumber%></p>
            <% if(tripType.equals("Round Trip")) { %>
                <p>Return Reservation Number: <%=returnReservationNumber%></p>
            <% } %>
            <p>Total fare: $<%=String.format("%.2f", totalFare)%></p>
            <%
        } catch(Exception e) {
            out.println("Error: " + e);
        }
        %>
        
        <br>
        <form method="post" action="customer_landing.jsp">
            <input type="submit" value="Return to Main Page">
        </form>
        <form method="post" action="forum_customer.jsp">
            <input type="submit" value="Customer Service Forum">
        </form>
    </body>
</html>