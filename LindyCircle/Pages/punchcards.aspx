<%@ Page Title="Punch Cards" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="punchcards.aspx.cs" Inherits="LindyCircle.Pages.punchcards" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        function DisableForm() {
            if (Page_ClientValidate("vgPurchaseCard")) {
                document.getElementById("ddlMembers").disabled = true;
                document.getElementById("txtPurchaseDate").disabled = true;
                document.getElementById("txtAmount").disabled = true;
                document.getElementById("btnPurchase").disabled = true;
                document.getElementById("lblWarning").innerHTML = "Processing - please wait...";
            }
        }
    </script>
    <asp:ObjectDataSource ID="odsMembers" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="GetMemberList" TypeName="LindyCircle.MemberDB"></asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsPunchCards" runat="server" OldValuesParameterFormatString="original_{0}"
        SelectMethod="GetPunchCardPurchasesByMemberID" TypeName="LindyCircle.PunchCardDB" DeleteMethod="DeletePunchCard">
        <DeleteParameters>
            <asp:Parameter Name="PunchCardID" Type="Int32" />
        </DeleteParameters>
        <SelectParameters>
            <asp:ControlParameter ControlID="ddlMembers" Name="memberID" PropertyName="SelectedValue" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <br />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="ddlMembers" />
        </Triggers>
        <ContentTemplate>
            Member:<asp:DropDownList ID="ddlMembers" runat="server" AutoPostBack="True" DataSourceID="odsMembers"
                DataTextField="FirstLastName" DataValueField="MemberID" CssClass="textbox" CausesValidation="false" ClientIDMode="Static" OnDataBound="ddlMembers_DataBound">
            </asp:DropDownList>
            Purchase Date:<asp:TextBox ID="txtPurchaseDate" runat="server" ValidationGroup="vgPurchaseCard"
                CssClass="textbox" Width="80px" ClientIDMode="Static"></asp:TextBox>
            <asp:RequiredFieldValidator ID="valPurchaseDateRequired" runat="server" ErrorMessage="Purchase date is required."
                ControlToValidate="txtPurchaseDate" CssClass="warning" Display="Dynamic" ValidationGroup="vgPurchaseCard">*&nbsp;</asp:RequiredFieldValidator>
            <asp:CompareValidator ID="valPurchaseDateType" runat="server" ErrorMessage="Purchase date must be a valid date."
                ControlToValidate="txtPurchaseDate" CssClass="warning" Operator="DataTypeCheck" Type="Date" ValidationGroup="vgPurchaseCard">*&nbsp;</asp:CompareValidator>
            Amount:<asp:TextBox ID="txtAmount" runat="server" CssClass="textbox" ValidationGroup="vgPurchaseCard"
                Width="60px" ClientIDMode="Static"></asp:TextBox>
            <asp:RequiredFieldValidator ID="valAmountRequired" runat="server" ErrorMessage="Amount is required."
                ControlToValidate="txtAmount" CssClass="warning" Display="Dynamic" ValidationGroup="vgPurchaseCard">*&nbsp;</asp:RequiredFieldValidator>
            <asp:CompareValidator ID="valAmountType" runat="server" ErrorMessage="Amount must be a valid decimal number."
                ControlToValidate="txtAmount" CssClass="warning" Operator="DataTypeCheck" Type="Currency" ValidationGroup="vgPurchaseCard">*&nbsp;</asp:CompareValidator>
            <asp:Button ID="btnPurchase" runat="server" Text="Purchase Card" ValidateGroup="vgPurchaseCard"
                UseSubmitBehavior="false" ClientIDMode="Static" OnClientClick="DisableForm();" OnClick="btnPurchase_Click" />
            <br />
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="warning" ValidationGroup="vgPurchaseCard" />
            <asp:Label ID="lblWarning" runat="server" Text="" CssClass="warning" ClientIDMode="Static"></asp:Label>
            <br />
            <asp:GridView ID="gvPunchCards" runat="server" DataSourceID="odsPunchCards" AutoGenerateColumns="False"
                DataKeyNames="PunchCardID" EmptyDataText="This member has not purchased any punch cards.">
                <AlternatingRowStyle BackColor="#CCCCCC" />
                <Columns>
                    <asp:BoundField DataField="PunchCardID" HeaderText="PunchCardID" Visible="false" />
                    <asp:BoundField DataField="PurchaseDate" HeaderText="Purchase Date" ItemStyle-Width="85px" DataFormatString="{0:yyyy-MM-dd}">
                        <ItemStyle Width="85px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PurchaseAmount" HeaderText="Amount" ItemStyle-Width="75px" DataFormatString="{0:n2}">
                        <ItemStyle Width="75px" />
                    </asp:BoundField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" runat="server" Text="Delete" CommandName="Delete"
                                OnCommand="btnDelete_Command" CommandArgument='<%#Eval("PunchCardID") %>'></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
