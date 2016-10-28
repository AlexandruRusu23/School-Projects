/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.regex.*;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Alexandru
 */
@WebServlet(name = "deleteContact", urlPatterns = {"/deleteContact"})
public class deleteContact extends HttpServlet {

    private static final String EMAIL_PATTERN = 
		"^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
		+ "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
    private final String FIRSTNAME_PATTERN = "[a-zA-Z]+";
    private final String SURNAME_PATTERN = "[a-zA-Z]+";
    private final String PHONENUMB_PATTERN = "[0-9]+";
    
    private final Pattern VALID_EMAIL = Pattern.compile(EMAIL_PATTERN);
    private final Pattern VALID_FIRSTNAME = Pattern.compile(FIRSTNAME_PATTERN);
    private final Pattern VALID_SURNAME = Pattern.compile(SURNAME_PATTERN);
    private final Pattern VALID_PHONENUMB = Pattern.compile(PHONENUMB_PATTERN);
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    private static boolean check;
    
    private static Connection link;
    private static Statement statement;
    private static ResultSet results;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
       
        String id = request.getParameter("id");
        String firstName = request.getParameter("firstName");
        String surname = request.getParameter("surname");
        String mobilePhone = request.getParameter("mobilePhone");
        String email = request.getParameter("email");
        
        Matcher firstNameMatch = VALID_FIRSTNAME.matcher(firstName);
        Matcher surnameMatch = VALID_SURNAME.matcher(surname);
        Matcher mobilePhoneMatch = VALID_PHONENUMB.matcher(mobilePhone);
        Matcher emailMatch = VALID_EMAIL.matcher(email);
        
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet deleteContact</title>");            
            out.println("</head>");
            out.println("<body>");
            
            try
            { // connect to database
                   Class.forName("com.mysql.jdbc.Driver");
                   link = DriverManager.getConnection("jdbc:mysql://localhost:3306/onlineagenda", "root", "root");
                }
                catch(ClassNotFoundException cnfEx)
                {
                System.out.println ("* Nu am putut incarca driverul! *");
            }
            catch(SQLException sqlEx)
                {
                   System.out.println("* Nu m-am putut conecta la baza de date! *");
                }
            
            try
                {
                    statement = link.createStatement();
                    System.out.println("Incerc sa sterg");
                    if(check == false)
                    {   
                        String remove;
                        
                        if(!"".equals(id))
                        {
                            remove = "DELETE from onlineagenda.contacts where "
                                    + "acctNum ='" +id+"';";
                        }
                        else
                        {
                            int cont = 1;
                            String search = "select acctNum from onlineagenda.contacts"
                                        + " where ";
                            if(firstNameMatch.find())
                            {
                                cont ++;
                                search = search + " firstname ='"+ firstName + "' ";                                
                            }
                            if(surnameMatch.find())
                            {
                                if(cont > 1)
                                {
                                    search = search + "and surname ='"+ surname + "' ";
                                }
                                else
                                    search = search + " surname ='"+ surname + "' ";
                                cont ++;
                            }
                            if(mobilePhoneMatch.find())
                            {
                                if(cont > 1)
                                {
                                    search = search + "and phonenumber ='"+ mobilePhone + "' ";
                                }
                                else
                                    search = search + " phonenumber ='"+ mobilePhone + "' ";
                                cont ++;
                            }
                            if(emailMatch.find())
                            {
                                if(cont > 1)
                                {
                                    search = search + "and email ='"+ email + "' ";
                                }
                                else
                                {
                                    search = search + " email ='"+ email + "' ";
                                }
                            }
                            search = search + "; ";
                            
                            results = statement.executeQuery(search);
                            while(results.next())
                            {
                                id = results.getString(1);
                            }
                            remove = "DELETE from onlineagenda.contacts where "
                                + "acctNum ='" +id+"';";
                        }
                        int result = statement.executeUpdate(remove);
                        if (result == 0)
                        {
                            System.out.println("\nUnable to delete!");
                        }
                        else
                        {
                            check = true;
                        }
                    }
                    
                    link.close();
                }
                catch(SQLException sqlEx)
                {
                    System.out.println("* Eroare de conexiune sau interogare SQL! *");
                }
            
            if(check == true)
            {
                out.println("<p> Delete succeded!</p>");
            }
            else
            {
                out.println("<p> Delete NOT work</p>");
            }
            
            out.println("</body>");
            out.println("</html>");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
