<%@ Page Title="Members" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="members.aspx.cs" Inherits="LindyCircle.Pages.members" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function DisableForm() {
            if (Page_ClientValidate("vgNewMember")) {
                document.getElementById("txtFirstName").disabled = true;
                document.getElementById("txtLastName").disabled = true;
                document.getElementById("btnNew").disabled = true;
                document.getElementById("lblWarning").innerHTML = "Processing - please wait...";
            }
        }
    </script>
    <style type="text/css">
        a {
            color: black;
        }
    </style>
    <asp:ObjectDataSource ID="odsMembers" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="GetMembers" TypeName="LindyCircle.MemberDB">
        <SelectParameters>
            <asp:ControlParameter ControlID="ckbActive" Name="active" PropertyName="Checked" Type="Boolean" DefaultValue="1" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <br />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnNew" />
            <asp:AsyncPostBackTrigger ControlID="ckbActive" />
        </Triggers>
        <ContentTemplate>
            First Name:<asp:TextBox ID="txtFirstName" runat="server" CssClass="textbox" ClientIDMode="Static" Width="75px"></asp:TextBox>
            <asp:RequiredFieldValidator ID="valFirstName" runat="server" ErrorMessage="First Name is required." Display="Dynamic"
                ValidationGroup="vgNewMember" CssClass="warning" ControlToValidate="txtFirstName">*&nbsp;</asp:RequiredFieldValidator>
            Last Name:<asp:TextBox ID="txtLastName" runat="server" CssClass="textbox" ClientIDMode="Static" Width="75px"></asp:TextBox>
            <asp:RequiredFieldValidator ID="valLastName" runat="server" ErrorMessage="Last Name is required." Display="Dynamic"
                ValidationGroup="vgNewMember" CssClass="warning" ControlToValidate="txtLastName">*&nbsp;</asp:RequiredFieldValidator>
            <asp:Button ID="btnNew" runat="server" Text="Add member" OnClick="btnNew_Click" ClientIDMode="Static"
                ValidationGroup="vgNewMember" OnClientClick="DisableForm();" UseSubmitBehavior="false" />
            <br />
            <asp:CheckBox ID="ckbActive" runat="server" Text="Show only active members" TextAlign="Right" AutoPostBack="true" Checked="true" />
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="warning" ValidationGroup="vgNewMember" />
            <asp:Label ID="lblWarning" runat="server" Text="" CssClass="warning" ClientIDMode="Static"></asp:Label>
            <br />
            <asp:GridView ID="gvMembers" runat="server" DataSourceID="odsMembers" AllowSorting="True" AutoGenerateColumns="False"
                DataKeyNames="MemberID">
                <AlternatingRowStyle BackColor="#CCCCCC" />
                <Columns>
                    <asp:BoundField DataField="MemberID" HeaderText="MemberID" Visible="false" />
                    <asp:TemplateField HeaderText="Name" ItemStyle-Width="150px" SortExpression="MemberName">
                        <ItemTemplate>
                            <a href="member/<%# Eval("MemberID") %>">
                                <asp:Label ID="lblMemberName" runat="server" Text='<%# Eval("MemberName") %>'></asp:Label></a>
                        </ItemTemplate>
                    </asp:TemplateField>
<%--                    <asp:BoundField DataField="MemberName" HeaderText="Name" SortExpression="MemberName" ItemStyle-Width="150px">
                        <ItemStyle Width="150px" />
                    </asp:BoundField>--%>
                    <asp:BoundField DataField="Attended" HeaderText="Attended" SortExpression="Attended" ItemStyle-Width="65px">
                        <ItemStyle Width="65px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PunchCards" HeaderText="Punch cards" ItemStyle-Width="65px">
                        <ItemStyle Width="65px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="UnusedPunches" HeaderText="Unused punches" ItemStyle-Width="65px">
                        <ItemStyle Width="65px" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Inactive">
                        <ItemStyle HorizontalAlign="Center" Width="50px" />
                        <ItemTemplate>
                            <asp:CheckBox ID="ckbInactive" runat="server" AutoPostBack="True"
                                OnCheckedChanged="ckbInactive_CheckedChanged" Checked='<%# Eval("Inactive") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
