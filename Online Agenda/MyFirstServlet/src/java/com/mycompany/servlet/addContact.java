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
@WebServlet(name = "addContact", urlPatterns = {"/addContact"})
public class addContact extends HttpServlet {

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
    
    private static int id;
    private static boolean check;
    
    private static Connection link;
    private static Statement statement;
    private static ResultSet results;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
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
        out.println("<title>ADD Contact</title>");
        out.println("</head>");
        out.println("<body>");
        
        check = false;
        if(firstNameMatch.find() && surnameMatch.find() && mobilePhoneMatch.find() && emailMatch.find())
        {
                //inserare contact in baza de date 
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
                
                // insert the new contact in the database
                try
                {
                    statement = link.createStatement();
                    
                    System.out.println("Incerc sa inserez");
                    String insert = "INSERT INTO onlineagenda.contacts (acctNum,firstname,"
                            + "surname, phonenumber, email";
                    String cont = "values ('"+mobilePhone+"','" + firstName + 
                            "','" + surname + "','" + mobilePhone + "','"+ email
                            + "' ";
                    
                    if(fixPhoneMatch.find())
                    {
                        insert = insert + ", fixnumber";
                        cont = cont + ", '" + fixPhone + "' ";
                    }
                    if(adressMatch.find())
                    {
                        insert = insert + ", adress";
                        cont = cont + ", '" + adress + "' ";
                    }
                    if(cityMatch.find())
                    {
                        insert = insert + ", city";
                        cont = cont + ", '" + city + "' ";
                    }
                    if(regionMatch.find())
                    {
                        insert = insert + ", region";
                        cont = cont + ", '" + region + "' ";
                    }
                    if(zipMatch.find())
                    {
                        insert = insert + ", zipcode";
                        cont = cont + ", '" + zipCode + "' ";
                    }
                    insert = insert +") ";
                    cont = cont + ");";
                    
                    insert = insert + cont;
                    
                    int result = statement.executeUpdate(insert);
                    if (result == 0)
                       System.out.println("\nUnable to insert record!");
                    else
                        check = true;
                    link.close();
                }
                catch(SQLException sqlEx)
                {
                    System.out.println("* Eroare de conexiune sau interogare SQL! *");
                }
        }
        
        if(check == false)
        {
            out.println("<h1> Contact NOT saved!</h1>");
        }
        else
        {
            out.println("<h1>Contact saved!</h1>");
            out.println("<p>You added " + firstName + " " + surname + " with id:" + id + "</p>");
        }
        
        out.println("<a href =\"index.html\"> HOME </a> <br><br>");
        out.println("<a href =\"addContact.html\"> Add another contact </a> <br><br>");
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
