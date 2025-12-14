<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
%>

<div class="container-fluid justify-content-end p-0">

				<div class="card mb-2 " style="max-width: 300px;" data-url="<%=cp %>/article.action/${project.numPro}">
					<div class="row g-1">
						<div class="col-md-5">
						
						<c:if test="${not empty mainImages.saveName}">
							 <div class="card-image-box"> <!-- 여기서 스타일을 불러왔기 때문입니다. -->
	                    		<img alt="프로젝트 이미지"
	                         		src="image/${mainImages.saveName}" class="img-fluid rounded-2 w-100 h-100"/>
	                         		
	                         		<!-- 좋아요 버튼 -->
								    <button class="btn p-0 goodBtn position-absolute start-0 bottom-0 p-2"
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
                		</c:if>
                		
						</div>
						<div class="col-md-7">
							<div class="card-body p-2">
								<h6 class="card-title fw-bold" style="color:#20b2aa;
								font-size:10pt;">${project.numPro}
								<b class="ml-1 fw-bold text-body-secondary" style="font-size: 10pt">
								${project.subject}</b></h6>
								<c:choose>
									<c:when test="${fn:length(project.content)>15 }">
									<p class="card-text" style="font-size:11pt;">
									${fn:substring(project.content,0,15)}...</p>
									</c:when>
								</c:choose>
								<p class="card-text fw-bold mb-0" style="color: #20b2aa;">${project.percent}% 달성</p>
								<p class="badge mb-0" style="font-size:7pt;background-color:#20b2aa ">
								<fmt:formatNumber value="${project.totalAmount}" pattern="#,###"/>원</p>
								<p class="badge mb-0" style="font-size:7pt;background-color:#bdc3c7; ">
								<fmt:formatNumber value="${project.totalUser}" pattern="#,###"/> + 참여중</p>
							</div>
						</div>
					</div>
				</div>
			</div>
