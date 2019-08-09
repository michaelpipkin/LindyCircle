<%@ Page Title="Attendance" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="attendance.aspx.cs" Inherits="LindyCircle.Pages.attendance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        tr td a {
            color: black;
        }
    </style>
    <asp:ObjectDataSource ID="odsMembers" runat="server" SelectMethod="GetMembersNotInPractice" TypeName="LindyCircle.AttendanceDB">
        <SelectParameters>
            <asp:ControlParameter ControlID="hidPracticeID" Name="practiceID" PropertyName="Value" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsAttendance" runat="server" SelectMethod="GetPracticeAttendees" TypeName="LindyCircle.AttendanceDB"
        DeleteMethod="DeleteAttendance">
        <DeleteParameters>
            <asp:Parameter Name="attendanceID" Type="Int32" />
        </DeleteParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="hidPracticeID" Name="practiceID" PropertyName="Value" Type="Int32" />
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
            Practice Date:<asp:TextBox ID="txtPracticeDate" runat="server" Width="85px" CssClass="control-margin-left"
                OnTextChanged="txtPracticeDate_TextChanged" CausesValidation="true"></asp:TextBox>
            <asp:CompareValidator ID="valPracticeDate" runat="server" ErrorMessage="Invalid format for practice date."
                CssClass="warning" ControlToValidate="txtPracticeDate" Operator="DataTypeCheck" Type="Date"
                ValidationGroup="vgPracticeDate" Display="Dynamic">*</asp:CompareValidator>
            <asp:HiddenField ID="hidPracticeID" runat="server" />
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
            <asp:Panel ID="panPracticeDetails" runat="server" Visible="false">
                <asp:Label ID="lblNewPractice" runat="server" Text=""></asp:Label>
                <br />
                Practice Number:<asp:TextBox ID="txtPracticeNumber" runat="server" CssClass="control-margin-left" Width="30px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="valPracticeNumberRequired" runat="server" ErrorMessage="Practice Number is required."
                    CssClass="warning" Display="Dynamic" ControlToValidate="txtPracticeNumber"
                    ValidationGroup="vgPractice">*</asp:RequiredFieldValidator>
                <asp:CompareValidator ID="valPracticeNumberType" runat="server" ErrorMessage="Practice Number must be a valid integer."
                    CssClass="warning" Display="Dynamic" ControlToValidate="txtPracticeNumber" ValidationGroup="vgPractice"
                    Operator="DataTypeCheck" Type="Integer">*</asp:CompareValidator>
                <asp:CustomValidator ID="valPracticeNumberUnique" runat="server" CssClass="warning" Display="Dynamic"
                    ErrorMessage="This Practice Number is already assigned to another practice."
                    ControlToValidate="txtPracticeNumber" ValidationGroup="vgPractice"
                    OnServerValidate="valPracticeNumberUnique_ServerValidate">*</asp:CustomValidator>
                <br />
                Practice Topic:<asp:TextBox ID="txtTopic" runat="server" CssClass="control-margin-left" Width="400px"></asp:TextBox>
                <br />
                Rental Cost:<asp:TextBox ID="txtRentalCost" runat="server" CssClass="control-margin-left" Width="50px"></asp:TextBox>
                <asp:CompareValidator ID="valRentalCost" runat="server" ErrorMessage="Rental Cost must be a decimal number."
                    ControlToValidate="txtRentalCost" CssClass="warning" Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" ValidationGroup="vgPractice">*</asp:CompareValidator>
                <br />
                Miscellaneous Expense:<asp:TextBox ID="txtMiscExpense" runat="server" CssClass="control-margin-left" Width="50px">0.00</asp:TextBox>
                <asp:CompareValidator ID="valMiscExpense" runat="server" ErrorMessage="Miscellaneous Expense must be a decimal number."
                    ControlToValidate="txtMiscExpense" CssClass="warning" Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" ValidationGroup="vgPractice">*</asp:CompareValidator>
                <br />
                Miscellaneous Revenue:<asp:TextBox ID="txtMiscRevenue" runat="server" CssClass="control-margin-left" Width="50px">0.00</asp:TextBox>
                <asp:CompareValidator ID="valMiscRevenue" runat="server" ErrorMessage="Miscellaneous Revenue must be a decimal number."
                    ControlToValidate="txtMiscRevenue" CssClass="warning" Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" ValidationGroup="vgPractice">*</asp:CompareValidator>
                <br />
                <asp:Button ID="btnSaveDetails" runat="server" Text="Save practice details"
                    OnClick="btnSaveDetails_Click" ValidationGroup="vgPractice" />
                <asp:Button ID="btnAddPractice" runat="server" Text="Add Practice" OnClick="btnAddPractice_Click"
                    ValidationGroup="vgNewPractice" CssClass="control-margin-left" />
                <asp:Button ID="btnCancelAddPractice" runat="server" Text="Cancel" CssClass="control-margin-left"
                    OnClick="btnCancelAddPractice_Click" />
                <asp:ValidationSummary ID="ValidationSummary2" runat="server" CssClass="warning" ValidationGroup="vgPractice" />
                <asp:Label ID="lblSaveStatus" runat="server" Text=""></asp:Label>
            </asp:Panel>
            <br />
            <asp:Panel ID="panPracticeMembers" runat="server" Visible="false">
                Member:<asp:DropDownList ID="ddlMembers" runat="server" CssClass="control-margin-left control-margin-right" DataSourceID="odsMembers"
                    DataTextField="FirstLastName" DataValueField="MemberID" OnDataBound="ddlMembers_DataBound"
                    OnSelectedIndexChanged="ddlMembers_SelectedIndexChanged" AutoPostBack="true">
                </asp:DropDownList>
                Unused punches:
                <asp:Label ID="lblUnusedPunches" runat="server" Text=""></asp:Label>
                <asp:CustomValidator ID="valPunchesRemaining" runat="server" ErrorMessage="Member has no unused punches."
                    Display="Dynamic" ValidationGroup="vgAddMember" CssClass="warning" 
                    OnServerValidate="valPunchesRemaining_ServerValidate">*</asp:CustomValidator>
                <br />
                Payment method:<asp:DropDownList ID="ddlPaymentTypes" runat="server" CssClass="control-margin-left control-margin-right"
                    OnSelectedIndexChanged="ddlPaymentTypes_SelectedIndexChanged" AutoPostBack="true">
                </asp:DropDownList>
                Amount:<asp:TextBox ID="txtPaymentAmount" runat="server" Width="50px" CssClass="control-margin-left"></asp:TextBox>
                <asp:CompareValidator ID="valPaymentAmount" runat="server" ErrorMessage="Amount must be a decimal number."
                    ControlToValidate="txtPaymentAmount" CssClass="warning" Display="Dynamic" Operator="DataTypeCheck"
                    Type="Double" ValidationGroup="vgAddMember">*</asp:CompareValidator>
                <asp:Button ID="btnCheckIn" runat="server" Text="Check in" CssClass="control-margin-left"
                    OnClick="btnCheckIn_Click" ValidationGroup="vgAddMember" />
                <asp:ValidationSummary ID="ValidationSummary3" runat="server" CssClass="warning" ValidationGroup="vgAddMember" />
                <asp:GridView ID="gvAttendance" runat="server" DataSourceID="odsAttendance" AutoGenerateColumns="False"
                    DataKeyNames="AttendanceID" ShowFooter="True" OnDataBound="gvAttendance_DataBound" Caption="Attendees">
                    <AlternatingRowStyle BackColor="#CCCCCC" />
                    <FooterStyle BackColor="#AAAAAA" Font-Bold="true" />
                    <Columns>
                        <asp:BoundField DataField="AttendanceID" HeaderText="ID" Visible="false" />
                        <asp:TemplateField HeaderText="Name" ItemStyle-Width="150px" SortExpression="MemberName" FooterText="Attended: ">
                            <ItemTemplate>
                                <a href="/member/<%# Eval("MemberID") %>">
                                    <asp:Label ID="lblMemberName" runat="server" Text='<%# Eval("Member") %>'></asp:Label></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="PaymentType" Visible="false" />
                        <asp:BoundField DataField="PaymentTypeText" HeaderText="Payment Type" ItemStyle-Width="100px" FooterText="Collected" />
                        <asp:BoundField DataField="PaymentAmount" HeaderText="Amount" HeaderStyle-Width="75px" HeaderStyle-CssClass="column-right-align"
                            ItemStyle-CssClass="column-right-align" FooterStyle-CssClass="column-right-align" />
                        <asp:TemplateField ItemStyle-CssClass="column-center-align" ItemStyle-Width="50px">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnRemove" runat="server" Text="Remove" CommandName="Delete"
                                    CommandArgument='<%#Eval("AttendanceID") %>'></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
