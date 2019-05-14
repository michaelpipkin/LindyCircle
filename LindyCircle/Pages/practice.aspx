<%@ Page Title="Practice Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="practice.aspx.cs" Inherits="LindyCircle.Pages.practice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        tr td a {
            color: black;
        }
    </style>
    <asp:ObjectDataSource ID="odsAttendance" runat="server" SelectMethod="GetPracticeAttendees"
        TypeName="LindyCircle.AttendanceDB">
        <SelectParameters>
            <asp:RouteParameter Name="practiceID" RouteKey="practiceID" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <br />
    Practice Number:<asp:TextBox ID="txtPracticeNumber" runat="server" CssClass="textbox" Width="30px"></asp:TextBox>
    <asp:RequiredFieldValidator ID="valPracticeNumberRequired" runat="server" ErrorMessage="Practice Number is required."
        CssClass="warning" Display="Dynamic" ControlToValidate="txtPracticeNumber" ValidationGroup="vgPractice">*</asp:RequiredFieldValidator>
    <asp:CompareValidator ID="valPracticeNumberType" runat="server" ErrorMessage="Practice Number must be a valid integer."
        CssClass="warning" Display="Dynamic" ControlToValidate="txtPracticeNumber" ValidationGroup="vgPractice"
        Operator="DataTypeCheck" Type="Integer">*</asp:CompareValidator>
    <asp:CustomValidator ID="valPracticeNumberUnique" runat="server" CssClass="warning" Display="Dynamic"
        ErrorMessage="This Practice Number is already assigned to another practice."
        ControlToValidate="txtPracticeNumber" ValidationGroup="vgPractice"
        OnServerValidate="valPracticeNumberUnique_ServerValidate">*</asp:CustomValidator>
    <br />
    Practice Date:<asp:Label ID="lblPracticeDate" runat="server" Text=""></asp:Label>
    <asp:GridView ID="gvAttendance" runat="server" DataSourceID="odsAttendance" AutoGenerateColumns="False"
        DataKeyNames="AttendanceID">
        <AlternatingRowStyle BackColor="#CCCCCC" />
        <Columns>
            <asp:BoundField DataField="AttendanceID" HeaderText="ID" Visible="false" />
            <asp:TemplateField HeaderText="Name" ItemStyle-Width="150px" SortExpression="MemberName">
                <ItemTemplate>
                    <a href="/member/<%# Eval("MemberID") %>">
                        <asp:Label ID="lblMemberName" runat="server" Text='<%# Eval("Member") %>'></asp:Label></a>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="PaymentType" Visible="false" />
            <asp:BoundField DataField="PaymentTypeText" HeaderText="Payment Type" ItemStyle-Width="100px" />
            <asp:BoundField DataField="PaymentAmount" HeaderText="Amount" ItemStyle-Width="75px" />
        </Columns>
    </asp:GridView>
    <br />
    Practice Topic:<asp:TextBox ID="txtTopic" runat="server" CssClass="textbox" Width="400px"></asp:TextBox>
    <br />
    Rental Cost:<asp:TextBox ID="txtRentalCost" runat="server" CssClass="textbox" Width="50px"></asp:TextBox>
    <asp:CompareValidator ID="valRentalCost" runat="server" ErrorMessage="Rental Cost must be a decimal number."
        ControlToValidate="txtRentalCost" CssClass="warning" Display="Dynamic" Operator="DataTypeCheck"
        Type="Double" ValidationGroup="vgPractice">*</asp:CompareValidator>
    <br />
    Miscellaneous Expense:<asp:TextBox ID="txtMiscExpense" runat="server" CssClass="textbox" Width="50px">0.00</asp:TextBox>
    <asp:CompareValidator ID="valMiscExpense" runat="server" ErrorMessage="Miscellaneous Expense must be a decimal number."
        ControlToValidate="txtMiscExpense" CssClass="warning" Display="Dynamic" Operator="DataTypeCheck"
        Type="Double" ValidationGroup="vgPractice">*</asp:CompareValidator>
    <br />
    Miscellaneous Revenue:<asp:TextBox ID="txtMiscRevenue" runat="server" CssClass="textbox" Width="50px">0.00</asp:TextBox>
    <asp:CompareValidator ID="valMiscRevenue" runat="server" ErrorMessage="Miscellaneous Revenue must be a decimal number."
        ControlToValidate="txtMiscRevenue" CssClass="warning" Display="Dynamic" Operator="DataTypeCheck"
        Type="Double" ValidationGroup="vgPractice">*</asp:CompareValidator>
    <br />
    <asp:Button ID="btnSave" runat="server" Text="Save practice details" OnClick="btnSave_Click" ValidationGroup="vgPractice" />
    <br />
    <asp:ValidationSummary ID="ValidationSummary4" runat="server" CssClass="warning" ValidationGroup="vgPractice" />
    <asp:Label ID="lblSaveStatus" runat="server" Text=""></asp:Label>
</asp:Content>
