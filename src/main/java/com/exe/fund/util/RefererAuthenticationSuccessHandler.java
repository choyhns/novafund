package com.exe.fund.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.WebAttributes;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

public class RefererAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler{
	
	 private final RequestCache requestCache = new HttpSessionRequestCache();
	
	 @Override
	    protected String determineTargetUrl(HttpServletRequest request, HttpServletResponse response) {
		 SavedRequest savedRequest = (SavedRequest) requestCache.getRequest(request,response);
	        if (savedRequest != null) {
	            return savedRequest.getRedirectUrl();
	        }
		 
	     String prevPage = (String) request.getSession().getAttribute("prevPage");
	        if (prevPage != null) {
	            request.getSession().removeAttribute("prevPage"); // 사용 후 삭제
	            return prevPage;
	        }
		 
		 String referer = request.getHeader("Referer");

	        if (referer != null && !referer.contains("/login.action")) {
	            return referer;
	        }

	        return getDefaultTargetUrl(); // 기본값 ("/")
	    }

	    @Override
	    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
	                                        Authentication authentication) throws java.io.IOException, javax.servlet.ServletException {
	        super.onAuthenticationSuccess(request, response, authentication);
	    }

}
