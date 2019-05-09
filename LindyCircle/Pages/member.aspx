<%@ Page Title="Member History" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="member.aspx.cs" Inherits="LindyCircle.Pages.member" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ObjectDataSource ID="odsMemberHistory" runat="server" OldValuesParameterFormatString="original_{0}" SelectMethod="GetMemberHistory" TypeName="LindyCircle.MemberDB">
        <SelectParameters>
            <asp:RouteParameter Name="memberID" RouteKey="memberID" Type="Int32" />
        </SelectParameters>
    </asp:ObjectDataSource>
    <br />
    Member:<asp:Label ID="lblMemberName" runat="server" Text=""></asp:Label>
    <br /><br />
    <asp:GridView ID="gvHistory" runat="server" DataSourceID="odsMemberHistory" AutoGenerateColumns="false" ShowFooter="true" OnDataBound="gvHistory_DataBound">
        <AlternatingRowStyle BackColor="#CCCCCC" />
        <FooterStyle BackColor="#AAAAAA" Font-Bold="true" />
        <Columns>
            <asp:BoundField DataField="PracticeDate" HeaderText="Practice Date" 
                DataFormatString="{0:yyyy-MM-dd}" FooterText="Total Attendance" HeaderStyle-Width="130px" />
            <asp:BoundField DataField="PaymentType" HeaderText="Type" HeaderStyle-Width="80px" />
            <asp:BoundField DataField="PaymentAmount" HeaderText="Amount" HeaderStyle-CssClass="column-right-align"
                ItemStyle-CssClass="column-right-align" FooterStyle-CssClass="column-right-align" HeaderStyle-Width="80px" />
        </Columns>
    </asp:GridView>
</asp:Content>