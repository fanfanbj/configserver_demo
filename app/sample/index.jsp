<%-- 
    Document   : index
    Created on : Dec 21, 2015, 4:33:25 PM
    Author     : bruno
--%>
<%@page import="java.net.UnknownHostException"%>
<%@page import="java.net.InetAddress"%>

<%@page import="java.io.*"%>
<%@page import="java.util.*"%>

<%
   String config_file = System.getenv("config_file");
   System.out.println(config_file);		
   FileInputStream inputStream = new FileInputStream(config_file);
   Properties p = new Properties();
   try {
   	p.load(inputStream);
   }catch (IOException e) {
	e.printStackTrace();
   }

%>

<%
    String hostname, serverAddress;
    hostname = "error";
    serverAddress = "error";
    try {
        InetAddress inetAddress;
        inetAddress = InetAddress.getLocalHost();
        hostname = inetAddress.getHostName();
        serverAddress = inetAddress.toString();
    } catch (UnknownHostException e) {
        e.printStackTrace();
    }
%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>app on Docker - Request Information</h1>
        <ul>
            <li>getVirtualServerName(): <%= request.getServletContext().getVirtualServerName() %></li>
            <li>InetAddress.hostname: <%=hostname%></li>
            <li>InetAddress.serverAddress: <%=serverAddress%></li>
            <li>getLocalAddr(): <%=request.getLocalAddr()%></li>
            <li>getLocalName(): <%=request.getLocalName()%></li>
            <li>getLocalPort(): <%=request.getLocalPort()%></li>
            <li>getServerName(): <%=request.getServerName()%></li>
        </ul>
	<h1>Properties Information</h1>
	<ul>
		<li>DB_HOST:<%=p.getProperty("DB_HOST")%></li>
		<li>DB_PORT:<%=p.getProperty("DB_PORT")%></li>
		<li>DB_NAME:<%=p.getProperty("DB_NAME")%></li>
		<li>DB_USER:<%=p.getProperty("DB_USER")%></li>
		<li>DB_PW:<%=p.getProperty("DB_PW")%></li>
	</ul>    
	</body>
</html>
