<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style type="text/css">

.modalBtn{
	height: 70px;
	display: flex;
	align-items: center;
	justify-content: space-between;
	font-size: 1rem;
}

</style>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/mainheader.jsp"/>

	
<div class="position-absolute top-50 start-50 translate-middle"
 style="width: 600px;max-width: 90%;
height: 700px;margin-top: 50px">

<h5 class="mx-4">설정</h5>
	<div>
		<div class="d-flex flex-column justify-content-center h-100">
			<div>
				<button type="button" class="btn d-flex align-items-center justify-content-between border-light-subtle w-100 modalBtn" data-ms-whatever="@nickname">
					<div class="text-start py-1">
					<p class="text-secondary mb-1" style="font-size: 9pt">닉네임</p>
					<p class="lh-1 mb-0">${dto.nickname }</p>
					</div>
					<i class="bi bi-chevron-right text-secondary"></i>
				</button>
				<button type="button" class="btn d-flex align-items-center justify-content-between border-light-subtle w-100 modalBtn" data-ms-whatever="@email">
					<div class="text-start py-1">
					<p class="text-secondary mb-1" style="font-size: 9pt">이메일</p>
					<c:if test="${not empty dto.email }">					
						<p class="lh-1 mb-0">${dto.email }</p>
					</c:if>
					<c:if test="${empty dto.email }">
						<p class="lh-1 mb-0 text-scondary">이메일을 등록해 주세요.</p>
					</c:if>
					</div>
					<i class="bi bi-chevron-right text-secondary"></i>
				</button>
			</div>
			
			<div class="pt-4">
				<p class="text-start text-secondary" style="font-size: 10pt">
				설정
				</p>
				<button type="button" class="btn d-flex align-items-center justify-content-between border-light-subtle w-100 modalBtn"  data-ms-whatever="@addr">
					<div class="text-start py-1">
					<p class="text-secondary mb-1" style="font-size: 12pt">주소관리</p>
					</div>
					<i class="bi bi-chevron-right text-secondary"></i>
				</button>
				<c:if test="${!social }">
				<button type="button" class="btn d-flex align-items-center justify-content-between border-light-subtle w-100 modalBtn"  data-ms-whatever="@pwd">
					<div class="text-start py-1">
					<p class="text-secondary mb-1" style="font-size: 12pt">비밀번호변경</p>
					</div>
					<i class="bi bi-chevron-right text-secondary"></i>
				</button>
				</c:if>
				<button type="button" class="btn d-flex align-items-center justify-content-between border-light-subtle w-100 modalBtn"  data-ms-whatever="@phone">
					<div class="text-start py-1">
					<p class="text-secondary mb-1" style="font-size: 12pt">전화번호설정</p>
					</div>
					<i class="bi bi-chevron-right text-secondary"></i>
				</button>
				<button type="button" class="btn d-flex align-items-center justify-content-between border-light-subtle w-100 modalBtn"  data-ms-whatever="@cash">
					<div class="text-start py-1">
					<p class="text-secondary mb-1" style="font-size: 12pt">캐시이용내역</p>
					</div>
					<i class="bi bi-chevron-right text-secondary"></i>
				</button>
				<button type="button" class="btn d-flex align-items-center justify-content-between border-light-subtle w-100 modalBtn"   data-ms-whatever="@spon">
					<div class="text-start py-1">
					<p class="text-secondary mb-1" style="font-size: 12pt">후원 관리</p>
					</div>
					<i class="bi bi-chevron-right text-secondary"></i>
				</button>
				<button type="button" class="btn d-flex align-items-center justify-content-between border-light-subtle w-100 modalBtn"   data-ms-whatever="@leave">
					<div class="text-start py-1">
					<p class="text-secondary mb-1" style="font-size: 12pt">회원 탈퇴</p>
					</div>
					<i class="bi bi-chevron-right text-secondary"></i>
				</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="nicknameModal" tabindex="-1">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content" style="width: 450px;">
			<div class="modal-header">
				<h5 class="modal-title">닉네임 변경</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>
			<div class="modal-body">
				<input type="text" id="nickname" class="form-control" value="${dto.nickname}">
			</div>
			<div class="modal-footer">
				<button type="button" id="saveNickname" class="btn saveBtn"
					 style="background-color: #20b2aa; color:white; width: 120px; 
					 margin-left: 5px" data-action="nickname">
					 저장</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="emailModal" tabindex="-1">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content" style="width: 450px;">
			<div class="modal-header">
				<h5 class="modal-title">이메일 수정</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>
			<div class="modal-body">
				<div class="d-flex">
				<input type="text" id="email" class="form-control" value="${dto.email}">
				<button type="button" id="sendAuthMail" class="btn"
					 style="background-color: #20b2aa; color:white; width: 120px;
					  margin-left: 5px" 
					 disabled="disabled">인증하기</button>
				</div>
				<div id="emailCheck" style="display: none;"></div>
				<div id="authDiv" style="display: none;">
				<label for="code" class="form-label">인증번호 입력</label>
				<div class="d-flex">
					<input type="text" name="code" id="code" class="form-control">
					<button type="button" id="verifyCode" class="btn"
					 style="background-color: #20b2aa; color:white; width: 120px; 
					 margin-left: 5px">
					 인증확인</button>
				</div>
				<div id="codeCheck" style="display: none;"></div>
			</div> 
			</div>
			<div class="modal-footer">
				<button type="button" id="saveEmail" class="btn saveBtn"
					 style="background-color: #20b2aa; color:white; width: 120px; 
					 margin-left: 5px" data-action="email">
					 저장</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="changePwdModal" tabindex="-1">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content" style="width: 450px;">
			<div class="modal-header">
				<h5 class="modal-title">비밀번호 변경</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>
			<div class="modal-body">
				<div>
					<label for="currentPwd" class="form-label">현재 비밀번호</label>
					<input type="password" id="currentPwd" class="form-control">
					<div id="currentPwdCheck" style="display: none;"></div>
				</div>
			
				<div>
					<label for="changePwd" class="form-label">변경 비밀번호</label>
					<input type="password" id="changePwd" class="form-control" >
					<div id="changePwdCheck" style="display: none;"></div>
				</div>
				<div>
					<label for="changeRepwd" class="form-label">비밀번호확인</label>
					<input type="password" id="changeRepwd" class="form-control" >
					<div id="changeRepwdCheck" style="display: none;"></div>
				</div>
			</div> 
			<div class="modal-footer">
				<button type="button" id="savePwd" class="btn saveBtn"
					 style="background-color: #20b2aa; color:white; width: 120px; 
					 margin-left: 5px" data-action="pwd">
					 저장</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="phoneModal" tabindex="-1">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content" style="width: 450px;">
			<div class="modal-header">
				<h5 class="modal-title">전화번호 변경</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>
			<div class="modal-body">
			<c:if test="${not empty dto.phone }">
				<input type="text" id="phone" class="form-control" placeholder="전화번호를 입력해주세요." value="${dto.phone}">
			</c:if>
			<c:if test="${empty dto.phone }">
				<input type="text" id="phone" class="form-control" placeholder="현재 등록된 전화번호가 없습니다.">
			</c:if>
			</div>
			<div class="modal-footer">
				<button type="button" id="savePhone" class="btn saveBtn"
					 style="background-color: #20b2aa; color:white; width: 120px; 
					 margin-left: 5px" data-action="phone">
					 저장</button>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="addrModal" tabindex="-1">
	<div class="modal-dialog modal-dialog-centered">
		<div class="modal-content" style="width: 600px;">
			<div class="modal-header">
				<h5 class="modal-title">주소 변경</h5>
				<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			</div>
			<div class="modal-body">
			<div class="mb-3 row">
				<label for="userPostCode" class="col-3 col-form-label text-end">우편번호</label>
				<div class="col-9 d-flex">
					<input type="text" id="userPostCode" class="form-control me-2" placeholder="우편번호" value="${userPostCode}" readonly>
					<button type="button" class="btn" style="color: white;background-color: #20b2aa;width: 120px"
					onclick="searchAddress();">주소찾기</button>
				</div>
			</div>
			<div class="mb-3 row">
				<label for="userAddress" class="col-3 col-form-label text-end">주 소</label>
				<div class="col-9">
					<input type="text" id="userAddress" class="form-control" placeholder="주 소" value="${userAddress}" readonly="readonly" required>
				</div>
			</div>
			<div class="mb-3 row">
				<label for="detailAddress" class="col-3 col-form-label text-end">상세주소</label>
				<div class="col-9">
					<input type="text" id="detailAddress" class="form-control" placeholder="상세주소" value="${detailAddress}" readonly="readonly" required>
				</div>
			</div>
			</div>
			<div class="modal-footer">
				<button type="button" id="savePhone" class="btn saveBtn"
					 style="background-color: #20b2aa; color:white; width: 120px; 
					 margin-left: 5px" data-action="addr">
					 저장</button>
			</div>
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
	
	$("#email").keyup(function(){
			
		var email = $(this).val();
		
		var emailPattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
		
		if(emailPattern.test(email)){
			$("#sendAuthMail").prop("disabled", false);
			$("#email").css("border-color","");
			$("#emailCheck").hide();
		}else{
			$("#sendAuthMail").prop("disabled",true);
			$("#email").css("border-color","red");
			$("#emailCheck").text("이메일을 입력하세요.").
			css({"color":"red","font-size":"9pt"}).show();
		}
	});
	
	$("#sendAuthMail").click(function(){
		var params = "email=" + $("#email").val();
		
		$.ajax({
			
			type:"post",
			url:"sendAuthMail.action",
			data:params,
			success:function(response){
				if(response=="success"){
					$("#authDiv").show();
				}else if(response=="exist"){
					$("#email").css("border-color","red");
					$("#emailCheck").text("이미 가입한 이메일입니다.").
					css({"color":"red","font-size":"9pt"}).show();
				}
			}
		});
	
	});
	
	$("#verifyCode").click(function(){
		var params = "code=" + $("#code").val();
		
		$.ajax({
			
			type:"post",
			url:"verifyCode.action",
			data:params,
			success:function(response){
				if(response=="verified"){
					$("#code").css("border-color","");
					$("#codeCheck").text("인증 완료").
					css({"color":"green","font-size":"9pt"}).show();
					
				}else{
					$("#code").css("border-color","red");
					$("#codeCheck").text("인증번호가 일치하지 않습니다.").
					css({"color":"red","font-size":"9pt"}).show();
				}
			}
		});
	
	});
	
	var targetAction = null;
	var social = ${social}
	
	$(".modalBtn").on("click",function(){
		targetAction = $(this).data("ms-whatever");
		
		if(social){
		
			if(targetAction=="@addr"){
				$("#addrModal").modal("show");
			} else if(targetAction === "@phone"){
				$("#phoneModal").modal("show");
			} else if(targetAction === "@email"){
				$("#changeEmailModal").modal("show");
			} else if(targetAction == "@leave"){
				if(confirm("정말 탈퇴하시겠습니까?")){
					location.href="<%=cp%>/delete.action"
				};
			}else if(targetAction=="@cash"){
				location.href="cashUseList.action";
			}else if(targetAction=="@spon"){
				location.href="sponList.action";
			}
		} else{
			$("#pwdModal").modal("show");
		}
	})
	
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
				
					if(targetAction=="@addr"){
						$("#addrModal").modal("show");
					} else if(targetAction === "@phone"){
						$("#phoneModal").modal("show");
					} else if(targetAction === "@pwd"){
						$("#changePwdModal").modal("show");
					}else if(targetAction === "@email"){
						$("#emailModal").modal("show");
					}else if(targetAction === "@nickname"){
						$("#nicknameModal").modal("show");
					} else if(targetAction == "@leave"){
						if(confirm("정말 탈퇴하시겠습니까?")){
							location.href="<%=cp%>/delete.action"
						};
					}else if(targetAction=="@cash"){
						location.href="cashUseList.action";
					}else if(targetAction=="@spon"){
						location.href="sponList.action";
					}
				} else {
					if(targetAction === "@email"){
						$("#changeEmailModal").modal("show");
					}
					$("#pwdCh").text("비밀번호가 일치하지 않습니다.").
					css({"color":"red","font-size":"9pt"}).show();
				}
			}
		});
	});
	
	$("#pwdModal").on("hidden.bs.modal",function(){
		$("#pwdCheck").val("");
		$("#pwdCh").hide();
	});
	
	$("#phone").keyup(function(){
		$(this).prop("placeholder","전화번호를 입력해주세요.")		
	});
	
	
	$(document).on("click",".saveBtn",function(){
		var action=$(this).data("action");
		
		if(action=="nickname"){
			var nickname = $("#nickname").val()
			$.post("<%=cp%>/updateNickname.action",{nickname:nickname},function(res){
				if(res=="success"){
					alert("닉네임 변경 완료")
					$("#nicknameModal").modal("hide");
					location.reload();
				}else{
					alert("닉네임 변경 실패")
					$("#nicknameModal").modal("hide")
				}
			});
		} else if(action=="email"){
			var email = $("#email").val()
			$.post("<%=cp%>/updateEmail.action",{email:email},function(res){
				if(res=="success"){
					alert("이메일 변경 완료")
					$("#emailModal").modal("hide");
					location.reload();
				}else{
					alert("이메일 변경 실패")
					$("#emailModal").modal("hide")
				}
			});
		}else if(action=="pwd"){
			var currentPwd = $("#currentPwd").val()
			var changePwd = $("#changePwd").val();
			var changeRepwd = $("#changeRepwd").val();
			
			if(!currentPwd){
				$("#currentPwdCheck").text("비밀번호를 입력해 주세요.").
				css({"color":"red","font-size":"9pt"}).show();
				$("#currentPwd").focus();
				return;
			}else if(!changePwd){
				$("#currentPwdCheck").hide();
				$("#changePwdCheck").text("변경할 비밀번호를 입력해 주세요.").
				css({"color":"red","font-size":"9pt"}).show();
				$("#changePwd").focus();
				return;
			}else if(!changeRepwd){
				$("#currentPwdCheck").hide();
				$("#changePwdCheck").hide();
				$("#changeRepwdCheck").text("비밀번호확인은 필수 입니다.").
				css({"color":"red","font-size":"9pt"}).show();
				$("#changeRepwd").focus();
				return;
			}else if(changePwd!=changeRepwd){
				$("#currentPwdCheck").hide();
				$("#changePwdCheck").hide();
				$("#changeRepwdCheck").hide();
				$("#changeRepwdCheck").text("입력한 비밀번호가 일치하지 않습니다.").
				css({"color":"red","font-size":"9pt"}).show();
				$("#changeRepwd").focus();
				return;
			}
			$("#changePwdCheck").hide();
			$("#changeRepwdCheck").hide();
			
			$.post("<%=cp%>/updatePwd.action",{currentPwd:currentPwd,changePwd:changePwd},function(res){
				if(res=="success"){
					alert("비밀번호 변경 완료")
					$("#pwdModal").modal("hide");
					location.reload();
				}else if(res=="mismatch"){
					$("#currentPwdCheck").text("비밀번호가 일치하지 않습니다.").
					css({"color":"red","font-size":"9pt"}).show();
				}else{
					alert("비밀번호 변경 실패")
					$("#pwdModal").modal("hide")
				}
			});
		}else if(action=="phone"){
			var phone = $("#phone").val()
			
			if(!phone){
				
			}
			$.post("<%=cp%>/updatePhone.action",{phone:phone},function(res){
				if(res=="success"){
					alert("전화번호 변경 완료")
					$("#phoneModal").modal("hide");
					location.reload();
				}else{
					alert("전화번호 변경 실패")
					$("#phoneModal").modal("hide")
				}
				
			});
		}else if(action=="addr"){
			var address = $("#userPostCode").val() + "|" + $("#userAddress").val() + "|" + $("#detailAddress").val() 
			$.post("<%=cp%>/updateAddress.action",{address:address},function(res){
				if(res=="success"){
					alert("주소 변경 완료")
					$("#addrModal").modal("hide");
					location.reload();
				}else{
					alert("주소 변경 실패")
					$("#addrModal").modal("hide")
				}
			});
		}
	});
});

/** 카카오 주소 처리 */
function searchAddress() {
    new daum.Postcode({
        oncomplete: function(data) { // 선택시 입력값 세팅
            document.getElementById("userAddress").value = data.address; // 주소 넣기
            document.getElementById("userPostCode").value = data.zonecode; // 우편번호 넣기
            var inputDtlAddr = document.getElementById("detailAddress"); // 주소란 읽기전용 설정
            inputDtlAddr.readOnly = false;
        }
    }).open();
}

/** 취소버튼 클릭 시 주소, 상세주소 초기화 */
function cancelAddress() {
    var inputPostCode = document.getElementById("userPostCode");
    inputPostCode.value = ""; // 우편번호 초기화
    var inputAddr = document.getElementById("userAddress");
    inputAddr.value = ""; // 주소란 초기화
    var inputDtlAddr = document.getElementById("detailAddress");
    inputDtlAddr.value = ""; // 상세주소란 초기화
    inputDtlAddr.readOnly = true; // 상세주소란 읽기전용 해제
}


</script>
</body>
</html>