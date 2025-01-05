<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>
</head>
<body>

Register customer credentials:
<br>
<form method="post" action = "registerCust.jsp">
<table>
<tr>    
<td>Email</td><td><input type="text" name="email">
</tr>
<tr>    
<td>Username</td><td><input type="text" name="username">
</tr>
<tr>
<td>Password</td><td><input type="password" name="password">
</tr>
<tr>    
<td>First name</td><td><input type="text" name="fname">
</tr>
<tr>    
<td>Last name</td><td><input type="text" name="lname">
</tr>
<tr>    
<td>Are you a minor?</td><td><label><input type="radio" name="minor" value="1"> True</label><label><input type="radio" name="minor" value="0"> False</label>
</tr>
<tr>    
<td>Are you a senior?</td><td><label><input type="radio" name="senior" value="1"> True</label><label><input type="radio" name="senior" value="0"> False</label>
</tr>
<tr>    
<td>Are you disabled?</td><td><label><input type="radio" name="disabled" value="1"> True</label><label><input type="radio" name="disabled" value="0"> False</label>
</tr>
</table>
<input type="submit" value="RegisterCust">
</form>
<br>

</body>
</html>