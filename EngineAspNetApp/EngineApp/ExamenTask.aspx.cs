using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

namespace EngineApp
{
    public partial class ExamenTask : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        private void BindDetailsView()
        {
            string constr = ConfigurationManager.ConnectionStrings["EngineDatabase"].ConnectionString;
            SqlConnection con = new SqlConnection(constr);
            string comm = "SELECT IdCarte, IdEditura, Titlu, Autor, DataPublicare, Categorie, ExemplareVandute FROM [Carte]";
            SqlCommand cmd = new SqlCommand(comm);

            try
            {
                using (SqlDataAdapter sda = new SqlDataAdapter())
                {
                    cmd.Connection = con;
                    sda.SelectCommand = cmd;
                    using (DataTable dt = new DataTable())
                    {
                        sda.Fill(dt);
                        SearchedItemsDetailsView.DataSource = dt;
                        SearchedItemsDetailsView.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }

        protected void SearchCarteButton_Click(object sender, EventArgs e)
        {
            string constr = ConfigurationManager.ConnectionStrings["EngineDatabase"].ConnectionString;
            SqlConnection con = new SqlConnection(constr);
            string comm = "SELECT IdCarte, IdEditura, Titlu, Autor, DataPublicare, Categorie, ExemplareVandute FROM [Carte] WHERE ExemplareVandute >= @min_value AND ExemplareVandute <= @max_value";
            SqlCommand cmd = new SqlCommand(comm);

            try
            {
                using (SqlDataAdapter sda = new SqlDataAdapter())
                {
                    cmd.Connection = con;
                    sda.SelectCommand = cmd;
                    sda.SelectCommand.Parameters.AddWithValue("@min_value", SearchMinValue.Text);
                    sda.SelectCommand.Parameters.AddWithValue("@max_value", SearchMaxValue.Text);

                    using (DataTable dt = new DataTable())
                    {
                        sda.Fill(dt);
                        SearchedItemsDetailsView.DataSource = dt;
                        SearchedItemsDetailsView.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                LabelSearchStatus.Text = "Failed";
            }
        }

        protected void SearchedItemsDetailsView_PageIndexChanging(object sender, DetailsViewPageEventArgs e)
        {
            SearchedItemsDetailsView.PageIndex = e.NewPageIndex;
            if (SearchMinValue.Text != "" && SearchMaxValue.Text != "")
                this.SearchCarteButton_Click(sender, e);
            else
                this.BindDetailsView();
        }

        protected void ShowItems_Click(object sender, EventArgs e)
        {
            this.BindDetailsView();
        }
    }
}