package service;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class LogoutServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;

	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		try{
			System.out.println("LogoutServlet...");
			
			HttpSession session = ((HttpServletRequest) request).getSession(false);
			session.invalidate();
			response.sendRedirect(request.getContextPath() + "/index.jsp");
			
		} catch(Exception e) {
			System.out.println("LoginServlet Exception:" + e);
		}

	}
}  