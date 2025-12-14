<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<title>Insert title here</title>

<style type="text/css">

 /* 체크박스 선택되었을 때 */
  .form-check-input.custom-check:checked {
    background-color: #20B2AA; /* 원하는 색 */
    border-color: #20B2AA;     /* 테두리도 맞춤 */
  }
  
  
  /* Chrome, Safari, Edge, Opera */
#addMoney::-webkit-outer-spin-button,
#addMoney::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}

/* Firefox */
#addMoney {
    -moz-appearance: textfield;
}

</style>
</head>
<body>


<!-- ================= 헤더 / 내비게이션 ================= -->
<jsp:include page="include/mainheader.jsp" />

<!-- Multi-step progress bar -->  
<div class="container" style="margin-top: 100px; margin-bottom: 75px">
  <div class="d-flex justify-content-between align-items-center">
    <div class="text-center flex-fill">
      <div class="rounded-circle border text-white mx-auto" style="width:40px; height:40px; line-height:40px; background-color: #20B2AA">1</div>
      <small>리워드 선택</small>
    </div>
    <div class="flex-fill border-top border border-dark " style="margin-top:20px;"></div>
    <div class="text-center flex-fill">
      <div class="rounded-circle border border-dark bg-light text-dark mx-auto" style="width:40px; height:40px; line-height:40px; background-color: #20B2AA;">2</div>
      <small>결제</small>
    </div>
    <div class="flex-fill border-top border border-dark" style="margin-top:20px;"></div>
    <div class="text-center flex-fill"> 
      <div class="rounded-circle border border-dark bg-light text-dark mx-auto" style="width:40px; height:40px; line-height:40px;">3</div>
      <small>결제 완료</small>
    </div>
  </div>
</div>


<div class="container" align="center" style="max-width: 600px; margin: 0 auto;
      text-align: left; "> 
	<h3 class="mb-4">리워드 선택</h3>
		<div class="list-group">
			<form action="<%=cp %>/purchase.action/${numPro}" id="rewardForm" method="post">
				<c:forEach var="lists" items="${rewardLists }" varStatus="status">
				<div class="list-group-item " >
					<div class="form-check d-flex align-items-center mt-4">
					
					<input class="form-check-input custom-check border border-secondary"  
						style="width: 22px; height: 22px;" name="rewardSelected"
						type="checkbox" value="${status.index}" id="check${status.index }"/> 
						
						<label class="form-check-label fw-bold d-block" for="check${status.index }" style="font-size: 20px;
						 margin-left: 15px;">
  							${lists.amount } 원
						</label>
						
					</div>
						
					
						<label class="form-check-label d-block fs-3 mt-3 mb-4" for="check${status.index }" >
							${lists.rewardSubject }
						</label>
						
						<label class="form-check-label d-block fs-6 mt-3 text-muted  mb-5" for="check${status.index }" >
							${lists.rewardContent }
						</label>
						
						
						
						<div class="quantity-container mt-2 align-items-center " id="quantity${status.index}" style="display: none;">
     						<label class="form-label me-2 mb-0"  style="display: inline-block; margin-right: 8px;">수량 :</label>
      						<input type="hidden"  value="${lists.rewardContent }" id="content${status.index }"/>
      						<input type="hidden" value="${lists.rewardSubject }" id="subject${status.index }"/>
      						<input type="hidden" value="${lists.amount }" id="amount${status.index }"/>
      						<input type="hidden" value="${lists.rewardId }" id="rewardId${status.index }"/>
      						<input type="number"  class="form-control" id="quantityInput${status.index}" min="1" value="1" style="display: inline-block; width: 100px;">
    					</div>
						
						</div>  
						
				</c:forEach>
				<div class="mt-5 " >
				<b>추가 후원 금액 (선택)</b>
				<div class="d-flex align-items-center">
				 <input class="mt-2 form-control" style="width: 30%;" id="addMoney" name="addMoney" type="number" min="0" value="0"/>
				 <span class="ms-2">원</span>
				</div>
				</div>
			 </form> 
		</div>  


	<div class="d-grid gap-2">
		<span class="invalid-feedback mt-5" id="feedback" style="display: none;">하나 이상의 리워드를 선택하세요</span>
  		<button id="submit"  class="btn btn-outline-light my-5" type="button" style="background-color: #20B2AA">결제 하기</button> 
	</div>


	</div> 


<script type="text/javascript">

var submitBtn = document.getElementById('submit');
var feedback = document.getElementById('feedback');

submitBtn.addEventListener('click',()=>{
	
	var checkboxes = document.querySelectorAll('#rewardForm input[type="checkbox"]');
	
	var anyChecked = Array.from(checkboxes).some(cb=>cb.checked);
	
	document.querySelectorAll('.quantity-container').forEach(div=>{
		
		var index = div.id.replace('quantity','');
		var checkbox = document.getElementById('check'+index);
		var quantityInput = document.getElementById('quantityInput'+index);
		var content = document.getElementById('content'+index);
		var subject = document.getElementById('subject'+index);
		var amount = document.getElementById('amount'+index);
		var rewardId = document.getElementById('rewardId'+index);
		
		if (checkbox.checked) {
			quantityInput.name = "rewardQuantity"+index;
			content.name="rewardContent"+index;
			subject.name="rewardSubject"+index;
			amount.name="amount"+index;
			rewardId.name="rewardId"+index;
		}else{
			quantityInput.removeAttribute("name");
			content.removeAttribute("name");
			subject.removeAttribute("name");
			amount.removeAttribute("name");
			rewardId.removeAttribute("name");
		}
		
	});
	
	if (!anyChecked) {
		
		feedback.style.display='block';
		submitBtn.classList.remove('my-5');
		submitBtn.classList.add('mb-5');
	}else{
		
		 feedback.style.display = 'none';
		 
		 submitBtn.classList.remove('mb-5');
		submitBtn.classList.add('my-5');
		 
		 document.getElementById('rewardForm').submit(); 
		
	}
	
	
	
});

document.querySelectorAll('input[type="checkbox"]').forEach(cb => {
	  
	cb.addEventListener('change', () => {
	    
		
	    var index = cb.id.replace('check','');
	    var quantityDiv = document.getElementById('quantity' + index);
	    
	    var input = quantityDiv.querySelector('input');
	    
	    if(cb.checked){
	      quantityDiv.style.display = 'block';
	      
	    } else {  
	      quantityDiv.style.display = 'none';
	      input.value= 1;
	    } 
	  });
	});
	

document.querySelectorAll('.quantity-container input[type="number"]').forEach(input => {
    input.addEventListener('input', () => {
        if(input.value < 1) input.value = 1;
    });
});

$(function () {
	
	var rewardIndex = "${rewardIndex}";
	
	if (rewardIndex) {
		var $checkBox = $("#check"+rewardIndex);
		
		if ($checkBox.length) {
			$checkBox.prop("checked",true);
			
			  // 체크박스 체크되었을 때 수량 div 보이도록
            var index = rewardIndex;
            $("#quantity" + index).show(); // jQuery 사용
		}
		
	}
	
	$("#addMoney").click(function () {
		
		$(this).val("");
	});
	
	$("#addMoney").on("blur",function(){
		
		if ($(this).val() == "") {
			
			$(this).val(0);	
		}
		
	});
	
});




</script>

</body>
</html>