<style type="text/css">
    body(scroll: auto;)
</style>

<%@ LANGUAGE="VBscript" %>
<%IF session("debcode")="" or isnull(session("debcode")) THEN response.Redirect("../../login.asp")%>
<%IF session("company")="" or isnull(session("company")) THEN response.Redirect("../../login.asp")%>
<%IF session("uid")="" or isnull(session("uid")) THEN response.Redirect("../../login.asp")%>
<%
    IF session("company") = "EIZO Europe GmbH" AND session("AXCustAccount") = "14312" THEN 
        sDataAreaID = "de" 
        sItemDesc = "	ISNULL(C_SERIALNUMBERS.ITEMname,'') as item_desc_1, " 
    ELSE 
        sDataAreaID = "us" 
        sItemDesc = "	ISNULL(INVENTtable.ITEMname,'') as item_desc_1, "         
    END IF
%>

<% gsno = Request.QueryString("gsno") %>

<!--METADATA type="DesignerControl" startspan
    <OBJECT ID="ChkGSno" width=151 HEIGHT=24
     CLASSID="CLSID:7FAEED80-9D58-11CF-8F68-00AA006D27C2">
        <PARAM name="_Version" value="65536">
        <PARAM name="_Version" value="65536">
        <PARAM name="_ExtentX" value="3969">
        <PARAM name="_ExtentY" value="635">
        <PARAM name="_StockProps" value="0">
        <PARAM name="DataConnection" value="gainsystems">
        <PARAM name="CommandText" value="SELECT invoice_number FROM invdetail WHERE serial_num = '0'">
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
REM     "	ISNULL(INVENTtable.ITEMname,'') as item_desc_1, " & _
REM     "	C_CONTRACTITEMS.SupportCoverage, SupportItem.ITEMname, " & _
REM     "	CASE WHEN SupportItem.ITEMname like '%Advance Replacement%' THEN 0 WHEN SupportItem.ITEMname like '%Advanced Replacement%' THEN 0 WHEN SupportItem.ITEMname like '%Depot Repair%' THEN 1 ELSE NULL END AS rmatype, " & _
REM     "	ISNULL(dbo.getdatefromdatetime([dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM)), 'n/a') as datefinal, " & _
REM     "	CASE WHEN [dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM) IS NULL THEN 0 WHEN [dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM) > getDate() THEN 1 ELSE 0 END AS InWarranty " & _
REM     "FROM C_SERIALNUMBERS " & _
REM     "	LEFT OUTER JOIN SALEStable ON SALEStable.SALESID = C_SERIALNUMBERS.SALESORDERNO " & _
REM     "	LEFT OUTER JOIN INVENTtable ON INVENTtable.ITEMID = C_SERIALNUMBERS.ITEMID and INVENTtable.DATAAREAID = 'us' " & _
REM     "	LEFT OUTER JOIN C_CONTRACTITEMS ON C_CONTRACTITEMS.SN = C_SERIALNUMBERS.SERNUM " & _
REM     "	LEFT OUTER JOIN C_CONTRACTS ON C_CONTRACTS.CONTRACTID_DISPLAY = C_CONTRACTITEMS.CONTRACTID " & _
REM     "	LEFT OUTER JOIN INVENTtable SupportItem ON SupportItem.ITEMID = C_CONTRACTITEMS.SUPPORTCOVERAGE AND SupportItem.DATAAREAID = C_CONTRACTITEMS.DATAAREAID " & _
REM     "WHERE C_SERIALNUMBERS.SERNUM like '%" & trim(gsno) & "' AND ISNULL(C_CONTRACTITEMS.Active, 1) = 1 AND " & _
REM     "   (SALEStable.INVOICEACCOUNT = '" & session("AXCustAccount") & "' or C_SERIALNUMBERS.CUSTOMER = '" & session("AXCustAccount") & "' and c_serialnumbers.dataareaid = 'us')"
cmdTemp.CommandText = _
    "SELECT C_SERIALNUMBERS.INVNUM as inv_no, C_SERIALNUMBERS.TRX_DT2 as inv_dt, C_SERIALNUMBERS.SERNUM as ser_lot_no, C_SERIALNUMBERS.ITEMID as item_no, " & _
    sItemDesc & _
    "	C_CONTRACTITEMS.SupportCoverage, SupportItem.ITEMname, " & _
    "	CASE WHEN SupportItem.ITEMname like '%Advance Replacement%' THEN 0 WHEN SupportItem.ITEMname like '%Advanced Replacement%' THEN 0 WHEN SupportItem.ITEMname like '%Depot Repair%' THEN 1 ELSE NULL END AS rmatype, " & _
    "	ISNULL(dbo.getdatefromdatetime([dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM)), 'n/a') as datefinal, " & _
    "	CASE WHEN [dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM) IS NULL THEN 1 WHEN [dbo].[GetExpirationDate](C_SERIALNUMBERS.SERNUM) > getDate() THEN 1 ELSE 1 END AS InWarranty " & _
    "FROM C_SERIALNUMBERS " & _
    "	LEFT OUTER JOIN SALEStable ON SALEStable.SALESID = C_SERIALNUMBERS.SALESORDERNO " & _
    "	LEFT OUTER JOIN INVENTtable ON INVENTtable.ITEMID = C_SERIALNUMBERS.ITEMID and INVENTtable.DATAAREAID = '" & sDataAreaID & "' " & _
    "	LEFT OUTER JOIN C_CONTRACTITEMS ON C_CONTRACTITEMS.SN = C_SERIALNUMBERS.SERNUM " & _
    "	LEFT OUTER JOIN C_CONTRACTS ON C_CONTRACTS.CONTRACTID_DISPLAY = C_CONTRACTITEMS.CONTRACTID " & _
    "	LEFT OUTER JOIN INVENTtable SupportItem ON SupportItem.ITEMID = C_CONTRACTITEMS.SUPPORTCOVERAGE AND SupportItem.DATAAREAID = C_CONTRACTITEMS.DATAAREAID " & _
    "WHERE C_SERIALNUMBERS.SERNUM like '%" & trim(gsno) & "%' AND ISNULL(C_CONTRACTITEMS.Active, 1) = 1 AND " & _
    "   (SALEStable.INVOICEACCOUNT = '" & session("AXCustAccount") & "' or C_SERIALNUMBERS.CUSTOMER = '" & session("AXCustAccount") & "' ) and c_serialnumbers.dataareaid = '" & sDataAreaID & "';"
ChkMacSno.CursorLocation = 3
Set cmdTemp.ActiveConnection = AX

IF session("debcode") = "01DMX001" THEN
    cmdTemp.CommandText = cmdTemp.CommandText & "AND (C_SerialNumbers.ItemID LIKE 's-dmx%')"
END IF
cmdTemp.CommandType = 1
'response.Write "<li>" & cmdTemp.CommandText
ChkMacSno.Open cmdTemp, , 1, 1
%>
<!--METADATA type="DesignerControl" endspan-->
<!-- Debugging ChkMacSno("rmatype") = <%=ChkMacSno("rmatype")%><br />
 Debugging ChkMacSno("inv_no")=<%=ChkMacSno("inv_no")%><br />
 Debugging ChkMacSno("inv_dt")=<%=ChkMacSno("inv_dt")%><br />
 Debugging ChkMacSno("ser_lot_no")=<%=ChkMacSno("ser_lot_no")%><br />
 Debugging ChkMacSno("item_no")=<%=ChkMacSno("item_no")%><br />
 Debugging ChkMacSno("item_desc_1")=<%=ChkMacSno("item_desc_1")%><br /><br /><br /><br /><br /><br /> -->
<%
IF NOT ChkMacSno.eof AND NOT ChkMacSno.bof THEN
%>
<script language="javascript" type='text/javascript'>
<!--
var Continue = true;
if(parent.document.defplist.rmatype) {
    <%IF ChkMacSno("rmatype") = "0" THEN%>
        parent.document.defplist.rmatype(0).checked = true;
		parent.document.defplist.rmatype(1).checked = false;
    <%ELSEIF ChkMacSno("rmatype") = "1" THEN%>
        parent.document.defplist.rmatype(0).checked = false;
		parent.document.defplist.rmatype(1).checked = true;
    <%END IF%>
}
if(!Continue) 
    alert('Invalid defective part selected for current RMA type.\n\nPlease call AGS service dept. for assistance.');
else {
    parent.document.defplist.invnum.value = '<%=ChkMacSno("inv_no")%>';
    parent.document.defplist.invdate.value = '<%=ChkMacSno("inv_dt")%>';
    parent.document.defplist.gsnum.value = '<%=ChkMacSno("ser_lot_no")%>';
    parent.document.defplist.pickitem.value = '<%=ChkMacSno("item_no")%>';
    parent.document.defplist.itemdesc.value = '<%=ChkMacSno("item_desc_1")%>';
    parent.document.defplist.warranty.value = 'yes';
	<%IF DateDiff("yyyy", CDate(ChkMacSno("inv_dt")), Date()) > 3 THEN%>
		Continue = confirm("<%=ChkMacSno("ser_lot_no")%> (<%=ChkMacSno("item_desc_1")%>) is no longer under warranty (Inv Date: <%=ChkMacSno("inv_dt")%>).  Do you wish to continue?");
		if(Continue){
			parent.document.defplist.warranty.value = 'no';
		} else {
			parent.document.defplist.warranty.value = '';
			parent.document.defplist.invnum.value = '';
			parent.document.defplist.invdate.value = '';
			parent.document.defplist.gsnum.value = '<%=Request.QueryString("gsno")%>';
			parent.document.defplist.pickitem.value = '';
			parent.document.defplist.itemdesc.value = '';
		}
	<%END IF%>
	<%IF TRIM(ChkMacSno("InWarranty") & "") = "0" THEN%>
		Continue = confirm("<%= ChkMacSno("ser_lot_no") %> (<%=ChkMacSno("item_desc_1")%>) does not appear to be under warranty (Expiration Date: <%=ChkMacSno("datefinal")%>).  Do you wish to continue?");
		if(Continue){
			parent.document.defplist.warranty.value = 'no';
		}else{
			parent.document.defplist.warranty.value = '';
			parent.document.defplist.invnum.value = '';
			parent.document.defplist.invdate.value = '';
			parent.document.defplist.gsnum.value = '<%=Request.QueryString("gsno")%>';
			parent.document.defplist.pickitem.value = '';
			parent.document.defplist.itemdesc.value = '';
		}
	<%END IF%>
}
-->
</script>

	<%
ELSE
	%>
<script language="javascript" type="text/javascript">
parent.document.defplist.warranty.value = '';
parent.document.defplist.invnum.value = '';
parent.document.defplist.invdate.value = '';
parent.document.defplist.gsnum.value = '<%=Request.QueryString("gsno")%>';
parent.document.defplist.pickitem.value = '';
parent.document.defplist.itemdesc.value = '';
alert("An invoice for serial #: <%= gsno%> was not found.\n\nPlease call AGS service department for assistance.")
	//location=("../../mainmenu.asp")
</script>

<%
END IF
%>