<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
%>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<nav class="navbar navbar-expand-lg sticky-top pt-4 px-5 mb-2 shadow-sm" style="background-color: #ffffff;">
	<div class="container-fluid d-flex flex-column w-100">
		<div class="d-flex w-100 justify-content-between">
			<a class="navbar-brand fw-bold fs-3 vw-50" style="color: #20b2aa;" href="<%=cp%>/">NOVAFUND</a>
			
			<form class="d-flex me-3 flex-grow-1 align-items-center" style="max-width: 40%;" role="search" method="get" 
				action="<%=cp %>/list.action">
				<div class="input-group position-relative">
					<button class="dropdown-toggle rounded-start-pill btn" id="categoryButton"
					style="border-color: #20b2aa; min-height: 45px;  min-width: 130px;
					 background-color: #ffffff; color: #20b2aa; border-right: none;"
						type="button" data-bs-toggle="dropdown" aria-expanded="false">카테고리 선택</button>
						
					<ul class="dropdown-menu dropdown-menu-write" aria-labelledby="navbarDarkDropdownMenuLink"
							style="margin-top: -7px; margin-left: 15px; width: 20px; border: none; 
							box-shadow: 0 4px 12px rgba(0,0,0,0.25);">
							
 							<li>
								<a class="dropdown-item" data-category="" style="padding: 8px;">전체</a>
							</li>

						<c:forEach var="caL" items="${caLists}">
							<li>
								<a class="dropdown-item" style="padding: 8px;"
								href="#" data-category="${caL.categoryName}">${caL.categoryName}</a>
							</li>
						</c:forEach>
					</ul>
					
					<input type="hidden" name="categoryName" id="categoryName" value=""/>
					
					<input class="form-control me-2 rounded-end-pill ps-1" style="border-color: #20b2aa;"
						type="search" placeholder="검색어를 입력하세요." aria-label="Search" name="searchValue"/>
						
					<button class="btn position-absolute end-0 top-50 translate-middle-y me-5 p-0 border-0 bg-transparent"
						type="submit">
							<i class="bi bi-search fs-5 text-secondary"></i>
					</button>					
						
				</div>
			</form>
			
			<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainNav"
	                    aria-controls="mainNav" aria-expanded="false" aria-label="메뉴 토글">
	                <span class="navbar-toggler-icon"></span>
	        </button>
	        <div class="d-flex align-items-center justify-content-end">
	        <sec:authorize access="isAnonymous()">
				
					<a href="<%=cp %>/login.action" class=" btn btn-outline-secondary me-2">로그인</a>
					<a href="<%=cp %>/join.action" class=" btn btn-outline-light" style="background-color: #20b2aa;">회원가입</a>
			</sec:authorize>
			<sec:authorize access="isAuthenticated()">
					<a href="<%=cp %>/logout.action" class=" btn btn-outline-secondary me-2" style="width: 95px;">로그아웃</a>
					<sec:authorize access="hasRole('USER')">
						<a href="<%=cp %>/memberInfo.action" class=" btn btn-outline-light" style="background-color: #20b2aa;width: 120px;">내정보 수정</a>
					</sec:authorize>
					<sec:authorize access="hasRole('ADMIN')">
						<a href="<%=cp %>/adminBoard.action" class=" btn btn-outline-light" style="background-color: #20b2aa;">관리자 페이지</a>
					</sec:authorize>
			
			</sec:authorize>
				</div>
			
			
			
			
        </div>
        
        <div class="collapse navbar-collapse w-100 d-flex justify-content-between" id="mainNav">
			<div class="text-start">
				<ul class="nav nav-underline">
					<li class="nav-item">
						<a class="nav-link ${empty categoryName ? 'active' : empty categoryNameAll ? '' : '' }" aria-current="page" 
						href="<%=cp %>/" style="font-size: 14px;color: #20b2aa">홈</a>
					</li>
					<li>
						<a class="nav-link ${categoryNameAll eq '전체' ? 'active' : '' }" aria-current="page" 
						href="<%=cp %>/list.action" style="font-size: 14px;color: #20b2aa">전체</a>
					</li>
					<c:forEach var="caL" items="${caLists }">
					<li>
						<a class="nav-link ${categoryName eq caL.categoryName ? 'active' : '' }" aria-current="page" 
						href="<%=cp %>/list.action?categoryName=${caL.categoryName}"
						 style="font-size: 14px;color: #20b2aa">${caL.categoryName }</a>
					</li>
					</c:forEach>
				</ul>
			</div>
			<div class="d-flex align-items-center text-end">
				<a class="btn btn-outline-light" style="background-color: #20b2aa;
				width: 225px" href="<%=cp%>/projectUpload.action">프로젝트 만들기</a>
			</div>
		</div>
		
	</div>
	
</nav>

<script>
$(function(){
	$(".dropdown-item").on("click",function(e){
		e.preventDefault();
		var te = $(this).text();
		$("#categoryName").val(te);
		
		var bu = $(this).text();
		$("#categoryButton").text(bu);
		
		
		console.log("카테고리",te);
	});
});

$(document).on("click",".nav-link",function(){
	e.preventDefault();
	var url = $(this).data("url");
	
	$(".nav-link").removeClass("active");
	
	$(this).addClass("active");
	
	if(url){
		location.href = url;
	}
	
});


</script>
