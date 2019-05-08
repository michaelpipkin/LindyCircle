<%@ Page Title="History" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="history.aspx.cs" Inherits="LindyCircle.Pages.history" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ObjectDataSource ID="odsPractices" runat="server" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetPracticeHistoryData" TypeName="LindyCircle.PracticeDB">
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
    <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="textbox" CausesValidation="false" OnClick="btnReset_Click" />
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="warning" EnableClientScript="True" ValidationGroup="vgFilter" />
    <br />
    <asp:Chart ID="Chart1" runat="server" DataSourceID="odsPractices" Width="800px" Height="400px" 
        ImageLocation="~/images/chart" ImageStorageMode="UseImageLocation" ImageType="Png">
        <Series>
            <asp:Series Name="Attendance" ChartType="Line" XValueMember="PracticeDate" YValueMembers="Attendees"
                Palette="None" XValueType="Date" YValueType="Int32" MarkerStyle="Circle" MarkerSize="8" 
                ChartArea="ChartArea1" Color="Blue" IsXValueIndexed="True"></asp:Series>
        </Series>
        <ChartAreas>
            <asp:ChartArea Name="ChartArea1">
                <AxisX>
                    <LabelStyle Interval="1" />
                    <MajorGrid Interval="2" LineColor="#999999" />
                    <MajorTickMark Interval="1" LineColor="#999999" />
                </AxisX>
                <AxisY>
                    <MajorGrid LineColor="#999999" />
                </AxisY>
            </asp:ChartArea>
        </ChartAreas>
    </asp:Chart>
</asp:Content>