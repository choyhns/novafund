<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    request.setCharacterEncoding("UTF-8");
    String cp = request.getContextPath();
    
 	// 현재시간 추가
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 HH:mm");
    String currentTime = sdf.format(new Date());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

<style type="text/css">

.btn-search-outline{
	border-color: #20b2aa;
	color: #20b2aa;
}	

.carousel-item {
	height: 200px;
}

.carousel-item img {
	height: 100%;
	width: 100%;
	object-fit: cover;
	object-position: center;
}
@media (min-width: 768px) {
	.carousel-item {
   		height: 300px; 
	}
}
@media (min-width: 1200px) {
 	.carousel-item {
   		height: 400px;
   	}
}

/* 스크롤 졸졸 따라오게 */
.col-lg-3 > section {
    position: sticky;
    top: 130px;
}



.card {
  border-left: 4px solid transparent; /* 자리만 잡아줌 */
  transition: all 0.3s ease;
}  
  
.card:hover{
	border-left-color: #20B2AA; /* 색상만 바뀜 */
	transform: scale(1.03);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
    background-color: #e0f7f5; 

}

.card-image-box {
    position: relative;
    width: 100%;
    padding-top: 100%; /* 카드(cardcommon)원하는 비율로 조절은 여기서 하는데, cardhorizon랑 같이 적용 됨! */
    overflow: hidden;
    border-radius: 5px;
}
.card-image-box img {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    object-position: center;
}

.deleteBtn{
	display: none;
}

/* 더보기 버튼 디자인 통일 */
.btn-more-style {
    background-color: #ffffff;
    color: #20b2aa;             
    border: 1px solid #20b2aa;
    font-size: 1.1rem;
    padding: 0.55rem 2.5rem;
    border-radius: 0.5rem;
    transition: all 0.2s ease;
    cursor: pointer;
}

/* 버튼 호버 */
.btn-more-style:hover {
    background-color: #20b2aa;
    color: #ffffff;           
    border-color: #20b2aa;  
}

</style>

</head>
<body>
<jsp:include page="/WEB-INF/views/include/mainheader.jsp"/>

<div class="container my-4 pt-4">
	<div class="row">
		<div class="col-lg-9">
			<section class="mb-4">	
				<div id="mycarousel"  class="carousel slide mx-auto" data-bs-ride="carousel" style="max-width: 2000px">
					<div class="carousel-inner">
						<div class="carousel-item active">
							<img src="<%=cp %>/image/logan-gutierrez-N3Rt8kYaT7I-unsplash.jpg" class="d-block w-100 border rounded">
						</div>
						<div class="carousel-item">
							<img src="<%=cp %>/image/conor-luddy-IVaKksEZmZA-unsplash.jpg" class="d-block w-100 border rounded">
						</div>
						<div class="carousel-item">
							<img src="<%=cp %>/image/michael-myers-B8WI9uF9o14-unsplash.jpg" class="d-block w-100 border rounded">
						</div>
					</div>
					<button class="carousel-control-prev" type="button" data-bs-target="#mycarousel" data-bs-slide="prev">
						<span class="carousel-control-prev-icon" aria-hidden="true"></span>
						<span class="visually-hidden">Previous</span>
					</button>
					<button class="carousel-control-next" type="button" data-bs-target="#mycarousel" data-bs-slide="next">
						<span class="carousel-control-next-icon" aria-hidden="true"></span>
						<span class="visually-hidden">Next</span>
					</button>
				</div>
				
				
					<br/><br/>
				
					<!-- 추천 상품(startDate) -->
					<div class="container-fluid" style="padding-top: 40px;">
						<div class="mb-3">
							<h3><b style="font-size: 15pt; color: #20b2aa;">스토어 추천 프로젝트</b></h3>
							팬들이 인정한 성공 펀딩 집합샵
						</div>
					
						<br/>
					
						<div class="row">
						<c:forEach var="recommend" items="${reLists}" varStatus="status">
							<div class="col-lg-4 col-md-4 col-sm-6 mb-4">
							
							 	<c:set var="project" value="${recommend}" scope="request"/>
							 	<c:set var="mainImage" value="${reMainImages[status.index]}" scope="request"/>
								<jsp:include page="/WEB-INF/views/include/cardcommon.jsp"/>
								
							</div>
						</c:forEach>
						</div>
						
						<br/><br/>
						
						<!-- 추천 버튼 -->
						<div class="d-grid gap-2 mx-auto" style="max-width: 200px;">
		  					<button class="btn btn-more-style" onclick="goToMorePage('recommend')">
		    					<b>추천 프로젝트 더보기</b>
		  					</button>
						</div>
					</div>
					
					<br/><br/><br/>
					
					<!-- 최신 상품(created) -->
					<div class="container-fluid" style="padding-top: 40px;">
						<div class="mb-3">
							<h3><b style="font-size: 15pt; color: #20b2aa;">이제 막 오픈한 최신 프로젝트</b></h3>
							따끈따끈 최신 프로젝트
						</div>
						
						<br/>
						
						<div class="row">
						<c:forEach var="created" items="${crLists}" varStatus="status">
							<div class="col-lg-4 col-md-4 col-sm-6 mb-4">
							
							 	<c:set var="project" value="${created}" scope="request"/>
            					<c:set var="mainImage" value="${crMainImages[status.index]}" scope="request"/>
								<jsp:include page="/WEB-INF/views/include/cardcommon.jsp"/>
							
							</div>
							
						</c:forEach>
						</div>
						
						<br/>
						
						<!-- 최신 버튼 -->
						<div class="d-grid gap-2 mx-auto" style="max-width: 200px;">
		  					<button class="btn btn-more-style" onclick="goToMorePage('created')">
		    					<b>최신 프로젝트 더보기</b>
		  					</button>
						</div>
					</div>
					
			</section>
	    </div>
	    
		<aside class="col-lg-3">
			<section>
			<h5 style="color: #20b2aa;" class="lh-1">실시간 인기 프로젝트</h5>
			<p class="text-body-seceondary lh-1" style="font-size:9pt">[<%=currentTime%>] 기준</p>
			
			<c:forEach var="dto" items="${goodLists }" varStatus="status" begin="0" end="3">
				<c:set var="project" value="${dto }" scope="request"/>
				<c:set var="mainImages" value="${goodMainImages[status.index]}" scope="request"/>
				<jsp:include page="/WEB-INF/views/include/cardhorizon.jsp"/>
			</c:forEach>
			</section>
		</aside>
		
		
	</div>
</div>



<script>

// 더보기(페이지) 버튼 값 가져오기
function goToMorePage(type) {
  location.href = '<%=cp%>/more.action/' + type;
}


$(function() {
    // 좋아요 버튼 클릭 이벤트
    $(document).on('click', '.goodBtn', function (e) {
    	e.stopPropagation();
        const $btn = $(this);
        const numPro = $btn.data('numpro');

        $.ajax({
            url: '<%=request.getContextPath()%>/project/userGood',
            type: 'POST',
            data: { numPro: numPro },
            success: function(res) {
            	
                // 성공 시 아이콘 토글
                const $icon = $btn.find('i');
                
                if(res == "notLogin"){
                	location.href = "<%=cp%>/login.action"
                }
                
                if (res == "removeGood") {
                    // 좋아요 ON
                    $icon.removeClass('bi-heart-fill text-danger')
                         .addClass('bi-heart text-white')
                         .css('text-shadow','0 0 3px rgba(0,0,0,0.5)');
                } else if(res == "addGood"){
                    // 좋아요 OFF
                    $icon.removeClass('bi-heart text-white')
                         .addClass('bi-heart-fill text-danger')
                         .css('text-shadow','');
                }
            },
            error: function() {
                alert('로그인이 필요합니다.');
            }
        });
    });
    
    $(document).on("click",".card",function(e){
    	var url = $(this).data("url");
    	location.href=url;
    });
});


</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
</body>
</html>