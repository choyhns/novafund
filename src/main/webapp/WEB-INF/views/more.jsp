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

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>


<style>
.card-image-box {
    position: relative;
    width: 100%;
    padding-top: 80%;  /* 얘는 조금 다르게 뒀습니다. 비율 맞추고 싶으면 여기서 하면 됩니당 */
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


/* 홈 화면과 동일한 버튼 스타일 */
.btn-more-style {
    background-color: #ffffff;  
    color: #20b2aa;                
    border: 1px solid #20b2aa;     
    height: 35px;
    font-weight: bold;
    border-radius: 0.5rem;
    font-size: 1.1rem;
    transition: all 0.2s ease;
    cursor: pointer;
}
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
    <h2 class="mb-4 text-secondary" style="padding-top: 2rem;">
        <b>
            <c:choose>
                <c:when test="${type == 'recommend'}">추천 프로젝트 검색결과</c:when>
                <c:when test="${type == 'created'}">최신 프로젝트 검색결과</c:when>
            </c:choose>
        </b>
    </h2>

	<br/>
	
    <!-- 카드 리스트 -->
    <div class="row g-4 justify-content" id="listArea">
        <c:forEach var="dto" items="${lists}" varStatus="status">
            <div class="col-lg-3 col-md-4 col-sm-6 col-12">
                <c:set var="project" value="${dto}" scope="request"/>
                <c:set var="mainImage" value="${mainImages[status.index]}" scope="request"/>
                
                <!-- include -->
                <jsp:include page="/WEB-INF/views/include/cardcommon.jsp">
                    <jsp:param name="index" value="${status.index}" />
                </jsp:include>
            </div>
        </c:forEach>
    </div>
    
    <br/><br/> 
    
    <c:if test="${empty lists }"> 
    
    <div class="text-center">
		<h2 class="mb-4 text-secondary" style="padding-top: 2rem;"><b>검색결과가 없습니다.</b></h2>
	</div>
    </c:if>
     
    <c:if test="${!empty lists }"> 
    <div class="d-grid gap-2 mx-auto text-center" style="max-width: 200px;"> 
		<button id="moreBtn" class="btn-more-style" style="height:50px;"><b>더 보기</b></button>
    </div> 
    </c:if>
    <br/> 
    
</div>

 
<script>
let currentPage = 1; // 첫 페이지는 이미 로드됨
const projType = "${type}";
const totalCount = ${dataCount}; // Controller에서 받은 전체 개수

$("#moreBtn").on("click", function() {
    currentPage++;
    
    $.ajax({
        url: "<%=cp%>/more.action/" + projType,
        type: "POST", 
        data: {
            pageNum: currentPage
        },
        success: function(data) {
            // JSP 응답에서 카드 부분만 추출
            const newCards = $(data).find("#listArea").html();
            
            if (!newCards || newCards.trim() === "") {
                $("#moreBtn").hide();
            } else {
                $("#listArea").append(newCards);
            }
            
            // 현재 로드된 카드 총 개수 확인
            const loaded = $("#listArea .col-lg-3").length;
            if(loaded >= totalCount) {
                $("#moreBtn").hide();
            }
            
        },
        error: function() {
            alert("더보기 불러오기 실패");
        }
    });
});


$(function() {
    // 좋아요 버튼 클릭 이벤트
    $(document).on('click', '.goodBtn', function () {
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
