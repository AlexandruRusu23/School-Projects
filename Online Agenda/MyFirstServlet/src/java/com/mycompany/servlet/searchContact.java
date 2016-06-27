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
@WebServlet(name = "searchContact", urlPatterns = {"/searchContact"})
public class searchContact extends HttpServlet {

    private static final String EMAIL_PATTERN = 
        "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
	+ "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
    private final String FIRSTNAME_PATTERN = "[a-zA-Z]+";
    private final String SURNAME_PATTERN = "[a-zA-Z]+";
    private final String PHONENUMB_PATTERN = "[0-9]+";
    private final String ZIPCODE_PATTERN = "[0-9]+";
    private final String CITY_PATTERN = "[A-Za-z]+";
    
    private final Pattern VALID_EMAIL = Pattern.compile(EMAIL_PATTERN);
    private final Pattern VALID_FIRSTNAME = Pattern.compile(FIRSTNAME_PATTERN);
    private final Pattern VALID_SURNAME = Pattern.compile(SURNAME_PATTERN);
    private final Pattern VALID_PHONENUMB = Pattern.compile(PHONENUMB_PATTERN);
    private final Pattern VALID_ZIPCODE = Pattern.compile(ZIPCODE_PATTERN);
    private final Pattern VALID_CITY = Pattern.compile(CITY_PATTERN);
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
        String fixPhone = request.getParameter("fixPhone");
        String email = request.getParameter("email");
        String adress = request.getParameter("adress");
        String city = request.getParameter("city");
        String region = request.getParameter("region");
        String zipCode = request.getParameter("zipCode");
        
        Matcher firstNameMatch = VALID_FIRSTNAME.matcher(firstName);
        Matcher surnameMatch = VALID_SURNAME.matcher(surname);
        Matcher mobilePhoneMatch = VALID_PHONENUMB.matcher(mobilePhone);
        Matcher fixPhoneMatch = VALID_PHONENUMB.matcher(fixPhone);
        Matcher emailMatch = VALID_EMAIL.matcher(email);
        Matcher adressMatch = VALID_CITY.matcher(adress);
        Matcher cityMatch = VALID_CITY.matcher(city);
        Matcher regionMatch = VALID_CITY.matcher(region);
        Matcher zipMatch = VALID_ZIPCODE.matcher(zipCode);
        
        out.println("<html>");
        out.println("<head>");
        out.println("<title>MODIFY Contact</title>");
        out.println("</head>");
        out.println("<body>");
        
                //modificare contact in baza de date 
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
                
                // search contact in the database
                try
                {
                    int cont = 1;
                    statement = link.createStatement();
                    String search = "select * from onlineagenda.contacts where ";
                    
                    if(!"".equals(id))
                    {
                        cont++;
                        search = search + " acctNum ='" +id + "' ";
                    }
                    if(firstNameMatch.find())
                    {
                        if(cont > 1)
                            search = search + " and firstname ='" + firstName + "' ";
                        else 
                            search = search + " firstname ='" + firstName + "' ";
                        cont++;
                    }
                    if(surnameMatch.find())
                    {
                        if(cont > 1)
                            search = search + " and surname ='" + surname +"' ";
                        else
                            search = search + " surname = '" +surname +"' ";
                        cont ++;
                    }
                    if(mobilePhoneMatch.find())
                    {
                        if(cont > 1)
                            search = search + " and phonenumber ='" + mobilePhone +"' ";
                        else
                            search = search + " phonenumber = '" + mobilePhone +"' ";
                        cont ++;
                    }
                    if(fixPhoneMatch.find())
                    {
                        if(cont > 1)
                            search = search + " and fixnumber ='" + fixPhone +"' ";
                        else
                            search = search + " fixnumber = '" + fixPhone +"' ";
                        cont ++;
                    }
                    if(emailMatch.find())
                    {
                        if(cont > 1)
                            search = search + " and email ='" + email +"' ";
                        else
                            search = search + " email = '" + email +"' ";
                        cont ++;
                    }
                    if(adressMatch.find())
                    {
                        if(cont > 1)
                            search = search + " and adress ='" + adress +"' ";
                        else
                            search = search + " adress = '" + adress +"' ";
                        cont ++;
                    }
                    if(cityMatch.find())
                    {
                        if(cont > 1)
                            search = search + "and city ='" + city +"' ";
                        else
                            search = search + " city = '" + city +"' ";
                        cont ++;
                    }
                    if(regionMatch.find())
                    {
                        if(cont > 1)
                            search = search + "and region ='" + region +"' ";
                        else
                            search = search + " region = '" + region +"' ";
                        cont ++;
                    }
                    if(zipMatch.find())
                    {
                        if(cont > 1)
                            search = search + "and zipcode ='" + zipCode +"' ";
                        else
                            search = search + " zipcode = '" + zipCode +"' ";
                        cont ++;
                    }
                    
                    if(cont > 1 )
                    {
                        search = search + " ; ";                       
                            
                        results = statement.executeQuery(search);
                        while(results.next())
                        {
                            out.println("<p>" + results.getString(2) + " " +
                                results.getString(3) + " " + results.getString(4) +
                                " " + results.getString(6) + "</p>");
                        }
                        check = true;
                            
                        link.close();
                    }
                }
                catch(SQLException sqlEx)
                {
                    System.out.println("* Eroare de conexiune sau interogare SQL! *");
                }
                
        if(check == false)
        {
            out.println("<h1> Contact NOT found!</h1>");
        }
        
        out.println("<a href =\"index.html\"> HOME </a> <br><br>");
        out.println("<a href =\"searchContact.html\"> Search another contact </a> <br><br>");
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
