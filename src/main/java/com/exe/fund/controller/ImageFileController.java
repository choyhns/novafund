package com.exe.fund.controller;

import java.io.File;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.MultipartRequest;
import org.springframework.web.servlet.ModelAndView;

import com.exe.fund.dao.CategoryListDAO;
import com.exe.fund.dao.ImageFileDAO;
import com.exe.fund.dto.CategoryListDTO;
import com.exe.fund.dto.ContentImageDTO;

@Controller
public class ImageFileController {

	private static final String Image_Repo_Path=
			"C:\\sts-bundle\\work\\SpringProjectFund\\src\\main\\webapp\\resources\\image";
	
	@Autowired
	private ImageFileDAO imageFileDAO;
	
	@Autowired
	@Qualifier("categoryListDAO")
	CategoryListDAO categoryListDAO;
    

	
	@RequestMapping(value = "/upload.action", method=RequestMethod.POST)
	public ModelAndView upload(
			MultipartHttpServletRequest multipartRequest,
			HttpServletResponse response) throws Exception{
		
		multipartRequest.setCharacterEncoding("utf-8");
		Map map = new HashMap();
		Enumeration enu = multipartRequest.getParameterNames();
		
		while(enu.hasMoreElements()) {
			String name = (String)enu.nextElement();
			String value = multipartRequest.getParameter(name);
			map.put(name, value);
		}
		
		List fileList = fileProcess(multipartRequest);
		map.put("fileList", fileList);
		
		ModelAndView mav = new ModelAndView();
		mav.addObject("map",map);
		mav.setViewName("uploadResult");
		return mav;
		
	}
	
	public List<String> fileProcess(
			MultipartHttpServletRequest multipartRequest) throws Exception{
		List<String> fileList = new ArrayList<String>();
		Iterator<String> fileNames = multipartRequest.getFileNames();
		
		while(fileNames.hasNext()) {
			String fileName = fileNames.next();
			MultipartFile mFile = multipartRequest.getFile(fileName);
			
			String originalFileName = mFile.getOriginalFilename();
			fileList.add(originalFileName);
			
			File file = new File(Image_Repo_Path + "\\" + fileName);
			if(mFile.getSize() !=0) {
				File uploadFile = new File(Image_Repo_Path, originalFileName);
				mFile.transferTo(uploadFile);
			}
			 
			
			
		}
		return fileList;
	}

	
	@RequestMapping("/download")
	public void download(@RequestParam("imageFileName") String imageFileName,
	                     HttpServletResponse response) throws Exception {
	    File file = new File(Image_Repo_Path, imageFileName);
	    if(file.exists()) {
	        // 파일 타입 설정 (JPEG, PNG 등)
	        String mimeType = Files.probeContentType(file.toPath());
	        response.setContentType(mimeType);
	        Files.copy(file.toPath(), response.getOutputStream());
	        response.getOutputStream().flush();
	    } else {
	        response.sendError(HttpServletResponse.SC_NOT_FOUND); // 파일 없으면 404
	    }
	}
	
	
}
