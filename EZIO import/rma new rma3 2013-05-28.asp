<%@ LANGUAGE="VBSCRIPT" %>
<%IF session("debcode")="" or isnull(session("debcode")) THEN response.Redirect("../../login.asp")%>
<%IF session("company")="" or isnull(session("company")) THEN response.Redirect("../../login.asp")%>
<%IF session("uid")="" or isnull(session("uid")) THEN response.Redirect("../../login.asp")%>

<%
rmanumber = Request.QueryString("rma")
itemcnt = Request.QueryString("itemcnt")
IF itemcnt = "" THEN itemcnt = "0"
needother = 0

redstar = "<font size='2' COLOR=Red>*</font>"

SET conGesinet = Server.CreateObject("ADODB.Connection")
conGesinet.Open Session("gainsystems_ConnectionString"), Session("gainsystems_RuntimeUserName"), Session("gainsystems_RuntimePassword")
SET GetDefList = Server.CreateObject("ADODB.Recordset")

sSQL = "SELECT rma_header.rma_mode, rma_header.rma_problem, rma_category FROM rma_header LEFT OUTER JOIN rma_contact on rma_contact.rma_number = rma_header.rma_number WHERE rma_header.rma_number = " & rmanumber & ";"
GetDefList.Open sSQL, conGesinet
IF NOT GetDefList.EOF THEN
    rmatype = GetDefList("rma_mode")
    rmaproblem = GetDefList("rma_problem")
    rma_category = GetDefList("rma_category")
END IF
GetDefList.close()

sSQL = "select * FROM rma_defparts WHERE rma_number = " & rmanumber & ";"
GetDefList.Open sSQL, conGesinet
%>
<!-- Insert HTML here -->
<html><head><title></title>
<style type="text/css">
em
	{
	font-family:"sans-serif";
	font-size:80%
	}
</style>

<script type="text/javascript" language='javascript'>
<!--
function deldefpart(partid)
{
	var findurl;
	findurl = "deldefparts.asp?rmano="+<%=rmanumber%>+"&partid="+partid;
	window.box.location=findurl;//, "viewinv", "toolbar=no,location=no,resizeable=no,width=230,height=230,top=250,left=300");
  //  document.all("box").src=(findurl);
    //window.location=(findurl)
}

function UpdDesc()
{
	tempStr = document.defplist.pickitem.value;
	intStrPos = tempStr.indexOf('|');
	if( intStrPos != -1 )
	{
		itemStr = tempStr.substring(0,intStrPos);
		descStr = tempStr.substring(intStrPos+1,tempStr.length);
	}
	document.defplist.itemnum.value = itemStr;
	document.defplist.itemdesc.value = descStr;
	document.defplist.otheritem.value = '';
	
	if (itemStr.length == 6)
	{
		document.defplist.itemserno.value = document.defplist.gserno.value;
	}
	else 
	{
		document.defplist.itemserno.value = '';
	}
}

function findserno( newval )
{//AAA00001HA     
    if (newval != '')
    {
	    var findurl;
	    findurl = "findserno.asp?gsno=" + newval;
	    var serno;
	    window.box.location=(findurl);//, "viewinv", "toolbar=no,location=no,resizeable=no,width=230,height=230,top=250,left=300");
	}
}

function ClearSelect(part)
{
	if (part == 1)
	{
		document.defplist.otheritem.value = '';
	}
	if (part == 2)
	{
		document.defplist.itemnum.value = '';
		document.defplist.itemdesc.value = '';
		document.defplist.itemserno.value = '';
		document.defplist.pickitem.value = '-1';
	}
}

function UpdProb(prob_code)
{
	window.open("rma3a.asp?code="+prob_code,"","width=400,height=200,top=250,left=300")
    //Window.Open(redirstr,"showrfe","toolbar=no,location=no,resizeable=no,scrollbars=yes,top=" & (Screen.Height-500)/2 & ",left=" & (Screen.width-600)/2 & ",width=600,height=500")
}

function verifySnfrm()
{
//    alert(document.defplist.warranty.value)
	if (document.defplist.itemprob.value == '')
	{
		alert ("A problem description needs to be entered to continue.");
	}
	else
	{
		document.defplist.additem.value = 'Add Item';
		document.defplist.submit();
	}
}

function verifyfrm()
{
	if ( document.defplist.rmatype == null || ( document.defplist.rmatype.value != 'A' && document.defplist.rmatype.value != 'D' ))
	{
		alert ("An RMA type needs to be selected to continue.");
		return false;
	}
//	else if (!(document.defplist.rmaproblem(0).checked || document.defplist.rmaproblem(1).checked))
//	{
//		alert ("A problem type needs to be selected to continue.");
//		return false;
//	}
<%IF session("debcode") = "01DMX001" THEN%>
	else if ( document.defplist.rma_category == null || ( document.defplist.rma_category.value != 'RMA_DOA' && document.defplist.rma_category.value != 'RMA_OOB' && document.defplist.rma_category.value != 'RMA_Flat-Rate' ))
	{
		alert ("An RMA category needs to be selected to continue.");
		return false;
	}
<%END IF%>
	else
	{
		return true;
	}
}
-->
</script>
</head>
<body bgcolor="#FFFFFF">
<br />
<font face="Verdana" size='2'>RMA #: <font color="Red">R-<%= rmanumber %></font></font>
<br /><br />
<form name="defplist" action="rmadefadd.asp" method="post">
<input type="hidden" name="rmanum" value="<%= rmanumber %>"/>
<input type="hidden" name="itemcnt" value="<%= itemcnt %>"/>
<input type="hidden" name="warranty"/>
<table cellspacing='0' cellpadding='0' border='0'>
    <tr valign="top">
        <td style="padding-right: 15px">
            <font face="Verdana" size='2'>
            <%= redstar %><strong>RMA Type:</strong></font>
            <br /><br /><!---<%=rmatype%>--->

            <input type='radio' name="rmatype" value="A" checked='checked' <%IF session("debcode") = "01DMX001" THEN%> disabled="disabled"<%END IF %>/>Advance Replacement<br />

            <%IF session("company") <> "EIZO Europe GmbH" OR session("AXCustAccount") <> "14312" THEN%>
            <input type='radio' name="rmatype" value="D"<%IF rmatype = "D" OR session("debcode") = "01DMX001" THEN%> checked='checked'<%END IF%>/>Depot Repair<br />
            <%END IF%>
        </td>
<%IF session("debcode") = "01DMX001" THEN%>
        <td>
			<font face="Verdana" size='2'>
			    <%= redstar %><strong>RMA Category: </strong>
			    <br /><br /><!---<%=rma_category %> --->
                <input type="radio" name="rma_category" value="RMA_DOA"<%IF rma_category = "RMA_DOA" THEN%> checked='checked'<%END IF%>/>RMA-30 Day DOA
                <br />
                <input type="radio" name="rma_category" value="RMA_OOB"<%IF rma_category = "RMA_OOB" THEN%> checked='checked'<%END IF%>/>RMA-OOB + 30 days
                
                <input type="radio" name="rma_category" value="RMA_Flat-Rate"<%IF rma_category = "RMA_Flat-Rate" THEN%> checked='checked'<%END IF%>/>RMA-Flat-Rate Repair
            </font>
        </td>
<%END IF%>
    </tr>
</table>
<br />
<table width='88%' cellspacing='0' cellpadding='0' border='0'>
	<tr>
		<td colspan="3">
		<font face="Verdana" size='2'><strong>Enter the serial number AND click "Search Now" below:</strong></font><br />
		<br />
		</td>
	</tr>
	<tr>
		<td width='30%' align='left'>
			<%= redstar %><font face="Verdana" size='2'><strong>AGS Serial Number: </strong></font>
		</td>
		<td align='left'>
			<input type='text' name="gsnum" value="" size='25' maxlength='18' onchange="findserno(gsnum.value)" />
			<input type='button' name="gsfind" value="Search Now" onclick="findserno(gsnum.value)" />
		</td>
	</tr>
	<tr>
		<td width='30%' align='left'>&nbsp;
		</td>
	</tr>
	<tr>
		<td width='30%' align='left'>
			<%= redstar %><font face="Verdana" size='2'>Invoice Number: </font>
		</td>
		<td align='left'>
			<input type='text' name="invnum" value="" size='25' maxlength='18' />
			<input type="hidden" name="invdate" value="" />
		</td>
	</tr>
	<tr>
		<td width='30%' align='left'>&nbsp;
		</td>
	</tr>
    <tr>
	<td align='left'>
		<%= redstar %><font face="Verdana" size='2'><b>Item</b></font>
	</td>
	<td align='left'>
		<!--METADATA type="DesignerControl" startspan
			<OBJECT ID="GetInvInfo" width=151 HEIGHT=24
			CLASSID="CLSID:7FAEED80-9D58-11CF-8F68-00AA006D27C2">
				<PARAM name="_Version" value="65536">
				<PARAM name="_Version" value="65536">
				<PARAM name="_ExtentX" value="3969">
				<PARAM name="_ExtentY" value="635">
				<PARAM name="_StockProps" value="0">
				<PARAM name="DataConnection" value="conGesinet">
				<PARAM name="CommandText" value="SELECT">
			</OBJECT>
		-->
            <input name="pickitem" value="" />
		
	</td>
</tr>
<tr valign="top">
	<td align='left'>
	<%	If needother Then%>
		<font face="Verdana" size='2'><b>Other Item</b></font><br />
		<em>If part NOT detailed on invoice (ie. power supply) enter it here.</em>
	</td>
	<td align='left'>
		<input type='text' name="otheritem" value="" size='25' maxlength='30' onchange="ClearSelect(2)" />
	<%else%>
	</td>
	<td align='left'>
		<input type='hidden' name="otheritem" value="" size='25' maxlength='30' onchange="ClearSelect(2)" />
	<%END IF%>
	</td>
</tr>
<tr valign="top">
	<td colspan='2' align='left'>&nbsp;</td>
</tr>
<tr valign="top">
	<td align='left'>
		<%= redstar %><font face="Verdana" size='2'><b>Item Description</b></font>
	</td>
	<td align='left'>
		    <input type='text' name="itemdesc" size='50' maxlength='35' />
	</td>
</tr>
<tr>
	<td colspan='2' align='left'>&nbsp;</td>
</tr>
<tr valign="top">
	<td align='left'>
		<%= redstar %><font face="Verdana" size='2'><b>Quantity</b></font>
	</td>
	<td align='left'>
		<input type='text' name="itemqty" value="1" size='50' maxlength='5' />
	</td>
</tr>
<tr>
	<td colspan='2' align='left'>&nbsp;</td>
</tr>
<tr valign="top">
	<td valign='top' align='left'>
		<%= redstar %><font face="Verdana" size='2'><b>Problem</b></font><br />
		<em>Type in a detailed description of the problem in the box.</em>
	</td>
	<td align='left'>
		<textarea name="itemprob" cols='50' rows='3'></textarea>
	</td>
</tr>
<tr>
	<td colspan='2' align='left'>&nbsp;</td>
</tr>
<tr valign="top">
	<td valign='top' align='left'>
		<font face="Verdana" size='2'><b>Special Instructions</b><br />
		<em>Use this field to denote special shipping instructions, jumper configurations, etc...</em></font>
	</td>
	<td align='left'>
		<textarea name="iteminst" cols='50' rows='3'></textarea>
	</td>
</tr>
<tr>
	<td colspan='2' align='left'>&nbsp;</td>
</tr>
<tr>
	<td colspan='2' align='left'>
<table><tr valign='top'><td align='left'><em>Click on 'Add Item' for each item that you are requesting an RMA for.</em></td>
		<td><input type='hidden' name="additem" value="" />
		<input type="button" value="Add Item" onclick="verifySnfrm()" /></td></tr>
<tr valign='top'><td align='left'><em>Click on 'Done' when finished adding items to the RMA.<br />
(must enter at least 1 item to complete RMA)</em> </td>
        <td><input type="submit" value="Done" <%IF GetDefList.EOF THEN%>disabled<%END IF%> onclick="return verifyfrm()" /></td></tr></table>
	</td>
</tr>
</table>
<table border="1" width="100%">
<tr style="font-size:11pt" bgcolor="#00CC00">
	<td>Line#</td>
	<td>Defective. Part#</td>
	<td>Description.</td>
	<td>Ser#</td>
	<td>Qty</td>
	<td>Delete</td>
<!--
	<td style="font-size=65%;" align="center">Delete</td>
-->
</tr>
<%
	IF NOT GetDefList.EOF AND NOT GetDefList.BOF THEN
	GetDefList.movefirst
	while NOT GetDefList.EOF
%>
<tr style="font-size:10pt">
	<td><%=GetDefList("def_part_id")%></td>
	<td><%=GetDefList("def_part_item")%></td>
	<td><%=GetDefList("def_part_desc")%></td>
	<td><%=GetDefList("def_part_sn")%></td>
	<td><%=GetDefList("def_part_qty")%></td>
	<td align="center" onclick="deldefpart('<%=GetDefList("def_part_id")%>')"><img src="../../images/trashcan.JPG" alt='Trashcan'/></td>
</tr>
<%
	GetDefList.movenext
	WEND
	END IF
	GetDefList.close
%>
</table>

<iframe name="box" align="right" height="100" width="500" frameborder="0" scrolling="no"></iframe>

</form>
</body>
</html>
