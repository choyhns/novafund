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

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script type="text/javascript">
	var contentCnt = 1;
	function addContentFile(){
		$("#content_files").append("<br/><input type='file' name='contentImages'>");
		contentCnt++;
	}
</script>
<script type="text/javascript">
	function sendIt(){
	
	f = document.myForm;
	
	
	str = f.category.value;
	str = str.trim();
	if(!str){
		alert("카테고리를 선택하세요.");
		f.category.focus();
		return;
	}
	f.category.value = str;
	
	str = f.subject.value;
	str = str.trim();
	if(!str){
		alert("제목을 입력하세요.");
		f.subject.focus();
		return;
	}
	f.subject.value = str;
	
	str = f.content.value;
	str = str.trim();
	if(!str){
		alert("내용을 입력하세요.");
		f.content.focus();
		return;
	}
	f.content.value = str;

    // 목표 금액 체크
    var goalAmount = f.goalAmount.value.trim();
    if (!goalAmount || isNaN(goalAmount) || parseInt(goalAmount) <= 0) {
        alert("펀딩 목표 금액을 올바르게 입력하세요.");
        f.goalAmount.focus();
        return;
    }

    // 날짜 체크
    if (!f.startDate.value) {
        alert("시작 날짜를 선택하세요.");
        f.startDate.focus();
        return;
    }
    if (!f.endDate.value) {
        alert("종료 날짜를 선택하세요.");
        f.endDate.focus();
        return;
    }

    // 메인 이미지 체크
    if (!f.mainImage.value) {
        alert("메인 이미지를 업로드하세요.");
        f.mainImage.focus();
        return;
    }

    // reward 제목 체크
    var rewardSubject = f.rewardSubject.value.trim();
    if (!rewardSubject) {
        alert("리워드 제목을 입력하세요.");
        f.rewardSubject.focus();
        return;
    }

    // reward 수량 체크
    var amount = f.amount.value.trim();
    if (!amount || isNaN(amount) || parseInt(amount) <= 0) {
        alert("리워드 수량을 올바르게 입력하세요.");
        f.amount.focus();
        return;
    }

    // reward 내용 체크
    var rewardContent = f.rewardContent.value.trim();
    if (!rewardContent) {
        alert("리워드 내용을 입력하세요.");
        f.rewardContent.focus();
        return;
    }

	
	f.submit();
	
}


</script>
</head>
<body>
<h2>프로젝트 등록</h2>
<form name="myForm" action="<%=cp %>/created_ok.action"
method="post" enctype="multipart/form-data">

<label>카테고리</label>
<select name="categoryName">
	<option value="" selected>선택</option>
	
    <c:forEach var="cat" items="${lists}">
        <option value="${cat.categoryName}">${cat.categoryName}</option>
    </c:forEach>
</select><br/><br/>
	
	<label>제목: </label>
	<input type="text" name="subject"/><br/><br/>
	
	<label>내용: </label>
	<input type="text" name="content"/><br/><br/>
	
	<label>시작날짜: </label>
	<input type="date" name="startDate"/><br/><br/>
	
	<label>종료날짜: </label>
	<input type="date" name="endDate"/><br/><br/>
	
	<label>목표금액: </label>
	<input type="number" name="goalAmount"/><br/><br/>
	
    <h3>리워드</h3>
    <label>제목:</label>
    <input type="text" name="rewardSubject" required><br/>
    <label>수량:</label>
    <input type="number" name="amount" required><br/>
    <label>내용:</label>
    <textarea name="rewardContent" rows="3" cols="50"></textarea><br/><br/>
	
	<h3>메인 이미지</h3>
	<input type="file" name="mainImage"><br/><br/>
	
	
	<h3>내용 이미지</h3>
	<div id="content_files">
	<input type="file" name="contentImages"><br/><br/>
	</div>
	
	<input type="button"  value="이미지 추가"	onclick="addContentFile()"><br/><br/>
	
	<input type="submit" value="프로젝트 등록">


</form>
</body>
</html>