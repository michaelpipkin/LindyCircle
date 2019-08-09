<%@ Page Title="Practices" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="practices.aspx.cs" Inherits="LindyCircle.Pages.practices" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        tr td a {
            color: black;
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
    Start Date<asp:TextBox ID="txtStartDate" runat="server" CssClass="control-margin-left" Width="75px"></asp:TextBox>
    <asp:CompareValidator ID="valStartDate" runat="server" ErrorMessage="Start Date must be a valid date."
        ControlToValidate="txtStartDate" CssClass="warning control-margin-right" Display="Dynamic" Operator="DataTypeCheck" Type="Date"
        ValidationGroup="vgFilter">*</asp:CompareValidator>
    End Date<asp:TextBox ID="txtEndDate" runat="server" CssClass="control-margin-left" Width="75px"></asp:TextBox>
    <asp:CompareValidator ID="valEndDate" runat="server" ErrorMessage="End Date must be a valid date."
        ControlToValidate="txtEndDate" CssClass="warning" Display="Dynamic" Operator="DataTypeCheck" Type="Date"
        ValidationGroup="vgFilter">*</asp:CompareValidator>
    <asp:CompareValidator ID="valCompareDates" runat="server" ErrorMessage="End Date must be later than Start Date."
        ControlToValidate="txtEndDate" CssClass="warning" Display="Dynamic" Operator="GreaterThan" Type="Date"
        ValidationGroup="vgFilter" ControlToCompare="txtStartDate">*</asp:CompareValidator>
    <br />
    Topic:<asp:TextBox ID="txtTopic" runat="server" Width="250px" CssClass="control-margin-left"></asp:TextBox>
    <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="control-margin-left" ValidationGroup="vgFilter" />
    <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="control-margin-left" CausesValidation="false" OnClick="btnClear_Click" />
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="warning" EnableClientScript="True" ValidationGroup="vgFilter" />
    <br />
    <asp:Label ID="lblMessage" runat="server" Text="" CssClass="warning"></asp:Label>
    <br />
    <asp:GridView ID="gvPractices" runat="server" DataSourceID="odsPractices" AllowSorting="True"
        AutoGenerateColumns="False" DataKeyNames="PracticeID" ShowFooter="True" OnDataBound="gvPractices_DataBound"
        OnRowDeleting="gvPractices_RowDeleting">
        <AlternatingRowStyle BackColor="#CCCCCC" />
        <FooterStyle BackColor="#AAAAAA" Font-Bold="true" />
        <Columns>
            <asp:BoundField DataField="PracticeID" HeaderText="PracticeID" Visible="false" />
            <asp:TemplateField HeaderText="Number" HeaderStyle-Width="60px" SortExpression="PracticeNumber" FooterText="Totals"
                ItemStyle-CssClass="column-left-align" HeaderStyle-CssClass="column-left-align">
                <ItemTemplate>
                    <a href="/practice/<%# Eval("PracticeID") %>">
                        <asp:Label ID="lblPracticeNumber" runat="server" Text='<%# Eval("PracticeNumber") %>'></asp:Label></a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Date" HeaderStyle-Width="80px"
                ItemStyle-CssClass="column-left-align" HeaderStyle-CssClass="column-left-align">
                <ItemTemplate>
                    <a href="/practice/<%# Eval("PracticeID") %>">
                        <asp:Label ID="lblPracticeDate" runat="server" Text='<%# Eval("PracticeDate", "{0:yyyy-MM-dd}") %>'></asp:Label></a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Topic" HeaderText="Topic" HeaderStyle-CssClass="column-left-align"
                ItemStyle-CssClass="column-left-align" />
            <asp:BoundField DataField="PracticeCost" HeaderText="Rental cost" ItemStyle-CssClass="column-right-align"
                FooterStyle-HorizontalAlign="Right" HeaderStyle-CssClass="column-right-align" DataFormatString="{0:#,##0.00}"
                HeaderStyle-Width="75px" />
            <asp:BoundField DataField="Revenue" HeaderText="Admission revenue" ItemStyle-CssClass="column-right-align"
                FooterStyle-HorizontalAlign="Right" HeaderStyle-CssClass="column-right-align" DataFormatString="{0:#,##0.00}"
                HeaderStyle-Width="75px" />
            <asp:BoundField DataField="MiscExpense" HeaderText="Misc expenses" ItemStyle-CssClass="column-right-align"
                FooterStyle-HorizontalAlign="Right" HeaderStyle-CssClass="column-right-align" DataFormatString="{0:#,##0.00}"
                HeaderStyle-Width="75px" />
            <asp:BoundField DataField="MiscRevenue" HeaderText="Misc revenue" ItemStyle-CssClass="column-right-align"
                FooterStyle-HorizontalAlign="Right" HeaderStyle-CssClass="column-right-align" DataFormatString="{0:#,##0.00}"
                HeaderStyle-Width="75px" />
            <asp:BoundField DataField="Attendees" HeaderText="Attendees" SortExpression="Attendees"
                ItemStyle-CssClass="column-right-align" FooterStyle-HorizontalAlign="Right"
                HeaderStyle-CssClass="column-right-align" HeaderStyle-Width="75px" />
            <asp:CommandField ButtonType="Link" ShowDeleteButton="True" ItemStyle-Width="50px" ItemStyle-CssClass="column-center-align" />
        </Columns>
    </asp:GridView>
</asp:Content>
