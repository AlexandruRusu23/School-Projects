<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ExamenTask.aspx.cs" Inherits="EngineApp.ExamenTask" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <p></p>
    <asp:Button ID="ShowItems" CssClass="btn btn-success" runat="server" Text="Show Items" OnClick="ShowItems_Click"/>
    <asp:Label ID="LabelSearchStatus" Text="" runat="server"></asp:Label>
    <p></p>
    <br />
    <h3>Cauta Carti:</h3>
    <table class ="table">
        <tr>
            <td>
                <asp:Label ID="LabelSearchMinValue" runat="server" Text="Introduceti numarul minim de exemplare:"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="SearchMinValue" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="reqMinTextBox" CssClass="text-danger" ControlToValidate="SearchMinValue" ErrorMessage="Text min field is required." runat="server" ValidationGroup="textGroup"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="LabelSearchMaxValue" runat="server" Text="Introduceti numarul maxim de exemplare:"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="SearchMaxValue" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="reqMaxTextBox" CssClass="text-danger" ControlToValidate="SearchMaxValue" ErrorMessage="Text max field is required." runat="server" ValidationGroup="textGroup"></asp:RequiredFieldValidator>
            </td>
        </tr>
    </table>
    <asp:Button ID="SearchCarteButton" runat="server" CssClass="btn btn-primary" OnClick="SearchCarteButton_Click" Text="Cauta Carti" ValidationGroup="textGroup"/>
    <p></p>
    <br />

    <asp:DetailsView ID="SearchedItemsDetailsView" runat="server" CssClass="table" AutoGenerateRows="false" AllowPaging="true" OnPageIndexChanging="SearchedItemsDetailsView_PageIndexChanging">
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

</asp:Content>
