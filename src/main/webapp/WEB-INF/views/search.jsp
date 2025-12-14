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
<title>moreList</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
.card-image-box {
    position: relative;
    width: 100%;
    padding-top: 80%;
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


/* 카드 본문 */

.card-body {
    padding: 0.75rem;
}
.card-title {
    font-size: 10pt;
    font-weight: bold;
}
.card-text {
    font-size: 9pt;
    margin-bottom: 0.25rem;
}

/* 더보기 버튼 */
.btn-more {
    background-color: #ffffff;        /* 흰색 배경 */
    color: #20b2aa;                   /* 글씨색 #20b2aa */
    border: 1px solid #20b2aa;        /* 테두리 #20b2aa */
    font-size: 1.1rem;                /* 글씨 크기 */
    padding: 0.55rem 2.5rem;          /* 버튼 크기 */
    border-radius: 0.5rem;            /* 둥근 모서리 */
    transition: all 0.2s ease;        /* 부드러운 전환 */
    cursor: pointer;
}
.btn-more:hover {
    background-color: #20b2aa;        /* 호버 시 배경색 반전 */
    color: #ffffff;                   /* 호버 시 글씨 흰색 */
    border-color: #20b2aa;            /* 테두리 유지 */
}


</style>

</head>
<body>
<c:set var="categoryNameAll" value="전체"/>

<jsp:include page="/WEB-INF/views/include/mainheader.jsp"/>

<div class="container my-4 pt-4">
	
	<c:if test="${empty lists }">
		<div class="text-center">
			<h2 class="mb-4 text-secondary" style="padding-top: 2rem;"><b>검색결과가 없습니다.</b></h2>
		</div>	
	</c:if>
	
	<c:if test="${not empty lists }">
		<h2 class="mb-4 text-secondary" style="padding-top: 2rem;">
			<b>검색결과(
			<c:if test="${empty categoryName }">전체</c:if>
			<c:if test="${not empty categoryName }">${categoryName }</c:if>
			)
			</b>
		</h2>
		
		<br/>
	
		<div class="row g-4 justify-content" id="listArea">
			<c:forEach var="dto" items="${lists}" varStatus="status">
				<div class="col-lg-3 col-md-4 col-sm-6 col-12">
			
				<c:set var="project" value="${dto}" scope="request"/>
				<c:set var="mainImage" value="${seMainImages[status.index]}" scope="request"/>
				
					<jsp:include page="/WEB-INF/views/include/cardcommon.jsp">
						<jsp:param name="index" value="${status.index}" />
					</jsp:include>
				</div>
			</c:forEach>
		</div>
		
		<br/><br/>
		
		<!-- 더보기 -->
		<c:if test="${!empty lists }"> 
	    <div class="d-grid gap-2 mx-auto text-center" style="max-width: 200px;"> 
			<button id="moreBtn" class="btn-more" style="height:50px;"><b>더 보기&nbsp;</b></button>
	    </div> 
	    </c:if>
	</c:if>
	
		<br/>
</div>

<script>
let currentPage = ${pageNum};               // Controller에서 넘어온 현재 페이지 번호
const totalCount = ${dataCount};            // 전체 데이터 개수
const pageSize   = 8;                       // 한 번에 8개씩
const category   = "${param.categoryName}"; // 카테고리(전체 등)
const searchVal  = "${param.searchValue}";  // 검색어

if (totalCount === 0) {
    $("#moreBtn").hide();
}

$("#moreBtn").on("click", function(){
    currentPage++;

    $.ajax({
        url : "<c:url value='/list.action'/>",
        type: "POST",
        data: {
            pageNum: currentPage,
            categoryName: category,
            searchValue: searchVal
        },
        success: function(data){
            // list 부분만 추출
            const newCards = $(data).find("#listArea").html();

            // --- [수정] 응답이 비어있으면 버튼 숨김 ---
            if (!newCards || newCards.trim() === "") {
                $("#moreBtn").hide();
                return;
            }

            $("#listArea").append(newCards);

            // 로드된 카드 수가 전체 개수 이상이면 버튼 숨김
            const loaded = $("#listArea .col-lg-3").length;
            if (loaded >= totalCount) {
                $("#moreBtn").hide();
            }
        },
        error: function(){
            alert("더보기 불러오기 실패");
        }
    });
});

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

</body>
</html>