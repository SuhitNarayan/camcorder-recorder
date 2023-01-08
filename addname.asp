<!DOCTYPE html>
<html>
<body>

<%
lngRecordNo = Request.QueryString("q")
set conn=Server.CreateObject("ADODB.Connection")
conn.Provider="Microsoft.Jet.OLEDB.4.0"
conn.Open "E:/database/suhit.mdb"
Set rsAddComments = Server.CreateObject("ADODB.Recordset")
strSQL = "SELECT * from gallery;"
rsAddComments.CursorType = 2
rsAddComments.LockType = 3
rsAddComments.Open strSQL, conn
rsAddComments.AddNew
rsAddComments.Fields("name") = lngRecordNo
rsAddComments.Update
rsAddComments.Close
Set rsAddComments = Nothing
Set conn = Nothing

Response.Redirect "record.asp"
%>

</body>
</html> 