<%@ page contentType="text/html; charset=UTF-8"%>
<%	
	String cp = request.getContextPath();
	request.setCharacterEncoding("UTF-8");

	int i = Integer.parseInt(request.getParameter("i"));
	String result="";
	
	
	int j = 1;
	while(j<=i){
		
		result+="<input type=\"file\" name=\"uploadFile\"><br/>";
		j++;
	}
	out.print(result);
	
	
%>




