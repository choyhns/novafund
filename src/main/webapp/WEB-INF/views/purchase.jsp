<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("utf-8");
	

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script type="text/javascript">


$(function() {
    $('#pointCharge').on('click', function() {
        location.href = '<%=cp%>/cashPoint.action/'+${numPro};
    });
});

</script>

<title>Insert title here</title>
<style type="text/css">

</style>
</head>

<body>
 

<!-- ================= 헤더 / 내비게이션 ================= -->
<jsp:include page="include/mainheader.jsp" />

<!-- Multi-step progress bar -->  
<div class="container" style="margin-top: 100px; margin-bottom: 75px">
  <div class="d-flex justify-content-between align-items-center">
    <div class="text-center flex-fill">
      <div class="rounded-circle border border-success text-dark mx-auto" style="width:40px; height:40px; line-height:40px;">1</div>
      <small>리워드 선택</small>
    </div>  
    <div class="flex-fill border-top border border-success" style="margin-top:20px;"></div>
    <div class="text-center flex-fill">
      <div class="rounded-circle border text-white mx-auto" style="width:40px; height:40px; line-height:40px; background-color: #20B2AA;">2</div>
      <small>결제</small>
    </div> 
    <div class="flex-fill border-top border border-dark" style="margin-top:20px;"></div>
    <div class="text-center flex-fill"> 
      <div class="rounded-circle border border-dark bg-light text-dark mx-auto" style="width:40px; height:40px; line-height:40px;">3</div>
      <small>결제 완료</small>
    </div>
  </div> 
</div>

<form action="<%=cp %>/complete.action/${numPro}" name="rewardForm" method="post">
<div class="container" align="center" style="max-width: 600px; margin: 0 auto;
      text-align: left; "> 
	<h3 class="mb-4">결제</h3>
		<div class="list-group">
				 
					<c:forEach var="lists" items="${rewardLists }" varStatus="status"> 
						<div class="list-group-item " > 
							<div class=" mt-4">
					
								<span class="fw-bold d-block " style="font-size: 10pt;">
								${lists.rewardSubject }
								</span>
				 			 	
								<span class="text-muted d-block mt-2" style="font-size: 8pt;">
								${lists.rewardContent }
								</span>
							
							</div>
							
							<div class="text-end">
								<span>
									수량 : ${lists.rewardQuantity } 개 &nbsp;&nbsp;&nbsp;&nbsp; ${lists.amount * lists.rewardQuantity } 원
								</span>
							</div>
							
						</div>
					</c:forEach>
					
					<div class="text-end mt-5">
						<span>
							추가 후원금 : ${addMoney } 원
						</span>
					</div>
					
					<div class="text-end mt-4 text-muted">
						<span>
							===================================================					
						</span>
					</div>
					
					
					
					<div class="text-end mt-5 fw-bold " >
						<span>
							총 결제 금액 : ${sum } 원
						</span>
					</div>
					
					
					<div class="text-end mt-5 fw-bold d-flex flex-column align-items-end" >
					<span style="color: #20B2AA">
							보유 포인트 : ${point } 원
					</span>
					
					<span class="mt-4" style="color: #20B2AA">
							--------------------------------------------------------------------------------------
					</span>
					
					<span class="mt-5" style="color: #20B2AA">
							잔여 포인트 : ${point - sum} 원
					</span>
					<span class="invalid-feedback" id="pointFeedback"  >보유 포인트가 부족합니다</span>
					</div>
					
					<div class="text-end mt-1" >
						<button type="button" class="btn btn-outline-light mt-4" id="pointCharge" style="background-color: #20B2AA" onclick="pointCharge();">포인트 충전</button>
					</div>
					
			
			</div>

<div class="list-group my-5">
<div class="list-group-item " > 
	<div class="mb-3"> 
		<button type="button" class="btn btn-outline-light" style="background-color: #20B2AA" onclick="searchAddress();">주소 찾기</button>
		 <button type="button" class="btn btn-outline-light" style="background-color:rgb(220,53,69) ;" onclick="cancelAddress();">입력 취소</button>
	</div>
	<div class="mb-3 d-flex align-items-center"> 
      <span>우편번호</span> 
        <input type="text" class="form-control ps-2 ms-2 w-25" id="userPostCode" name="userPostCode" readonly required>
    </div>
        
    
    <div class="mb-3 d-flex align-items-center" > 
       <span> 주 소</span> 
        <input class="form-control ps-2 w-75" type="text" style="margin-left: 35px;" id="userAddress" name="userAddress" readonly required>
    </div>
	
	<div class="mb-3 d-flex align-items-center"> 
      <span> 상세주소</span> 
        <input type="text" class="form-control ps-2 ms-2 w-75" id="detailAddress" name="detailAddress" maxlength="100" readonly required>
	</div>
</div>
</div>



			
	<div class="d-grid gap-2">
		<span class="invalid-feedback addressFeedback1  mt-5"  >주소를 입력해 주세요</span>
		<span class="invalid-feedback addressFeedback2  mt-5"  >상세 주소를 입력해 주세요</span>
		<span class="invalid-feedback pointFeedback2  mt-5"  >보유 포인트가 부족합니다.</span>
		<input type="hidden" name="sum" value="${sum }">
		<input type="hidden" name="address" value="">
		<input type="hidden" name="reward" value="${reward }">
  		<button id="submit"  class="btn btn-outline-light mb-5" type="submit" style="background-color: #20B2AA">결제 하기</button>
	</div>
</div>
</form>
	


	
 





<script>
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
    
    
    var $mailNum = $('#userPostCode');
    
    var $address = $('#userAddress');
	
	var $detailAddress = $('#detailAddress');
	
	var sum = ${sum};
	var point = ${point};
	
	
    
    $('#submit').on('click',function(event){
    	
    	
    	 var $feedback1 = $('.addressFeedback1');
    	 
    	 var $feedback2 = $('.addressFeedback2');
    	 
    	 var $pointFeedback2 = $('.pointFeedback2');
    	
    	if(!$address.val()){
    		
    		$pointFeedback2.hide();
    		
    		event.preventDefault();
    		
    		 $feedback1.show(); // feedback 보이게
    		
    	} else if(!$detailAddress.val()){
    		
    		$pointFeedback2.hide();
    		
    			$feedback1.hide(); // 주소가 있으면 feedback 숨기기
    		 
    		 event.preventDefault();
	    		
    		 $feedback2.show();
    	    		
    	    	} else {
    	    		
    	    		if (sum > point) {
    	    			
    	    			$feedback2.hide();
    	    			$pointFeedback2.show();
    	    			event.preventDefault();
    	    			
					}else{
						
						$feedback1.hide();
		    	    	$feedback2.hide(); // 주소가 있으면 feedback 숨기기
		    	    	$pointFeedback2.hide();
		    	    	
		    	    	$('input[name="address"]').val(
		    	    			
		    	    		$mailNum.val().trim() + "|" + $address.val().trim() + "|" + $detailAddress.val().trim()
		    	    			
		    	    	);
		    	    	
		    	    	
		    	    	document.rewardForm.submit();
						
					}
    		 
		}
    	
		
    	
    });
     
    
    $(function () {
		
    	if (${address != null}) {
			
    		$mailNum.val('${mailNum}');

    		$address.val('${address}');
    		
    		$detailAddress.val('${detailAddress}');
		}
    	
    	
    	
    	var $pointFeedback = $('#pointFeedback');
    	
    	var $pointCharge = $('#pointCharge');
    	
    	if (sum > point) {
			
    		$pointCharge.show(); 
    		$pointFeedback.show();
    		
    		
		}else {
			
			
			$pointCharge.hide();
			$pointFeedback.hide();
			
			
		}
    	
	});
    
   
    
    
</script>







</body>
</html>