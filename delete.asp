<!DOCTYPE html>
<html>
<body>

<%
lngRecordNo = CLng(Request.QueryString("ID"))
set conn=Server.CreateObject("ADODB.Connection")
conn.Provider="Microsoft.Jet.OLEDB.4.0"
conn.Open "E:/database/suhit.mdb"
Set rsDeleteComments = Server.CreateObject("ADODB.Recordset")
strSQL = "SELECT * FROM gallery WHERE ID=" & lngRecordNo
rsDeleteComments.CursorType = 2
rsDeleteComments.LockType = 3
rsDeleteComments.Open strSQL, conn
rsDeleteComments.Delete
rsDeleteComments.Close
Set rsDeleteComments = Nothing
Set conn = Nothing

Response.Redirect "record.asp"
%>

</body>
</html> 