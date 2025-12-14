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
<title>프로젝트 생성 및 파일 업로드 test</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style type="text/css">
.form-container{
	width: 80%;
	margin: 0 auto;
}

.form-container .form-control{
	width:100%;
}

.form-border{
	border: 1px solid #20b2aa;
	width: 90%;
	padding: 20px;
	margin: 10px auto;
	border-radius: 8px;
	
}

.h3-control{
	color:#b7b7b7; 
	border-bottom: 3px; 
	user-select: none;

}

.btn-custom{
	display: block;
	width: 30%;
	margin-left: 5%;
	margin-top: 15px;
	padding: 10px;
	
	background-color: #20b2aa;
	color: white;
	border: none;
	border-radius: 8px;
	font-size: 16px;
	font-weight: bold;
	text-align: center;
	cursor: pointer;
	
	
}

</style>

</head>
<body>
<!-- ================= 헤더 / 내비게이션 ================= -->
<jsp:include page="/WEB-INF/views/include/mainheader.jsp" />


<div class="form-container">
<form name="myForm" action="<%=cp %>/projectUpdated_ok.action"
method="post" enctype="multipart/form-data" onsubmit="return sendIt()">

<input type="hidden" name="numPro" value="${project.numPro}" />


	<br/>
	<h2 style="color: #20b2aa; padding-bottom: 8px; ">&nbsp;&nbsp;&nbsp;&nbsp;프로젝트 정보</h2>
	
	<div class="form-border">
	<label class="form-label" style="border-bottom: 3px;">카테고리</label>
	<h6 class="h3-control" >
	카테고리는 서포터가 프로젝트를 더 잘 찾을 수도록 도와줘요.</h6>
	
	<select id="categorySelect" name="categoryName" class="form-control" 
	style="width:30%;">
	<option value="${project.categoryName}" selected>${project.categoryName}</option>
		
	    <c:forEach var="cat" items="${lists}">
	        <option value="${cat.categoryName}">${cat.categoryName}</option>
	    </c:forEach>
	</select><br/><br/>
	
	<div id="categoryModal" style="display:none; 
                              position:fixed; top:50%; left:50%; 
                              transform:translate(-50%, -50%);
                              background:#fff; border:1px solid #ccc; padding:20px;
                              z-index:1000;
                              width: 560px;
                              border-radius: 8px;
                              border: 2px solid #20b2aa;
                              box-shadow: 0 4px 10px rgba(0,0,0,0.3);">
                      
    <label> 카테고리 선택</label>
	<h6 class="h3-control" >
	카테고리는 서포터가 프로젝트를 더 잘 찾을 수도록 도와줘요.</h6>

    <select id="modalSelect" class="form-select form-select-sm mb-3" >
        <c:forEach var="cat" items="${lists}">
            <option value="${cat.categoryName}">${cat.categoryName}</option>
        </c:forEach>
    </select>
    <br/><br/><br/>
    <div style="display: flex; justify-content: flex-end; margin-top: 20px;">
    <button type="button" onclick="confirmCategory()" 
    class="btn btn-primary" >확인</button>&nbsp;&nbsp;
    <button type="button" onclick="closeModal()" 
    class="btn btn-light" >취소</button>
</div>
</div>
<div id="modalBg" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; 
                         background:rgba(0,0,0,0.3); z-index:999;" onclick="closeModal()"></div>
	
	
	
	<label class="form-label" style="border-bottom: 3px;">제목 </label>
	<h6 class="h3-control" >
	 많은 프로젝트 사이에서 이목을 끌 수 있는 표현,<br/>
	 리워드의 가장 중요한 특징으로 서포터님들의 호기심을 자극해 보세요. 
	</h6>

	<input type="text" name="subject" class="form-control" value="${project.subject }"
	style="width: 30%;"/><br/><br/>
	
	<label class="form-label" style="border-bottom: 3px;">시작날짜 </label>
	<h6 class="h3-control" >
    펀딩 시작날짜를 설정해 주세요.</h6>

	<input type="date" name="startDate" class="form-control" 
	style="width: 25%;" value="${project.startDate }"/><br/><br/>
	
	<label class="form-label" style="border-bottom: 3px;">종료날짜 </label>
	<h6 class="h3-control" >
    펀딩 종료날짜를 설정해 주세요.</h6>

	<input type="date" name="endDate" class="form-control" 
	style="width: 25%;" value="${project.endDate }"/><br/><br/>
	
	<label class="form-label" style="border-bottom: 3px;">목표금액 </label>
	<h6 class="h3-control" >
    목표금액은 원화 기준으로 설정해 주세요.</h6>
	<div style="display: flex; align-items: center; width: 25%;">
        <input type="text" name="goalAmount" class="form-control" style="flex:1;" 
           oninput="formatNumber(this);" value="${project.goalAmount} "/>
    <span style="margin-left:5px;">원</span><br/>

    </div>
    </div>
	<br/><br/><br/>
	
	
	<h2 style="color: #20b2aa; padding-bottom: 8px;">&nbsp;&nbsp;&nbsp;&nbsp;스토리 작성</h2>
	
	
	<div class="form-border">
	<label class="form-label" style="border-bottom: 3px;">제품 소개</label>
	<h6 class="h3-control" >
	기존 제품 ・ 서비스 ・ 콘텐츠를 개선했다면 어떤 점이 달라졌는지 작성해 주세요.</h6>
    <textarea name="content" rows="3" cols="50" class="form-control"
     style="width: 40%;">${project.content }</textarea><br/><br/>
	
	<label class="form-label"  style="border-bottom: 3px;">제목 이미지</label>
	<h6 class="h3-control" >
	포털 검색 결과, SNS 타겟 광고 등에 노출할 대표 이미지를 등록해 주세요.
	</h6>
	<div id="existing_main_images">
	<div id="main_files">
	<c:forEach var="img" items="${mainImages}">	
	<div class="image-item" data-numpro="${img.numPro }" data-savename="${img.saveName }"
	style="display: flex; align-items: center; gap: 5px; margin-bottom: 5px;">
	<input type="text" name="mainImages" multiple class="form-control" 
	style="width: 30%;" value="${img.originalName }"/>
	<button type="button" class="delete-Mainimage btn btn-sm btn-outline-danger">삭제</button>
	</div>
	</c:forEach>
	</div>
	</div>
	<br/>
	<input type="button"  value="메인이미지 추가"	
	onclick="addMainFile()" class="form-control" style="width: 20%;"/><br/><br/>
	
	
	<label class="form-label"  style="border-bottom: 3px;">내용 이미지</label>
	<h6 class="h3-control" >
	소개 영상·사진은 프로젝트 상세페이지 최상단에 노출되는 중요한 영역이에요.
	</h6>
	<div id="existing_content_images">
	<div id="content_files">
	<c:forEach var="img" items="${contentImages }">	
	<div class="image-item" data-numpro="${img.numPro }" data-savename="${img.saveName }"
	style="display: flex; align-items: center; gap: 5px; margin-bottom: 5px;">
	<input type="text" name="contentImages" multiple class="form-control" 
	style="width: 30%;" value="${img.originalName }"/>
	<button type="button" class="delete-Contentimage btn btn-sm btn-outline-danger">삭제</button>
	</div>
	</c:forEach>
	</div>
	</div>
	<br/>
	<input type="button"  value="내용이미지 추가"	
	onclick="addContentFile()" class="form-control"
	style="width: 20%;"/><br/><br/>
	</div>
	<br/><br/><br/>
	
	
<!-- 	<h2 style="color: #20b2aa; padding-bottom: 8px;"> -->
<!-- 	&nbsp;&nbsp;&nbsp;&nbsp;사업자 등록</h2> -->
	
<!-- 	<div class="form-border" id="bizForm"> -->
<!-- 	<label class="form-label" style="border-bottom: 3px;">사업자등록번호</label> -->
<%--     <input type="text" id="bNum" name="bNum" placeholder="예: 1234567890" value="${bizCheck.BNum }" --%>
<!--     class="form-control" style="width: 30%;" maxlength="10"><br> -->
    
<!--     <label class="form-label" style="border-bottom: 3px;">대표자명</label> -->
<%--     <input type="text" id="pName" name="pName" placeholder="대표자 성명" value="${bizCheck.PName }" --%>
<!--     class="form-control"  style="width: 30%;"><br> -->
    
<!--     <label class="form-label" style="border-bottom: 3px;">개업일</label> -->
<%--     <input type="text" id="bizStartDate" name="bizStartDate" placeholder="YYYYMMDD" value="${bizCheck.bizStartDate }" --%>
<!--      class="form-control"  style="width: 30%;" maxlength="8"> -->
    
<%--     <div id="result">${result}</div><br/><br/> --%>
    
<!-- 	<button type="button" id="checkBtn"  -->
<!-- 	class="form-control"style="width: 15%;">조회하기</button> -->
<!-- 	</div> -->
<!-- 	<br/><br/><br/> -->


<script type="text/javascript">
// $(document).ready(function() {
//     $("#checkBtn").click(function() {
//     	//alert("button click");

//         //alert("bNum:" + $("#bNum").val());
//        // alert("pName:" + $("#pName").val());
//         //alert("bizStartDate:" + $("#bizStartDate").val());
    	
//     	var data = JSON.stringify({
//     		b_no: $("#bNum").val(),
//     		p_nm: $("#pName").val(),
//     		start_dt: $("#bizStartDate").val()
//     	});
//     	//alert("보낼데이터:" + data);
//         $.ajax({
//             url:"${pageContext.request.contextPath}/bizCheckAjax.action",	            
//             type: "POST",
//             dataType: "json",
//             data: data,
//             contentType: "application/json; charset=utf-8",
//             success: function(res) {
            	
//             	var status = res.data[0].b_stt; //계속사업자 = b_stt
//                 $("#result").html(status + "입니다");
//             },
//             error: function(err) {
//             	alert("API 에러:" + err);
//                 alert("조회 중 오류가 발생했습니다.");
//             }
//         });
//     });
// });

</script>

	<h2 style="color: #20b2aa; padding-bottom: 8px;">
	&nbsp;&nbsp;&nbsp;&nbsp;리워드 정보</h2>
	
	<c:forEach var="reward" items="${rewards}" varStatus="status">
	<div class="form-border">
    <label class="form-label" style="border-bottom: 3px;">리워드 제품</label>
	<input type="hidden" name="rewardIds" value="${reward.rewardId}" />
	<h6 class="h3-control" >
	제품명을 입력해주세요.
	</h6>
    <input type="text" name="rewardSubject" class="form-control" value="${reward.rewardSubject }"
    style="width: 30%;"/><br/>
    
        <label class="form-label" style="border-bottom: 3px;">제품 소개</label>
	<h6 class="h3-control" >
	준비하고 계신 리워드의 특별한 점을 작성해 주세요.
	</h6>    
    <textarea name="rewardContent" rows="3" cols="50" class="form-control" style="width: 40%;" >${reward.rewardContent}</textarea><br/>
    
    <label class="form-label" style="border-bottom: 3px;">리워드 가격</label>
	<h6 style="color:#b7b7b7; border-bottom: 3px;" >
	리워드 금액은 원화 기준으로 설정해 주세요.</h6>
    <div style="display: flex; align-items: center; width: 25%;">
        <input type="text" name="amount" class="form-control" value="${reward.amount}"
        style="flex:1;" oninput="formatNumber(this);" />
    <span style="margin-left:5px;">원</span><br/><br/>
    </div>    
	</div>
	</c:forEach>
	
	<div id="reward_container">

	</div>
	
	<div>
	<input type="button" class="btn-custom" value="리워드 추가" style="width: 15%;"
	onclick="addRewardForm()"  />
	</div><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
	
		<!-- Footer Fixed Buttons -->
		<div id="fixedFooter" style="
		    position: fixed;
		    bottom: 0;
		    left: 0;
		    width: 100%;
		    background-color: #ffffff;
		    box-shadow: 0 -2px 10px rgba(0,0,0,0.1);
		    padding: 10px 0;
		    display: flex;
		    justify-content: center;
		    gap: 20px;
		    z-index: 999;
		">
	   <input type="submit" class="btn-custom" value="프로젝트 등록"
	        style="
	            background-color: #20b2aa;
	            color: white;
	            border: none;
	            border-radius: 8px;
	            padding: 10px 25px;
	            font-size: 16px;
	            font-weight: bold;
	            cursor: pointer;
	        "/>
   
	    <button type="button" class="btn-custom" onclick="location.href='<%=cp%>/'"
	        style="
	            background-color: #f1f1f1;
	            color: #20b2aa;
	            border: 1px solid #20b2aa;
	            border-radius: 8px;
	            padding: 10px 25px;
	            font-size: 16px;
	            font-weight: bold;
	            cursor: pointer;
	        ">
	        메인화면으로 돌아가기
    </button>
</div>
	
</form>


</div>

<script type="text/javascript">

//제목이미지 delete
$(document).on("click",".delete-Mainimage",function(){
	
	const parentDiv = $(this).closest(".image-item");
	
	const numPro = parentDiv.data("numpro");
	const saveName = parentDiv.data("savename");
	
	if(!confirm("정말 삭제하시겠습니까?")) return;
	
	$.ajax({
		url: '<%=cp%>/deleteMainImage.action',
		type: 'POST',
		data:{
			numPro: parseInt(numPro),
			saveName: saveName
		},
		
		success: function(res){
			if(res=="success"){
				parentDiv.remove();
			}else{
				alert("삭제 실패: " + res.message);
			}
		},
		error: function(err){
			alert("서버오류");
			console.log(err);
		}
		
	});

});

//내용이미지 delete
$(document).on("click",".delete-Contentimage",function(){
	
	const parentDiv = $(this).closest(".image-item");
	
	const numPro = parentDiv.data("numpro");
	const saveName = parentDiv.data("savename");
	
	if(!confirm("정말 삭제하시겠습니까?")) return;
	
	$.ajax({
		url: '<%=cp%>/deleteContentImage.action',
		type: 'POST',
		data:{
			numPro: parseInt(numPro),
			saveName: saveName
		},
		success: function(res){
			alert(res);
			if(res=="success"){
				parentDiv.remove();
			}else{
				alert("삭제 실패: ");
			}
		},
		error: function(err){
			alert("서버오류");
			
		}
		
	});

});



var rewardCount =1;

function addRewardForm(){
	rewardCount++;
	var html = `

	<div class="form-border">
	
    <label class="form-label" style="border-bottom: 3px;">리워드 제품</label>
	<h6 class="h3-control" >
	제품명을 입력해주세요.
	</h6>
    <input type="text" name="rewardSubject" class="form-control"
    style="width: 30%;"/><br/>
    
        <label class="form-label" style="border-bottom: 3px;">제품 소개</label>
	<h6 class="h3-control" >
	준비하고 계신 리워드의 특별한 점을 작성해 주세요.
	</h6>    
    <textarea name="rewardContent" rows="3" cols="50" class="form-control" style="width: 40%;"></textarea><br/>
    
    <label class="form-label" style="border-bottom: 3px;">리워드 가격</label>
	<h6 style="color:#b7b7b7; border-bottom: 3px;" >
	리워드 금액은 원화 기준으로 설정해 주세요.</h6>
    <div style="display: flex; align-items: center; width: 25%;">
        <input type="text" name="amount" class="form-control" style="flex:1;" oninput="formatNumber(this);" />
    <span style="margin-left:5px;">원</span><br/><br/>
    </div>
    
	</div>
	`;
	
	$("#reward_container ").append(html);
	
}


//가격에 #,000원
function formatNumber(input){
	var num = input.value.replace(/[^0-9]/g,'');
	if(num==="") return;
	input.value = Number(num).toLocaleString();
	
}

	//카테고리폼 띄우기
	const categorySelect = document.getElementById('categorySelect');
	const modal = document.getElementById('categoryModal');
	const modalBg = document.getElementById('modalBg');
	const modalSelect = document.getElementById('modalSelect');

	// select 클릭 시 모달 표시
	categorySelect.addEventListener('mousedown', function(e) {
	    e.preventDefault(); // 기존 드롭다운 열림 방지
	    modal.style.display = 'block';
	    modalBg.style.display = 'block';
	});

	// 확인 버튼 클릭 시 select 값 업데이트
	function confirmCategory() {
	    categorySelect.value = modalSelect.value;
	    closeModal();
	}

	// 모달 닫기
	function closeModal() {
	    modal.style.display = 'none';
	    modalBg.style.display = 'none';
	}
	
	
	var contentCnt = 1;
	function addContentFile(){
		$("#content_files").append("<input type='file' name='newContentImages' class='form-control' style='width: 30%;'/><br/>");
		contentCnt++;
	}
	
	var mainCnt = 1;
	function addMainFile(){
		$("#main_files").append("<input type='file' name='newMainImages' class='form-control' style='width: 30%;'/><br/>");
		mainCnt++;
	}

	
	function sendIt(){
	
	f = document.myForm;
	
	str = f.categoryName.value.trim();
	if(!str){
		alert("카테고리를 선택하세요.");
		f.categoryName.focus();
		return false;
	}
	f.categoryName.value = str;
	
	str = f.subject.value.trim();
	if(!str){
		alert("제목을 입력하세요.");
		f.subject.focus();
		return false;
	}
	f.subject.value = str;   

    // 날짜 체크
    if (!f.startDate.value) {
        alert("시작 날짜를 선택하세요.");
        f.startDate.focus();
        return false;
    }
    if (!f.endDate.value) {
        alert("종료 날짜를 선택하세요.");
        f.endDate.focus();
        return false;
    }
    
    // 목표 금액 체크
    var goalAmount = f.goalAmount.value.trim();
    var numericGoal = goalAmount.replace(/,/g,''); //,제거하기
    if (!goalAmount || isNaN(numericGoal) || parseInt(numericGoal) <= 0) {
        alert("펀딩 목표 금액을 올바르게 입력하세요.");        
        return false;
    }
    
    //제품 소개
	str = f.content.value.trim();
	if(!str){
		alert("내용을 입력하세요.");
		f.content.focus();
		return false;
	}
	f.content.value = str;

	//메인이미지 input마다 체크 가능하게
	var mainFiles = document.getElementsByName("mainImages");
	var hasFile = false;

	for (var i = 0; i < mainFiles.length; i++) {
	    if (mainFiles[i].value.trim() !== "") {
	        hasFile = true;
	        break;
	    }
	}

	if (!hasFile) {
	    alert("메인 이미지를 업로드하세요.");
	    mainFiles[0].focus();
	    return false;
	}
	
    //사업자 번호
//     var bNum = f.bNum.value.trim();
//     if (!f.bNum.value){
//         alert("사업자 등록번호를 입력하세요.");
//         f.bNum.focus();
//         return false;
//     }  
//     //사업자 이름
//     var pName = f.pName.value.trim();
//     if (!pName) {
//         alert("사업자 이름을 입력하세요.");
//         f.pName.focus();
//         return false;
//     }
//     //사업 개업일 조회
//     var bizStartDate = f.bizStartDate.value.trim();
//     if (!bizStartDate) {
//         alert("개업일을 입력하세요.");
//         f.bizStartDate.focus();
//         return false;
//     }
    
    var rewardSubjects = document.getElementsByName("rewardSubject");
    var rewardContents = document.getElementsByName("rewardContent");
    var amounts = document.getElementsByName("amount");
    
    // reward 내용 체크
    for(var i=0; i<rewardSubjects.length;i++){
    	if (!rewardSubjects[i].value.trim()) {
            alert("리워드 제품명을 입력하세요.");
            rewardSubjects[i].focus();
            return false;
        }
        
        // reward 내용 체크
        if (!rewardContents[i].value.trim()) {
            alert("리워드를 설명해주세요.");
            rewardContents[i].focus();
            return false;
        }
        
        // reward 수량 체크
        var numericAmount = amounts[i].value.replaceAll(/,/g,''); //,제거하기
        if (!numericAmount || isNaN(numericAmount) || parseInt(numericAmount) <= 0) {
            alert("리워드 가격을 올바르게 입력하세요.");
           amounts[i].focus();
            return false;
        }
        amounts[i].value = numericAmount;	
        
    }
    
    //금액 콤마제거 (데이터 내보낼때)
	numericGoal = goalAmount.replaceAll(/,/g,'');
	f.goalAmount.value = numericGoal;
  
	return true;
	
}


</script>


</body>
</html>