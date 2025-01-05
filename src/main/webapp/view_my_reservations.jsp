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
    <title>My Reservations</title>
</head>
<body>
    <h2>My Reservations</h2>
    
    <%
    try {
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();

        String username = (String)session.getAttribute("username");
        
        String emailQuery = "SELECT email FROM customers WHERE username = ?";
        PreparedStatement psEmail = con.prepareStatement(emailQuery);
        psEmail.setString(1, username);
        ResultSet rsEmail = psEmail.executeQuery();
        rsEmail.next();
        String userEmail = rsEmail.getString("email");

        String futureQuery = "SELECT * FROM reservation WHERE email = ? AND is_active = true AND departure_time >= CURDATE() ORDER BY departure_time ASC";
        PreparedStatement psFuture = con.prepareStatement(futureQuery);
        psFuture.setString(1, userEmail);
        ResultSet rsFuture = psFuture.executeQuery();
    %>
    
    <h3>Current Reservations</h3>
    <table border="1">
        <tr>
            <th>Reservation Number</th>
            <th>Train</th>
            <th>Line</th>
            <th>Departure Time</th>
            <th>Type</th>
            <th>Fare</th>
            <th>Actions</th>
        </tr>
        <% while(rsFuture.next()) { %>
            <tr>
                <td><%=rsFuture.getInt("reservation_number")%></td>
                <td><%=rsFuture.getInt("train")%></td>
                <td><%=rsFuture.getString("line_name")%></td>
                <td><%=rsFuture.getTimestamp("departure_time")%></td>
                <td><%=rsFuture.getString("reservation_type")%></td>
                <td>$<%=String.format("%.2f", rsFuture.getFloat("fare"))%></td>
                <td>
                    <form action="cancel_reservation.jsp" method="post" style="display: inline;">
                        <input type="hidden" name="reservation_number" value="<%=rsFuture.getInt("reservation_number")%>">
                        <input type="submit" value="Cancel">
                    </form>
                    <form action="view_travel_itinerary.jsp" method="post" style="display: inline;">
                        <input type="hidden" name="reservation_number" value="<%=rsFuture.getInt("reservation_number")%>">
                        <input type="submit" value="Travel Itinerary">
                    </form>
                </td>
            </tr>
        <% } %>
    </table>

    <%
        String pastQuery = "SELECT * FROM reservation r WHERE r.email = ? AND (r.is_active = false OR (r.is_active = true AND r.departure_time < CURDATE())) ORDER BY departure_time DESC";
        PreparedStatement psPast = con.prepareStatement(pastQuery);
        psPast.setString(1, userEmail);
        ResultSet rsPast = psPast.executeQuery();
    %>
    
    <h3>Past Reservations</h3>
<table border="1">
    <tr>
        <th>Reservation Number</th>
        <th>Train</th>
        <th>Line</th>
        <th>Departure Time</th>
        <th>Type</th>
        <th>Fare</th>
        <th>Actions</th>
    </tr>
    <% while(rsPast.next()) { %>
        <tr>
            <td><%=rsPast.getInt("reservation_number")%></td>
            <td><%=rsPast.getInt("train")%></td>
            <td><%=rsPast.getString("line_name")%></td>
            <td><%=rsPast.getTimestamp("departure_time")%></td>
            <td><%=rsPast.getString("reservation_type")%></td>
            <td>$<%=String.format("%.2f", rsPast.getFloat("fare"))%></td>
            <td>
                <form action="view_travel_itinerary.jsp" method="post">
                    <input type="hidden" name="reservation_number" value="<%=rsPast.getInt("reservation_number")%>">
                    <input type="submit" value="Travel Itinerary">
                </form>
            </td>
        </tr>
    <% } %>
</table>

    <%
        rsEmail.close();
        psEmail.close();
        rsFuture.close();
        psFuture.close();
        rsPast.close();
        psPast.close();
        con.close();
    } catch(Exception e) {
        out.println("Error: " + e);
    }
    %>
    
    <br>
    <form method="post" action="customer_landing.jsp">
        <input type="submit" value="Back">
    </form>
    <form method="post" action="forum_customer.jsp">
            <input type="submit" value="Customer Service Forum">
        </form>
</body>
</html>