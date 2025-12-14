<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>마이페이지|NOVAFUND</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
<style>
    body {
        background-color: #fff;
    }
    
    a{
    	color: inherit;
    	text-decoration: none;
    }
    
    a:hover{
    	color: #20B2AA;
    	text-decoration: underline;
    }
    
    .profile-header {
        border-bottom: 1px solid #eee;
        padding: 2rem 0;
    }
    .stats {
        font-size: 0.9rem;
        color: #666;
    }
    .stats strong {
        display: block;
        font-size: 1.2rem;
        color: #000;
    }
    .nav-pills .nav-link.active {
        background-color: #20b2aa !important;
        color: #fff !important;
    }
    .nav-pills .nav-link:hover {
        background-color: #20b2aa33;
        color: #20b2aa;
    }
    
    .card {
	    height: auto;
		border-left: 4px solid transparent; /* 자리만 잡아줌 */
		overflow: hidden;
		transition: all 0.3s ease;
	}  
	  
	.card:hover{
		border-left-color: #20B2AA; /* 색상만 바뀜 */
	    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
	    background-color: #e0f7f5; 
	    position: relative;
		cursor: pointer;
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
    
    .swiper-button-next,
	.swiper-button-prev {
	  background-color: rgba(32, 178, 170, 0.9); /* 배경색 */
	  border-radius: 50%;                       /* 동그랗게 */
	  width: 40px;
	  height: 40px;
	  display: flex;
	  align-items: center;
	  justify-content: center;
	}
	
	/* 화살표 아이콘 색상 */
	.swiper-button-next::after,
	.swiper-button-prev::after {
	  font-size: 20px;
	  color: #fff; /* 아이콘 색상 */
	  font-weight: bold;
	}
	
	/* hover 시 효과 */
	.swiper-button-next:hover,
	.swiper-button-prev:hover {
	  background-color: #20b2aa; /* hover 시 진한 색 */
	  transform: scale(1.1);     /* 살짝 확대 */
	  transition: 0.2s;
	}
	
	.swiper-pagination{
		position: relative !important;
		margin-top: 15px;
		text-align: center;
	}
	
	.swiper-pagination-bullet {
	  width: 12px;
	  height: 12px;
	  background-color: #ccc; /* 기본 회색 */
	  opacity: 1;             /* 흐리게 안 하고 전부 보이게 */
	  border-radius: 50%;     /* 동그라미 */
	  margin: 0 6px !important;
	  transition: all 0.3s ease;
	}
	
	/* 활성화된 bullet */
	.swiper-pagination-bullet-active {
	  background-color: #20b2aa; /* 활성화 색상 */
	  transform: scale(1.2);     /* 살짝 커짐 */
	}
	
	/* hover 효과 */
	.swiper-pagination-bullet:hover {
	  background-color: #20b2aa66; /* 투명한 NOVAFUND 컬러 */
	  cursor: pointer;
	}
    
	.section-block {
	  border: 1px solid #eee;   /* 연한 테두리 */
	  border-radius: 8px;       /* 모서리 둥글게 */
	  padding: 1rem;
	  margin-bottom: 2rem;
	  background-color: #fff;   /* 카드 느낌 */
	}
	.section-block h5 {
	  border-bottom: 2px solid #20b2aa;
	  padding-bottom: .5rem;
	  margin-bottom: 1.5rem;
	}
	
	.recommend-section {
	  margin-top: 2rem;   /* 위쪽 여백 */
	}
	
	.tab-content {
	  margin-bottom: 4rem;  /* 탭 아래쪽 여백 */
	}
	
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/include/mainheader.jsp"/>

<div class="container pt-2">

	<div class="text-center mb-2">
		<h4 class="mb-0">${dto.nickname }</h4>
		<p class="text-muted mb-2">
			<c:choose>
				<c:when test="${not empty email and fn:contains(email,'@')}">
					${dto.email }
				</c:when>
				<c:otherwise>
					이메일을 설정해 주세요
				</c:otherwise>
			</c:choose>
		</p>
		<div class="d-flex justify-content-center gap-5 mb-3 stats"
		style="padding-left: 70px;">
			<div class="text-center">
				<strong>${pLists.size() }</strong>
				후원수
			</div>
			<div class="text-center">
				<strong>${mLists.size() }</strong>
				내 프로젝트 수
			</div>
			<div class="text-center">
				<strong>${gLists.size() }</strong>
				관심 프로젝트 수
			</div>
		</div>
		<div class="d-flex justify-content-center gap-5 mb-3 stats"
		style="padding-left: 70px;">
		<p class="pt-1">현재 나의 캐시</p>
		<strong><fmt:formatNumber value="${dto.cashPoint }" pattern="#,###"/>point</strong>
			<div>
				<button type="button" class="btn btn-sm btn-outline-light" 
				style="background-color: #20b2aa;max-height: 30px"
				onclick="location='<%=cp%>/cashPoint.action'">충전하기</button>
				<button type="button" class="btn btn-sm btn-outline-light" 
				style="background-color: #20b2aa;max-height: 30px"
				onclick="location='<%=cp%>/withdraw.action'">출금하기</button>
			</div>
		</div>
		<a href="update.action" class="btn btn-outline-secondary btn-sm">프로필 설정</a>
	</div>

	<ul class="nav nav-underline justify-content-center mt-4 shadow-sm" id="mypageTabs" role="tablist">
		<li class="nav-item">
			<button class="nav-link active" data-bs-toggle="pill" data-bs-target="#fundHistory" style="color: #20b2aa;">후원 내역</button>
		</li>
		<li class="nav-item">
			<button class="nav-link" data-bs-toggle="pill" data-bs-target="#myProjects" style="color: #20b2aa;">내 프로젝트</button>
		</li>
		<li class="nav-item">
			<button class="nav-link" data-bs-toggle="pill" data-bs-target="#wishlist" style="color: #20b2aa;">관심 프로젝트</button>
		</li>
	</ul>

	<div class="tab-content mt-4" style="height: 500px;">
		<div class="tab-pane fade show active" id="fundHistory">
			<div class="section-block">
				<h5 class="mb-4">
				<a href="<%=cp%>/sponList.action">
				후원 내역
				<i class="bi bi-chevron-right text-secondary"></i></a>
				</h5>
				<c:choose>
					<c:when test="${not empty pLists }">
					<div class="swiper fundSwiper">
						<div class="swiper-wrapper">
							<c:forEach var="dto" items="${pLists }" varStatus="status">	
							<div class="swiper-slide">
								<c:set var="project" value="${dto}" scope="request"/>
								<c:set var="mainImage" value="${pImageLists[status.index]}" scope="request"/>
								<jsp:include page="/WEB-INF/views/include/cardcommon.jsp"/>
							</div>
							</c:forEach>
						</div>
						<div class="swiper-button-next"></div>
						<div class="swiper-button-prev"></div>
						<div class="swiper-pagination"></div>
					</div>
					</c:when>
					<c:otherwise>
					<div class="text-center">
						<p class="text-muted">후원한 프로젝트가 없습니다.</p>
					</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	
		<div class="tab-pane fade" id="myProjects">
			<div class="d-flex justify-content-between align-items-center mb-3">
				<div class="section-block w-100 h-100">
					<h5>내 프로젝트</h5>
			
					<c:choose>
						<c:when test="${not empty mLists }">
						<div class="swiper myProjectSwiper">
							<div class="swiper-wrapper">
								<c:forEach var="dto" items="${mLists }" varStatus="status">	
		
									<div class="swiper-slide ">
									<c:set var="project" value="${dto}" scope="request"/>
									<c:set var="mainImage" value="${mImageLists[status.index]}" scope="request"/>
									<jsp:include page="/WEB-INF/views/include/cardcommon.jsp"/>
										<div class="position-absolute end-0 top-0 p-2 mt-2 ms-2 deleteBtn">
										<c:if test="${pageContext.request.userPrincipal.name eq project.userId }">
										<a class="btn btn-sm updateBtn" style="background-color: #20b2aa;color: white;"
										 data-url="<%=cp%>/projectUpdate.action?numPro=${project.numPro}">수정</a>
										</c:if>
										<c:if test="${pageContext.request.userPrincipal.name eq project.userId 
										or pageContext.request.isUserInRole('ADMIN')}">
										<a class="btn btn-sm deleteBtn" style="background-color: #20b2aa;color: white;"
										data-url="<%=cp%>/deleted_ok.action?numPro=${project.numPro}" data-ms-whatever="@delete">삭제</a>
										</c:if>
										</div>
									</div>
								</c:forEach>
							</div>
							<div class="swiper-button-next"></div>
							<div class="swiper-button-prev"></div>
							<div class="swiper-pagination"></div>
						</div>
						</c:when>
						<c:otherwise>
						<div class="text-center">
							<p class="text-muted">등록한 프로젝트가 없습니다.</p>
							<a href="<%=cp%>/projectUpload.action" class="btn" 
							style="background-color: #20b2aa;color: white;">
								<i class="bi bi-plus-circle" ></i> 새 프로젝트 등록
							</a>
						</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	
		<div class="tab-pane fade" id="wishlist">
			<div class="section-block">
				<h5 class="mb-4">관심 프로젝트</h5>
				<c:choose>
					<c:when test="${not empty gLists }">
						<div class="swiper goodSwiper">
							<div class="swiper-wrapper">
								<c:forEach var="dto" items="${gLists }" varStatus="status">	

									<div class="swiper-slide">
							
									<c:set var="project" value="${dto}" scope="request"/>
									<c:set var="mainImage" value="${gImageLists[status.index]}" scope="request"/>
									<jsp:include page="/WEB-INF/views/include/cardcommon.jsp"/>
									</div>
								</c:forEach>
							</div>
							<div class="swiper-button-next"></div>
							<div class="swiper-button-prev"></div>
							<div class="swiper-pagination"></div>
						</div>
					</c:when>
					<c:otherwise>
					<div class="text-center">
						<p class="text-muted">좋아요한 프로젝트가 없습니다.</p>
					</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
	
	<div class="section-block recommend-section">
		<h5>
		<a href="<%=cp%>/more.action/recommend">
		추천 프로젝트<i class="bi bi-chevron-right text-secondary"></i></a></h5>
		<div class="swiper recommendSwiper">
			<div class="swiper-wrapper">
				<c:forEach var="dto" items="${reLists }" varStatus="status">	

					<div class="swiper-slide">
							
					<c:set var="project" value="${dto}" scope="request"/>
					<c:set var="mainImage" value="${reImageLists[status.index]}" scope="request"/>
					<jsp:include page="/WEB-INF/views/include/cardcommon.jsp"/>
						
					</div>
				</c:forEach>
			</div>
			<div class="swiper-button-next"></div>
			<div class="swiper-button-prev"></div>
			<div class="swiper-pagination"></div>
		</div>
	</div>
	
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  function initSwiper(className) {
    return new Swiper(className, {
      slidesPerView: 4,
      spaceBetween: 20,
      navigation: {
        nextEl: className + " .swiper-button-next",
        prevEl: className + " .swiper-button-prev",
      },
      pagination: {
        el: className + " .swiper-pagination",
        clickable: true,
      },
      breakpoints: {
        1200: { slidesPerView: 4 },
        992: { slidesPerView: 3 },
        768: { slidesPerView: 2 },
        576: { slidesPerView: 1 },
      }
    });
  }

  // 각각 초기화
  initSwiper(".fundSwiper");
  initSwiper(".myProjectSwiper");
  initSwiper(".goodSwiper");
  initSwiper(".recommendSwiper");

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
	    
	    $(document).on("click",".updateBtn",function(e){
	    	e.stopPropagation();
	    	var url = $(this).data("url");
	    	
	    	location.href=url;
	    });
	    
	    $(document).on("click",".deleteBtn",function(e){
	    	if(confirm("삭제하시겠습니까?")){
	    	e.stopPropagation();
	    	var url = $(this).data("url");
	    	
	    	location.href=url;
	    	}
	    });
	});  
  
</script>
</body>
</html>