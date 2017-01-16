<%@ Page Title="All Items" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AllDatabaseItems.aspx.cs" Inherits="EngineApp.AllDatabaseItems" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <section>
        <div>
            <hgroup>
                <h2><%: Page.Title %></h2>
            </hgroup>

            <p></p>
            <hr />
            <asp:GridView ID="ItemList" runat="server" CssClass="table" DataSourceID="SqlShowItems" AutoGenerateColumns="false">
                <Columns>
                    <asp:BoundField DataField="IdCarte" HeaderText="ID" SortExpression="IdCarte" />
                    <asp:BoundField DataField="IdEditura" HeaderText="ID Editura" SortExpression="IdEditura" />
                    <asp:BoundField DataField="Titlu" HeaderText="Titlu" SortExpression="Titlu" />
                    <asp:BoundField DataField="Autor" HeaderText="Autor" SortExpression="Autor" />
                    <asp:BoundField DataField="DataPublicare" HeaderText="Data Publicare" SortExpression="DataPublicare" />
                    <asp:BoundField DataField="Categorie" HeaderText="Categorie" SortExpression="Categorie" />
                    <asp:BoundField DataField="ExemplareVandute" HeaderText="Exemplare Vandute" SortExpression="ExemplareVandute" />
                </Columns>
            </asp:GridView>
            <asp:SqlDataSource ID="SqlShowItems" runat="server" ConnectionString="<%$ ConnectionStrings:EngineDatabase %>" SelectCommand="SELECT [IdCarte], [IdEditura], [Titlu], [Autor], [DataPublicare], [Categorie], [ExemplareVandute] FROM [Carte]">
            </asp:SqlDataSource>

            <p></p>
            <br />

            <asp:DetailsView ID="DetailsView1" runat="server" CssClass="table" AutoGenerateRows="false" AllowPaging="true" OnPageIndexChanging = "OnPageIndexChanging">
                <Fields>
                <asp:BoundField DataField="IdCarte" HeaderText="ID" HeaderStyle-CssClass="header" />
                <asp:BoundField DataField="IdEditura" HeaderText="ID Editura" HeaderStyle-CssClass="header" />
                <asp:BoundField DataField="Titlu" HeaderText="Titlu" HeaderStyle-CssClass="header" />
                <asp:BoundField DataField="Autor" HeaderText="Autor" HeaderStyle-CssClass="header" />
                <asp:BoundField DataField="DataPublicare" HeaderText="Data Publicare" HeaderStyle-CssClass="header" />
                <asp:BoundField DataField="Categorie" HeaderText="Categorie" HeaderStyle-CssClass="header" />
                <asp:BoundField DataField="ExemplareVandute" HeaderText="Exemplare Vandute" HeaderStyle-CssClass="header" />
                </Fields>
            </asp:DetailsView>

            <p></p>
            <br />

        </div>
    </section>
</asp:Content>
