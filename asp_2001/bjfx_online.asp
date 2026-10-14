<!-- #Include file="../include/adovbs.inc" -->

<%
Dim rstBJFX 	' As ADODB.Recordset
Dim strCnn 		' As String

strCnn = "DRIVER={Microsoft Access Driver (*.mdb)};DBQ=" & Server.MapPath("/lozic/db/bjfx.mdb")
Set rstBJFX = Server.CreateObject("ADODB.Recordset")
rstBJFX.CursorLocation = adUseClient
rstBJFX.Open "bjfx", strCnn, adOpenStatic, adLockBatchOptimistic, adCmdTable
%>

<html>
<head>
<title>Online Graphology System</title>
</head>
<body>
<b>
<center>请您对所提出的<%=rstBJFX.RecordCount%>个问题按四个等级认真进行回答,谢谢!</center>
<form method="post" action="bjfx_result.asp">
<table border="1" style="border-collapse: collapse" bordercolor="#111111">

<%
WHILE NOT rstBJFX.EOF
	Response.Write "<tr>"
	Response.Write "<td>" & rstBJFX.AbsolutePosition & "</td>" & _
				   "<td>" & rstBJFX("ZJTD") & "</td>" & _
				   "<td>" & "<input type=""radio"" name=""ans" & rstBJFX.AbsolutePosition & """ value=""" & rstBJFX("QZSX") & "0"" checked>没有" & _
				   "    " & "<input type=""radio"" name=""ans" & rstBJFX.AbsolutePosition & """ value=""" & rstBJFX("QZSX") & "1"">模糊" & _
				   "    " & "<input type=""radio"" name=""ans" & rstBJFX.AbsolutePosition & """ value=""" & rstBJFX("QZSX") & "2"">一般" & _
				   "    " & "<input type=""radio"" name=""ans" & rstBJFX.AbsolutePosition & """ value=""" & rstBJFX("QZSX") & "4"">显著" & "</td>"
	Response.Write "</tr>"
	rstBJFX.MoveNext
WEND
%>

</table>
<p>
<center>
<input type="submit" value="分析">
<input type="reset" value="重填">
</center>
</p>
</form>
</b>
</body>
</html>

<%
rstBJFX.Close
Set rstBJFX = Nothing
%>
