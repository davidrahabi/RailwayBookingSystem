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
        <title>Travel Itinerary</title>
    </head>
    <body>
        <h2>Travel Itinerary</h2>
        
        <%
        try {
            ApplicationDB db = new ApplicationDB();    
            Connection con = db.getConnection();
            
            int reservationNumber = Integer.parseInt(request.getParameter("reservation_number"));
            
            String resQuery = "SELECT r.*, c.is_disabled, c.is_senior, c.is_child FROM reservation r " +
                            "JOIN customers c ON r.email = c.email " +
                            "WHERE r.reservation_number = ?";
            PreparedStatement psRes = con.prepareStatement(resQuery);
            psRes.setInt(1, reservationNumber);
            ResultSet rsRes = psRes.executeQuery();
            
            if(rsRes.next()) {
                int train = rsRes.getInt("train");
                String lineName = rsRes.getString("line_name");
                Timestamp departureTime = rsRes.getTimestamp("departure_time");
                
                float discountMultiplier = 1.0f;
                String discountType = "";
                if(rsRes.getBoolean("is_disabled")) {
                    discountMultiplier = 0.50f;
                    discountType = "Disability - 50% discount";
                } else if(rsRes.getBoolean("is_senior")) {
                    discountMultiplier = 0.65f;  // 35% discount
                    discountType = "Senior - 35% discount";
                } else if(rsRes.getBoolean("is_child")) {
                    discountMultiplier = 0.75f;  // 25% discount
                    discountType = "Child - 25% discount";
                }
                
                String stopsQuery = "SELECT stop_number, station, arrival_time, departure_time, fare, " +
                        "st.station_name, st.city, st.state " +
                        "FROM ( " +
                        "    SELECT 0 as stop_number, " +  // Changed to 0 for origin
                        "           t.origin_station as station, " +
                        "           t.departure_time as arrival_time, " +
                        "           t.departure_time as departure_time, " +
                        "           0 as fare " +
                        "    FROM train_schedule t " +
                        "    WHERE t.train = ? AND t.line_name = ? AND t.departure_time = ? " +
                        "    UNION ALL " +
                        "    SELECT stop_number, station, arrival_time, departure_time, fare " +
                        "    FROM stops s " +
                        "    WHERE s.train = ? AND s.line_name = ? AND s.origin_departure_time = ? " +
                        ") all_stops " +
                        "JOIN station st ON all_stops.station = st.stationid " +
                        "ORDER BY stop_number";

                PreparedStatement psStops = con.prepareStatement(stopsQuery);
                psStops.setInt(1, train);
                psStops.setString(2, lineName);
                psStops.setTimestamp(3, departureTime);
                psStops.setInt(4, train);
                psStops.setString(5, lineName);
                psStops.setTimestamp(6, departureTime);
                
                ResultSet rsStops = psStops.executeQuery();
                %>
                
                <h3>Reservation Details:</h3>
                <p>Reservation Number: <%=reservationNumber%></p>
                <p>Train: <%=train%></p>
                <p>Line: <%=lineName%></p>
                <p>Departure Time: <%=departureTime%></p>
                <% if(!discountType.isEmpty()) { %>
                    <p>Discount: <%=discountType%></p>
                <% } %>
                
                <h3>Route Itinerary:</h3>
                <table border="1">
                    <tr>
                        <th>Stop #</th>
                        <th>Station</th>
                        <th>Location</th>
                        <th>Arrival Time</th>
                        <th>Departure Time</th>
                        <th>Fare</th>
                    </tr>
                    
                    <% while(rsStops.next()) { 
                        float originalFare = rsStops.getFloat("fare");
                        float discountedFare = originalFare * discountMultiplier;
                    %>
                        <tr>
                            <td><%=rsStops.getInt("stop_number")%></td>
                            <td><%=rsStops.getString("station_name")%></td>
                            <td><%=rsStops.getString("city")%>, <%=rsStops.getString("state")%></td>
                            <td><%=rsStops.getTimestamp("arrival_time")%></td>
                            <td><%=rsStops.getTimestamp("departure_time")%></td>
                            <td>$<%=String.format("%.2f", discountedFare)%></td>
                        </tr>
                    <% } 
                    
                    rsStops.close();
                    psStops.close();
                } else {
                    %>
                    <p>Reservation not found.</p>
                    <%
                }
                
                rsRes.close();
                psRes.close();
                con.close();
                
        } catch(Exception e) {
            out.println("Error: " + e);
        }
        %>
        
        <br>
        <form method="post" action="view_my_reservations.jsp">
            <input type="submit" value="Back to Reservations">
        </form>
        <form method="post" action="forum_customer.jsp">
            <input type="submit" value="Customer Service Forum">
        </form>
    </body>
</html>