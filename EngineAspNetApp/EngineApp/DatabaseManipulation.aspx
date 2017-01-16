<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DatabaseManipulation.aspx.cs" Inherits="EngineApp.DatabaseManipulation" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <p></p>
    <br />
   
    <h3>Adauga Carte:</h3>
    <table class="table">
        <tr>
            <td>
                <asp:Label ID="LabelAddFromEditura" runat="server">Editura:</asp:Label>
            </td>
            <td>
                <asp:DropDownList ID="DropDownShowFromEditura" runat="server" DataSourceID="SqlGetFromEditura" DataTextField="Nume" DataValueField="IdEditura">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlGetFromEditura" runat="server" ConnectionString="<%$ ConnectionStrings:EngineDatabase %>" SelectCommand="SELECT [IdEditura], [Nume] from [Editura]"></asp:SqlDataSource>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="LabelAddTitlu" runat="server">Titlu:</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="AddTitlu" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator CssClass="text-danger" runat="server" ControlToValidate="AddTitlu" ErrorMessage="The title field is required." ValidationGroup="addCarteGroup"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="LabelAddAutor" runat="server">Autor:</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="AddAutor" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator CssClass="text-danger" runat="server" ControlToValidate="AddAutor" ErrorMessage="The author field is required." ValidationGroup="addCarteGroup"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td><asp:Label ID="LabelAddDate" runat="server">Data publicare:</asp:Label></td>
            <td>
                <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <asp:Calendar ID="AddCarteDate" SelectedMode="Day" ShowGridLines="true" OnSelectionChanged="AddCarteDate_SelectionChanged" runat="server">
                            <SelectedDayStyle BackColor="Yellow"
                                   ForeColor="Red">
                            </SelectedDayStyle>
                        </asp:Calendar>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="LabelAddCategorie" runat="server">Categorie:</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="AddCategorie" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator CssClass="text-danger" runat="server" ControlToValidate="AddCategorie" ErrorMessage="The category field is required." ValidationGroup="addCarteGroup"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="LabelAddExemplareVandute" runat="server">Exemplare Vandute:</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="AddExemplareVandute" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator CssClass="text-danger" runat="server" ControlToValidate="AddExemplareVandute" ErrorMessage="The number field is required." ValidationGroup="addCarteGroup"></asp:RequiredFieldValidator>
            </td>
        </tr>
    </table>
    <p></p>
    <br />
    <asp:Button CssClass="btn btn-success" ID="AddCarteButton" runat="server" Text="Adauga Carte" OnClick="AddCarteButton_Click" ValidationGroup="addCarteGroup"/>
    <asp:Label ID="LabelAddStatus" runat="server" Text=""></asp:Label>
    <p></p>
    <br />

    <h3>Sterge Carte:</h3>
    <table class="table">
        <tr>
            <td>
                <asp:Label ID="LabelRemoveFromCarte" runat="server">Carti:</asp:Label>
            </td>
            <td>
                <asp:DropDownList ID="DDL_RemoveFromCarte" CssClass="form-control" runat="server" DataSourceID="SqlGetFromCarte" DataTextField="Titlu" DataValueField="IdCarte">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlGetFromCarte" runat="server" ConnectionString="<%$ ConnectionStrings:EngineDatabase %>" SelectCommand="SELECT [IdCarte], [Titlu] from [Carte]"></asp:SqlDataSource>
            </td>
        </tr>
    </table>
    <asp:Button CssClass="btn btn-danger" ID="RemoveCarteButton" runat="server" Text="Sterge Carte" OnClick="RemoveCarteButton_Click"/>
    <asp:Label ID="LabelRemoveStatus" runat="server" Text=""></asp:Label>
    <p></p>
    <br />

    <h3>Editeaza Carte:</h3>
    <table class="table">
        <tr>
            <td>
                <asp:Label ID="LabelGetCarte" runat="server">Selecteaza cartea pentru editat:</asp:Label>
            </td>
            <td>
                <asp:DropDownList ID="DDL_EditFromCarte" CssClass="form-control" runat="server" DataSourceID="SqlGetCarte" DataTextField="Titlu" DataValueField="IdCarte">
                </asp:DropDownList>
                <asp:SqlDataSource ID="SqlGetCarte" runat="server" ConnectionString="<%$ ConnectionStrings:EngineDatabase %>" SelectCommand="SELECT [IdCarte], [Titlu] from [Carte]"></asp:SqlDataSource>
            </td>
            <td>
                <asp:Button ID="SelectFromCarteButton" runat="server" CssClass="btn btn-primary" OnClick="SelectFromCarteButton_Click" Text="Afiseaza Carti"/>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="LabelEditEditura" runat="server">Editura:</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="EditEditura" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator CssClass="text-danger" runat="server" ControlToValidate="EditEditura" ErrorMessage="The text field is required." ValidationGroup="editCarteGroup"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="LabelEditTitlu" runat="server">Titlu:</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="EditTitlu" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator CssClass="text-danger" runat="server" ControlToValidate="EditTitlu" ErrorMessage="The text field is required." ValidationGroup="editCarteGroup"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="LabelEditAutor" runat="server">Autor:</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="EditAutor" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator CssClass="text-danger" runat="server" ControlToValidate="EditAutor" ErrorMessage="The text field is required." ValidationGroup="editCarteGroup"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="LabelEditDataPublicare" runat="server">Data Publicare:</asp:Label>
            </td>
            <td>
                 <asp:UpdatePanel runat="server">
                    <ContentTemplate>
                        <asp:Calendar ID="EditCarteDataPublicare" SelectedMode="Day" ShowGridLines="true" OnSelectionChanged="EditCarteDataPublicare_SelectionChanged" runat="server">
                            <SelectedDayStyle BackColor="Yellow"
                                   ForeColor="Red">
                            </SelectedDayStyle>
                        </asp:Calendar>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="LabelEditCategorie" runat="server">Categorie:</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="EditCategorie" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator CssClass="text-danger" runat="server" ControlToValidate="EditCategorie" ErrorMessage="The text field is required." ValidationGroup="editCarteGroup"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="LabelEditExemplareVandute" runat="server">Exemplare Vandute:</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="EditExemplareVandute" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator CssClass="text-danger" runat="server" ControlToValidate="EditExemplareVandute" ErrorMessage="The text field is required." ValidationGroup="editCarteGroup"></asp:RequiredFieldValidator>
            </td>
        </tr>
    </table>
    <p></p>
    <br />
    <asp:Button CssClass="btn btn-success" ID="EditCarteButton" runat="server" Text="Editeaza Carte" OnClick="EditCarteButton_Click" ValidationGroup="editCarteGroup"/>
    <asp:Label ID="LabelEditStatus" runat="server" Text=""></asp:Label>
    <p></p>
    <br />

</asp:Content>
