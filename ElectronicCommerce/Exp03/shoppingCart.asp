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
		If Session("username")="" Then
			Response.write "<script LANGUAGE='javascript'>alert('δ��¼�����ȵ�¼!')</script>"
		End If
		Dim submit
			submit=Trim(Request("submit"))
		If submit="logout" Then
			Session("username")=""
			Response.write "<script LANGUAGE='javascript'>alert('�Ѿ��˳���¼!');window.location.href='index.asp'</script>"
		End If
	%>
	<p align="center">
	<a href="index.asp">ѡ����Ʒ</a> ->
	<a href="shoppingCart.asp">���ﳵ</a> ->
	<a href="order.asp">������</a>
	</p>

	<p align="center"><font fane="����" size="5">���ﳵ</font></p>
	<hr>
<%
		If Trim(Request("submit"))<>"" Then
			strSql="select ONum from orders where username='"&Session("username")&"' and cfm=0"
			Set rs=conn.execute(strSql)
			strSql="update orders set consignee='"&Request("consignee")&"',location='"&Request("location")&"',zipcode='"&Request("zipcode")&"',tel='"&Request("tel")&"' where ONum='"&rs("ONum")&"'"
			Set rs2=conn.execute(strSql)
			strSql="select BName,GCount from buy left join goods on buy.BName=goods.GName where ONum='"&rs("ONum")&"'"
			Set rs3=conn.execute(strSql)
			If Not rs3.eof And Not rs3.bof Then
				Do While Not rs3.eof
					'Response.write Request(rs3("BName"))&rs3("GCount")
					If CInt(Request(rs3("BName")))>=CInt(rs3("GCount")) Then
						Response.write "<script LANGUAGE='javascript'>alert('��治�㣬������ѡ���������');history.go(-1)</script>"
						Response.End
					End If
					rs3.movenext
				Loop
			End If
			rs3.close
			strSql="select BName from buy where ONum='"&rs("ONum")&"'"
			Set rs2=conn.execute(strSql)
			If Not rs2.eof And Not rs2.bof Then
				Do While Not rs2.eof
					strSql="update buy set BCount='"&Request(rs2("BName"))&"' where ONum='"&rs("ONum")&"' and BName='"&rs2("BName")&"'"
					conn.execute(strSql)
					strSql="update goods set GCount=GCount-'"&Request(rs2("BName"))&"' where  GName='"&rs2("BName")&"'"
					'Response.write strSql
					'Response.End
					conn.execute(strSql)
					rs2.movenext
				Loop
			End If
			strSql="update orders set cfm=1 where ONum='"&rs("ONum")&"'"
			Set rs2=conn.execute(strSql)
			rs.close
			Response.write "<script LANGUAGE='javascript'>alert('�����ɶ���!')</script>"
		End If
%>
	<form>
	<p align="center">
		������Ϣ
		<table border="2" width="80%">
			<tr>
				<th width="40%">�û�</th>
				<th width="60%"><%Response.write Session("username")%></th>
			</tr>
			<tr>
				<th width="40%">������</th>
				<th width="60%">
				<%
					strSql="select ONum,OTime from orders where username='"&Session("username")&"' and cfm=0"
					Set rs=conn.execute(strSql)
					If rs.eof Or rs.bof Then
						Response.write "���ﳵΪ��,����ѡ����Ʒ"
						Response.end
					Else
						Response.write rs("ONum")
					End If
				%>
				</th>
			</tr>
			<tr>
				<th width="40%">����ʱ��</th>
				<th width="60%"><%=rs("OTime")%></th>
			</tr>
		</table>
		��Ʒ��Ϣ
		<table border="3" width="80%">
			<tr>
				<th width="40%">��Ʒ��</th>
				<th width="30%">����</th>
				<th width="30%">�۸�</th>
			</tr>
<%
		strSql="select BName,GPrice from buy left join goods on buy.BName=goods.GName where ONum='"&rs("ONum")&"'"
		Set rs2=conn.execute(strSql)
		If Not rs2.eof And Not rs2.bof Then
			Do While Not rs2.eof
%>
		<tr>
			<th><%=rs2("BName")%></th>
			<th><input type="text" name=<%=rs2("BName")%> size=10></input></th>
			<th><%=rs2("GPrice")%></th>
		</tr>
<%
			rs2.movenext
			Loop
		End If
		rs.close
		rs2.close
%>
		</table>
		������Ϣ
		<table border="2" width="80%">
			<tr>
				<th width="40%">�ջ���</th>
				<th width="60%"><input type="text" name="consignee" size=20></th>
			</tr>
			<tr>
				<th width="40%">�ջ���ַ</th>
				<th width="60%"><input type="text" name="location" size=20></th>
			</tr>
			<tr>
				<th width="40%">�ʱ�</th>
				<th width="60%"><input type="text" name="zipcode" size=20></th>
			</tr>
			<tr>
				<th width="40%">�绰</th>
				<th width="60%"><input type="text" name="tel" size=20></th>
			</tr>
		</table>
		
		<br>
		<input type="submit" value="���ɶ���" name="submit">
		<input type="button" onclick="javascript:top.location='order.asp';" value="�鿴�嵥">
	</p>
	</form>
	

</body>
</html>