<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>관리자 페이지 | NOVAFUND</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

<style>
.page-title {
    font-size: 22px;
    font-weight: bold;
    color: #20b2aa;
    margin-bottom: 25px;
}
.nav-tabs .nav-link.active {
    background-color: #20b2aa;
    color: white !important;
    border-color: #20b2aa #20b2aa white;
}
.nav-tabs .nav-link {
    color: #20b2aa;
    font-weight: 500;
}
.table th {
    background-color: #f8f9fa;
}
</style>
</head>
<body>

<jsp:include page="/WEB-INF/views/include/mainheader.jsp"/>

<div class="container mt-5">

    <h4 class="page-title text-center"><i class="bi bi-speedometer2"></i> 관리자 페이지</h4>

    <!-- 네비게이션 탭 -->
    <ul class="nav nav-tabs mb-3" id="adminTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="project-tab" data-bs-toggle="tab" data-bs-target="#project"
                type="button" role="tab">신규 프로젝트 승인</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="projectSuccess-tab" data-bs-toggle="tab" data-bs-target="#projectSuccess"
                type="button" role="tab">완료 프로젝트 승인</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="projectSuccess-tab" data-bs-toggle="tab" data-bs-target="#projectFailed"
                type="button" role="tab">실패 프로젝트 승인</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="withdraw-tab" data-bs-toggle="tab" data-bs-target="#withdraw"
                type="button" role="tab">출금 신청 승인</button>
        </li>
    </ul>

    <!-- 탭 콘텐츠 -->
    <div class="tab-content">

        <!-- 신규 프로젝트 승인 -->
        <div class="tab-pane fade show active" id="project" role="tabpanel">
            <div class="card shadow-sm mb-4">
                <div class="card-header text-white" style="background-color:#20b2aa;">
                    <i class="bi bi-clipboard-check"></i> 승인 대기중인 프로젝트
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover text-center align-middle mb-0">
                        <thead>
                            <tr>
                                <th>프로젝트명</th>
                                <th>작성자</th>
                                <th>등록일</th>
                                <th>목표금액</th>
                                <th>상태</th>
                                <th>승인/반려</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${not empty projectPendingLists}">
                                <c:forEach var="pro" items="${projectPendingLists}">
                                    <tr>
                                        <td>${pro.subject}</td>
                                        <td>${pro.userId}</td>
                                        <td>${pro.created}</td>
                                        <td><fmt:formatNumber value="${pro.goalAmount}" pattern="#,###"/> P</td>
                                        <td><span class="badge bg-warning text-dark">대기</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-success approveBtn" data-id="${pro.numPro}">승인</button>
                                            <button class="btn btn-sm btn-danger rejectBtn" data-id="${pro.numPro}">반려</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty projectPendingLists}">
                                <tr><td colspan="6" class="text-muted">승인 대기중인 프로젝트가 없습니다.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 완료 프로젝트 승인 -->
        <div class="tab-pane fade" id="projectSuccess" role="tabpanel">
            <div class="card shadow-sm mb-4">
                <div class="card-header text-white" style="background-color:#20b2aa;">
                    <i class="bi bi-flag"></i> 정산 대기중인 프로젝트
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover text-center align-middle mb-0">
                        <thead>
                            <tr>
                                <th>프로젝트명</th>
                                <th>작성자</th>
                                <th>등록일</th>
                                <th>목표금액</th>
                                <th>상태</th>
                                <th>승인/반려</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${not empty projectSuccessLists}">
                                <c:forEach var="pro" items="${projectSuccessLists}">
                                    <tr>
                                        <td>${pro.subject}</td>
                                        <td>${pro.userId}</td>
                                        <td>${pro.created}</td>
                                        <td><fmt:formatNumber value="${pro.goalAmount}" pattern="#,###"/> P</td>
                                        <td><span class="badge bg-warning text-dark">정산 대기</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-success approveSuccessBtn" data-id="${pro.numPro}">승인</button>
                                            <button class="btn btn-sm btn-danger rejectSuccessBtn" data-id="${pro.numPro}">반려</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty projectSuccessLists}">
                                <tr><td colspan="6" class="text-muted">정산 대기중인 프로젝트가 없습니다.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

		<!-- 실패 프로젝트 승인 -->
        <div class="tab-pane fade" id="projectFailed" role="tabpanel">
            <div class="card shadow-sm mb-4">
                <div class="card-header text-white" style="background-color:#20b2aa;">
                    <i class="bi bi-flag"></i> 정산 대기중인 프로젝트
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover text-center align-middle mb-0">
                        <thead>
                            <tr>
                                <th>프로젝트명</th>
                                <th>작성자</th>
                                <th>등록일</th>
                                <th>목표금액</th>
                                <th>상태</th>
                                <th>승인/반려</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${not empty projectFailedLists}">
                                <c:forEach var="pro" items="${projectFailedLists}">
                                    <tr>
                                        <td>${pro.subject}</td>
                                        <td>${pro.userId}</td>
                                        <td>${pro.created}</td>
                                        <td><fmt:formatNumber value="${pro.goalAmount}" pattern="#,###"/> P</td>
                                        <td><span class="badge bg-warning text-dark">정산 대기</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-success approveFailedBtn" data-id="${pro.numPro}">승인</button>
                                            <button class="btn btn-sm btn-danger rejectFailedBtn" data-id="${pro.numPro}">반려</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty projectFailedLists}">
                                <tr><td colspan="6" class="text-muted">정산 대기중인 프로젝트가 없습니다.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- 출금 신청 승인 -->
        <div class="tab-pane fade" id="withdraw" role="tabpanel">
            <div class="card shadow-sm">
                <div class="card-header text-white" style="background-color:#20b2aa;">
                    <i class="bi bi-cash-coin"></i> 출금 신청 목록
                </div>
                <div class="card-body p-0">
                    <table class="table table-hover text-center align-middle mb-0">
                        <thead>
                            <tr>
                                <th>유저</th>
                                <th>은행</th>
                                <th>계좌번호</th>
                                <th>예금주</th>
                                <th>금액</th>
                                <th>신청일</th>
                                <th>승인/반려</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${not empty withdrawPendingLists}">
                                <c:forEach var="wd" items="${withdrawPendingLists}">
                                    <tr>
                                        <td>${wd.userId}</td>
                                        <td>${wd.bankName}</td>
                                        <td>${wd.accountNumber}</td>
                                        <td>${wd.holder}</td>
                                        <td><fmt:formatNumber value="${wd.amount}" pattern="#,###"/> P</td>
                                        <td>${wd.requestDate}</td>
                                        <td>
                                            <button class="btn btn-sm btn-success approveWithdrawBtn" data-id="${wd.withdrawId}">승인</button>
                                            <button class="btn btn-sm btn-danger rejectWithdrawBtn" data-id="${wd.withdrawId}">반려</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty withdrawPendingLists}">
                                <tr><td colspan="7" class="text-muted">출금 신청 내역이 없습니다.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
$(function(){
    function handleAction(selector, url, successMsg, failMsg){
        $(selector).click(function(){
            var id = $(this).data("id");
            if(confirm("정말 진행하시겠습니까?")){
                $.post("<%=cp%>"+url,{id:id},function(res){
                    if(res=="success"){ alert(successMsg); location.reload();}
                    else{ alert(failMsg); }
                });
            }
        });
    }

    handleAction(".approveBtn","/projectApprove.action","프로젝트 승인 완료","승인 실패");
    handleAction(".rejectBtn","/projectReject.action","프로젝트 반려 완료","반려 실패");
    handleAction(".approveSuccessBtn","/projectSuccessApprove.action","정산 승인 완료","승인 실패");
    handleAction(".rejectSuccessBtn","/projectSuccessReject.action","정산 반려 완료","반려 실패");
    handleAction(".approveFailedBtn","/projectFailedApprove.action","정산 승인 완료","승인 실패");
    handleAction(".rejectFailedBtn","/projectFailedReject.action","정산 반려 완료","반려 실패");
    handleAction(".approveWithdrawBtn","/withdrawApprove.action","출금 승인 완료","승인 실패");
    handleAction(".rejectWithdrawBtn","/withdrawReject.action","출금 반려 완료","반려 실패");
});
</script>

</body>
</html>