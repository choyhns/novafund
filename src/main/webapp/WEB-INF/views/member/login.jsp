<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로그인|novafund</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js"></script>
<script type="text/javascript">

	function sendIt(){
		var f = document.myForm;
		
		var userId = $("#userId").val();
		var pwd = $("#pwd").val();
		
		var emailPattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
		
		if(!emailPattern.test(userId)){
			$("#userId").css("border-color","red");
			$("#idCheck").text("이메일을 입력해 주세요.").
			css({"color":"red","font-size":"9pt"}).show();
			return;
		}
		
		if(!pwd){
			$("#pwd").css("border-color","red");
			$("#pwdCheck").text("비밀번호를 입력해 주세요.").
			css({"color":"red","font-size":"9pt"}).show();
			return;
		}
		
		f.action = "login_ok.action";
		f.submit();
	}

	$(function(){
		$("#userId").keyup(function(){
			var userId = $("#userId").val();
			var emailPattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
			
			if(emailPattern.test(userId)){
				$("#userId").css("border-color","");
				$("#idCheck").hide();
			}
		});
		
		$("#pwd").keyup(function(){
			var pwd = $("#pwd").val();
			
			if(pwd){
				$("#pwd").css("border-color","");
				$("#pwdCheck").hide();
			}
			
		});
	});
</script>

</head>
<body>


<form name="myForm" method="post">
	
	<div class="position-absolute top-50 start-50 translate-middle"
	 style="width: 400px;max-width: 90%;
	height: 700px">
	
	<div class="text-center mb-4" style="padding-top: 10%;">
	<a class="navbar-brand fw-bold fs-2" style="color: #20b2aa;" href="<%=cp%>/">NOVAFUND</a>
	</div>
	
	<div class="border border-light-subtle rounded-3 p-4">
		<div class="d-flex flex-column justify-content-center h-100">
		
			<div class="mb-3">
			<label for="userId" class="form-label">이메일</label>
			<input id="userId" type="text" class="form-control" name="userId" placeholder="이메일 입력"/>
			<div id="idCheck"></div>
			</div>
			<div class="mb-3">
			<label for="pwd" class="form-label">비밀번호</label>
			<input id="pwd" type="password" class="form-control" name="pwd" placeholder="비밀번호 입력"/>
			<div id="pwdCheck"></div>
			</div>
			<c:if test="${param.error eq 'true' }">
				<div class="text-danger mt-1 mb-1 text-center" style="font-size: 9pt">
					아이디 또는 비밀번호가 회원정보와 일치하지 않습니다.
				</div>
			
			</c:if>
			<div class="mb-2">
				<button type="button" class="btn w-100" 
				style="background-color: #20b2aa;color:white;height: 50px"
				 id="loginBtn" onclick="sendIt();">이메일로 로그인</button>
			</div>
			<div class="text-center">
				<a href="https://kauth.kakao.com/oauth/authorize?client_id=42037fb805891476dc04c0876f4eb812&redirect_uri=http://192.168.0.34:8080/fund/login.action/oauth2/code/kakao&response_type=code">
				<img src="<%=cp %>/image/kakao_login_large_wide.png" class="img-fluid w-100"/></a>
			</div>
		</div>
		
		<div class="text-center">
		<a href="search.action" class="text-secondary" style="font-size: 10pt;">아이디/비밀번호 찾기</a>
		│
		<a href="join.action" class="text-secondary" style="font-size: 10pt;">회원가입</a>
		</div>
		</div>
	</div>
</form>	
	
	
</body>
</html>