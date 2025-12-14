<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
%>


<div class="card h-100" data-url="<%=cp%>/article.action/${project.numPro}">


	<div class="card-image-box"> <!-- 스타일은 여깄습니다.(메인에서 불러왔습니다.) -->
	


		<c:if test="${not empty mainImage.saveName }">
			<img src="<%=request.getContextPath()%>/image/${mainImage.saveName}" alt="<%=request.getContextPath()%>/image/${mainImage.saveName}"
				class="project-image" />

		</c:if>
		
		
		 
		<!-- 좋아요 버튼 -->
	    <button class="btn goodBtn position-absolute start-0 bottom-0 p-2 mb-2 ms-2"
	            data-numpro="${project.numPro}"
	            type="button"
	            style="background: none; border: none; bottom: 55px;">
	        <c:choose>
            <c:when test="${project.userGood eq 'Y'}">
         		<i class="bi bi-heart-fill text-danger fs-5"></i>
            </c:when>
            <c:otherwise>
                <i class="bi bi-heart text-white fs-5" style="text-shadow:0 0 3px rgba(0,0,0,0.5);"></i>
            </c:otherwise>
        </c:choose>
	    </button>
	    
	</div>
	
		<div class="card-body p-2">
			<h6 class="card-title mb-1">
			<b class="ml-1 fw-bold text-body-secondary" style="font-size: 10pt">
			${project.subject}</b></h6>
			<p class="card-text"style="height: 2em;">${project.content}</p>
			<p class="card-text" style="color: #20b2aa;">${project.percent}% 달성</p>
			<p class="badge mb-0" style="font-size:7pt;background-color:#20b2aa ">
			<fmt:formatNumber value="${project.totalAmount}" pattern="#,###"/>원</p>
			<p class="badge mb-0" style="font-size:7pt;background-color:#bdc3c7; ">
			<fmt:formatNumber value="${project.totalUser}" pattern="#,###"/> + 참여중</p>
		</div>
</div>


