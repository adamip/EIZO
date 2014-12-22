<style>
    body(scroll: auto;)
</style>
<%@ LANGUAGE="VBSCRIPT" %>
<%if session("debcode")="" or isnull(session("debcode")) then response.Redirect("../../login.asp")%>
<%if session("company")="" or isnull(session("company")) then response.Redirect("../../login.asp")%>
<%if session("uid")="" or isnull(session("uid")) then response.Redirect("../../login.asp")%>


<% gsno = Request.QueryString("gsno") %>


<!--METADATA TYPE="DesignerControl" startspan
    <OBJECT ID="ChkGSno" WIDTH=151 HEIGHT=24
     CLASSID="CLSID:7FAEED80-9D58-11CF-8F68-00AA006D27C2">
        <PARAM NAME="_Version" VALUE="65536">
        <PARAM NAME="_Version" VALUE="65536">
        <PARAM NAME="_ExtentX" VALUE="3969">
        <PARAM NAME="_ExtentY" VALUE="635">
        <PARAM NAME="_StockProps" VALUE="0">
        <PARAM NAME="DataConnection" VALUE="gainsystems">
        <PARAM NAME="CommandText" VALUE="SELECT invoice_number FROM invdetail WHERE serial_num = '0'">
    </OBJECT>
-->
<%
Set gainsystems = Server.CreateObject("ADODB.Connection")
gainsystems.ConnectionTimeout = Session("gainsystems_ConnectionTimeout")
gainsystems.CommandTimeout = Session("gainsystems_CommandTimeout")
gainsystems.Open Session("gainsystems_ConnectionString"), Session("gainsystems_RuntimeUserName"), Session("gainsystems_RuntimePassword")

Set AX = Server.CreateObject("ADODB.Connection")
AX.ConnectionTimeout = Session("gainsystems_ConnectionTimeout")
AX.CommandTimeout = Session("gainsystems_CommandTimeout")
AX.Open Session("AX_ConnectionString")

Set cmdTemp = Server.CreateObject("ADODB.Command")
'Set ChkGSno = Server.CreateObject("ADODB.Recordset")
Set ChkMacSno = Server.CreateObject("ADODB.Recordset")
Set ChkMac05Sno = Server.CreateObject("ADODB.Recordset")

REM On Nov 15 2011 Nik Moissiadis <nmoissiadis@steelbox.com> instructs to comment out the function GetExpirationDate( ) so that this function
REM     will always returns 1.  He realizes that this act will affect all the program modules which calls this function
REM cmdTemp.CommandText = _
REM     "SELECT C_SERIALNUMBERS.INVNUM as inv_no, C_SERIALNUMBERS.TRX_DT2 as inv_dt, C_SERIALNUMBERS.SERNUM as ser_lot_no, C_SERIALNUMBERS.ITEMID as item_no, " & _
REM     "	ISNULL(INVENTTABLE.ITEMNAME,'') as item_desc_1, " & _
REM     "	C_CONTRACTITEMS.SupportCoverage, SupportItem.ITEMNAME, " & _
REM     "	CASE WHEN SupportItem.ITEMNAME like '%Advance Replacement%' then 0 WHEN SupportItem.ITEMNAME like '%Advanced Replacement%' then 0 WHEN SupportItem.ITEMNAME like '%Depot Repair%' THEN 1 ELSE NULL END AS rmatype, " & _
REM     "	ISNULL(dbo.getdatefromdatetime([dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM)), 'n/a') as datefinal, " & _
REM     "	CASE WHEN [dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM) IS NULL THEN 0 WHEN [dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM) > getDate() THEN 1 ELSE 0 END AS InWarranty " & _
REM     "FROM C_SERIALNUMBERS " & _
REM     "	LEFT OUTER JOIN SALESTABLE ON SALESTABLE.SALESID = C_SERIALNUMBERS.SALESORDERNO " & _
REM     "	LEFT OUTER JOIN INVENTTABLE ON INVENTTABLE.ITEMID = C_SERIALNUMBERS.ITEMID and INVENTTABLE.DATAAREAID = 'us' " & _
REM     "	LEFT OUTER JOIN C_CONTRACTITEMS ON C_CONTRACTITEMS.SN = C_SERIALNUMBERS.SERNUM " & _
REM     "	LEFT OUTER JOIN C_CONTRACTS ON C_CONTRACTS.CONTRACTID_DISPLAY = C_CONTRACTITEMS.CONTRACTID " & _
REM     "	LEFT OUTER JOIN INVENTTABLE SupportItem ON SupportItem.ITEMID = C_CONTRACTITEMS.SUPPORTCOVERAGE AND SupportItem.DATAAREAID = C_CONTRACTITEMS.DATAAREAID " & _
REM     "WHERE C_SERIALNUMBERS.SERNUM like '%" & trim(gsno) & "' AND ISNULL(C_CONTRACTITEMS.Active, 1) = 1 AND " & _
REM     "   (SALESTABLE.INVOICEACCOUNT = '" & session("AXCustAccount") & "' or C_SERIALNUMBERS.CUSTOMER = '" & session("AXCustAccount") & "' and c_serialnumbers.dataareaid = 'us')"
cmdTemp.CommandText = _
    "SELECT C_SERIALNUMBERS.INVNUM as inv_no, C_SERIALNUMBERS.TRX_DT2 as inv_dt, C_SERIALNUMBERS.SERNUM as ser_lot_no, C_SERIALNUMBERS.ITEMID as item_no, " & _
    "	ISNULL(INVENTTABLE.ITEMNAME,'') as item_desc_1, " & _
    "	C_CONTRACTITEMS.SupportCoverage, SupportItem.ITEMNAME, " & _
    "	CASE WHEN SupportItem.ITEMNAME like '%Advance Replacement%' then 0 WHEN SupportItem.ITEMNAME like '%Advanced Replacement%' then 0 WHEN SupportItem.ITEMNAME like '%Depot Repair%' THEN 1 ELSE NULL END AS rmatype, " & _
    "	ISNULL(dbo.getdatefromdatetime([dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM)), 'n/a') as datefinal, " & _
    "	CASE WHEN [dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM) IS NULL THEN 1 WHEN [dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM) > getDate() THEN 1 ELSE 1 END AS InWarranty " & _
    "FROM C_SERIALNUMBERS " & _
    "	LEFT OUTER JOIN SALESTABLE ON SALESTABLE.SALESID = C_SERIALNUMBERS.SALESORDERNO " & _
    "	LEFT OUTER JOIN INVENTTABLE ON INVENTTABLE.ITEMID = C_SERIALNUMBERS.ITEMID and INVENTTABLE.DATAAREAID = 'us' " & _
    "	LEFT OUTER JOIN C_CONTRACTITEMS ON C_CONTRACTITEMS.SN = C_SERIALNUMBERS.SERNUM " & _
    "	LEFT OUTER JOIN C_CONTRACTS ON C_CONTRACTS.CONTRACTID_DISPLAY = C_CONTRACTITEMS.CONTRACTID " & _
    "	LEFT OUTER JOIN INVENTTABLE SupportItem ON SupportItem.ITEMID = C_CONTRACTITEMS.SUPPORTCOVERAGE AND SupportItem.DATAAREAID = C_CONTRACTITEMS.DATAAREAID " & _
    "WHERE C_SERIALNUMBERS.SERNUM like '%" & trim(gsno) & "%' AND ISNULL(C_CONTRACTITEMS.Active, 1) = 1 AND " & _
    "   (SALESTABLE.INVOICEACCOUNT = '" & session("AXCustAccount") & "' or C_SERIALNUMBERS.CUSTOMER = '" & session("AXCustAccount") & "' and c_serialnumbers.dataareaid = 'us')"
ChkMacSno.CursorLocation = 3
Set cmdTemp.ActiveConnection = AX

if session("debcode") = "01DMX001" then
    cmdTemp.CommandText = cmdTemp.CommandText & _
       "AND (C_SerialNumbers.ItemID LIKE 's-dmx%')"
end if
cmdTemp.CommandType = 1
'response.Write "<li>" & cmdTemp.CommandText
ChkMacSno.Open cmdTemp, , 1, 1
%>
<!--METADATA TYPE="DesignerControl" endspan-->

<%
if not ChkMacSno.eof and not ChkMacSno.bof then
	%>

<SCRIPT language="JavaScript">
<!--
var Continue = true;
<%if ChkMacSno("rmatype") = "0" or ChkMacSno("rmatype") = "1" then%>
if(parent.document.defplist.rmatype) {
    <%if ChkMacSno("rmatype") = "0" then
        %>if(!parent.document.defplist.rmatype(0).checked && parent.document.defplist.rmatype(1).checked) Continue = false<%
    elseif ChkMacSno("rmatype") = "1" then
        %>if(!parent.document.defplist.rmatype(1).checked && parent.document.defplist.rmatype(0).checked) Continue = false<%
    end if%>
}
<%end if%>
if(!Continue) alert('Invalid defective part selected for current RMA type.\n\nPlease call AGS service dept. for assistance.');
else {
<%if ChkMacSno("rmatype") = "0" or ChkMacSno("rmatype") = "1" then%>
    if(parent.document.defplist.rmatype) parent.document.defplist.rmatype(<%= ChkMacSno("rmatype") %>).checked = true
<%end if%>
    parent.document.defplist.invnum.value = '<%= ChkMacSno("inv_no") %>';
    parent.document.defplist.invdate.value = '<%= ChkMacSno("inv_dt") %>';
    parent.document.defplist.gsnum.value = '<%= ChkMacSno("ser_lot_no") %>';
    parent.document.defplist.pickitem.value = '<%= ChkMacSno("item_no") %>';
    parent.document.defplist.itemdesc.value = '<%= ChkMacSno("item_desc_1") %>';
    parent.document.defplist.warranty.value = 'yes';
<%if DateDiff("yyyy", CDate(ChkMacSno("inv_dt")), Date()) > 3 then%>
    Continue = confirm("<%= ChkMacSno("ser_lot_no") %> (<%= ChkMacSno("item_desc_1") %>) is no longer under warranty (Inv Date: <%=ChkMacSno("inv_dt")%>).  Do you wish to continue?")
    if(Continue) {
        parent.document.defplist.warranty.value = 'no';
    }else{
        parent.document.defplist.warranty.value = '';
        parent.document.defplist.invnum.value = '';
        parent.document.defplist.invdate.value = '';
        parent.document.defplist.gsnum.value = '<%=Request.QueryString("gsno")%>';
        parent.document.defplist.pickitem.value = '';
        parent.document.defplist.itemdesc.value = '';
    }
<%end if %>
<%if trim(ChkMacSno("InWarranty") & "") = "0" then%>
    Continue = confirm("<%= ChkMacSno("ser_lot_no") %> (<%= ChkMacSno("item_desc_1") %>) does not appear to be under warranty (Expiration Date: <%=ChkMacSno("datefinal")%>).  Do you wish to continue?")
    if(Continue) {
        parent.document.defplist.warranty.value = 'no';
    }else{
        parent.document.defplist.warranty.value = '';
        parent.document.defplist.invnum.value = '';
        parent.document.defplist.invdate.value = '';
        parent.document.defplist.gsnum.value = '<%=Request.QueryString("gsno")%>';
        parent.document.defplist.pickitem.value = '';
        parent.document.defplist.itemdesc.value = '';
    }
<%end if %>
}
-->
</SCRIPT>

	<%
else
	%>

<SCRIPT language="JavaScript">
<!--
parent.document.defplist.warranty.value = '';
parent.document.defplist.invnum.value = '';
parent.document.defplist.invdate.value = '';
parent.document.defplist.gsnum.value = '<%=Request.QueryString("gsno")%>';
parent.document.defplist.pickitem.value = '';
parent.document.defplist.itemdesc.value = '';

	alert("An invoice for serial #: <%= gsno %> was not found.\n\nPlease call AGS service dept. for assistance.")
	//location=("../../mainmenu.asp")
-->
</SCRIPT>

<%
End If
%>