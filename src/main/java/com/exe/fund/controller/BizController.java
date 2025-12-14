package com.exe.fund.controller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import com.exe.fund.dao.BizCheckDAO;
import com.exe.fund.dao.CategoryListDAO;
import com.exe.fund.dto.BizCheckDTO;
import com.exe.fund.dto.CategoryListDTO;
import com.exe.fund.dto.MemberDTO;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.Scanner;

import javax.servlet.http.HttpSession;


@Controller
public class BizController {

    @Autowired
    private BizCheckDAO dao;
    
    @Autowired
	@Qualifier("categoryListDAO")
	CategoryListDAO categoryListDAO;
    

    private final String serviceKey = "SfcEgFTq5ngZbwZ1kxRkQC9CRL%2BEOHzeZmowfx3QigdswvicmFpPftBH82VRW4tIGzoL3NVf%2BrT%2B3Chz%2BXpI7A%3D%3D";
    
    

    // 사업자등록 진위여부 확인 (AJAX용)

    @RequestMapping(value="/bizCheckAjax.action", method=RequestMethod.POST,
            consumes = "application/json",
            produces = "application/json; charset=UTF-8")
    @ResponseBody
    public String checkBiz(@RequestBody BizCheckDTO bdto,
    		HttpSession session,
    		Authentication auth) {
        System.out.println("aa1");
 
        
        try {
        	 String userId = auth.getName();
        	   
             bdto.setUserId(userId != null ? userId : "userId");  // 테스트용 기본값
            
             
             
          // API에서 요구하는 JSON 형식 (b_no는 배열!)
             String jsonInputString = "{"
            		  + "\"b_no\": [\"" + bdto.getBNum() + "\"],"
                      + "\"start_dt\": \"" + bdto.getBizStartDate() + "\","
                      + "\"p_nm\": \"" + bdto.getPName() + "\""
                      + "}";
            System.out.println("aa2 JSON: " + jsonInputString);

            URL url = new URL("https://api.odcloud.kr/api/nts-businessman/v1/status?serviceKey=" 
                                + serviceKey + "&returnType=json");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8"); // utf-8 명시
            conn.setRequestProperty("Accept", "application/json"); //api가 헤더를 요구함 
            conn.setDoOutput(true);

            // Body 전송
            OutputStream os = null;
            try {
                os = conn.getOutputStream();
                os.write(jsonInputString.getBytes("UTF-8"));
            } finally {
                if (os != null) os.close();
            }
            
           
            int responseCode = conn.getResponseCode();
            System.out.println("HTTP Response Code: " + responseCode);
            System.out.println("aa3");

            Scanner scanner;
            if (responseCode == 200) {
                scanner = new Scanner(conn.getInputStream(), "UTF-8");
            } else {
                scanner = new Scanner(conn.getErrorStream(), "UTF-8"); // 400 에러도 읽기
            }

            String responseBody = scanner.useDelimiter("\\A").hasNext() ? scanner.next() : "";
            scanner.close();
            
            System.out.println("aa4 Response: " + responseBody);
            
            
            //status = 계속사업자 (api에서 b_stt값을 추출)
            String status = "";
            int idx = responseBody.indexOf("\"b_stt\":\"");
            if(idx != -1) {
            	int start = idx + "\"b_stt\":\"".length(); //== idx + 8
            	int end = responseBody.indexOf("\"",start);
            	if(end !=-1) {
            		status = responseBody.substring(start,end);
            	}
            }
            
            //dto에 계속사업자 담아두기
            bdto.setResult(status);
            
            //session에 저장
            session.setAttribute("bizStatus", status);
            
            //db저장은 projectController에서 할 예정
            //dao.insertBizNum(dto);

            

            
            return "{\"data\":[{\"b_stt\":\"" + status + "\"}]}";

        } catch (Exception e) {
            e.printStackTrace();
            return "{\"error\":\"API 호출 실패\"}";
        }
    }

}