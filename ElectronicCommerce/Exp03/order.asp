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

	<p align="center"><font fane="����" size="5">������</font></p>
	<hr>
<%
		If Trim(Request("del"))<>"" Then
			strSql="select ONum from orders where username='"&Session("username")&"' and cfm=1 and ONum='"&Request("del")&"'"
			Set rs=conn.execute(strSql)
			strSql="delete from orders where ONum='"&rs("ONum")&"'"
			'Response.write strSql
			Set rs2=conn.execute(strSql)
			strSql="delete from buy where ONum='"&rs("ONum")&"'"
			Set rs2=conn.execute(strSql)
			'Response.write strSql
			'Response.End
			rs.close
		End If
%>
	<p align="center">
	<%
		strSql="select ONum,OTime,consignee,location,zipcode,tel from orders where username='"&Session("username")&"' and cfm=1 order by ONum desc"
		Set rs=conn.execute(strSql)
		If rs.eof Or rs.bof Then
			Response.write "�����ύ�Ķ���"
			Response.End
		Else
			Do While Not rs.eof
			
	%>
	</p>
		<p align="center">
		������Ϣ
		<table border="2" width="80%">
			<tr>
				<th width="40%">�û�</th>
				<th width="60%"><%Response.write Session("username")%></th>
			</tr>
			<tr>
				<th width="40%">������</th>
				<th width="60%"><%=rs("ONum")%></th>
			</tr>
			<tr>
				<th width="40%">����ʱ��</th>
				<th width="60%"><%=rs("OTime")%></th>
			</tr>
				<th width="40%">�ܼ�</th>
				<th width="60%">
				<%
					strSql="select sum(BCount*GPrice) as total from buy left join goods on buy.BName=goods.GName where ONum='"&rs("ONum")&"'"
					Set rs2=conn.execute(strSql)
					Response.write rs2("total")
				%></th>
		</table>

		��Ʒ��Ϣ
		<table border="3" width="80%">
			<tr>
				<th width="40%">��Ʒ��</th>
				<th width="30%">����</th>
				<th width="30%">�۸�</th>
			</tr>
<%
		strSql="select BName,BCount,GPrice from buy left join goods on buy.BName=goods.GName where ONum='"&rs("ONum")&"'"
		Set rs2=conn.execute(strSql)
		If Not rs2.eof And Not rs2.bof Then
			Do While Not rs2.eof
%>
		<tr>
			<th><%=rs2("BName")%></th>
			<th><%=rs2("BCount")%></th>
			<th><%=rs2("GPrice")%></th>
		</tr>
<%
			rs2.movenext
			Loop
		End If
%>
		</table>
		������Ϣ
		<table border="2" width="80%">
			<tr>
				<th width="40%">�ջ���</th>
				<th width="60%"><%=rs("consignee")%></th>
			</tr>
			<tr>
				<th width="40%">�ջ���ַ</th>
				<th width="60%"><%=rs("location")%></th>
			</tr>
			<tr>
				<th width="40%">�ʱ�</th>
				<th width="60%"><%=rs("zipcode")%></th>
			</tr>
			<tr>
				<th width="40%">�绰</th>
				<th width="60%"><%=rs("tel")%></th>
			</tr>
		</table>
		
		<br>
		<input type="button" onclick="javascript:top.location='?del=<%=rs("ONum")%>';" value="ɾ������">
	<%
		rs.movenext
		rs2.close
	%>
		<hr>
	<%
	Loop
	End If
	rs.close
	%>
	</p>

</body>
</html>