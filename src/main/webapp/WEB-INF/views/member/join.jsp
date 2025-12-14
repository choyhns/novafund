<%@ page contentType="text/html; charset=UTF-8"%>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원가입|novafund</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js"></script>
<script type="text/javascript">
	
	$(function(){
		$("#email").keyup(function(){
			
			var email = $(this).val();
			
			var emailPattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
			
			if(emailPattern.test(email)){
				$("#sendAuthMail").prop("disabled", false);
				$("#email").css("border-color","");
				$("#emailCheck").hide();
			}else{
				$("#sendAuthMail").prop("disabled",true);
				$("#email").css("border-color","red");
				$("#emailCheck").text("이메일을 입력하세요.").
				css({"color":"red","font-size":"9pt"}).show();
			}
		});
	});
	
	$(function(){
		$("#pwd").keyup(function(){
		
			var pwd = $(this).val();
			var pwdPattern = /^(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$/;
			
			if(pwdPattern.test(pwd)){
				$("#pwd").css("border-color","");
				$("#pwdCheck").hide();
			}else{
				$("#pwd").css("border-color","red");
				$("#pwdCheck").text("비밀번호는 8자 이상,특수문자 1개 이상 포함해야 합니다.").
				css({"color":"red","font-size":"9pt"}).show();
			}
		});
	});
	
	$(function(){
		$("#repwd").keyup(function(){
		
			var repwd = $(this).val();
			var pwd = $("#pwd").val();
			
			if(repwd==pwd){
				$("#repwd").css("border-color","");
				$("#repwdCheck").hide();
			}else{
				$("#repwd").css("border-color","red");
				$("#repwdCheck").text("비밀번호가 일치하지 않습니다.").
				css({"color":"red","font-size":"9pt"}).show();
			}
		});
	});
	
	$(function(){
		$("#sendAuthMail").click(function(){
			var params = "email=" + $("#email").val();
			
			$.ajax({
				
				type:"post",
				url:"sendAuthMail.action",
				data:params,
				success:function(response){
					if(response=="success"){
						$("#authDiv").show();
					}else if(response=="exist"){
						$("#email").css("border-color","red");
						$("#emailCheck").text("이미 가입한 이메일입니다.").
						css({"color":"red","font-size":"9pt"}).show();
					}
				}
			});
		
		});
	});
	
	$(function(){
		$("#verifyCode").click(function(){
			var params = "code=" + $("#code").val();
			
			$.ajax({
				
				type:"post",
				url:"verifyCode.action",
				data:params,
				success:function(response){
					if(response=="verified"){
						$("#code").css("border-color","");
						$("#codeCheck").text("인증 완료").
						css({"color":"green","font-size":"9pt"}).show();
						
						$("#pwd").prop("disabled",false);
						$("#pwd").prop("readonly",false);
						$("#repwd").prop("disabled",false);
						$("#repwd").prop("readonly",false);
					}else{
						$("#code").css("border-color","red");
						$("#codeCheck").text("인증번호가 일치하지 않습니다.").
						css({"color":"red","font-size":"9pt"}).show();
					}
				}
			});
		
		});
	});
	
	$(function(){
		$(".form-check-input").on("change",function(){
			var agree1 = $("#agree1").is(":checked");
			var agree2 = $("#agree2").is(":checked");
			
			if(agree1 && agree2){
				$("#joinBtn").prop("disabled",false);
			}else{
				$("#joinBtn").prop("disabled",true);
			}
		});
	});
	
	function sendIt(){
		var f = document.myForm;
		
		var email = f.email.value;
		
		if(!email){
			$("#email").css("border-color","red");
			$("#emailCheck").text("이메일을 입력해주세요.").
			css({"color":"red","font-size":"9pt"}).show();
			
			return;
		}
		
		var nickname = f.nickname.value;
		
		if(!nickname){
			$("#nickname").css("border-color","red");
			$("#nicknameCheck").text("닉네임을 입력해주세요.").
			css({"color":"red","font-size":"9pt"}).show();
			
			return;
		}
		
		var pwd = f.pwd.value;
		
		if(!pwd){
			$("#pwd").css("border-color","red");
			$("#pwdCheck").text("비밀번호를 입력해주세요.").
			css({"color":"red","font-size":"9pt"}).show();
			
			return;
		}
		
		var repwd = f.repwd.value;
		
		if(!repwd){
			$("#repwd").css("border-color","red");
			$("#repwdCheck").text("비밀번호확인은 필수 입니다.").
			css({"color":"red","font-size":"9pt"}).show();
			
			return;
		}
		
		f.action = "join.action";
		f.submit();
			
	}
</script>

</head>
<body>
<form method="post" name="myForm">
	<div class="position-absolute top-50 start-50 translate-middle"
	style="width: 600px">
		<h5 class="bold mb-3">이메일 가입</h5>
		<div class="border border-light-subtle rounded-3 p-4">
			<div>
				<label for="email" class="form-label bol">이메일</label>
				<div class="d-flex">
					<input type="text" name="email" id="email" class="form-control">
					<button type="button" id="sendAuthMail" class="btn"
					 style="background-color: #20b2aa; color:white; width: 120px;
					  margin-left: 5px" 
					 disabled="disabled">인증하기</button>
				</div>
				<div id="emailCheck" style="display: none;"></div>
			</div>
			<div id="authDiv" style="display: none;">
				<label for="code" class="form-label">인증번호 입력</label>
				<div class="d-flex">
					<input type="text" name="code" id="code" class="form-control">
					<button type="button" id="verifyCode" class="btn"
					 style="background-color: #20b2aa; color:white; width: 120px; 
					 margin-left: 5px">
					 인증확인</button>
				</div>
				<div id="codeCheck" style="display: none;"></div>
			</div> 
			<div>
				<label for="nickname" class="form-label">닉네임</label>
				<input type="text" name="nickname" id="nickname" 
					class="form-control">
				<div id="nicknameCheck" style="display: none;"></div>
			</div>
			<div>
				<label for="pwd" class="form-label">비밀번호</label>
				<input type="password" name="pwd" id="pwd" 
					class="form-control " readonly="readonly" disabled="disabled">
				<div id="pwdCheck" style="display: none;"></div>
			</div>
			<div>
				<label for="repwd" class="form-label">비밀번호확인</label>
				<input type="password" name="repwd" id="repwd" class="form-control" 
				readonly="readonly" disabled="disabled">
				<div id="repwdCheck" style="display: none;"></div>
			</div>
		</div>
		<div class="accordion mt-4" id="termsAccordion">
			<div class="accordion-item">
				<h2 class="accordion-header" id="headingOne">
				<button class="accordion-button" type="button" 
				data-bs-toggle="collapse" data-bs-target="#collapseOne" 
				aria-expanded="true" aria-controls="collapseOne">
				[필수] 서비스 이용약관
				</button>
				</h2>
				<div id="collapseOne" class="accordion-collapse collapse" 
					aria-labelledby="headingOne" 
					data-bs-parent="#termsAccordion">
					<div class="accordion-body">
						<p>
						제1조 (목적)<br>
						본 약관은 NovaFunding(이하 "회사")가 제공하는 
						크라우드펀딩 서비스의 이용조건 및 절차,
						회사와 회원 간의 권리와 의무, 기타 필요한 사항을 
						규정하는 것을 목적으로 합니다.
						</p>
						<p>
						제2조 (정의)<br>
						1. "회원"이라 함은 본 약관에 동의하고 서비스를 
						이용하는 이용자를 의미합니다.<br>
						2. "펀딩"이라 함은 프로젝트 개설자가 게시한 
						프로젝트에 대하여 회원이 금전적 후원을 하는 행위를 
						말합니다.
						</p>
						<div class="form-check">
							<input class="form-check-input" type="checkbox" 
							id="agree1">
							<label class="form-check-label" for="agree1">
							서비스 이용약관에 동의합니다.</label>
						</div>
					</div>
				</div>
			</div>
	
			<div class="accordion-item">
				<h2 class="accordion-header" id="headingTwo">
				<button class="accordion-button collapsed" type="button" 
				data-bs-toggle="collapse" data-bs-target="#collapseTwo" 
				aria-expanded="false" aria-controls="collapseTwo">
				[필수] 개인정보 수집 및 이용
				</button>
				</h2>
				<div id="collapseTwo" class="accordion-collapse collapse" 
					aria-labelledby="headingTwo" 
					data-bs-parent="#termsAccordion">
					<div class="accordion-body">
						<p>
						1. 수집 항목: 이메일, 이름, 비밀번호, 휴대폰 번호<br>
						2. 이용 목적: 회원 식별, 펀딩 결제 처리, 민원 처리<br>
						3. 보유 기간: 회원 탈퇴 시까지 
						(법령에 따라 일정 기간 보관 가능)
						</p>
						<div class="form-check">
							<input class="form-check-input" 
							type="checkbox" id="agree2">
							<label class="form-check-label" 
							for="agree2">개인정보 수집 및 이용에 동의합니다.</label>
						</div>
					</div>
				</div>
			</div>											
	
			<div class="accordion-item">
				<h2 class="accordion-header" id="headingThree">
				<button class="accordion-button collapsed" type="button" 
				data-bs-toggle="collapse" data-bs-target="#collapseThree" 
				aria-expanded="false" aria-controls="collapseThree">
				[선택] 마케팅/광고 수신 동의
				</button>
				</h2>
				<div id="collapseThree" class="accordion-collapse collapse" 
					aria-labelledby="headingThree" 
					data-bs-parent="#termsAccordion">
					<div class="accordion-body">
						<p>
						회사는 이벤트, 신규 프로젝트 안내 등 마케팅 정보를 이메일, 
						문자메시지 등을 통해 발송할 수 있습니다.<br>
						동의를 거부하셔도 서비스 이용에는 제한이 없습니다.
						</p>
						<div class="form-check">
							<input class="form-check-input" type="checkbox"
							 id="agree3">
							<label class="form-check-label" for="agree3">
							마케팅/광고 수신에 동의합니다. (선택)</label>
						</div>
					</div>
				</div>
			</div>
	
		</div>
		
		<div>
			<button id="joinBtn" onclick="sendIt()" type="button"
			class="btn mt-4 w-100" style="background-color:#20b2aa; 
			color:white;" disabled="disabled">약관 동의 후 회원가입</button>
		</div>
	</div>
</form>

</body>
</html>