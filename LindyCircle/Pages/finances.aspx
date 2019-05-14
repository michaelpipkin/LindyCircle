<%@ Page Title="Finances" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="finances.aspx.cs" Inherits="LindyCircle.Pages.finances" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        tr td a {
            color: black;
        }
    </style>
    <asp:ObjectDataSource ID="odsFinances" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetFinancialData" TypeName="LindyCircle.FinanceDB">
        <SelectParameters>
            <asp:ControlParameter ControlID="txtStartDate" Name="startDate" PropertyName="Text" Type="DateTime" />
            <asp:ControlParameter ControlID="txtEndDate" Name="endDate" PropertyName="Text" Type="DateTime" />
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
    <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="textbox" ValidationGroup="vgFilter" />
    <asp:Button ID="btnReset" runat="server" Text="Clear" CssClass="textbox" CausesValidation="false" OnClick="btnReset_Click" />
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="warning" EnableClientScript="True" ValidationGroup="vgFilter" />
    <br />
    <br />
    <asp:GridView ID="gvFinances" runat="server" DataSourceID="odsFinances" AutoGenerateColumns="false" 
        ShowFooter="true" OnDataBound="gvFinances_DataBound">
        <HeaderStyle BackColor="#CCCCCC" />
        <AlternatingRowStyle BackColor="#CCCCCC" />
        <FooterStyle BackColor="#AAAAAA" Font-Bold="true" />
        <Columns>
            <asp:TemplateField HeaderText="Practice Date" HeaderStyle-Width="80px" FooterText="Totals"
                ItemStyle-CssClass="column-left-align" HeaderStyle-CssClass="column-left-align">
                <ItemTemplate>
                    <a href="/practice/<%# Eval("PracticeID") %>">
                        <asp:Label ID="lblPracticeDate" runat="server" Text='<%# Eval("PracticeDate", "{0:yyyy-MM-dd}") %>'></asp:Label></a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="RentalCost" HeaderText="Rental Cost" DataFormatString="{0:#,##0.00}" HeaderStyle-Width="80px" 
                HeaderStyle-CssClass="column-right-align" ItemStyle-CssClass="column-right-align" FooterStyle-CssClass="column-right-align" />
            <asp:BoundField DataField="AdmissionRevenue" HeaderText="Admissions" DataFormatString="{0:#,##0.00}" HeaderStyle-Width="80px" 
                HeaderStyle-CssClass="column-right-align" ItemStyle-CssClass="column-right-align" FooterStyle-CssClass="column-right-align" />
            <asp:BoundField DataField="MiscExpense" HeaderText="Misc Expense" DataFormatString="{0:#,##0.00}" HeaderStyle-Width="80px" 
                HeaderStyle-CssClass="column-right-align" ItemStyle-CssClass="column-right-align" FooterStyle-CssClass="column-right-align" />
            <asp:BoundField DataField="MiscRevenue" HeaderText="Misc Revenue" DataFormatString="{0:#,##0.00}" HeaderStyle-Width="80px" 
                HeaderStyle-CssClass="column-right-align" ItemStyle-CssClass="column-right-align" FooterStyle-CssClass="column-right-align" />
            <asp:BoundField DataField="PunchCardsSold" HeaderText="Punch Cards Sold" DataFormatString="{0:0}" HeaderStyle-Width="80px" 
                HeaderStyle-CssClass="column-right-align" ItemStyle-CssClass="column-right-align" FooterStyle-CssClass="column-right-align" />
            <asp:BoundField DataField="PunchCardRevenue" HeaderText="Punch Card Revenue" DataFormatString="{0:#,##0.00}" HeaderStyle-Width="80px" 
                HeaderStyle-CssClass="column-right-align" ItemStyle-CssClass="column-right-align" FooterStyle-CssClass="column-right-align" />
            <asp:BoundField DataField="TotalExpenseRevenue" HeaderText="Line Total" DataFormatString="{0:#,##0.00}" HeaderStyle-Width="80px" 
                HeaderStyle-CssClass="column-right-align" ItemStyle-CssClass="column-right-align" FooterStyle-CssClass="column-right-align" />
            <asp:BoundField DataField="RunningTotal" HeaderText="Running Total" DataFormatString="{0:#,##0.00}" HeaderStyle-Width="80px" 
                HeaderStyle-CssClass="column-right-align" ItemStyle-CssClass="column-right-align" FooterStyle-CssClass="column-right-align" />
        </Columns>
    </asp:GridView>
</asp:Content>
