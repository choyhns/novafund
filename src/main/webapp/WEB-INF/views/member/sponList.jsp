<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>후원 내역 | NOVAFUND</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js"></script>

<style>
.page-title {
    font-size: 20px;
    font-weight: bold;
    color: #20b2aa;
    margin-bottom: 20px;
}
.table th {
    background-color: #f8f9fa;
    color: #333;
}
.amount {
    font-weight: bold;
    color: #20b2aa;
}

.breadcrumb-prev{
	color: #20B2AA; /* 원하는 색상 코드로 변경 가능 */
    text-decoration: none; /* 밑줄 제거 */
}

.breadcrumb-prev:hover{
	text-decoration: underline;
}
</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/mainheader.jsp"/>

<div class="container mt-5">
<ol class="breadcrumb">
  <li class="breadcrumb-item"><a href="memberInfo.action" class="breadcrumb-prev">내정보</a></li>
  <li class="breadcrumb-item"><a href="update.action" class="breadcrumb-prev">프로필 편집/설정</a></li>
  <li class="breadcrumb-item active" aria-current="page">후원 관리</li>
</ol>
    <h5 class="page-title">내 후원 내역</h5>

    <!-- 후원 내역 테이블 -->
    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover mb-0 text-center align-middle">
                <thead>
                    <tr>
                        <th style="width: 15%;">날짜</th>
                        <th style="width: 25%;">프로젝트</th>
                        <th style="width: 20%;">리워드</th>
                        <th style="width: 15%;">금액</th>
                        <th style="width: 5%;">상태</th>
                        <th style="width: 10%;">취소하기</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="spon" items="${sponLists}" varStatus="status"
                    begin="${start }" end="${end }">
                    <c:set var="project" value="${proLists[status.index] }"/>
                    <c:set var="spondetail" value="${sponDetailLists[status.index] }"/>
                    
                        <tr>
                            <td>${spon.created}</td>
                            <td>
                                <a href="<%=cp %>/article.action/${spon.numPro}" class="text-decoration-none breadcrumb-prev">
                                    ${project.subject}
                                </a>
                                <c:choose>
                                	<c:when test="${project.status==0 }">
                                		<span class="badge bg-secondary">진행중</span>
                                	</c:when>
                                	<c:when test="${project.status==1 }">
                                		<span class="badge bg-secondary">진행중</span>
                                	</c:when>
                                	<c:when test="${project.status==2 }">
                                		<span class="badge bg-success">성공</span>
                                	</c:when>
                                	<c:when test="${project.status==3 }">
                                		<span class="badge bg-success">정산완료</span>
                                	</c:when>
                                	<c:when test="${project.status==-1 }">
                                		<span class="badge bg-danger">실패</span>
                                	</c:when>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty spon.rewardId}">
                                        ${spon.rewardId}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            
                            <td class="amount"><fmt:formatNumber value="${spon.amount}" pattern="#,###"/> P</td>
                            <td>
                                <c:choose>
                                    <c:when test="${spon.paid == 0 and (project.status == 1 or project.status == 2)}">
                                        <span class="badge bg-success">후원완료</span>
                                        </td>
                                        <td>
                                        	<button class="badge bg-secondary cancelBtn"
                                        	data-sponNum="${spon.sponNum }">취소하기</button>
                                        </td>
                                    </c:when>
                                    <c:when test="${spon.paid == 0 and project.status == -1 }">
                                    	<span class="badge bg-warning text-dark">환불중</span>
                                    </c:when>
                                    <c:when test="${spon.paid == 1 }">
                                        <span class="badge bg-success">후원완료</span>
                                    </c:when>
                                    <c:when test="${spon.paid eq '-2'}">
                                        <span class="badge bg-danger">후원취소</span>
                                    </c:when>
                                    <c:when test="${spon.paid eq '-1'}">
                                        <span class="badge bg-secondary">환불완료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning text-dark">대기</span>
                                        </td>
                                        <td>
                                        	<button class="badge bg-secondary text-dark cancelBtn"
                                        	data-sponNum="${spon.sponNum }">취소하기</button>
                                        </td>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty sponLists}">
                        <tr>
                            <td colspan="5" class="text-muted">후원 내역이 없습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

    <!-- 페이지네이션 -->
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
		    <a class="page-link" href="<%=cp%>/sponList.action?page=${startPage-1}">&laquo;</a>
		</li>
		</c:if>
		
		<!-- 페이지 번호 -->
		<c:forEach var="p" begin="${startPage}" end="${endPage}">
		<li class="page-item ${p == currentPage ? 'active' : ''}">
		<a class="page-link" href="<%=cp%>/sponList.action?page=${p}">${p}</a>
		</li>
		</c:forEach>
		
		<!-- >> 버튼 -->
		<c:if test="${endPage < totalPages}">
		<li class="page-item">
		    <a class="page-link" href="<%=cp%>/sponList.action?page=${endPage+1}">&raquo;</a>
		</li>
		</c:if>
		</ul>
    </div>
</div>

<script type="text/javascript">

	$(function() {
		$(document).on("click",".cancelBtn",function(){
			var sponNum = $(this).data("sponnum")
			alert(sponNum)
			if(confirm("정말 후원을 취소 하시겠습니까?")){
				$.ajax({
					type:"post",
					url:"<%=cp%>/sponCancel.action",
					data:{sponNum:sponNum},
					success: function(res){
						if(res=="success"){
							alert("후원이 취소되었습니다.");
							location.reload();
						} else {
							alert("취소에 실패했습니다.");
						}
					},
					error: function(){
						alert("서버 오류가 발생했습니다.");
					}
				})
			}
		});
	});
	
</script>

</body>
</html>