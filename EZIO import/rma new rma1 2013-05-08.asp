<%@ language="VBSCRIPT" %>
<%if session("debcode")="" or isnull(session("debcode")) then response.Redirect("../../login.asp")%>
<%if session("company")="" or isnull(session("company")) then response.Redirect("../../login.asp")%>
<%if session("uid")="" or isnull(session("uid")) then response.Redirect("../../login.asp")%>


<script language="javascript" type="text/javascript">
<!--
	window.parent.fr_head.apname.innerText = "RMA - New";
//-->
</script>

<% rmanumber = Request.QueryString("rma") %>

<html><head><title>RMA New</title></head>
<body bgcolor="#FFFFFF">

<!-- Insert HTML here -->
<br />
<font face="Verdana" size='2'>RMA #: </font><font color="Red">R-<%= rmanumber %></font>
<br /><br />
<form name="rmaform" action="rma1a.asp" method="Post">
<input type="hidden" name="rmanum" value="<%= rmanumber %>"/>
<font face="Verdana" size='2'>
<strong>Please choose what type of RMA you are creating :<br />
</strong>
<i>
Choose Advance Replacement if AGS needs to send parts to the customer site.<br />
Choose Depot Repair if the machine will be sent to AGS for repair.
</i>
<br /><br />
<%IF session("company") = "EIZO Europe GmbH" AND session("AXCustAccount") = "14312" THEN%> 
<input type='radio' name="rmatype" value="A" />Advance Replacement<br />
<input type='radio' name="rmatype" value="D" checked="checked" />Depot Repair<br />
<%ELSE%>
<input type='radio' name="rmatype" value="A" checked="checked" />Advance Replacement<br />
<input type='radio' name="rmatype" value="D" />Depot Repair<br />
<%END IF%>

<!--
<input type=Radio name="rmatype" value="D" checked onClick="chkit('2')">Depot Repair<br />
<br /><br />
<strong>Choose which warranty service will be involved:<br />
</strong>
<i>
Choose On-Site Repair if a technician needs to be dispatched for repair service.
</i>
<br /><br />
-->
<!--<input type=Radio name="wsp" value="G">AGS Service Technician<br />-->
<!--<input type=Radio name="wsp" value="S" onClick="chkit('1')">On-Site Repair<br />-->
<!--<input type=Radio name="wsp" value="P">Panda<br />-->
<!--<input type=Radio name="wsp" value="N" checked>None<br />-->
<input type='hidden' name="wsp" value="N"/><br />
<br /><br />
<input type="submit" name="nextstep" value=" Next -> "/>
</font>
</form>

</body>

<script language="JavaScript" type="text/javascript">
<!--
function chkit( intype )
{
	if( intype == '1' ) 
		rmaform.rmatype(0).checked = 1;
	else
		rmaform.wsp(1).checked = 1;
}
//-->
</script>

<script language="vbscript" type="text/vbscript">
<!--
Function chkform()
	If rmaform.rmatype(0).checked = false and rmaform.rmatype(1).checked = false and rmaform.rmatype(2).checked = false Then
	    MsgBox "Please choose a RMA Category.", vbExclamation + vbOkOnly, "Warning"
	rem Elseif rmaform.wsp(3).checked = False Then
	rem 	MsgBox "Service Provider must be None.", vbExclamation + vbOkOnly, "Warning"
	Else
		rmaform.Submit
	End If
End Function
//-->
</script>


</html>
