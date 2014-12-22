<%@ LANGUAGE="VBSCRIPT" %>
<%IF session("debcode")="" or isnull(session("debcode")) THEN response.Redirect("../../login.asp")%>
<%IF session("company")="" or isnull(session("company")) THEN response.Redirect("../../login.asp")%>
<%IF session("uid")="" or isnull(session("uid")) THEN response.Redirect("../../login.asp")%>


<% rmanumber = Request.QueryString("rma") %>
<%
redstar = "<font size=2 COLOR=Red>*</font>"
%>
<!--METADATA type="DesignerControl" startspan
    <OBJECT ID="GetShipInfo" width=151 HEIGHT=24
     CLASSID="CLSID:7FAEED80-9D58-11CF-8F68-00AA006D27C2">
        <PARAM name="_Version" value="65536">
        <PARAM name="_Version" value="65536">
        <PARAM name="_ExtentX" value="3969">
        <PARAM name="_ExtentY" value="635">
        <PARAM name="_StockProps" value="0">
        <PARAM name="DataConnection" value="gainsystems">
        <PARAM name="CommandText" value="SELECT * FROM rma_shipping WHERE rma_number = 0">
    </OBJECT>
-->
<%
SET gainsystems = Server.CreateObject("ADODB.Connection")
gainsystems.ConnectionTimeout = Session("gainsystems_ConnectionTimeout")
gainsystems.CommandTimeout = Session("gainsystems_CommandTimeout")
gainsystems.Open Session("gainsystems_ConnectionString"), Session("gainsystems_RuntimeUserName"), Session("gainsystems_RuntimePassword")
SET cmdTemp = Server.CreateObject("ADODB.Command")
SET GetShipInfo = Server.CreateObject("ADODB.Recordset")
cmdTemp.CommandText = "SELECT * FROM rma_shipping WHERE rma_number = " & rmanumber
cmdTemp.CommandType = 1
SET cmdTemp.ActiveConnection = gainsystems
GetShipInfo.Open cmdTemp, , 0, 1
%>
<!--METADATA type="DesignerControl" endspan-->

<html><head><title></title>
<script type="text/javascript" language="javaScript">
<!--
    function valfm() {
        if (document.rmaship.s2comp.value == '') {
            alert("Please enter a ship-to company name.");
        }
        else if (document.rmaship.s2addr1.value == '') {
            alert("Please enter a ship-to address.");
        }
        else if (document.rmaship.s2city.value == '') {
            alert("Please enter a ship-to city.");
        }
        else if (document.rmaship.s2state.value == '') {
            alert("Please enter a ship-to state.");
        }
        else if (document.rmaship.s2zip.value == '') {
            alert("Please enter a ship-to zip code.");
        }
        else if (document.rmaship.s2zip.value.length < 5) {
            alert("Zip Code NOT long enough.");
        }
        else {
            document.rmaship.submit()
        }
    }
-->
</script>
</head>
<body bgcolor="#FFFFFF">

<!-- Insert HTML here -->
<br />
<font face="Verdana" size='2'>
<strong>Please complete the following shipping information<br />
for the advance replacement components:<br />
<br />
</strong>
<form name="rmaship" action="../../rma/new/rma2a.asp" method="post">
<input type="hidden" name="rmanum" value="<%= rmanumber %>"/>
<table width='72%' cellspacing='0' cellpadding='0' border='0'>
<tr>
	<td width='30%' align='left'>
		<%= redstar %><font face="Verdana" size='2'><b>Company</b></font>
	</td>
	<td align='left'>
		<input type='text' name="s2comp" value="<%= RTrim(GetShipInfo("shipto_company")) %>" size='50' maxlength='50'/>
	</td>
</tr>
<tr>
	<td align='right' colspan='2'>&nbsp;</td>
</tr>
<tr>
	<td width='30%' align='left'>
		<font face="Verdana" size='2'><b>Attention</b></font>
	</td>
	<td align='left'>
		<input type='text' name="s2attn" value="<%= RTrim(GetShipInfo("shipto_attn")) %>" size='50' maxlength='50'/>
	</td>
</tr>
<tr>
	<td align='right' colspan='2'>&nbsp;</td>
</tr>
<tr>
	<td width='30%' align='left'>
		<font face="Verdana" size='2'><b>Phone Number</b></font>
	</td>
	<td align='left'>
		<input type='text' name="s2phone" value="" size='50' maxlength='50'/>
	</td>
</tr>
<tr>
	<td align='right' colspan='2'>&nbsp;</td>
</tr>
<tr>
	<td width='30%' align='left'>
		<%= redstar %><font face="Verdana" size='2'><b>Address</b></font>
	</td>
	<td align='left'>
		<input type='text' name="s2addr1" value="<%= RTrim(GetShipInfo("shipto_addr1")) %>" size='50' maxlength='50'/>
	</td>
</tr>
<tr>
	<td align='right' colspan='2'>&nbsp;</td>
</tr>
<tr>
	<td width='30%' align='left'>
		<font face="Verdana" size='2'>&nbsp;</font>
	</td>
	<td align='left'>
		<input type='text' name="s2addr2" value="<%= RTrim(GetShipInfo("shipto_addr2")) %>" size='50' maxlength='50'/>
	</td>
</tr>
<tr>
	<td align='right' colspan='2'>&nbsp;</td>
</tr>
<tr>
	<td width='30%' align='left'>
		<%= redstar %><font face="Verdana" size='2'><b>City, State, Zip</b></font>
	</td>
	<td align='left'>
		<input type='text' name="s2city" value="<%= RTrim(GetShipInfo("shipto_city")) %>" size='25' maxlength='25'/>&nbsp;
		<input type='text' name="s2state" value="<%= RTrim(GetShipInfo("shipto_state")) %>" size='5' maxlength='2'/>&nbsp;&nbsp;
		<input type='text' name="s2zip" value="<%= RTrim(GetShipInfo("shipto_zip")) %>" size='15' maxlength='12'/>
	</td>
</tr>
<tr>
	<td align='right' colspan='2'>&nbsp;</td>
</tr>
<tr>
	<td align='right' colspan='2'><input type='button' name="saverec" value=" Next -> " onclick="valfm()"/></td>
</tr>
</table>
</form>
</font>
</body>
</html>
