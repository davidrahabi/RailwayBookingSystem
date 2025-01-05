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
        <title>Canceling Reservation</title>
    </head>
    <body>
        <%
        try {
            ApplicationDB db = new ApplicationDB();
            Connection con = db.getConnection();

            int reservationNumber = Integer.parseInt(request.getParameter("reservation_number"));
            String username = (String)session.getAttribute("username");
            
            String emailQuery = "SELECT email FROM customers WHERE username = ?";
            PreparedStatement psEmail = con.prepareStatement(emailQuery);
            psEmail.setString(1, username);
            ResultSet rsEmail = psEmail.executeQuery();
            
            if(rsEmail.next()) {
                String email = rsEmail.getString("email");
                
                String verifyQuery = "SELECT * FROM reservation WHERE reservation_number = ? AND email = ? AND is_active = true AND departure_time > NOW()";
                PreparedStatement psVerify = con.prepareStatement(verifyQuery);
                psVerify.setInt(1, reservationNumber);
                psVerify.setString(2, email);
                ResultSet rsVerify = psVerify.executeQuery();

                if(rsVerify.next()) {
                    String cancelQuery = "UPDATE reservation SET is_active = false WHERE reservation_number = ? OR (pair_id = ? AND is_active = true)";
                    PreparedStatement psCancel = con.prepareStatement(cancelQuery);
                    psCancel.setInt(1, reservationNumber);
                    psCancel.setInt(2, reservationNumber);
                    int rowsAffected = psCancel.executeUpdate();

                    if(rowsAffected > 1) {
                        %>
                        <h2>Round Trip Reservation Cancelled</h2>
                        <p>Outbound and return reservations have been cancelled.</p>
                        <%
                    } else {
                        %>
                        <h2>Reservation Successfully Cancelled</h2>
                        <p>Your reservation (<%=reservationNumber%>) has been cancelled.</p>
                        <%
                    }
                    psCancel.close();
                } else {
                    %>
                    <h2>Error</h2>
                    <p>Unable to cancel reservation.</p>
                    <%
                }
                rsVerify.close();
                psVerify.close();
            }
            rsEmail.close();
            psEmail.close();
            con.close();

        } catch(Exception e) {
            out.println("Error: " + e.getMessage());
        }
        %>

        <br><br>
        <script>
            setTimeout(function() {
                window.location.href = 'view_my_reservations.jsp';
            }, 3000);
        </script>

        Redirecting back to reservations page...
        <br><br>
        <form method="post" action="view_my_reservations.jsp">
            <input type="submit" value="Back to Reservations">
        </form>
        <form method="post" action="forum_customer.jsp">
            <input type="submit" value="Customer Service Forum">
        </form>
    </body>
</html>