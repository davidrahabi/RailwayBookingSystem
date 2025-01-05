<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
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
        <title>Available Trains</title>
    </head>
    <body>
        <h2>Available Trains</h2>
        
        <%
        try {
            ApplicationDB db = new ApplicationDB();    
            Connection con = db.getConnection();
            
            String username = (String)session.getAttribute("username");
            String discountQuery = "SELECT is_disabled, is_senior, is_child FROM customers WHERE username = ?";
            PreparedStatement psDiscount = con.prepareStatement(discountQuery);
            psDiscount.setString(1, username);
            ResultSet rsDiscount = psDiscount.executeQuery();
            
            float discountRate = 0.0f;
            String discountType = "none";
            if(rsDiscount.next()) {
                if(rsDiscount.getBoolean("is_disabled")) {
                    discountRate = 0.50f;  
                    discountType = "Disability (50% off)";
                } else if(rsDiscount.getBoolean("is_senior")) {
                    discountRate = 0.35f;  
                    discountType = "Senior (35% off)";
                } else if(rsDiscount.getBoolean("is_child")) {
                    discountRate = 0.25f;  
                    discountType = "Child (25% off)";
                }
            }
            rsDiscount.close();
            psDiscount.close();
            
            int originStation = Integer.parseInt(request.getParameter("origin"));
            int destinationStation = Integer.parseInt(request.getParameter("destination"));
            String tripType = request.getParameter("tripType");
            String travelDate = request.getParameter("travelDate");
            
            String query = "SELECT ts.*, " +
                          "orig.station_name as origin_name, " +
                          "dest.station_name as destination_name " +
                          "FROM train_schedule ts " +
                          "JOIN station orig ON ts.origin_station = orig.stationid " +
                          "JOIN station dest ON ts.destination_station = dest.stationid " +
                          "WHERE ts.origin_station = ? " +
                          "AND ts.destination_station = ? " +
                          "AND DATE(ts.departure_time) = ? " +
                          "ORDER BY ts.departure_time";
                          
            PreparedStatement ps = con.prepareStatement(query);
            ps.setInt(1, originStation);
            ps.setInt(2, destinationStation);
            ps.setString(3, travelDate);
            
            ResultSet rs = ps.executeQuery();
            
            if (!rs.isBeforeFirst()) {
                %>
                <p>No trains available for the selected route and date.</p>
                <%
            } else {
                if(discountRate > 0) {
                    %>
                    <div style="background-color: #e8f5e9; padding: 10px; margin: 10px 0; border-radius: 5px;">
                        <p>You are eligible for a <%=discountType%> discount.</p>
                    </div>
                    <%
                }
                %>
                <form method="post" action="finalize_reservation.jsp">
                    <input type="hidden" name="tripType" value="<%=tripType%>">
                    
                    <h3>Select Outbound Train:</h3>
                    <table border="1">
                        <tr>
                            <th>Select</th>
                            <th>Train ID</th>
                            <th>Line Name</th>
                            <th>Origin</th>
                            <th>Destination</th>
                            <th>Departure Time</th>
                            <th>Arrival Time</th>
                            <th>Fare</th>
                            <% if(discountRate > 0) { %>
                                <th>Discounted Fare</th>
                            <% } %>
                        </tr>
                        <% while(rs.next()) { 
                            float originalFare = rs.getFloat("fare");
                            float discountedFare = originalFare * (1 - discountRate);
                            float finalFare = discountRate > 0 ? discountedFare : originalFare;
                        %>
                            <tr>
                                <td>
                                    <input type="radio" name="outboundTrain" 
                                           value="<%=rs.getInt("train")%>_<%=rs.getString("line_name")%>_<%=rs.getTimestamp("departure_time")%>_<%=finalFare%>" 
                                           required>
                                </td>
                                <td><%=rs.getInt("train")%></td>
                                <td><%=rs.getString("line_name")%></td>
                                <td><%=rs.getString("origin_name")%></td>
                                <td><%=rs.getString("destination_name")%></td>
                                <td><%=rs.getTimestamp("departure_time")%></td>
                                <td><%=rs.getTimestamp("arrival_time")%></td>
                                <td>$<%=String.format("%.2f", originalFare)%></td>
                                <% if(discountRate > 0) { %>
                                    <td>$<%=String.format("%.2f", discountedFare)%></td>
                                <% } %>
                            </tr>
                        <% } %>
                    </table>
                    
                    <%
                    if(tripType.equals("Round Trip")) {
                        String returnDate = request.getParameter("returnDate");
                        
                        ps = con.prepareStatement(query);
                        ps.setInt(1, destinationStation);
                        ps.setInt(2, originStation);
                        ps.setString(3, returnDate);
                        
                        rs = ps.executeQuery();
                        
                        if (!rs.isBeforeFirst()) {
                            %>
                            <p>No return trains available for the selected date.</p>
                            <%
                        } else {
                            %>
                            <h3>Select Return Train:</h3>
                            <table border="1">
                                <tr>
                                    <th>Select</th>
                                    <th>Train ID</th>
                                    <th>Line Name</th>
                                    <th>Origin</th>
                                    <th>Destination</th>
                                    <th>Departure Time</th>
                                    <th>Arrival Time</th>
                                    <th>Fare</th>
                                    <% if(discountRate > 0) { %>
                                        <th>Discounted Fare</th>
                                    <% } %>
                                </tr>
                                <% while(rs.next()) { 
                                    float originalFare = rs.getFloat("fare");
                                    float discountedFare = originalFare * (1 - discountRate);
                                    float finalFare = discountRate > 0 ? discountedFare : originalFare;
                                %>
                                    <tr>
                                        <td>
                                            <input type="radio" name="returnTrain" 
                                                   value="<%=rs.getInt("train")%>_<%=rs.getString("line_name")%>_<%=rs.getTimestamp("departure_time")%>_<%=finalFare%>" 
                                                   required>
                                        </td>
                                        <td><%=rs.getInt("train")%></td>
                                        <td><%=rs.getString("line_name")%></td>
                                        <td><%=rs.getString("origin_name")%></td>
                                        <td><%=rs.getString("destination_name")%></td>
                                        <td><%=rs.getTimestamp("departure_time")%></td>
                                        <td><%=rs.getTimestamp("arrival_time")%></td>
                                        <td>$<%=String.format("%.2f", originalFare)%></td>
                                        <% if(discountRate > 0) { %>
                                            <td>$<%=String.format("%.2f", discountedFare)%></td>
                                        <% } %>
                                    </tr>
                                <% } %>
                            </table>
                            <%
                        }
                    }
                    %>
                    
                    <br>
                    <input type="submit" value="Confirm Reservation">
                </form>
                <%
            }
            
            con.close();
        } catch(Exception e) {
            out.println("Error: " + e);
        }
        %>
        
        <br>
        <form method="post" action="make_reservation.jsp">
            <input type="submit" value="Back">
        </form>
        <form method="post" action="forum_customer.jsp">
            <input type="submit" value="Customer Service Forum">
        </form>
    </body>
</html>