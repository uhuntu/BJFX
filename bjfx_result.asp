<!-- #Include file="../include/adovbs.inc" -->

<%
Dim rstBJFX 	' As ADODB.Recordset
Dim strCnn 		' As String

strCnn = "DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" & Server.MapPath("/lozic/db/bjfx.mdb")
Set rstBJFX = Server.CreateObject("ADODB.Recordset")
rstBJFX.CursorLocation = adUseClient
rstBJFX.Open "bjfx", strCnn, adOpenStatic, adLockBatchOptimistic, adCmdTable
%>

<% 
DZ_Count = 0
YY_Count = 0
NY_Count = 0
DX_Count = 0
Max_QZSX = ""
MXCD = ""	' 表示明显程度

For Each x In Request.Form
	Select Case Left(Request.Form(x), 2)
	Case "DZ"	'胆汁质
		DZ_Count = DZ_Count + Right(Request.Form(x), 1)
  	Case "YY"	'抑郁质
		YY_Count = YY_Count + Right(Request.Form(x), 1)
  	Case "NY"	'粘液质
		NY_Count = NY_Count + Right(Request.Form(x), 1)
  	Case "DX"	'多血质
		DX_Count = DX_Count + Right(Request.Form(x), 1)
  	End Select
  	
  	' !注意! Move的参数是相对位置，所以第一条记录的相对位置应是1 - 1，以此类推。
	rstBJFX.Move Mid(x, 4, 2) - 1, adBookmarkFirst	
	rstBJFX("XZBJ") = Right(Request.Form(x), 1)
Next 

If DZ_Count > YY_Count And DZ_Count > NY_Count And DZ_Count > DX_Count Then	Max_QZSX = "DZ"
If YY_Count > DZ_Count And YY_Count > NY_Count And YY_Count > DX_Count Then	Max_QZSX = "YY"
If NY_Count > DZ_Count And NY_Count > YY_Count And NY_Count > DX_Count Then	Max_QZSX = "NY"
If DX_Count > DZ_Count And DX_Count > YY_Count And DX_Count > NY_Count Then	Max_QZSX = "DX"

If Max_QZSX = "" Then
	Response.Write "对不起,分析失败."
	Response.Write "<br>"
	Response.Write "可能原因:"
	Response.Write "<br>"
	Response.Write "&nbsp&nbsp&nbsp&nbsp1.被分析的人性格怪异;"
	Response.Write "<br>"
	Response.Write "&nbsp&nbsp&nbsp&nbsp2.您在回答问题上出现偏差."
	Response.Write "<br>"
	Response.Write "建议按后退键再做一次分析."
	Response.Write "<br>"
	Response.End
End If	
 
rstBJFX.MoveFirst
rstBJFX.Filter = "QZSX = '" & Max_QZSX & "' AND XZBJ <> '0'"
rstBJFX.Sort = "XZBJ DESC" 	' 注意是DESC，而非MSDN98的DESCENDING
rstBJFX.MoveFirst
%>

<html>
<head>
<title>Online Graphology System</title>
</head>
<body>
<b>
<center>您的分析结果如下：</center>
<br>
<table border="1" style="border-collapse: collapse" bordercolor="#111111">

<%
WHILE NOT rstBJFX.EOF
	Select Case rstBJFX("XZBJ")
	Case 1
		MXCD = "模糊"
	Case 2
		MXCD = "一般"
	Case 4
		MXCD = "显著"
	End Select

	Response.Write "<tr>"
	Response.Write "<td>" & MXCD & "</td>" & _
				   "<td>" & rstBJFX("DYXG") & "</td>" 
	Response.Write "</tr>"
	rstBJFX.MoveNext
WEND
%>

</table>
</b>
</body>
</html>

<%
rstBJFX.Sort = ""
rstBJFX.Filter = ""
rstBJFX.CancelBatch

rstBJFX.Close
Set rstBJFX = Nothing
%>
