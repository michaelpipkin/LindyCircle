<%@ Page Title="Attendance" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="attendance.aspx.cs" Inherits="LindyCircle.Pages.attendance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ObjectDataSource ID="odsMembers" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetMembersNotInPractice" TypeName="LindyCircle.AttendanceDB">
        <SelectParameters>
            <asp:ControlParameter ControlID="txtPracticeID" Name="practiceID" PropertyName="Text" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsAttendance" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetPracticeAttendees" TypeName="LindyCircle.AttendanceDB">
        <SelectParameters>
            <asp:ControlParameter ControlID="txtPracticeID" Name="practiceID" PropertyName="Text" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <br />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="txtPracticeDate" EventName="TextChanged" />
            <asp:AsyncPostBackTrigger ControlID="calPracticeDate" EventName="SelectionChanged" />
            <asp:AsyncPostBackTrigger ControlID="ddlPaymentTypes" />
            <asp:AsyncPostBackTrigger ControlID="ddlMembers" />
        </Triggers>
        <ContentTemplate>
            Practice Date:<asp:TextBox ID="txtPracticeDate" runat="server" Width="85px" CssClass="textbox"
                OnTextChanged="txtPracticeDate_TextChanged" CausesValidation="true"></asp:TextBox>
            <asp:CompareValidator ID="valPracticeDate" runat="server" ErrorMessage="Invalid format for practice date."
                CssClass="warning" ControlToValidate="txtPracticeDate" Operator="DataTypeCheck" Type="Date"
                ValidationGroup="vgPracticeDate" Display="Dynamic">*&nbsp;</asp:CompareValidator>
            <asp:TextBox ID="txtPracticeID" runat="server" Visible="false"></asp:TextBox>
            <asp:Calendar ID="calPracticeDate" runat="server" BackColor="White" BorderColor="#999999" CellPadding="4"
                DayNameFormat="Shortest" Font-Names="Verdana" Font-Size="8pt" ForeColor="Black" Height="180px"
                OnSelectionChanged="calPracticeDate_SelectionChanged" Width="200px">
                <DayHeaderStyle BackColor="#CCCCCC" Font-Bold="True" Font-Size="7pt" />
                <NextPrevStyle VerticalAlign="Bottom" />
                <OtherMonthDayStyle ForeColor="#808080" />
                <SelectedDayStyle BackColor="#666666" Font-Bold="True" ForeColor="White" />
                <SelectorStyle BackColor="#CCCCCC" />
                <TitleStyle BackColor="#999999" BorderColor="Black" Font-Bold="True" />
                <TodayDayStyle BackColor="#CCCCCC" ForeColor="Black" />
                <WeekendDayStyle BackColor="#FFFFCC" />
            </asp:Calendar>
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="warning" ValidationGroup="vgPracticeDate" />
            <br />
            <asp:Panel ID="panNewPractice" runat="server" Visible="false">
                <asp:Label ID="lblNewPractice" runat="server" Text=""></asp:Label>
                <br />
                Practice Topic:<asp:TextBox ID="txtNewTopic" runat="server" CssClass="textbox" Width="400px"></asp:TextBox>
                <br />
                Rental Cost:<asp:TextBox ID="txtNewRentalCost" runat="server" CssClass="textbox" Width="50px"></asp:TextBox>
                <asp:CompareValidator ID="valNewRentalCost" runat="server" ErrorMessage="Rental Cost must be a decimal number."
                    ControlToValidate="txtNewRentalCost" CssClass="warning" Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" ValidationGroup="vgNewPractice">*</asp:CompareValidator>
                <br />
                Miscellaneous Expense:<asp:TextBox ID="txtNewMiscExpense" runat="server" CssClass="textbox" Width="50px">0.00</asp:TextBox>
                <asp:CompareValidator ID="valNewMiscExpense" runat="server" ErrorMessage="Miscellaneous Expense must be a decimal number."
                    ControlToValidate="txtNewMiscExpense" CssClass="warning" Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" ValidationGroup="vgNewPractice">*</asp:CompareValidator>
                <br />
                Miscellaneous Revenue:<asp:TextBox ID="txtNewMiscRevenue" runat="server" CssClass="textbox" Width="50px">0.00</asp:TextBox>
                <asp:CompareValidator ID="valNewMiscRevenue" runat="server" ErrorMessage="Miscellaneous Revenue must be a decimal number."
                    ControlToValidate="txtNewMiscRevenue" CssClass="warning" Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" ValidationGroup="vgNewPractice">*</asp:CompareValidator>
                <br />
                <asp:Button ID="btnYes" runat="server" Text="Add Practice" OnClick="btnYes_Click" />
                <asp:Button ID="btnNo" runat="server" Text="Cancel" CssClass="textbox" OnClick="btnNo_Click" />
                <asp:ValidationSummary ID="ValidationSummary2" runat="server" CssClass="warning" ValidationGroup="vgNewPractice" />
            </asp:Panel>
            <asp:Panel ID="panPracticeDetails" runat="server" Visible="false">
                Member:<asp:DropDownList ID="ddlMembers" runat="server" CssClass="textbox" DataSourceID="odsMembers"
                    DataTextField="FirstLastName" DataValueField="MemberID" OnDataBound="ddlMembers_DataBound"
                    OnSelectedIndexChanged="ddlMembers_SelectedIndexChanged" AutoPostBack="true">
                </asp:DropDownList>
                &nbsp;Unused punches:
                <asp:Label ID="lblUnusedPunches" runat="server" Text=""></asp:Label>
                <br />
                Payment method:<asp:DropDownList ID="ddlPaymentTypes" runat="server" CssClass="textbox"
                    OnSelectedIndexChanged="ddlPaymentTypes_SelectedIndexChanged" AutoPostBack="true">
                </asp:DropDownList>
                Amount:<asp:TextBox ID="txtPaymentAmount" runat="server" Width="50px" CssClass="textbox"></asp:TextBox>
                <asp:CompareValidator ID="valPaymentAmount" runat="server" ErrorMessage="Amount must be a decimal number."
                    ControlToValidate="txtPaymentAmount" CssClass="warning" Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" ValidationGroup="vgAddMember">*</asp:CompareValidator>
                <asp:Button ID="btnAddToPractice" runat="server" Text="Check in" CssClass="textbox"
                    OnClick="btnAddToPractice_Click" ValidationGroup="vgAddMember" />
                <asp:ValidationSummary ID="ValidationSummary3" runat="server" CssClass="warning" ValidationGroup="vgAddMember" />
                <br />
                <br />
                <asp:GridView ID="gvAttendance" runat="server" DataSourceID="odsAttendance" AutoGenerateColumns="false" DataKeyNames="AttendanceID">
                    <AlternatingRowStyle BackColor="#CCCCCC" />
                    <Columns>
                        <asp:BoundField DataField="AttendanceID" HeaderText="ID" Visible="false" />
                        <asp:BoundField DataField="Member" HeaderText="Name" ItemStyle-Width="150px" />
                        <asp:BoundField DataField="PaymentType" Visible="false" />
                        <asp:BoundField DataField="PaymentTypeText" HeaderText="Payment Type" ItemStyle-Width="100px" />
                        <asp:BoundField DataField="PaymentAmount" HeaderText="Amount" ItemStyle-Width="75px" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton ID="btnRemove" runat="server" Text="Remove" CommandName="Delete"
                                    OnCommand="btnRemove_Command" CommandArgument='<%#Eval("AttendanceID") %>'></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
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
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
