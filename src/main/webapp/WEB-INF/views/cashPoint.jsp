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
<title>카드 선택</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>



<style type="text/css">
body {
    font-family: Arial, sans-serif;
    background-color: #f5f5f5;
}

.card-container {
    display: flex;
    gap: 20px;
    flex-wrap: wrap;
}

.card {
    border: 3px solid #ccc;
    border-radius: 10px;
    padding: 20px;
    width: 380px;
    text-align: center;
    background-color: #fff;
    cursor: pointer;
    transition: all 0.2s ease;
    position: relative;
}

.card input[type="radio"] {
    display: none;
}

.card label {
    display: block;
    cursor: pointer;
}

.card.selected {
    border: 3px solid #20b2aa;
    box-shadow: 0 0 10px rgba(0,0,0,0.1);
}

.card .price {
    font-size: 20px;
    font-weight: bold;
    margin-bottom: 10px;
}

.card .bonus {
    color: #888;
    font-size: 14px;
}


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
/* Chrome, Safari, Edge */
input[type=number]::-webkit-outer-spin-button,
input[type=number]::-webkit-inner-spin-button {
    -webkit-appearance: none; /* 화살표 제거 */
    margin: 0;
}


</style>

</head>
<body>
<!-- ================= 헤더 / 내비게이션 ================= -->
<jsp:include page="/WEB-INF/views/include/mainheader.jsp" />

<div class="form-container">
<form name="myForm" action="<%=cp %>/updateCash_ok.action"
method="post" enctype="multipart/form-data"
onsubmit="return sendIt();">

	<br/>
	<h2 style="color: #20b2aa; padding-bottom: 8px; ">NOVA e Cash</h2>
	
	<div class="card-container">
    <div class="card">
        <input type="radio" id="option1" name="amount" value="10000">
        <label for="option1">
            <div class="price">10,000원</div>
            <div class="bonus">· 추가 e캐시 1,000원 제공(+10%)</div>
            
        </label>
    </div>

    <div class="card">
        <input type="radio" id="option2" name="amount" value="30000">
        <label for="option2">
            <div class="price">30,000원</div>
            <div class="bonus">· 추가 e캐시 3,000원 제공(+10%)</div>
        </label>
    </div>
	<br/>
    <div class="card">
        <input type="radio" id="option3" name="amount" value="50000">
        <label for="option3">
            <div class="price">50,000원</div>
            <div class="bonus">· 추가 e캐시 5,000원 제공(+10%)</div>
        </label>
    </div>

    <div class="card">
        <input type="radio" id="option4" name="amount" value="100000">
        <label for="option4">
            <div class="price">100,000원</div>
            <div class="bonus">· 추가 e캐시 10,000원 제공(+10%)</div>
        </label>
    </div>
    <br/>
	<div class="card">
        <input type="radio" id="option5" name="amountRadio" value="custom">

        <label for="option5">
            <div class="price">
            
            
            <input type="number" id="customAmount" placeholder="직접 입력" 
            style="width: 180px; text-align: right; ">

            <style>
			#customAmount:placeholder-shown{
				text-align: left;
			}
			#customAmount{
				text-align: right;
				padding: 6px 10px;
				border: 2px solid #ccc;
				border-radius: 6px;
				outline: none;
				transition: border-color 0.2s, box-shadow 0.2s;
			}
			#customAmount:focus{
				border-color: black;
				box-shadow: 0 0 5px rgba(32,178,170,0,5);
			}
			
			</style>
            원
            </div>
            <div class="bonus">· 추가 e캐시 10% 제공</div>
        </label>
	</div>
	<input type="hidden" name="amount" id="amount"/>
	<input type="hidden" name="numPro" id="numPro" value="${numPro }"/>
    
    
</div>
	
	
	
	<br/><br/><br/>
	
	<div>
	<input type="submit" value="충전하기" class="form-control"
	style="width: 15%;"/>
	</div>
	
	
	
	<br/><br/><br/><br/><br/>
	
</form>
</div>

<script type="text/javascript">
	//리워드가격에 #,000원
	function formatNumber(input){
		var num = input.value.replace(/[^0-9]/g,'');
		if(num==="") return;
		input.value = Number(num).toLocaleString();
		
	}

$(document).ready(function(){
		$(".card").click(function(){
		
			$(this).siblings().removeClass("selected");
			$(this).addClass("selected");
			$(this).find("input[type='radio']").prop("checked",true);
			
			var val = $(this).find("input[type='radio']").val();
			
			if (val=="custom") {
				
				$("#amount").val($("#customAmount").val());
				
			}else {
				$("#amount").val(val);
			}
			
		});
		
		
		// customAmount 입력 시 hidden 필드 업데이트
	    $("#customAmount").on("input", function(){
	        if($("#option5").prop("checked")) { // custom 카드 선택 시만
	            var num = $(this).val().replace(/[^0-9]/g,''); // 숫자만 허용
	            $(this).val(num); 
	            $("#amount").val(num);
	        }
	    });
		
	});
	
	
	function sendIt() {
		if ($("#amount").val()==="" || isNaN($("#amount").val())) {
			alert("충전할 금액을 선택하거나 입력해주세요");
			
			return false;
		}
		
		return true;
	}
	
</script>

</body>
</html>