<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%
	request.setCharacterEncoding("UTF-8");
	String cp = request.getContextPath();
	
	String pageNum = request.getParameter("pageNum");
%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>


<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>펀딩 프로젝트 상세보기</title>
   
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr" crossorigin="anonymous">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
	
<!-- Swiper CSS -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.css" />

<!-- Swiper JS -->
<script src="https://cdn.jsdelivr.net/npm/swiper@10/swiper-bundle.min.js"></script>
<style type="text/css">

	.hidden{
		display: none !important;
	}
	
	.outlined-star {
    color: gold;                 /* 내부 색 */
    -webkit-text-stroke: 1px gold; /* 테두리 색과 두께 */
}

/* 선택되지 않은 탭 글씨 색 변경 */
.nav-tabs .nav-link {
    color: #20B2AA; /* 원하는 색으로 변경 */
}

 /* 제목, 가격 검은색 유지 */
  .reward-title,
  .reward-price {
    color: #000000;
    font-weight: 600;
  }

  /* 리워드 카드 기본 스타일 */
  .reward-card,
  .category-card {
    transition: all 0.3s ease;
    background-color: #ffffff;
  }

  /* 리워드 카드 hover 시 은은하게 빛나는 배경 */
  .reward-card:hover {
    transform: scale(1.03);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
    border-left: 4px solid #20B2AA;
    background-color: #e0f7f5; /* 은은한 포인트 컬러 배경 */
  }
  
  /* 같은 카테고리 카드 hover 시 은은하게 빛나는 배경 */
  .category-card:hover {
    transform: scale(1.03);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
    border-left: 4px solid #20B2AA;
    background-color: #e0f7f5; /* 은은한 포인트 컬러 배경 */
  }
  
  
  body {
            background-color: #f9f9f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .participant-card {
            background-color: #ffffff;
            border-radius: 10px;
            padding: 15px 20px;
            margin-bottom: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .participant-card:hover {
            transform: translateY(-3px);
        }
        .participant-name {
            color: #20B2AA;
            font-weight: 600;
            font-size: 1.1rem;
        }
        .participant-price {
            font-weight: 500;
            color: #555;
        }
        .participant-date {
            font-size: 0.9rem;
            color: #888;
        }
        .list-container {
            max-width: 600px;
            margin: 50px auto;
        }
        
        
        
        /* 페이지 네비게이션 토트 색깔*/
.mySwiper .swiper-pagination-bullet-active {
  background-color: #20B2AA; /* 원하는 색상 (예: 연한 청록) */
}




.reward-card {
    text-decoration: none; /* 밑줄 제거 */
    color: inherit;        /* 글자색 상속 */
}


.navbar.sticky-top {
  z-index: 1050;
}

.bg.sticky-top {
  z-index: 1000;
}


.mySwiper {
  width: 100%;
  padding-bottom: 40px; /* pagination 버튼 영역 확보 */
}

.mySwiper .swiper-wrapper {
  display: flex; /* 필수 */
}

.mySwiper .swiper-slide { 
  flex-shrink: 0;  /* 줄어들지 않게 */
  height: auto;
}

.disabled-link {
    pointer-events: none; 
    opacity: 0.6;
    cursor: not-allowed;
}

.reply-review,
.update-review,
.delete-review,
.reply-update {
    color: #20B2AA; /* 원하는 색상 코드로 변경 가능 */
    text-decoration: none; /* 밑줄 제거 */
}

.reply-review:hover,
.update-review:hover,
.delete-review:hover,
.reply-update:hover { 
    text-decoration: underline; /* 마우스 오버 시 밑줄 */
}


  
</style> 
<script type="text/javascript">
 
 function purchase() {
	
	 location = '<%=cp%>/user/reward.action/${proDto.numPro}/-1';
	 
	  
}

</script>

	
</head>

<body> 

<!-- ================= 헤더 / 내비게이션 ================= -->
<jsp:include page="include/mainheader.jsp" /> 
  
<!-- ✅ 프로젝트 상세 -->

<sec:authentication property="name" var="loginUser"/>

<div class="container" style="margin-top: 75px; margin-bottom: 50px; ">
  <div class="row align-items-stretch">
    <!-- 프로젝트 이미지 -->
	<div id="carouselExampleCaptions" class="carousel slide col-md-8"  data-bs-ride="carousel">
  <div class="carousel-indicators">
  	
  	<c:forEach var="main" items="${mainImageLists }" varStatus="vs">
  		    <button type="button" data-bs-target="#carouselExampleCaptions" 
  		     data-bs-slide-to="${vs.index }" 
  		      
  		    <c:if test="${vs.first }">
  		    class="active" aria-current="true"
  		    </c:if>>
  		    </button>
  	</c:forEach>

  </div>
  <div class="carousel-inner h-100">
  
  <c:forEach var="main" items="${mainImageLists }" varStatus="vs">
  
   
    <div class="carousel-item
    
    <c:if test="${vs.first }">
    	active
    </c:if>">
      <img  src="<%=cp %>/image/${main.saveName}"
      style="object-fit: cover; height: 450px;" class="d-block w-100" alt="...">
    </div>
  
  </c:forEach>
  <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide="prev">
    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
    <span class="visually-hidden">Previous</span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide="next">
    <span class="carousel-control-next-icon" aria-hidden="true"></span>
    <span class="visually-hidden">Next</span>
  </button> 
</div>
 </div>
    <!-- 프로젝트 설명 -->
    <div class="col-md-4 "  >
      <h2 class="mb-3">${proDto.subject }</h2> 
      <div style="height: 175px;"> 
      <p class="lead">${proDto.content}
      
      </p>
      </div>
      <!-- 목표 금액 / 현재 금액 -->
      
      <c:set var="safeSponAmount" value="${sponAmount != null ? sponAmount : 0}" />
      
       <fmt:formatNumber value="${(safeSponAmount/proDto.goalAmount)*100}" 
                  type="number" 
                  maxFractionDigits="2" 
                  var="percentStr"/>
        
      <fmt:parseNumber value="${percentStr}" type="number" var="percent"/>
       
      <div class="mb-3">
        <p><strong>목표 금액 : </strong> ${proDto.goalAmount }원</p>
        <p><strong>현재 금액 : </strong> ${sponAmount }원 
        
        <c:if test="${sponAmount >= proDto.goalAmount }">
        <strong class="fs-5" style=" color: #20B2AA">${percent }% 달성!</strong>
        </c:if>
        </p>
        <p class="d-flex justify-content-between align-items-center">
        
			<button id="goodBtn" type="button" data-numpro="${proDto.numPro}"
			 class="btn 
			 
			 		<c:choose>
			 			
			 			<c:when test='${status==1 and daysBetween >=0 }'>
			 			
			 			<c:choose>
			 					<c:when test='${good }'>btn-outline-danger</c:when>
			 					<c:otherwise>btn-danger</c:otherwise>
			 				</c:choose>
			 			
			 			</c:when>
			 			
			 			<c:otherwise> 
			 				btn-dark
			 			</c:otherwise> 
			 			
			 		</c:choose>
			 			">
				<svg id="svg" xmlns="http://www.w3.org/2000/svg" width="16" height="16"  class="bi bi-heart" fill="currentColor"  viewBox="0 0 16 16">	
					<path d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143q.09.083.176.171a3 3 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15"/> 
				</svg>
					<span id="goodCount">${proDto.good }</span>
			</button>
			
			<c:choose>
				<c:when test="${status==1 and daysBetween >=0}"><strong style="">${daysBetween }일 남음</strong></c:when>
				<c:otherwise><strong style="">종료</strong></c:otherwise>
			</c:choose>
			 
			
		</p>
		  
         
      </div>
     
      <!-- 진행률 -->
      
      <c:if test="${percent eq 0.0 }">
      	<div class="progress mb-3" style="height: 25px;">
        <div class="progress-bar text-white 
             " role="progressbar" style="width: 100%; background-color: #cccccc; " aria-valuenow="${percent}" aria-valuemin="0" aria-valuemax="100">
          ${percent}%
        </div> 
      </div> 
      </c:if>
      <c:if test="${percent > 0.0 }"> 
      <div class="progress mb-3" style="height: 25px;">
        <div class="progress-bar bg-info text-white progress-bar-animated 
             " role="progressbar" style="width: ${percent}%;" aria-valuenow="${percent}" aria-valuemin="0" aria-valuemax="100">
          ${percent}%
        </div>
      </div>
      </c:if>
      
      <!-- 후원 버튼 -->
      
      <c:choose>
      <c:when test="${status==1 and daysBetween >=0}">
      <button class="btn btn-lg w-100 btn-outline-light" style="background-color: #20B2AA"
      onclick="purchase();">
      이 프로젝트 후원하기
      </button>
      </c:when>
      <c:otherwise>
      <button class="btn btn-lg w-100 " style="background-color: #20B2AA"
      >
      종료된 프로젝트 입니다
      </button>
      </c:otherwise>
      </c:choose> 
    </div>
  </div>
</div>

<!-- ✅ 프로젝트 상세 설명 / 리뷰 / 참여자 -->
<div class="container-fluid d-flex" >
  <!-- 탭 메뉴 -->
  <div class="flex-grow-1 p-3 " style="width:70%"> 
  <ul class="nav nav-tabs " id="projectTab" role="tablist">
    <li class="nav-item flex-fill" role="presentation">
      <button class="nav-link active w-100" id="desc-tab" data-bs-toggle="tab" data-bs-target="#desc" type="button" role="tab" aria-controls="desc" aria-selected="true">프로젝트 설명</button>
    </li>
    <li class="nav-item flex-fill" role="presentation">
      <button class="nav-link w-100" id="review-tab" data-bs-toggle="tab" data-bs-target="#review" type="button" role="tab" aria-controls="review" aria-selected="false">리뷰</button>
    </li>
    <li class="nav-item flex-fill" role="presentation">
      <button class="nav-link w-100" id="participant-tab" data-bs-toggle="tab" data-bs-target="#participant" type="button" role="tab" aria-controls="participant" aria-selected="false">참여자</button>
    </li>
  </ul>   
  
  <!-- 탭 내용 -->
  <div class="tab-content p-4 border border-top-0 rounded-bottom bg-white "  id="projectTabContent">
    <!-- 설명 -->
    <div class="tab-pane fade show active mt-3 " id="desc" role="tabpanel" aria-labelledby="desc-tab">
  <h4>프로젝트 상세 설명</h4>
  <p>이 프로젝트는 친환경 소재로 제작된 제품을 통해 환경 보호에 기여하고자 합니다. 아래는 프로젝트 관련 이미지입니다:</p>
  
    <!-- 큰 이미지 하나씩 -->
    
    <c:forEach var="content" items="${contentImageLists }" varStatus="vs">
    
  <div class="mb-4 text-center ">
  	<img alt="프로젝트 이미지" src="<%=cp %>/image/${content.saveName}" style="width: 80%;"
  	class="contentImage img-fluid rounded 
  	<c:if test='${vs.index > 1}'>hidden</c:if>
  	" />
  </div>

	</c:forEach>
    
  <div class="d-grid gap-2">
  <button id="moreImage"  class="btn btn-outline-light" type="button" style="background-color: #20B2AA">더 보기</button>
</div>
  
</div>

    <!-- 리뷰 -->
    <div class="tab-pane fade" id="review" role="tabpanel" aria-labelledby="review-tab">
    	
  		<div style="width:300px; margin:50px auto; text-align:center;">
        <h3>전체 리뷰 평점</h3>
        <c:set var="fullStars" value="${reviewGradeAvg.intValue()}" />
        <c:set var="halfStar" value="${(reviewGradeAvg - fullStars) >= 0.5 ? 1 : 0}" />
        <c:set var="emptyStars" value="${5 - fullStars - halfStar}" />

        <!-- 별점 표시 -->
        <span>
            <c:forEach begin="1" end="${fullStars}" var="i">
                <i class="bi bi-star-fill outlined-star" ></i>
            </c:forEach>
            <c:if test="${halfStar == 1}">
                <i class="bi bi-star-half outlined-star"  ></i>
            </c:if>
            <c:forEach begin="1" end="${emptyStars}" var="i">
                <i class="bi bi-star outlined-star"  ></i>
            </c:forEach>
        </span>

        <p style="margin-top:10px;">평균 평점: ${reviewGradeAvg} / 5</p>
    </div>
  		
  		<c:set var="spon" value="false"/>
  		
  		 <c:forEach var="lists" items="${sponLists }">
  			<c:if test="${lists.userId eq loginUser}">
  				<c:set var="spon" value="true" />
  			</c:if>
  		</c:forEach>
  		
  		<c:if test="${spon and status ==1}">
  		<h5>리뷰 작성하기</h5>
  		
  		 <div class="mt-3">
    		<img id="preview" src="" alt="미리보기" style="max-width:200px; max-height:200px; display:none; border:1px solid #ccc; padding:5px;">
  		</div>
  		 
			<div id="starFeedback" class="invalid-feedback" style="display:none;">
				 <span class="d-flex justify-content-end">별점을 선택해 주세요.</span>
   			</div>  		 
  		 
  		<form action="<%=cp %>/reviewUpload.action/${proDto.numPro}" name="reviewForm" id="reviewForm" method="post" class="mb-3 needs-validation" enctype="multipart/form-data" novalidate>
  			
  			<div id="starRating" class="d-flex justify-content-end">
  			
  				<span class="fw-bold ">별점주기 : &nbsp;</span>
  				
  				<i class="bi bi-star outlined-star" data-value="1"></i>
  				&nbsp;
  				<i class="bi bi-star outlined-star" data-value="2"></i>
  				&nbsp;
  				<i class="bi bi-star outlined-star" data-value="3"></i>
  				&nbsp;
  				<i class="bi bi-star outlined-star" data-value="4"></i>
  				&nbsp;
  				<i class="bi bi-star outlined-star" data-value="5"></i>
				 
				
				<input type="hidden" class="form-control" id="rating" name="grade" value="" required>
				
   		 	</div>
   		 	
   		 	<div class="mb-3">
   		 		
   		 		<textarea class="form-control" id="reviewText" style="resize: none;" name="content" rows="3" required></textarea>
  					
  					<div class="invalid-feedback">
    					리뷰를 작성해 주세요.
  					</div>
  					
			</div>
			
    		<button type="submit" class="btn btn-outline-light" style="background-color: #20B2AA">리뷰 등록</button>
			 <button type="button" id="customButton" class="btn btn-outline-light" style="background-color: #20B2AA">이미지 선택</button>
			<input type="file" id="realFile" name="realFile" style="display:none;" accept="image/*" />
  		</form>
  		</c:if>
  
  <br/>
  		<h4>후원자 리뷰</h4>
  		<c:if test="${not empty reviewLists }">
  		<c:forEach var="review" items="${reviewLists }">
      	<div class="list-group">
      	
      		<c:if test="${review.depth == 0 }">
        	<div class="list-group-item" data-numrev="${review.numRev }" 
        	data-numpro="${review.numPro }">
        		<div class="d-flex">
        			<div class="flex-grow-1 me-3 "  style="width: 60%;">
        			<c:if test="${proDto.userId eq review.userId }">
        			<span class="badge rounded-pill text-white me-2" style="background-color:#20B2AA; font-size:0.65rem; height:15px; align-items:center; padding:0 10px; padding-top: 2px;">
       				 Maker
   					 </span> 
   					 </c:if>  
         				<strong> 
    						${review.userId }</strong> 
         				
         					<c:forEach var="i" begin="1" end="5">
         						<i class="bi 
									<c:choose> 
										<c:when test="${i <= review.grade }"> 
											bi-star-fill
										</c:when>
										<c:otherwise> 
											bi-star
										</c:otherwise>
									</c:choose>
         						 outlined-star" > </i>
         					</c:forEach>
         				
         				&nbsp;
         				<span class="text-muted" >${review.created }</span>
         				<sec:authorize access="isAuthenticated()">  
         					<a href="javascript:void(0);" class="reply-review">답글</a>
         				
         				<c:choose>
         				<c:when test="${loginUser eq review.userId }"> 
         					<a href="javascript:void(0);" class="update-review">수정</a>
         					<a href="<%=cp%>/reviewDelete.action/${review.numRev}/${review.numPro}/${review.userId}/<%=pageNum %>" 
         					class="delete-review">삭제</a>
         				</c:when>
         				
         				<c:otherwise>
         				<sec:authorize access="hasRole('ADMIN')">
               			 <a href="<%=cp%>/reviewDelete.action/${review.numRev}/${review.numPro}/${review.userId}/<%=pageNum %>"
                   			class="delete-review">삭제</a>
            			</sec:authorize>
         				</c:otherwise>
         				</c:choose>
         				</sec:authorize>
          				<p class="mb-1 review-content">${review.content }</p>
          			</div>
          			<c:if test="${review.saveFileName != null}">
          			<div style="width: 40%;">
          			
          			<img style="max-width:100%; max-height:100%; min-width:80%; min-height:80%;
          			padding-right: 20px;"
          			class="contentImage img-fluid float-end rounded clickable-image"  
          				src="<%=cp %>/image/${review.saveFileName}"> 
          			</div>
          			</c:if>
          		</div>
          	</div>
          	</c:if>
          	
          	
          	<c:if test="${review.depth != 0 }">
        	<div class="list-group-item " 
        	style=" margin-left:${review.depth * 30}px;"
        	data-numrev="${review.numRev }" 
        	data-numpro="${review.numPro }">
        		<div class="d-flex">
        			<div class="flex-grow-1 me-3 "  style="width: 60%;">
        			
        			<c:if test="${proDto.userId eq review.userId }">
        			<span class="badge rounded-pill text-white me-2" style="background-color:#20B2AA; font-size:0.65rem; height:15px; align-items:center; padding:0 10px; padding-top: 2px;">
       				 Maker
   					 </span> 
   					 </c:if>
        			
         				<strong>${review.userId }</strong> 
         				
         				<span class="text-muted" >${review.created }</span>
         				
         				<sec:authorize access="isAuthenticated()">
         				
         					<a href="javascript:void(0);" class="reply-review">답글</a>
         				</sec:authorize>
         				
         				<c:choose>
         				<c:when test="${loginUser eq review.userId }"> 
         					<a href="javascript:void(0);" class="reply-update">수정</a>
         					<a href="<%=cp%>/reviewDelete.action/${review.numRev}/${review.numPro}/${review.userId}/<%=pageNum %>" 
         					class="delete-review">삭제</a>
         				</c:when>
         				
         				<c:otherwise>
         				<sec:authorize access="hasRole('ADMIN')">
               			 <a href="<%=cp%>/reviewDelete.action/${review.numRev}/${review.numPro}/${review.userId}/<%=pageNum %>" 
         					class="delete-review">삭제</a>
            			</sec:authorize>
         				</c:otherwise>
         				</c:choose>
          				<p class="mb-1 reply-content">${review.content }</p>
          			</div>
          			<div style="width: 40%;">
          			
          			
          			
          			
          			</div>
          		</div>
          	</div> 
          	</c:if>
          	
        </div>
        
        </c:forEach>
        
        	<div class="d-flex justify-content-center mt-3">
    <c:set var="block" value="5" />

    <!-- 블록 인덱스 (floor 나눗셈) -->
    <fmt:parseNumber var="blockIndex" value="${(currentPage-1) div block}" integerOnly="true" />

    <!-- 시작 / 끝 페이지 -->
    <c:set var="startPage" value="${blockIndex*block+1}" />
    <c:set var="endPage" value="${startPage+block-1}" />

    <c:if test="${endPage > totalPages}">
        <c:set var="endPage" value="${totalPages}" />
    </c:if>

    <ul class="pagination">
        <!-- << 버튼 -->
        <c:if test="${startPage > 1}">
            <li class="page-item">
                <a class="page-link" href="<%=cp %>/article.action/${numPro }?page=${startPage-1}">&laquo;</a>
            </li>
        </c:if>

        <!-- 페이지 번호 -->
        <c:forEach var="p" begin="${startPage}" end="${endPage}">
            <li class="page-item ${p == currentPage ? 'active' : ''}">
                <a class="page-link" href="<%=cp %>/article.action/${numPro }?page=${p}">${p}</a>
            </li>
        </c:forEach>

        <!-- >> 버튼 -->
        <c:if test="${endPage < totalPages}">
            <li class="page-item">
                <a class="page-link" href="<%=cp %>/article.action/${numPro }?page=${endPage+1}">&raquo;</a>
            </li>
        </c:if>
    </ul>
</div>
</c:if>
<c:if test="${empty reviewLists }">
	<div class="text-center text-muted mt-4">등록된 리뷰가 없습니다.</div>
</c:if>
      
        
	</div> 
    
    <!-- 참여자-->
    <div class="tab-pane fade " id="participant" role="tabpanel" aria-labelledby="participant-tab">
      <div class="list-container">
        <h3 class="text-center mb-4" style="color:#20B2AA;">펀딩 참여자 목록</h3>
        
        <c:forEach var="p" items="${sponLists}" varStatus="vs"> 
            <div class="participant-card hidden d-flex justify-content-between align-items-center"> 
                <div> 
                    <div class="participant-name">${p.userId}</div>
                    <div class="participant-date">${p.daysAgo}일 전 참여</div>
                </div>
                <div class="participant-price">${p.amount}원</div>  
                </div>   
        </c:forEach>
        
        <c:if test="${!empty sponLists}">  
        <div class="d-grid gap-2 mt-5"> 
  			<button id="moreParticipant"  class="btn btn-outline-light" type="button" style="background-color: #20B2AA">더 보기</button>
		</div> 
		</c:if>
		
        <c:if test="${empty sponLists}"> 
            <div class="text-center text-muted mt-4">참여자가 아직 없습니다.</div>
        </c:if>
    </div>
    </div>
    
    </div>
    
	<!-- 모달 -->
<!-- 	이미지 확대 모달 -->
<div class="modal fade" id="imageModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg">
        <img src="" id="modalImage" class="img-fluid" alt="확대 이미지">
  </div>
</div>


<!-- 리뷰 수정 모달 -->
<div class="modal fade" id="editReviewModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">리뷰 수정</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <form id="editReviewForm" enctype="multipart/form-data" novalidate>
          <input type="hidden" name="numRev" id="editReviewId">
          <input type="hidden" name="numPro" id="editProjectId">
          <input type="hidden" name="originalFileName" id="originalFileName">
          

          <!-- 별점 -->
          <div id="editStars" class="d-flex justify-content-end mb-3">
            <span class="fw-bold">별점주기 : &nbsp;</span>
            <i class="bi bi-star outlined-star" data-value="1"></i>&nbsp;
            <i class="bi bi-star outlined-star" data-value="2"></i>&nbsp;
            <i class="bi bi-star outlined-star" data-value="3"></i>&nbsp;
            <i class="bi bi-star outlined-star" data-value="4"></i>&nbsp;
            <i class="bi bi-star outlined-star" data-value="5"></i>
            <input type="hidden" name="grade" id="editRating" value="" required>
          </div>

          <!-- 내용 -->
          <div class="mb-3">
            <textarea id="editReviewContent" name="content" class="form-control" rows="3" required></textarea>
            <div class="invalid-feedback">리뷰를 작성해 주세요.</div>
          </div>

          <!-- 이미지 -->
          <div class="mb-3">
            <input type="file" id="editReviewImage" name="modifyFile" class="form-control">
            <img id="modifyFile" src="" style="width:100px; height:100px; margin-top:10px;">
          </div>

          <button type="submit" class="btn btn-primary">수정 완료</button>
        </form>
      </div>
    </div>
  </div>
</div>


<!-- 답글 모달 -->
<div class="modal fade" id="replyReviewModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
  	<div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">답글</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <form id="replyReviewForm" novalidate> 
          <input type="hidden" name="numPro" id="replyProjectId"> 
          <input type="hidden" name="parentNumRev" id="replyParentId">
          
          <!-- 내용 -->
          <div class="mb-3">
          	<p name = userId><sec:authentication property="name" /></p> 
            <textarea id="replyReviewContent" style="resize: none;" name="content" class="form-control" rows="3" required></textarea>
            <div class="invalid-feedback">리뷰를 작성해 주세요.</div>
          </div>

          <button type="submit" class="btn btn-primary">작성 완료</button>
        </form>
      </div>
     </div>
    </div>
</div> 

  		 
    
    </div>
  <div class="bg sticky-top p-3 pt-5 col-md-4" style=" top:6rem; height: calc(100vh - 2rem); 
  overflow-y: auto;">
    <!-- 리워드 리스트 --> 
  <div class="reward-list pb-5">
    <!-- 리워드 카드 예시 --> 
     
    <h4 class="mb-4 ">리워드 선택</h4> 
    <c:forEach var="lists" items="${rewardLists }" varStatus="vs">
    <a href="<%=cp%>/user/reward.action/${lists.numPro}/${vs.index}" class="card mb-3 reward-card 
    ${(status==1 and daysBetween >=0) ? '' : 'disabled-link'}" ${(status==1 and daysBetween >=0) ? '' : 'onclick="return false;"'}>
      <div class="card-body" >
        <h5 class="card-title reward-title mb-3" >${lists.rewardSubject }</h5>
        <h6 class="card-subtitle mb-4 reward-price">₩${lists.amount }</h6>
        <p class="card-text mb-0">${lists.rewardContent }</p>
      </div>
     
     </a>
</c:forEach>
  </div>
</div>
</div>
  
<div class="container" style="margin-top:150px; margin-bottom:50px;">
  <h4 class="mb-4">같은 카테고리의 프로젝트</h4>

  <div class="swiper mySwiper">
    <div class="swiper-wrapper">
      <c:forEach var="lists" items="${categoryLists}" varStatus="vs">
        <div class="swiper-slide" >
        <a href="<%=cp %>/article.action/${lists.numPro}" >
          <div class="card h-100 category-card">
<%--           	<c:set var="mainImages" value="${categotyImageLists[status.index]}"></c:set> --%>
            <img src="<%=cp %>/image/${lists.mainImage.saveName}" 
                 style="height:200px; object-fit:cover;" class="card-img-top" alt="프로젝트 이미지">
            <div class="card-body">
              <h5 class="card-title">${lists.subject}</h5>
              <p class="card-text">
                <c:choose>  
                  <c:when test="${fn:length(lists.content) > 20}"> 
                    ${fn:substring(lists.content,0,20)}... 
                  </c:when> 
                  <c:otherwise>
                    ${lists.content}  
                  </c:otherwise>
                </c:choose>
              </p>
            </div>
          </div>
          </a>
        </div>
      </c:forEach>
    </div>

    <div class="swiper-button-next" style="color:  #20B2AA"></div>
    <div class="swiper-button-prev" style="color:  #20B2AA"></div>
    <div class="swiper-pagination " style="position: relative; margin-top: 30px;text-align: center;" ></div>
  </div>
</div>
  
<!-- ✅ 푸터 -->
<footer class="bg-light text-center py-3 border-top">
  <p class="mb-0 text-muted">&copy; 2025 펀딩사이트. All Rights Reserved.</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">






//좋아요--------------------------------------------------------------------

$(function() {

	if (${status==1 and daysBetween >=0}) {
	
    $("#goodBtn").click(function() {

    	var $btn = $(this);
    	
        var numPro = $(this).data("numpro");

        $.ajax({
            url: "<%=cp%>/article/good/" + numPro,
            type: "POST",
            success: function(res) {

                var count = parseInt($("#goodCount").text());

                if (res == "notLogin") {
                    location.href= "<%=cp%>/login.action";
                } else if (res == "addGood") {
                    $("#goodCount").text(count + 1);
                    $btn.removeClass("btn-outline-danger").addClass("btn-danger");
                    
                } else if (res == "removeGood") {
                    $("#goodCount").text(count - 1);
                    $btn.removeClass("btn-danger").addClass("btn-outline-danger");
                }
            },
            error: function(xhr, status, error) {
                alert("에러 발생: " + status + " / " + error);
            }
        });
    });
	}
});


//------------------------------------------------------------------------------


//컨텐츠 이미지 더보기 ---------------------------------------------------------


// moreImage (더보기) 안전 바인딩
const moreImageButton = document.getElementById("moreImage");
const hiddenImageOpen = document.getElementsByClassName("contentImage");
if (moreImageButton) {
  moreImageButton.addEventListener("click", function(){
    this.classList.toggle("hidden");
    Array.from(hiddenImageOpen).forEach(function (img) {
      img.classList.remove("hidden");
    });
  }); 
}
	
	//-----------------------------------------------------------------------
	
	//참여자 더보기
$(function() {
    const $cards = $(".participant-card");
    $cards.slice(0, 5).removeClass("hidden"); // 첫 5개만 보이게

    let currentIndex = 5;
    $("#moreParticipant").on("click", function() {
        $cards.slice(currentIndex, currentIndex + 5).removeClass("hidden");
        currentIndex += 5;

        if (currentIndex >= $cards.length) $(this).hide();
    });
});
	
	
	//별점 선택---------------------------------------------------------------
	
	const stars = document.querySelectorAll("#starRating i");
	const ratingInput = document.getElementById("rating");
	const feedback = document.getElementById("starFeedback");

	
	if (stars && stars.length > 0 && ratingInput) {
	// 클릭 이벤트
	stars.forEach(star => {
	    star.addEventListener("click", function() {
	        const value = parseInt(this.getAttribute("data-value"));
	        ratingInput.value = value; // hidden input에 값 저장
	        updateStars(value);
	        
	        // invalid-feedback 숨기기
	        feedback.style.display = "none";
	    });

	    // 마우스 오버 이벤트 (미리보기)
	    star.addEventListener("mouseover", function() {
	        const value = parseInt(this.getAttribute("data-value"));
	        updateStars(value);
	    });

	    // 마우스 아웃 이벤트 (클릭값 유지)
	    star.addEventListener("mouseout", function() {
	        updateStars(parseInt(ratingInput.value));
	    });
	});
	} 

	// 별 색 업데이트 함수
	function updateStars(value) {
	    stars.forEach(star => {
	        const starValue = parseInt(star.getAttribute("data-value"));
	        if (starValue <= value) {
	            star.classList.remove("bi-star");
	            star.classList.add("bi-star-fill");
	        } else {
	            star.classList.remove("bi-star-fill");
	            star.classList.add("bi-star");
	        }
	    });
	}
	
	// reviewForm 제출 검사 안전 바인딩
	const reviewForm = document.querySelector("form[name='reviewForm']");
	if (reviewForm) {
	  reviewForm.addEventListener("submit", function(e){
	    if(!ratingInput || !ratingInput.value){
	      e.preventDefault();
	      if (feedback) feedback.style.display = "block";
	    }
	  });
	}
	//--------------------------------------------------------------------------
	
	//리뷰 이미지 미리보기---------------------------------------------
	const realFile = document.getElementById("realFile");
	const customButton = document.getElementById("customButton");
	const preview = document.getElementById("preview");

	// 버튼 클릭 시 실제 input 클릭
	if (customButton && realFile) {
	customButton.addEventListener("click", () => {
	  realFile.click();
	});
	

	// 파일 선택 시 
	realFile.addEventListener("change", () => {
	  if(realFile.files && realFile.files[0]){
	    const file = realFile.files[0];


	    // 이미지 미리보기
	    const reader = new FileReader();
	    reader.onload = function(e){
	    	if(preview){
	      preview.src = e.target.result;
	      preview.style.display = "block";
	    }
	    };
	    reader.readAsDataURL(file);
	  } else {
	    preview.style.display = "none";
	    preview.src = "";
	  }
	});
	}
	//---------------------------------------------------------------
	
	//리뷰 검사---------------------------------------------------
	(() => {
		  'use strict'
		  
		  // Fetch all the forms we want to apply custom Bootstrap validation styles to
		  const forms = document.querySelectorAll('.needs-validation')

		  // Loop over them and prevent submission
		  Array.from(forms).forEach(form => {
		    form.addEventListener('submit', event => {
		      if (!form.checkValidity()) {
		        event.preventDefault()
		        event.stopPropagation()
		      }

		      form.classList.add('was-validated')
		    }, false)
		  })
		})()

	//----------------------------------------------------------------	
		
	
	//리뷰 이미지 확대-----------------------------------------------------------
	const images = document.querySelectorAll(".clickable-image");
  	const modalImage = document.getElementById("modalImage");
  	if (images && images.length > 0) {
  images.forEach(img => {
    img.addEventListener("click", () => {
    	if (modalImage) {
			
		
      modalImage.src = img.src;  // 클릭한 이미지 경로를 모달에 넣기
      const myModal = new bootstrap.Modal(document.getElementById("imageModal"));
      myModal.show();
    	}
    });
  });
  }

		 
  

//----------------------------------------------------------------------
  
	$(document).on('click', '.update-review', function() {
		
    const reviewItem = $(this).closest('[data-numrev]');
    const numRev = reviewItem.data('numrev');
    const numPro = reviewItem.data('numpro');
    const content = reviewItem.find('.review-content').text().trim();
    const grade = reviewItem.find('.bi-star-fill').length;
    const modifyFile = reviewItem.find('.contentImage').attr('src') || '';
    
    // 모달 열기 전에 초기화
    $('#editReviewId').val('');
    $('#editProjectId').val('');
    $('#editReviewContent').val('');
    $('#editRating').val('');
    $('#modifyFile').attr('src', '');
    $('#originalFileName').val('');
    $('#editReviewImage').val('');
    
    

    $('#editReviewId').val(numRev);
    $('#editProjectId').val(numPro);
    $('#editReviewContent').val(content);
    $('#editRating').val(grade);
    $('#modifyFile').attr('src', modifyFile);
    
    const fileNameOnly = modifyFile.split('/').pop(); 

 	$('#originalFileName').val(fileNameOnly);
 	
 	
 	
 	
 	 

 // 리뷰 수정 모달 별점 선택
    const editStars = document.querySelectorAll("#editStars i");
    const editRatingInput = document.getElementById("editRating");

    // 클릭 이벤트
    editStars.forEach(star => {
        star.addEventListener("click", function() {
            const value = parseInt(this.getAttribute("data-value"));
            editRatingInput.value = value; // hidden input에 값 저장
            updateEditStars(value);
        });

        // 마우스 오버 이벤트 (미리보기)
        star.addEventListener("mouseover", function() {
            const value = parseInt(this.getAttribute("data-value"));
            updateEditStars(value);
        });

        // 마우스 아웃 이벤트 (클릭값 유지)
        star.addEventListener("mouseout", function() {
            updateEditStars(parseInt(editRatingInput.value));
        });
    });

    // 별 색 업데이트 함수
    function updateEditStars(value) {
        editStars.forEach(star => {
            const starValue = parseInt(star.getAttribute("data-value"));
            if (starValue <= value) {
                star.classList.remove("bi-star");
                star.classList.add("bi-star-fill");
            } else {
                star.classList.remove("bi-star-fill");
                star.classList.add("bi-star");
            }
        });
    }
    
 	// 파일 선택 시 미리보기 업데이트
    $('#editReviewImage').off('change').on('change', function() {
        const file = this.files[0];
        if(file){
            const reader = new FileReader();
            reader.onload = function(e){
                $('#modifyFile').attr('src', e.target.result);
            }
            reader.readAsDataURL(file);
        }
    });
 	
 	$('#editReviewForm').off('submit').on('submit',function(e){
 		
 		e.preventDefault();
 		
 		const textarea = $('#editReviewContent');
 	    const feedback = textarea.siblings('.invalid-feedback');

 	    // 값 없으면 invalid-feedback 보여주고 중단
 	    if (!textarea.val().trim()) {
 	        textarea.addClass('is-invalid'); // 붉은 테두리 표시
 	        if(feedback) feedback.show();
 	        return;
 	    } else {
 	        textarea.removeClass('is-invalid');
 	        if(feedback) feedback.hide();
 	    }
 		
 		
 		
 		e.preventDefault();
 		
 		const formData = new FormData(this); 
 		
 		$.ajax({
 			url: '<%=cp%>/reviewUpdate.action',
 			type:'POST',
 			data:formData,
 			processData: false,
 			contentType: false,
 			success: function (res) {
 				
 				const parts = res.split("|");
		        const status = parts[0];      // success 또는 fail
		        const imagePath = parts[1];   // 이미지 경로
		        
				if (status == "success") {
					
					const numRev = formData.get('numRev');
					const reviewItem = $('[data-numrev="'+numRev+'"]');
					
					reviewItem.find('.review-content').text(formData.get('content'));
					
					const stars = parseInt(formData.get('grade'));
	                reviewItem.find('.bi-star, .bi-star-fill').removeClass('bi-star-fill').addClass('bi-star');
	                reviewItem.find('.bi-star').each(function(index){
	                    if(index < stars) $(this).removeClass('bi-star').addClass('bi-star-fill');
	                });
	                
	                if(imagePath){
	                    let img = reviewItem.find('.contentImage');
	                    if(img.length > 0) img.attr('src','<%=cp%>/' + imagePath);
	                    else reviewItem.append('<img class="contentImage img-fluid float-end rounded clickable-image" src="' + '<%=cp%>/'+ imagePath + '">');
	                }
	                
	                const modalEl = document.getElementById('editReviewModal');
	                const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
	                modal.hide();
	                
				
				
 			} else {
                alert('수정 실패: '+imagePath);
            	}
				
			},
		    error: function(xhr, status, error) {
		    	alert("에러 발생: " + error);
		        console.log("status:", status);
		        console.log("xhr.responseText:", xhr.responseText);
		    }
 		});
 		
 	});
 	
	
    const modal = new bootstrap.Modal(document.getElementById('editReviewModal'));
    
    modal.show();
});

//----------------------------------------------------------------

//삭제후 페이지 되돌리기

$(document).ready(function() {
	
	// ===================== 답글 작성 클릭 =====================
    $('#replyReviewForm').on('submit', function() {
        // 현재 스크롤 위치 저장
        sessionStorage.setItem('scrollPos', window.scrollY || window.pageYOffset);
        // 현재 활성 탭 저장
        const activeTabId = $('#projectTab .nav-link.active').attr('id');
        sessionStorage.setItem('activeTab', activeTabId);
    });
	
	// ===================== 리뷰 등록 클릭 =====================
    $('#reviewForm').on('submit', function() {
        // 현재 스크롤 위치 저장
        sessionStorage.setItem('scrollPos', window.scrollY || window.pageYOffset);
        // 현재 활성 탭 저장
        const activeTabId = $('#projectTab .nav-link.active').attr('id');
        sessionStorage.setItem('activeTab', activeTabId);
    });

    // ===================== 삭제 버튼 클릭 =====================
    $(document).on('click', 'a.delete-review', function() {
        // 현재 스크롤 위치 저장
        sessionStorage.setItem('scrollPos', window.scrollY || window.pageYOffset);
        // 현재 활성 탭 저장
        const activeTabId = $('#projectTab .nav-link.active').attr('id');
        sessionStorage.setItem('activeTab', activeTabId);
    });

    // ===================== 리뷰 수정 제출 후 =====================
    // 모달에서 AJAX로 수정 후 페이지 리다이렉트 또는 새로고침 시에도 위치 복원 가능
    $('#editReviewForm').on('submit', function() {
        sessionStorage.setItem('scrollPos', window.scrollY || window.pageYOffset);
        const activeTabId = $('#projectTab .nav-link.active').attr('id');
        sessionStorage.setItem('activeTab', activeTabId);
    });
    
	 // ===================== 페이징 버튼 클릭 =====================
    $(document).on('click', '.pagination', function() {
        // 현재 스크롤 위치 저장
        sessionStorage.setItem('scrollPos', window.scrollY || window.pageYOffset);
        // 현재 활성 탭 저장
        const activeTabId = $('#projectTab .nav-link.active').attr('id');
        sessionStorage.setItem('activeTab', activeTabId);
    });

    // ===================== 페이지 로드 시 =====================
    // 1. 탭 복원
    const activeTabId = sessionStorage.getItem('activeTab');
    if(activeTabId) {
        const tabTrigger = new bootstrap.Tab(document.getElementById(activeTabId));
        tabTrigger.show();
        sessionStorage.removeItem('activeTab');
    }

    // 2. 스크롤 위치 복원
    const scrollPos = sessionStorage.getItem('scrollPos');
    if(scrollPos) {
        window.scrollTo(0, parseInt(scrollPos));
        sessionStorage.removeItem('scrollPos');
    }

});

//--------------------------------------------------------------------------------------

let replyMode = 'write'; // write = 작성, edit = 수정
let editingNumRev = null;

// 답글 작성 클릭
$(document).on('click', '.reply-review', function() {
    replyMode = 'write';
    editingNumRev = null;

    const reviewItem = $(this).closest('[data-numrev]');
    const parentNumRev = reviewItem.data('numrev');
    const numPro = reviewItem.data('numpro');

    $('#replyProjectId').val(numPro);
    $('#replyParentId').val(parentNumRev);
    $('#replyReviewContent').val('');

    const modal = new bootstrap.Modal(document.getElementById('replyReviewModal'));
    modal.show();
});

// 답글 수정 클릭
$(document).on('click', '.reply-update', function() {
    replyMode = 'edit';

    const reviewItem = $(this).closest('[data-numrev]');
    editingNumRev = reviewItem.data('numrev');
    const numPro = reviewItem.data('numpro');
    const content = reviewItem.find('.reply-content').text().trim();

    $('#replyProjectId').val(numPro);
    $('#replyParentId').val(''); // 수정일 때 parent는 필요 없음
    $('#replyReviewContent').val(content);

    const modal = new bootstrap.Modal(document.getElementById('replyReviewModal'));
    modal.show();
});

// 답글 모달 제출
$('#replyReviewForm').off('submit').on('submit', function(e) {
	
    e.preventDefault();

    const textarea = $('#replyReviewContent');
    const feedback = textarea.siblings('.invalid-feedback');

    // 값 없으면 invalid-feedback 보여주고 중단
    if (!textarea.val().trim()) {
        textarea.addClass('is-invalid'); // 붉은 테두리 표시
        if(feedback) feedback.show();
        return;
    } else {
        textarea.removeClass('is-invalid');
        if(feedback) feedback.hide();
    }

    const formData = new FormData(this);
    let url = '';

    if(replyMode === 'write') {
        const parentNumRev = $('#replyParentId').val();
        url = '<%=cp%>/reply.action/' + parentNumRev; // 작성
    } else if(replyMode === 'edit') {
        formData.append('numRev', editingNumRev);
        url = '<%=cp%>/reviewUpdate.action'; // 수정
    }

    $.ajax({
        url: url,
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        success: function(res){
        	
        	if(res.includes("|")){
        		
        		const parts = res.split("|");
    	        res = parts[0];      // success 또는 fail
    	        const imagePath = parts[1]; 
        		
        	}
        	
            if(res === 'success'){
            	
                if(replyMode === 'edit'){
                    const reviewItem = $('[data-numrev="'+editingNumRev+'"]');
                    reviewItem.find('.reply-content').text(formData.get('content'));
                } else {
                    location.reload(); // 새 답글은 새로고침 or DOM에 append
                }
                const modalEl = document.getElementById('replyReviewModal');
                const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
                modal.hide();
            } else {
                alert('실패했습니다.');
            }
        },
        error: function(xhr, status, error){
            console.error("AJAX 에러:", status, error);
        }
    });
});
 


//swiper
$(document).ready(function() {
    const slides = document.querySelectorAll('.mySwiper .swiper-slide');
    const totalSlides = slides.length;

    if(totalSlides > 0) {
        const swiper = new Swiper(".mySwiper", {
            slidesPerView: 3,
            spaceBetween: 20,
            loop: totalSlides > 3,
            navigation: {
                nextEl: ".swiper-button-next",
                prevEl: ".swiper-button-prev",
            },
            pagination: {
                el: ".swiper-pagination",
                clickable: true,
            },
            breakpoints: {
                768: { slidesPerView: 3 },
                480: { slidesPerView: 2 },
                320: { slidesPerView: 1 }
            },
        });
    }
});

  
</script>
</body>
</html>