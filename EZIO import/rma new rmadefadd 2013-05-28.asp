<%@ LANGUAGE="VBSCRIPT" %>
<%IF session("debcode")="" or isnull(session("debcode")) THEN response.Redirect("../../login.asp")%>
<%IF session("company")="" or isnull(session("company")) THEN response.Redirect("../../login.asp")%>
<%IF session("uid")="" or isnull(session("uid")) THEN response.Redirect("../../login.asp")%>


<%
rmanumber = Request.Form("rmanum")

REM A = Advanced Placement, D = Depot Repair, R = Return Upon Receipt, C = Return For Credit
REM CustomerPortals END-user will only be exposed to A AND D for their selection
REM Adtech Internal staffs will have all 4 selections to choose FROM
rma_type_mode = Request.Form("rmatype")
Select Case rma_type_mode
	Case "A" :  incoming = "N"
				outgoing = "N"
				shipparts = "Y"
	Case "D" :  incoming = "N"
				outgoing = "N"
				shipparts = "N"
	Case "R" :  incoming = "N"
				outgoing = "N"
				shipparts = "Y"
	Case "C" :  incoming = "N"
				outgoing = "F"
				shipparts = "N"
End Select
rma_category = Request.Form("rma_category")

DIM Description: Description = RTrim(Request.Form("itemdesc"))
IF request.Form("warranty") = "no" THEN
    Description = Description + " (NON WARRANTIED ITEM)"
END IF

SET gainsystems = Server.CreateObject("ADODB.Connection")
gainsystems.ConnectionTimeout = Session("gainsystems_ConnectionTimeout")
gainsystems.CommandTimeout = Session("gainsystems_CommandTimeout")
gainsystems.Open Session("gainsystems_ConnectionString"), Session("gainsystems_RuntimeUserName"), Session("gainsystems_RuntimePassword")
SET cmdTemp = Server.CreateObject("ADODB.Command")
SET CreateRMA = Server.CreateObject("ADODB.Recordset")
    
cmdTemp.CommandText = "SELECT * FROM rma_header WHERE rma_number = " & rmanumber
'response.Write cmdTemp.CommandText
'response.Flush
cmdTemp.CommandType = 1
SET cmdTemp.ActiveConnection = gainsystems
CreateRMA.Open cmdTemp, , 1, 3
%>
<!--METADATA type="DesignerControl" endspan-->
<%
IF CreateRMA.EOF or CreateRMA.BOF THEN
    CreateRMA.AddNew
    CreateRMA("date_created") = Date
    CreateRMA("has_rep_parts") = shipparts
    CreateRMA("rma_number") = rmanumber
    CreateRMA("what_csp") = wsp
    CreateRMA("rma_nonsir") = "Y"
END IF
CreateRMA("rma_mode") = rma_type_mode
CreateRMA("rma_incoming") = incoming
CreateRMA("rma_outgoing") = outgoing
CreateRMA("rma_status") = "O"
CreateRMA("rma_status_date") = Date
CreateRMA.Update

'    cmdTemp.commandtext = "Update rma_header SET "
'    If CreateRMA.EOF or CreateRMA.BOF Then
'        cmdTemp.commandtext = cmdTemp.commandtext & _
'            "   date_created = '" & Date & "' " & _
'            "   has_rep_parts = '" & shipparts & "' " & _
'            "   rma_number = '" & rmanumber & "' " & _
'            "   what_csp = '" & wsp & "' " & _
'            "   rma_nonsir = 'Y' "
'    else
'        cmdTemp.commandtext = "Update rma_header SET "
'    END IF
'    cmdTemp.commandtext = cmdTemp.commandtext & _
'        "   rma_mode = '" & rma_type_mode & "' " & _
'        "   rma_incoming = '" & incoming & "' " & _
'        "   rma_outgoing = '" & outgoing & "' " & _
'        "   rma_status = 'O' " & _
'        "   rma_status_date = '" & Date & "' " & _
'        "WHERE rma_number = '" & rmanumber & "'"
'    cmdTemp.execute()
    
cmdTemp.commandtext = "Update rma_contact SET rma_category = '" & rma_category & "' WHERE rma_number = '" & rmanumber & "'"
cmdTemp.execute()

IF Request.Form("additem") <> "Add Item" THEN
	redirstr = "rmadone.asp?rma=" & rmanumber
	Response.Redirect(redirstr)
END IF

uid = Request.ServerVariables("LOGON_USER")
%>

<!--METADATA type="DesignerControl" startspan
    <OBJECT ID="AddFAR" width=151 HEIGHT=24
     CLASSID="CLSID:7FAEED80-9D58-11CF-8F68-00AA006D27C2">
        <PARAM name="_Version" value="65536">
        <PARAM name="_Version" value="65536">
        <PARAM name="_ExtentX" value="3969">
        <PARAM name="_ExtentY" value="635">
        <PARAM name="_StockProps" value="0">
        <PARAM name="DataConnection" value="gainsystems">
        <PARAM name="CommandText" value="SELECT * FROM FARLibrary WHERE FARNumber = -1">
        <PARAM name="CursorType" value="1">
        <PARAM name="LockType" value="3">
    </OBJECT>
-->
<%
SET gainsystems = Server.CreateObject("ADODB.Connection")
gainsystems.ConnectionTimeout = Session("gainsystems_ConnectionTimeout")
gainsystems.CommandTimeout = Session("gainsystems_CommandTimeout")
gainsystems.Open Session("gainsystems_ConnectionString"), Session("gainsystems_RuntimeUserName"), Session("gainsystems_RuntimePassword")
SET cmdTemp = Server.CreateObject("ADODB.Command")
SET AddFAR = Server.CreateObject("ADODB.Recordset")
cmdTemp.CommandText = "SELECT * FROM FARLibrary WHERE FARNumber = -1"
cmdTemp.CommandType = 1
SET cmdTemp.ActiveConnection = gainsystems
AddFAR.Open cmdTemp, , 1, 3
%>
<!--METADATA type="DesignerControl" endspan-->
<%
AddFAR.AddNew
AddFAR("FAROpenedBy") = uid
AddFAR("FARDateOpened") = CDate(Date)
AddFAR("FARCustOrSrc") = ""
AddFAR("FARCustRef") = ""
AddFAR("FARPartSerNo") = RTrim(Request.Form("gsnum"))
AddFAR("FARGainRMA") = rmanumber
IF RTrim(Request.Form("otheritem")) = "" THEN
	AddFAR("FARGainPartNo") = RTrim(Request.Form("PickItem"))
ELSE
	AddFAR("FARGainPartNo") = RTrim(Request.Form("otheritem"))
END IF
AddFAR("FARGainPartDesc") = Description
AddFAR("FARPartQty") = CINT(Request.Form("ItemQty"))
AddFAR("FARPartCond") = ""
AddFAR("FARLocation") = ""
AddFAR("FARIsClosed") = "N"
AddFAR("FARStatus") = "Unaddressed"
AddFAR("FARProbDesc") = RTrim(Request.Form("itemprob"))
AddFAR.Update
REM NewFARNum assignment does NOT work
REM NewFARNum = AddFAR("FARNumber")

SET AddedFarNum = Server.CreateObject("ADODB.Recordset")
SET CmdTemp3 = Server.CreateObject("ADODB.Command")
SET CmdTemp3.ActiveConnection = gainsystems
CmdTemp3.CommandText = "SELECT TOP 1 FarNumber FROM FarLibrary WHERE FAROpenedBy LIKE '" & uid & "' AND FARGainRMA = " & RMAnumber & " AND FarDateOpened = '" & AddFAR("FARDateOpened") & "' ORDER BY FARNUMBER DESC;"
CmdTemp3.CommandType = 1
AddedFarNum.Open CmdTemp3, , 1, 3
NewFARNum = AddedFarNum("FarNumber")
AddedFarNum.Close
AddFAR.Close
%>

<!--METADATA type="DesignerControl" startspan
    <OBJECT ID="AddDefItem" width=151 HEIGHT=24
     CLASSID="CLSID:7FAEED80-9D58-11CF-8F68-00AA006D27C2">
        <PARAM name="_Version" value="65536">
        <PARAM name="_Version" value="65536">
        <PARAM name="_ExtentX" value="3969">
        <PARAM name="_ExtentY" value="635">
        <PARAM name="_StockProps" value="0">
        <PARAM name="DataConnection" value="gainsystems">
        <PARAM name="CommandText" value="SELECT * FROM rma_defparts WHERE rma_number = -1">
        <PARAM name="CursorType" value="1">
        <PARAM name="LockType" value="3">
    </OBJECT>
-->
<%

SET gainsystems = Server.CreateObject("ADODB.Connection")
gainsystems.ConnectionTimeout = Session("gainsystems_ConnectionTimeout")
gainsystems.CommandTimeout = Session("gainsystems_CommandTimeout")
gainsystems.Open Session("gainsystems_ConnectionString"), Session("gainsystems_RuntimeUserName"), Session("gainsystems_RuntimePassword")
SET cmdTemp = Server.CreateObject("ADODB.Command")
SET AddDefItem = Server.CreateObject("ADODB.Recordset")
cmdTemp.CommandText = "SELECT max_id = MAX(def_part_id) FROM rma_defparts WHERE rma_number = " & rmanumber
cmdTemp.CommandType = 1
SET cmdTemp.ActiveConnection = gainsystems
AddDefItem.Open cmdTemp, , 1, 3
IF AddDefItem.EOF = true OR AddDefItem.BOF = true OR IsNull(AddDefItem("max_id")) = true THEN
  item_num = 1
ELSE
  item_num = AddDefItem("max_id") + 1
END IF
AddDefItem.Close
cmdTemp.CommandText = "SELECT * FROM rma_defparts WHERE rma_number = " & rmanumber & " AND def_part_id = " & item_num
AddDefItem.Open cmdTemp, , 1, 3
IF AddDefItem.EOF OR AddDefItem.BOF THEN
    %>
    <!--METADATA type="DesignerControl" endspan-->
    <%
    AddDefItem.AddNew
    AddDefItem("def_part_desc") = Description
    AddDefItem("def_part_id") = item_num
    AddDefItem("def_part_inst") = RTrim(Request.Form("iteminst"))
    IF RTrim(Request.Form("otheritem")) = "" THEN
	    AddDefItem("def_part_item") = RTrim(Request.Form("pickitem"))
    ELSE
	    AddDefItem("def_part_item") = RTrim(Request.Form("otheritem"))
    END IF
    AddDefItem("def_part_prob") = RTrim(Request.Form("itemprob"))
    AddDefItem("def_part_sn") = RTrim(Request.Form("gsnum"))
    AddDefItem("def_part_qty") = Request.Form("itemqty")
    AddDefItem("date_expected") = date() + 14
    AddDefItem("qty_recvd") = 0
    AddDefItem("far_idnumber") = NewFARNum
    AddDefItem("rma_number") = rmanumber
    AddDefItem.Update

    redirstr = "rma3.asp?rma=" & rmanumber & "&itemcnt=" & CStr(Request.Form("itemcnt")+1)
    Response.Redirect(redirstr)
ELSE
    %>
    <html><head><title></title></head>
    <body>
    An error occurred adding record: Rma Num: <%= rmanumber %>, Id: <%= item_num %>
    </body>
    </html>
    <%
END IF

%>