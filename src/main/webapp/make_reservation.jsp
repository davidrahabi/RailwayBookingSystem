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
        <title>Book a Reservation</title>
    </head>
    <body>
        <h2>Book a New Reservation</h2>
        
        <form method="post" action="process_reservation.jsp">
            <h3>Select Trip Type:</h3>
            <input type="radio" name="tripType" value="One Way" required> One Way
            <input type="radio" name="tripType" value="Round Trip"> Round Trip
            <br><br>
            
            <h3>Select Stations:</h3>
            <table>
                <tr>
                    <td>Origin Station:</td>
                    <td>
                        <select name="origin" required>
                            <option value="">Select Origin</option>
                            <%
                            try {
                                ApplicationDB db = new ApplicationDB();    
                                Connection con = db.getConnection();
                                Statement stmt = con.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT DISTINCT stationid, station_name FROM station");
                                while(rs.next()) {
                            %>
                                    <option value="<%=rs.getInt("stationid")%>">
                                        <%=rs.getString("station_name")%>
                                    </option>
                            <%
                                }
                                con.close();
                            } catch(Exception e) {
                                out.println("Error: " + e);
                            }
                            %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Destination Station:</td>
                    <td>
                        <select name="destination" required>
                            <option value="">Select Destination</option>
                            <%
                            try {
                                ApplicationDB db = new ApplicationDB();    
                                Connection con = db.getConnection();
                                Statement stmt = con.createStatement();
                                ResultSet rs = stmt.executeQuery("SELECT DISTINCT stationid, station_name FROM station");
                                while(rs.next()) {
                            %>
                                    <option value="<%=rs.getInt("stationid")%>">
                                        <%=rs.getString("station_name")%>
                                    </option>
                            <%
                                }
                                con.close();
                            } catch(Exception e) {
                                out.println("Error: " + e);
                            }
                            %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>Travel Date:</td>
                    <td><input type="date" name="travelDate" required></td>
                </tr>
                <tr class="returnDate" style="display:none;">
                    <td>Return Date:</td>
                    <td><input type="date" name="returnDate"></td>
                </tr>
            </table>
            
            <br>
            <input type="submit" value="Search Available Trains">
        </form>
        
        <br>
        <form method="post" action="customer_landing.jsp">
            <input type="submit" value="Back">
        </form>
        <form method="post" action="forum_customer.jsp">
            <input type="submit" value="Customer Service Forum">
        </form>
        
        
        <script>
            document.querySelectorAll('input[name="tripType"]').forEach(radio => {
                radio.addEventListener('change', function() {
                    const returnDateRow = document.querySelector('.returnDate');
                    if (this.value === 'Round Trip') {
                        returnDateRow.style.display = 'table-row';
                        document.querySelector('input[name="returnDate"]').required = true;
                    } else {
                        returnDateRow.style.display = 'none';
                        document.querySelector('input[name="returnDate"]').required = false;
                    }
                });
            });
        </script>
    </body>
</html>