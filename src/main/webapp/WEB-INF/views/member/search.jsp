<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>아이디/비밀번호 찾기</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js"></script>
</head>
<body>

<div class="d-flex justify-content-center align-items-start min-vh-100 pt-5">

	<div class="text-center" style="width: 500px;max-width: 90%">
		<h4>아이디/비밀번호 찾기</h4>

		<ul class="nav nav-underline border-bottom border-light-subtle pt-5">
			<li class="nav-item" style="flex: 1;">
				<a class="nav-link active" href="searchId.action"
				style="font-size: 13pt">아이디찾기</a>
			</li>
			<li class="nav-item" style="flex: 1;">
				<a class="nav-link" href="searchPwd.action"
				style="font-size: 13pt">비밀번호찾기</a>
			</li>
		</ul>
	
		<div id="content" class="mt-3 d-flex justify-content-center"></div>
	</div>
</div>

<script type="text/javascript">

	$(function(){
		$("#content").load($(".nav-link.active").attr("href"));

		$(".nav-link").on("click", function(e) {
			e.preventDefault();
		
			$(".nav-link").removeClass("active");
			$(this).addClass("active");
			
			var target = $(this).attr("href");
			$("#content").load(target);
		});
	});

</script>
</body>
</html>