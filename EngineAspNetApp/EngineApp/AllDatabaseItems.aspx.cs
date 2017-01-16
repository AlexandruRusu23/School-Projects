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
    public partial class AllDatabaseItems : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                this.BindDetailsView();
            }
        }

        private void BindDetailsView()
        {
            string constr = ConfigurationManager.ConnectionStrings["EngineDatabase"].ConnectionString;
            SqlConnection con = new SqlConnection(constr);
            string comm = "SELECT IdCarte, IdEditura, Titlu, Autor, DataPublicare, Categorie, ExemplareVandute FROM Carte";
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
                            DetailsView1.DataSource = dt;
                            DetailsView1.DataBind();
                        }
                    }
             }
            catch(Exception ex)
                {
                
                }
        }

        protected void OnPageIndexChanging(object sender, DetailsViewPageEventArgs e)
        {
            DetailsView1.PageIndex = e.NewPageIndex;
            this.BindDetailsView();
        }
    }
}