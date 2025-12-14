<%@ page contentType="text/html; charset=UTF-8"%>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js"></script>
</head>
<body>

	<div class="p-3 border rounded-3 border-light-subtle" 
	style="width: 500px; max-width: 90%">
		<p style="font-size: 13pt;" class="fw-bold lh-1">이메일을 입력해 주세요.</p>
		<p style="font-size: 10pt" class="text-secondary lh-1 text-start">
		이메일을 입력해 주세요. 입력한 이메일로 가입여부를 확인합니다.</p>
		<input class="form-control" style="margin-top: 30px" placeholder="이메일" name="userId" id="userId">
		<div id="idCheck" class="text-start"></div>
		<button class="btn w-100" style="color: white;margin-top: 20px;
		background-color: #20b2aa;" type="button"  id="idBtn" disabled="disabled">
		확인</button>
		<div id="redir">
		<a class="btn w-100" style="color: white;margin-top: 20px;
		background-color: #20b2aa;" href="login.action">로그인하러 가기</a>
		</div>
	</div>
	
	<script type="text/javascript">
	
		$(function(){
			
			$("#redir").hide();
			
			$("#userId").keyup(function(){
				
				$("#redir").hide();
				
				var userId = $("#userId").val();
				var emailPattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
				
				if(!userId){
					$("#userId").css("border-color","");
					$("#idCheck").hide();
					$("#idBtn").prop("disabled",true);
					return;
				}else if(!emailPattern.test(userId)){
					$("#userId").css("border-color","red");
					$("#idCheck").text("이메일 형식이 아닙니다.").
					css({"color":"red","font-size":"9pt"}).show();
					$("#idBtn").prop("disabled",false);
					return;
				}
				$("#userId").css("border-color","");
				$("#idCheck").hide();
				$("#idBtn").prop("disabled",false);
			});
			
			$("#idBtn").click(function(){
			
			var userId = $("#userId").val();
			var emailPattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
			
			$("#userId").css("border-color","");
			$("#idCheck").hide();
			var params = "userId=" + userId;
			
			$.ajax({
				
				type:"post",
				url:"searchId.action",
				data:params,
				success:function(res){
					if(res=="fail"){
						$("#idCheck").text("가입하지 않은 이메일입니다.").
						css({"color":"green","font-size":"11pt"}).show();
						$("#idBtn").prop("disabled",true);
					}else if(res=="success"){
						$("#idCheck").text("이미 가입한 이메일입니다.").
						css({"color":"green","font-size":"11pt"}).show();
						$("#idBtn").prop("disabled",true);
					}
					$("#redir").show();
				},
				error: function(xhr,status,error){
					consol.log("ajax오류",error)
				}
			});
			
			});
			
		})
	</script>
	
</body>
</html>