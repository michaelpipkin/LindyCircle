<%@ Page Title="Practices" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="practices.aspx.cs" Inherits="LindyCircle.Pages.practices" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        .grid-column-right {
            width: 75px;
            text-align: right;
            padding-right: 2px;
        }
    </style>
    <asp:ObjectDataSource ID="odsPractices" runat="server"
        SelectMethod="GetPractices" TypeName="LindyCircle.PracticeDB" DeleteMethod="DeletePractice">
        <DeleteParameters>
            <asp:Parameter Name="practiceID" Type="Int32" />
        </DeleteParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="txtStartDate" Name="startDate" PropertyName="Text" Type="DateTime" />
            <asp:ControlParameter ControlID="txtEndDate" Name="endDate" PropertyName="Text" Type="DateTime" />
            <asp:ControlParameter ControlID="txtTopic" Name="topic" PropertyName="Text" Type="String" 
                ConvertEmptyStringToNull="False" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <br />
    Start Date<asp:TextBox ID="txtStartDate" runat="server" CssClass="textbox" Width="75px"></asp:TextBox>
    <asp:CompareValidator ID="valStartDate" runat="server" ErrorMessage="Start Date must be a valid date."
        ControlToValidate="txtStartDate" CssClass="warning" Display="Dynamic" Operator="DataTypeCheck" Type="Date"
        ValidationGroup="vgFilter">*</asp:CompareValidator>
    &nbsp;End Date<asp:TextBox ID="txtEndDate" runat="server" CssClass="textbox" Width="75px"></asp:TextBox>
    <asp:CompareValidator ID="valEndDate" runat="server" ErrorMessage="End Date must be a valid date."
        ControlToValidate="txtEndDate" CssClass="warning" Display="Dynamic" Operator="DataTypeCheck" Type="Date"
        ValidationGroup="vgFilter">*</asp:CompareValidator>
    <asp:CompareValidator ID="valCompareDates" runat="server" ErrorMessage="End Date must be later than Start Date."
        ControlToValidate="txtEndDate" CssClass="warning" Display="Dynamic" Operator="GreaterThan" Type="Date"
        ValidationGroup="vgFilter" ControlToCompare="txtStartDate">*</asp:CompareValidator>
    <br />
    Topic:<asp:TextBox ID="txtTopic" runat="server" Width="250px" CssClass="textbox"></asp:TextBox>
    <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="textbox" ValidationGroup="vgFilter" />
    <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="textbox" CausesValidation="false" OnClick="btnClear_Click" />
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="warning" EnableClientScript="True" ValidationGroup="vgFilter" />
    <br />
    <asp:Label ID="lblMessage" runat="server" Text="" CssClass="warning"></asp:Label>
    <br />
    <asp:GridView ID="gvPractices" runat="server" DataSourceID="odsPractices" AllowSorting="True"
        AutoGenerateColumns="False" DataKeyNames="PracticeID" ShowFooter="True" OnDataBound="gvPractices_DataBound" OnRowDeleting="gvPractices_RowDeleting">
        <AlternatingRowStyle BackColor="#CCCCCC" />
        <FooterStyle BackColor="#AAAAAA" Font-Bold="true" />
        <Columns>
            <asp:BoundField DataField="PracticeID" HeaderText="PracticeID" Visible="false" />
            <asp:BoundField DataField="PracticeNumber" HeaderText="Number" ItemStyle-Width="50px" FooterText="Totals"
                ItemStyle-CssClass="column-left-align" HeaderStyle-CssClass="column-left-align" />
            <asp:BoundField DataField="PracticeDate" HeaderText="Date" SortExpression="PracticeDate" HeaderStyle-CssClass="column-left-align"
                ItemStyle-Width="80px" DataFormatString="{0:yyyy-MM-dd}" ItemStyle-CssClass="column-left-align" />
            <asp:BoundField DataField="Topic" HeaderText="Topic" HeaderStyle-CssClass="column-left-align"
                ItemStyle-CssClass="column-left-align" />
            <asp:BoundField DataField="PracticeCost" HeaderText="Rental cost" ItemStyle-CssClass="grid-column-right"
                FooterStyle-HorizontalAlign="Right" HeaderStyle-CssClass="column-right-align" DataFormatString="{0:#,##0.00}" />
            <asp:BoundField DataField="Revenue" HeaderText="Admission revenue" ItemStyle-CssClass="grid-column-right"
                FooterStyle-HorizontalAlign="Right" HeaderStyle-CssClass="column-right-align" DataFormatString="{0:#,##0.00}" />
            <asp:BoundField DataField="MiscExpense" HeaderText="Misc expenses" ItemStyle-CssClass="grid-column-right"
                FooterStyle-HorizontalAlign="Right" HeaderStyle-CssClass="column-right-align" DataFormatString="{0:#,##0.00}" />
            <asp:BoundField DataField="MiscRevenue" HeaderText="Misc revenue" ItemStyle-CssClass="grid-column-right"
                FooterStyle-HorizontalAlign="Right" HeaderStyle-CssClass="column-right-align" DataFormatString="{0:#,##0.00}" />
            <asp:BoundField DataField="Attendees" HeaderText="Attendees" SortExpression="Attendees" ItemStyle-CssClass="grid-column-right"
                FooterStyle-HorizontalAlign="Right" HeaderStyle-CssClass="column-right-align" />
            <asp:CommandField ButtonType="Link" ShowDeleteButton="True" ItemStyle-Width="50px" />
        </Columns>
    </asp:GridView>
</asp:Content>