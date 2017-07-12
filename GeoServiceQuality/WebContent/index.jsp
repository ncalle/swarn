<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<html>
<head>

   <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">
    
    <title>Login </title> 
	
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap.min.css">
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.0.2/css/bootstrap-theme.min.css">
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" ></script>
	
	 <!-- Custom styles for this template -->
    <link href="./css/signin.css" rel="stylesheet">
	
	
</head>
<body>
	
	
      <form class="form-signin" action="loginServlet" method="post">
        <h3 class="form-signin-heading">GeoServiceQuality</h3>
        
        <label for="inputEmail" class="sr-only">Email</label>
        <input type="email" id="inputEmail" class="form-control" placeholder="Email address" name="username" required autofocus>
        
        <label for="inputPassword" class="sr-only">Password</label>
        <input type="password" id="inputPassword" class="form-control" placeholder="Password" name="userpass" required>
        
        <button class="btn btn-lg btn-secondary btn-block" type="submit" value="Login">Login</button>
        <h4 class="form-signin-text">Olvidé mi contraseña</h4>
      </form>
      

</body>
</html>