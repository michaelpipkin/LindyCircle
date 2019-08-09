<%@ Page Title="Member History" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="member.aspx.cs" Inherits="LindyCircle.Pages.member" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style type="text/css">
        tr td a {
            color: black;
        }

        #gvHistory {
            float: left;
        }

        #gvPunchCards {
            float: left;
            margin-left: 10px;
        }

        #panClear {
            clear: both;
        }
    </style>
    <asp:ObjectDataSource ID="odsMemberHistory" runat="server" SelectMethod="GetMemberHistory" TypeName="LindyCircle.MemberDB">
        <SelectParameters>
            <asp:RouteParameter Name="memberID" RouteKey="memberID" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsPunchCards" runat="server"
        SelectMethod="GetPunchCardPurchasesByMemberID" TypeName="LindyCircle.PunchCardDB">
        <SelectParameters>
            <asp:RouteParameter Name="memberID" RouteKey="memberID" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <br />
    Member:<asp:Label ID="lblMemberName" runat="server" Text="" CssClass="control-margin-left"></asp:Label>
    <br />
    Unused punches:<asp:Label ID="lblUnusedPunches" runat="server" Text="" CssClass="control-margin-left"></asp:Label>
    <br />
    Total paid:<asp:Label ID="lblTotalPaid" runat="server" Text="" CssClass="control-margin-left"></asp:Label>
    <br />
    <asp:Panel ID="panGrids" runat="server" ClientIDMode="Static">
        <asp:GridView ID="gvHistory" runat="server" DataSourceID="odsMemberHistory" AutoGenerateColumns="false"
            ShowFooter="true" OnDataBound="gvHistory_DataBound" ClientIDMode="Static" Caption="Practices">
            <AlternatingRowStyle BackColor="#CCCCCC" />
            <FooterStyle BackColor="#AAAAAA" Font-Bold="true" />
            <Columns>
                <asp:TemplateField HeaderText="Practice Date" HeaderStyle-Width="110px" SortExpression="PracticeDate"
                    FooterText="Total Attended"
                    ItemStyle-CssClass="column-left-align" HeaderStyle-CssClass="column-left-align">
                    <ItemTemplate>
                        <a href="/practice/<%# Eval("PracticeID") %>">
                            <asp:Label ID="lblPracticeDate" runat="server"
                                Text='<%# Eval("PracticeDate", "{0:yyyy-MM-dd}") %>'></asp:Label></a>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="PaymentType" HeaderText="Type" HeaderStyle-Width="80px" />
                <asp:BoundField DataField="PaymentAmount" HeaderText="Amount" HeaderStyle-CssClass="column-right-align"
                    ItemStyle-CssClass="column-right-align" FooterStyle-CssClass="column-right-align" HeaderStyle-Width="65px" />
            </Columns>
        </asp:GridView>
        <asp:GridView ID="gvPunchCards" runat="server" DataSourceID="odsPunchCards" AutoGenerateColumns="False"
            DataKeyNames="PunchCardID" EmptyDataText="This member has not purchased any punch cards." ClientIDMode="Static" 
            ShowFooter="true" OnDataBound="gvPunchCards_DataBound" Caption="Punch Cards">
            <AlternatingRowStyle BackColor="#CCCCCC" />
            <FooterStyle BackColor="#AAAAAA" Font-Bold="true" />
            <Columns>
                <asp:BoundField DataField="PunchCardID" HeaderText="PunchCardID" Visible="false" />
                <asp:BoundField DataField="PurchaseDate" HeaderText="Purchase Date" HeaderStyle-Width="105px"
                    DataFormatString="{0:yyyy-MM-dd}" FooterText="Total">
                </asp:BoundField>
                <asp:BoundField DataField="PurchaseAmount" HeaderText="Amount" HeaderStyle-Width="65px"
                    DataFormatString="{0:n2}" HeaderStyle-CssClass="column-right-align" ItemStyle-CssClass="column-right-align" 
                        FooterStyle-CssClass="column-right-align">
                </asp:BoundField>
            </Columns>
        </asp:GridView>
    </asp:Panel>
    <asp:Panel ID="panClear" runat="server" ClientIDMode="Static"></asp:Panel>
</asp:Content>