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
<title>출금 신청 | NOVAFUND</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
   .page-title {
       font-size: 20px;
       font-weight: bold;
       color: #20b2aa;
       margin-bottom: 20px;
   }
   .form-label {
       font-weight: bold;
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
  <li class="breadcrumb-item"><a href="cashUseList.action" class="breadcrumb-prev">캐시 이용 내역</a></li>
  <li class="breadcrumb-item active" aria-current="page">출금 신청</li>
</ol>

    <!-- 페이지 제목 -->
    <h5 class="page-title">출금 신청</h5>

    <!-- 현재 보유 캐시 -->
    <div class="alert alert-info d-flex justify-content-between align-items-center">
        <span><i class="bi bi-wallet2"></i> 현재 보유 캐시</span>
        <strong>${dto.cashPoint} P</strong>
    </div>

    <!-- 출금 신청 폼 -->
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <form action="<%=cp%>/cashWithdraw.action" method="post" name="myForm">
                <div class="mb-3">
                    <label for="amount" class="form-label">출금 금액</label>
                    <input type="number" class="form-control" id="amount" name="amount"
                           placeholder="출금할 금액을 입력하세요" min="1000" required>
                    <small class="text-muted">최소 출금 금액은 1,000P 입니다.</small>
                </div>

                <div class="mb-3">
                    <label for="bankName" class="form-label">은행명</label>
                    <input type="text" class="form-control" id="bankName" name="bankName" placeholder="은행명을 입력하세요" required>
                </div>

                <div class="mb-3">
                    <label for="accountNumber" class="form-label">계좌번호</label>
                    <input type="text" class="form-control" id="accountNumber" name="accountNumber"
                           placeholder="계좌번호를 입력하세요" required>
                </div>

                <div class="mb-3">
                    <label for="holder" class="form-label">예금주</label>
                    <input type="text" class="form-control" id="holder" name="holder"
                           placeholder="예금주명을 입력하세요" required>
                </div>

                <div class="d-flex justify-content-end">
                    <button type="button" style="background-color:#20b2aa;"
                    class="btn text-white" data-bs-toggle="modal" data-bs-target="#pwdModal">
                        출금 신청하기
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- 최근 출금 내역 -->
    <h6 class="fw-bold mb-3">최근 출금 내역</h6>
    <div class="card shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover mb-0 text-center align-middle">
                <thead>
                <tr>
                    <th style="width: 15%;">요청일</th>
                    <th style="width: 15%;">처리일</th>
                    <th style="width: 15%;">은행</th>
                    <th style="width: 25%;">계좌번호</th>
                    <th style="width: 15%;">금액</th>
                    <th style="width: 15%;">상태</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${not empty withdrawLists}">
                    <c:forEach var="wd" items="${withdrawLists}">
                        <tr>
                            <td>${wd.requestDate}</td>
                            <td>${wd.processDate }</td>
                            <td>${wd.bankName}</td>
                            <td>${wd.accountNumber}</td>
                            <td><fmt:formatNumber value="${wd.amount}" pattern="#,###"/> P
                            <c:if test="${wd.status eq 'PENDING' }">
                            <a class="badge bg-light text-dark" 
                            href="<%=cp %>/cancelWithdraw.action/${wd.withdrawId}">취소하기</a>
                            </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${fn:toUpperCase(wd.status) eq 'SUCCESS'}">
                                        <span class="badge bg-success">처리완료</span>
                                    </c:when>
                                    <c:when test="${fn:toUpperCase(wd.status) eq 'PENDING'}">
                                        <span class="badge bg-warning text-dark">대기</span>
                                    </c:when>
                                    <c:when test="${fn:toUpperCase(wd.status) eq 'CANCEL'}">
                                        <span class="badge bg-danger">취소</span>
                                    </c:when>
                                    <c:when test="${fn:toUpperCase(wd.status) eq 'Failed' }">
                                    	<span class="badge bg-danger">반려</span>
                                    </c:when>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                <c:if test="${empty withdrawLists}">
                    <tr>
                        <td colspan="5" class="text-muted">출금 내역이 없습니다.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
<div class="modal fade" id="pwdModal" tabindex="-1">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content" style="width: 450px;">
			<div class="modal-header">
				<h5 class="modal-title">비밀번호 확인</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>
			<div class="modal-body">
				<div>
				<input type="password" id="pwdCheck" class="form-control" placeholder="비밀번호 입력">
				</div>
				<div id="pwdCh" style="display: none;"></div>
			</div>
			<div class="modal-footer">
				<button type="button" id="pwdConfirm" class="btn"
					 style="background-color: #20b2aa; color:white; width: 120px; 
					 margin-left: 5px">
					 확인</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">

	$(function(){
		
		$("#pwdConfirm").click(function(){
			var pwd = $("#pwdCheck").val();
			
			$("#pwdCh").hide();
			$.ajax({
				type:"post",
				url:"checkPwd.action",
				data:{pwd:pwd},
				success:function(res){
					if(res=="success"){
						$("#pwdModal").modal("hide");
						
						sendIt();
					}else{
						$("#pwdCh").text("비밀번호가 일치하지 않습니다.").
						css({"color":"red","font-size":"9pt"}).show();		
					}
				}
			});
		});
	});
		
	function sendIt(){
	
		var f = document.myForm;
		
		
		var amount = f.amount.value.trim()
		if(!amount){
			alert("금액을 입력해 주세요.");
			f.amount.focus();
			return;
		}
		
		var accountNumber = f.accountNumber.value.trim();
		if(!accountNumber){
			alert("계좌번호를 입력해 주세요.");
			f.accountNumber.focus();
			return;
		}
		
		var bankName = f.bankName.value.trim();
		if(!bankName){
			alert("은행명을 입력해 주세요.");
			f.bankName.focus();
			return;
		}
		
		var holder = f.holder.value.trim();
		if(!holder){
			alert("예금주명을 입력해 주세요.");
			f.holder.focus();
			return;
		}
		
		f.submit();
	}
	
	
	
</script>
</body>
</html>