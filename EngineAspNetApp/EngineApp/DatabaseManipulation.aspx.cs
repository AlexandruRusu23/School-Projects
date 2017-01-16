using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace EngineApp
{
    public partial class DatabaseManipulation : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            AddCarteDate.SelectedDate = DateTime.Today;
        }

        protected void AddCarteButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    SqlConnection connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["EngineDatabase"].ConnectionString);

                    string insertNewCarte = "INSERT INTO [Carte] (IdCarte, IdEditura, Titlu, Autor, DataPublicare, Categorie, ExemplareVandute) VALUES (@id_carte, @id_editura, @titlu, @autor, @data_publicare, @categorie, @exemplare_vandute)";

                    connection.Open();

                    try
                    {
                        SqlCommand command = new SqlCommand(insertNewCarte, connection);

                        int nextId = 1;

                        try
                        {
                            string getMaxId = "SELECT MAX(IdCarte) FROM Carte";

                            SqlCommand com = new SqlCommand(getMaxId, connection);
                            nextId = Convert.ToInt32(com.ExecuteScalar());
                            nextId++;
                        }
                        catch (Exception ex)
                        {
                            LabelAddStatus.Text = "Error in database: " + ex.Message;
                        }

                        command.Parameters.AddWithValue("id_carte", nextId);
                        command.Parameters.AddWithValue("id_editura", DropDownShowFromEditura.SelectedValue);
                        command.Parameters.AddWithValue("titlu", AddTitlu.Text);
                        command.Parameters.AddWithValue("autor", AddAutor.Text);
                        command.Parameters.AddWithValue("data_publicare", AddCarteDate.SelectedDate);
                        command.Parameters.AddWithValue("categorie", AddCategorie.Text);
                        command.Parameters.AddWithValue("exemplare_vandute", Convert.ToInt32(AddExemplareVandute.Text));

                        command.ExecuteNonQuery();

                        LabelAddStatus.Text = "Book added successfully.";
                    }
                    catch (Exception ex)
                    {
                        LabelAddStatus.Text = "Database insert error: " + ex.Message;
                    }
                    finally
                    {
                        connection.Close();
                    }
                }
                catch (SqlException se)
                {
                    LabelAddStatus.Text = "Database connection error: " + se.Message;
                }
                catch (Exception ex)
                {
                    LabelAddStatus.Text = "Data conversion error: " + ex.Message;
                }
            }
        }

        protected void RemoveCarteButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    SqlConnection connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["EngineDatabase"].ConnectionString);

                    string deleteFromPrimary = "DELETE FROM [Carte] WHERE IdCarte = @id_carte";

                    connection.Open();

                    try
                    {
                        SqlCommand command = new SqlCommand(deleteFromPrimary, connection);

                        command.Parameters.AddWithValue("id_carte", DDL_RemoveFromCarte.SelectedValue);
                        
                        command.ExecuteNonQuery();

                        LabelRemoveStatus.Text = "Book deleted successfully.";
                    }
                    catch (Exception ex)
                    {
                        LabelRemoveStatus.Text = "Database delete error: " + ex.Message;
                    }
                    finally
                    {
                        connection.Close();
                    }
                }
                catch (SqlException se)
                {
                    LabelRemoveStatus.Text = "Database connection error: " + se.Message;
                }
                catch (Exception ex)
                {
                    LabelRemoveStatus.Text = "Data conversion error: " + ex.Message;
                }
            }
            Response.Redirect(Request.RawUrl);
        }

        protected void SelectFromCarteButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    SqlConnection connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["EngineDatabase"].ConnectionString);

                    string deleteFromPrimary = "SELECT IdCarte, IdEditura, Titlu, Autor, DataPublicare, Categorie, ExemplareVandute FROM [Carte] WHERE IdCarte = @id";

                    connection.Open();

                    try
                    {
                        SqlCommand command = new SqlCommand(deleteFromPrimary, connection);

                        command.Parameters.AddWithValue("id", DDL_EditFromCarte.SelectedValue);

                        SqlDataReader reader = command.ExecuteReader();

                        LabelEditStatus.Text = "Book selected successfully.";

                        while (reader.Read())
                        {
                            EditEditura.Text = Convert.ToString(reader["IdEditura"].ToString());
                            EditTitlu.Text = Convert.ToString(reader["Titlu"].ToString());
                            EditAutor.Text = Convert.ToString(reader["Autor"].ToString());
                            EditCarteDataPublicare.SelectedDate = Convert.ToDateTime(reader["DataPublicare"].ToString());
                            EditCarteDataPublicare.TodaysDate = Convert.ToDateTime(reader["DataPublicare"].ToString());
                            EditCategorie.Text = Convert.ToString(reader["Categorie"].ToString());
                            EditExemplareVandute.Text = Convert.ToString(reader["ExemplareVandute"].ToString());
                        }
                    }
                    catch (Exception ex)
                    {
                        LabelEditStatus.Text = "Database select error: " + ex.Message;
                    }
                    finally
                    {
                        connection.Close();
                    }
                }
                catch (SqlException se)
                {
                    LabelEditStatus.Text = "Database connection error: " + se.Message;
                }
                catch (Exception ex)
                {
                    LabelEditStatus.Text = "Data conversion error: " + ex.Message;
                }
            }
        }

        protected void EditCarteButton_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    SqlConnection connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["EngineDatabase"].ConnectionString);

                    string updateInPrimary = "UPDATE [Carte] SET [IdEditura] = @id_editura, [Titlu] = @titlu, [Autor] = @autor, [DataPublicare] = @data_publicare, [Categorie] = @categorie, [ExemplareVandute] = @exemplare_vandute WHERE IdCarte = @id";

                    connection.Open();

                    try
                    {
                        SqlCommand command = new SqlCommand(updateInPrimary, connection);

                        command.Parameters.AddWithValue("@id", DDL_EditFromCarte.SelectedValue);
                        command.Parameters.AddWithValue("@id_editura", EditEditura.Text);
                        command.Parameters.AddWithValue("@titlu", EditTitlu.Text);
                        command.Parameters.AddWithValue("@autor", EditAutor.Text);
                        command.Parameters.AddWithValue("@data_publicare", EditCarteDataPublicare.SelectedDate);
                        command.Parameters.AddWithValue("@categorie", EditCategorie.Text);
                        command.Parameters.AddWithValue("@exemplare_vandute", EditExemplareVandute.Text);

                        command.ExecuteNonQuery();

                        LabelEditStatus.Text = "Book updated successfully.";
                    }
                    catch (Exception ex)
                    {
                        LabelEditStatus.Text = "Database update error: " + ex.Message;
                    }
                    finally
                    {
                        connection.Close();
                    }
                }
                catch (SqlException se)
                {
                    LabelEditStatus.Text = "Database connection error: " + se.Message;
                }
                catch (Exception ex)
                {
                    LabelEditStatus.Text = "Data conversion error: " + ex.Message;
                }
            }
            Response.Redirect(Request.RawUrl);
        }

        protected void AddCarteDate_SelectionChanged(object sender, EventArgs e)
        {

        }

        protected void EditCarteDataPublicare_SelectionChanged(object sender, EventArgs e)
        {

        }
    }
}