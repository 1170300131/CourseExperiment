<!--#include file="conn.asp"-->
<html>
<head>
<title>���õ��̳�</title>
</head>
<body>

	<p align="right">
	�û�:<%Response.write Session("username")%>
	<a href="login">��¼</a>
	<a href="?submit=logout">ע��</a>
	<a href="">����</a>
	</p>
	<%
		Dim submit
			submit=Trim(Request("submit"))
		If submit="logout" Then
			Session("username")=""
			Response.write "<script LANGUAGE='javascript'>alert('�Ѿ��˳���¼!');window.location.href='index.asp'</script>"
		ElseIf submit="buy" Then
			If Session("username")="" Then
				Response.write "<script LANGUAGE='javascript'>alert('δ��¼�����ȵ�¼!')</script>"
			Else
				Dim GName
				GName=Trim(Request("GName"))
				Dim a,b,c

				strSql="select ONum from orders where cfm=0 and username='"&Session("username")&"';"
				Set rs=conn.execute(strSql)
				If rs.eof Or rs.bof Then
					strSql="select isnull(max(ONum)+1,1) as ONum from orders"
					Set rs=conn.execute(strSql)
					strSql="insert into orders(ONum,OTime,username,cfm) values ('"&rs("ONum")&"','"&now()&"','"&Session("username")&"','0')"
					conn.execute(strSql)
				End If
				strSql="select * from buy where ONum='"&rs("ONum")&"' and BName='"&Request("GName")&"'"
				Set rs2=conn.execute(strSql)
				If rs2.eof Or rs2.bof Then
					strSql="insert into buy(ONum,BName) values ('"&rs("ONum")&"','"&Request("GName")&"')"
				End If
				conn.execute(strSql)
				Response.write "<script LANGUAGE='javascript'>alert('�Ѽ��빺�복!')</script>"
				'sql server
				'strSql=       "if not exists (select * from orders where cfm=0 and username='"&Session("username")&"') "
				'strSql=strSql&"begin"
				'strSql=strSql&"declare @a int"
				'strSql=strSql&"select @a=(isnull(max(ONum),0)+1) from orders where cfm=1 and username='"&Session("username")&"'"
				'strSql=strSql&"insert into orders(ONum,OTime,username,cfm) "
				'strSql=strSql&"values (@a,'"&now()&"','"&Session("username")&"','0')"
				'strSql=strSql&"end"
				'strSql=strSql&"declare @b int"
				'strSql=strSql&"select @b=ONum from orders where cfm=0 and username='"&Session("username")&"'"
				'strSql=strSql&"insert into buy(ONum,BName) values (@b,'"&Session("username")&"')"

				'Response.write strSql
				'Set rs=server.CreateObject("adodb.recordset")
				'rs.open strSql,conn,1,1
			End If
		End If
	%>
	<p align="center">
	<a href="index.asp">ѡ����Ʒ</a> ->
	<a href="shoppingCart.asp">���ﳵ</a> ->
	<a href="order.asp">������</a>
	</p>
	<p align="center"><font fane="����" size="5">���õ��̳�</font></p>
	<form method="GET" action="">
		<p align="center">
			<input type="text" name="search" size=20></input>
			<input type="submit" value="����" name="submit">
		</p>
	</form>
	<hr>
	<p align="center">
		<table border="4" width="80%">
			<tr>
				<th width="25%">��Ʒ��</th>
				<th width="25%">����</th>
				<th width="25%">�۸�</th>
				<th width="25%">����</th>
			</tr>
<%


		Dim search
		search=Trim(Request("search"))
		If search <> "" Then
			strSql="select GName,GPrice,GCount from goods where GName='"&search&"'"
		Else
			strSql="select GName,GPrice,GCount from goods"
		End If
		Set rs=server.CreateObject("adodb.recordset")
		rs.open strSql,conn,1,1
		If Not rs.eof And Not rs.bof Then
			Do While Not rs.eof
%>
		<tr>
			<th><%=rs("GName")%></th>
			<th><%=rs("GCount")%></th>
			<th><%=rs("GPrice")%></th>
			<th>
				<a href="?submit=buy&GName=<%=rs("GName")%>">���빺�ﳵ</a>
			</th>
		</tr>
<%
			rs.movenext
			Loop
		End If
		rs.close
%>
		</table>
		</br>
		<input type="button" onclick="javascript:top.location='shoppingCart.asp';" value="����">
	</p>

</body>
</html>