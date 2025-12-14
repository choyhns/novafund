package com.exe.fund.util;

import org.springframework.stereotype.Component;

@Component
public class MyUtil { //페이징 처리
	
	//전체페이지 갯수
	public int getPageCount(int numPerPage,int dataCount) {//페이지당 데이터갯수,전체 데이터 갯수
		
		int pageCount = 0;
		pageCount = dataCount / numPerPage;
		
		if (dataCount % numPerPage !=0) {
			pageCount++;
		}
		
		return pageCount;
		
	}
	
	
	//페이징 처리 메소드
	public String pageIndexList(int currentPage,int totalPage,String listUrl) {//현재페이지,전체페이지갯수
		
		int numPerBlock = 3; // ◀이전 6 7 8 9 10 다음▶
		int currentPageSetup; //◀이전 
		int page;
		
		int firstPage = 1;
		int lastPage = totalPage;
		
		
		StringBuffer sb = new StringBuffer();
		
		if (currentPage == 0 || totalPage == 0) {
			return "";
		}
		
		//list.jsp
		//list.jsp?searchKey=name&searchValue=suzi
		
		if (listUrl.indexOf("?")!=-1) {//?가 있다면, 검색을 했다면
			
			listUrl = listUrl + "&";
			
		}else {
			listUrl = listUrl + "?";
		}
		
		//◀이전의 pageNum 구하는 공식
		currentPageSetup = (currentPage/numPerBlock)*numPerBlock;
		
		if (currentPage % numPerBlock == 0) {
			
			currentPageSetup = currentPageSetup - numPerBlock;
			
		}
		
		//◀이전의 링크
		
		if (totalPage>numPerBlock && currentPageSetup >0) {
			sb.append("<a href=\"" + listUrl + "pageNum=" + firstPage + "\">◀◀</a>&nbsp;&nbsp;"
					+ "<a href=\""+listUrl + "pageNum=" + currentPageSetup + "\">◀이전</a>&nbsp;"); 
			// <a href = "list.jsp?pageNum=5">◀이전</a>&nbsp;
		}
		
		//바로가기 페이지
		page = currentPageSetup +1;
		
		while (page<=totalPage && page <= (currentPageSetup + numPerBlock)) {
			
			if (page == currentPage) {
				
				sb.append("<font color=\"Fuchsia\">" + page + "</font>&nbsp;");
				//<font color = "Fuchsia">9</font>&nbsp;
				
			}else {
				
				sb.append("<a href=\"" + listUrl + "pageNum=" + page + "\">" + page + "</a>&nbsp;");
				//<a href = "list.jsp?pageNum=7">7</a>&nbsp;
				
			}
			
			page++;
			
		}
		
		
		//다음▶
		if (totalPage - currentPageSetup > numPerBlock) {
			
			sb.append("<a href=\"" + listUrl + "pageNum=" + page + "\">다음▶</a>&nbsp;&nbsp;"
					+"<a href=\"" + listUrl + "pageNum=" + lastPage + "\">▶▶</a>&nbsp;");
			//<a href = "list.jsp?pageNum=11">다음▶</a>&nbsp;
			
		}
		
		return sb.toString();
		
		
	}
	
	

}
