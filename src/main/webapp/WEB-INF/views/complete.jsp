<%@ page contentType="text/html; charset=UTF-8"%>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("utf-8");
%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr" crossorigin="anonymous">
<title>Insert title here</title>

</head> 
<body>


<!-- ================= 헤더 / 내비게이션 ================= -->
<jsp:include page="include/mainheader.jsp" />

<!-- Multi-step progress bar -->  
<div class="container" style="margin-top: 100px;">
  <div class="d-flex justify-content-between align-items-center">
    <div class="text-center flex-fill">
      <div class="rounded-circle border border-success text-dark mx-auto" style="width:40px; height:40px; line-height:40px;">1</div>
      <small>리워드 선택</small>
    </div>  
    <div class="flex-fill border-top border border-success" style="margin-top:20px;"></div>
    <div class="text-center flex-fill">
      <div class="rounded-circle border border-success text-black mx-auto" style="width:40px; height:40px; line-height:40px;">2</div>
      <small>결제</small>
    </div> 
    <div class="flex-fill border-top border border-success" style="margin-top:20px;"></div>
    <div class="text-center flex-fill"> 
      <div class="rounded-circle border text-white mx-auto" style="width:40px; height:40px; line-height:40px; background-color: #20B2AA;">3</div>
      <small>결제 완료</small>
    </div>
  </div>  
</div>


 <div class="container mt-5">
        <div class="text-center">
            <h2 style="color: #20B2AA">결제가 완료되었습니다!</h2>
            <p class="lead">후원해주셔서 감사합니다.</p>
        </div>

        <div class="card mt-4">
            <div class="card-body">
                <h5 class="card-title">결제 정보</h5>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">
                        <strong>프로젝트명 : </strong> ${proDto.subject}
                    </li>
                    <li class="list-group-item">
                        <strong>후원자 : </strong> <sec:authentication property="name" />
                    </li>
                    <li class="list-group-item">
                        <strong>결제 금액 : </strong> <fmt:formatNumber value="${sum}" type="currency" currencySymbol="₩"/>
                    </li>
                    <li class="list-group-item">
                        <strong>주문 번호 : </strong> ${sponNum}
                    </li>
                    <li class="list-group-item">
                        <strong>결제 일시 : </strong> ${time }
                    </li>
                </ul>
                <div class="mt-3 text-center">
                    <a href="<%=cp %>/article.action/${proDto.numPro}" class="btn btn-outline-light " style="background-color: #20B2AA">프로젝트 페이지로 이동</a>
                    <a href="<%=cp %>/" class="btn btn-secondary btn-outline-light" style="background-color: gray;">홈으로</a>
                </div>
            </div>
        </div>
    </div>










</body>
</html>