package service;

import java.io.IOException;
import java.io.PrintWriter;

import javax.ejb.EJB;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import entity.User;
import dao.UserBeanRemote;


public class LoginServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;

    @EJB
    private UserBeanRemote userBean;
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)  
			throws ServletException, IOException { 
       
		try{
			System.out.println("LoginServlet doPost...");
			response.setContentType("text/html");  
			PrintWriter out = response.getWriter();  
			
			String userName = request.getParameter("username");  
			String userPassword = request.getParameter("userpass"); 
			
	        User foundUser = userBean.find(userName, userPassword);
	        System.out.println("Se ha encontrado el usuario: " + foundUser);
	        
	        if(foundUser!=null){
				HttpSession session = request.getSession(false);
					
				if(session!=null) {
					session.setAttribute("name", foundUser.getFirstName() + ' ' + foundUser.getLastName());
					session.setAttribute("userId", foundUser.getUserId());
					
				}
	        	request.getRequestDispatcher("home.xhtml");
	        	response.sendRedirect(request.getContextPath() + "/home.xhtml");
	        }
	        				
			 else{  
				out.println("<div class=\"alert alert-danger\" role=\"alert\">"
						+ "<span class=\"glyphicon glyphicon-exclamation-sign\" aria-hidden=\"true\">"
						+ "</span><span class=\"sr-only\">Error:</span>"
						+ " Usuario o password incorrectos</div>");
				     
				RequestDispatcher rd = request.getRequestDispatcher("index.jsp");  
				rd.include(request,response);  
			}  

			out.close();  
		} catch(Exception e) {
			System.out.println("LoginServlet Exception:" + e);
		}

		
	}  
}  