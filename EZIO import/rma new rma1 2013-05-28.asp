<%@ language="VBSCRIPT" %>
<%IF session("debcode")="" or isnull(session("debcode")) THEN response.Redirect("../../login.asp")%>
<%IF session("company")="" or isnull(session("company")) THEN response.Redirect("../../login.asp")%>
<%IF session("uid")="" or isnull(session("uid")) THEN response.Redirect("../../login.asp")%>
<% rmanumber = Request.QueryString("rma") %>
<html><head><title>RMA New</title>
<script language="javascript" type="text/javascript">
<!--
    window.parent.fr_head.apname.innerText = "RMA - New";
//-->
</script>
<script language="JavaScript" type="text/javascript">
<!--
    function chkit(intype) {
        if (intype == '1')
            rmaform.rmatype(0).checked = 1;
        else
            rmaform.wsp(1).checked = 1;
    }
//-->
</script>

<script language="vbscript" type="text/vbscript">
<!--
FUNCTION chkform()
	IF rmaform.rmatype(0).checked = FALSE AND rmaform.rmatype(1).checked = FALSE AND rmaform.rmatype(2).checked = FALSE THEN
	    MsgBox "Please choose a RMA Category.", vbExclamation + vbOkOnly, "Warning"
	rem Elseif rmaform.wsp(3).checked = False Then
	rem 	MsgBox "Service Provider must be None.", vbExclamation + vbOkOnly, "Warning"
	ELSE
		rmaform.Submit
	END IF
END FUNCTION
//-->
</script>
</head>
<body bgcolor="#FFFFFF">

<!-- Insert HTML here -->
<br />
<font face="Verdana" size='2'>RMA #: </font><font color="Red">R-<%= rmanumber %></font>
<br /><br />
<form name="rmaform" action="rma1a.asp" method="post">
<input type="hidden" name="rmanum" value="<%= rmanumber %>"/>
<font face="Verdana" size='2'>
<strong>Please choose what type of RMA you are creating :<br />
</strong>
<i>
Choose Advance Replacement if AGS needs to send parts to the customer site.<br />
Choose Depot Repair if the machine will be sent to AGS for repair.
</i>
<br /><br />
<input type='radio' name="rmatype" value="A" />Advance Replacement<br />
<input type='radio' name="rmatype" value="D" checked="checked" />Depot Repair<br />
<!--
<input type=Radio name="rmatype" value="D" checked onClick="chkit('2')">Depot Repair<br />
<br /><br />
<strong>Choose which warranty service will be involved:<br />
</strong>
<i>
Choose On-Site Repair IF a technician needs to be dispatched for repair service.
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
</html>
