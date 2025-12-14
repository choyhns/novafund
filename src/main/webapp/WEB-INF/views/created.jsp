<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script type="text/javascript">


</script>
</head>
<body>


<form name="myForm" action="" method="post" enctype="multipart/form-data">

<label>카테고리</label>
<select name="category">
	<option value="" selected>선택</option>
	
    <c:forEach var="cat" items="${lists}">
        <option value="${cat.numCategory}">${cat.name}</option>
    </c:forEach>
</select>

<div>
	<dl>
		<dt>subject</dt>
		<dd>
		<input type="text" name="subject"
		size="35" maxlength="20">
		</dd>	
	</dl>
</div>
<div>
	<dl>
		<dt>content</dt>
		<dd>
		<input type="text" name="content"
		size="50" maxlength="30">
		</dd>	
	</dl>
</div>

<c:set var="i" value="${1 }"></c:set>

<div>
    <input type="file" name="uploadFile" />
    <input type="button" id="plus" value="+"/>
    <input type="hidden" id="i" value="${i }"/>
    <input type="button" id="upload" value=" 등록 " onclick="sendIt();"/>
	<button id="clearButton">지우기</button>
</div>
<div id="resultDiv"></div>


</form>


<script type="text/javascript">
$(function(){
	$("#plus").click(function(){
		
		var params = "i=" + $("#i").val();
		
		var i = parseInt($("#i").val());
		i++;
		$("#i").val(i);
		
		
		
		$.ajax({
			
			type:"POST",
			url:"<%=cp%>/project_ok.action",
			data:params,
			success:function(msg){
				$("#resultDiv").html(msg);
				
			},
			error:function(e){
				alert(e.responseText);
			}
			
		});
		
	});

});

		

</script>

</body>

</html>