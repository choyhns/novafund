package com.exe.fund.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.exe.fund.dao.ArticleDAO;
import com.exe.fund.dao.CategoryListDAO;
import com.exe.fund.dao.MemberDAO;
import com.exe.fund.dto.MemberDTO;
import com.exe.fund.dao.ImageFileDAO;
import com.exe.fund.dao.ProjectDAO;
import com.exe.fund.dao.SponAmountDAO;
import com.exe.fund.dto.CategoryListDTO;
import com.exe.fund.dto.MainImageDTO;
import com.exe.fund.dto.ProjectDTO;
import com.exe.fund.dto.SponAmountDTO;

@Controller
public class HomeController {
	
	@Autowired
	@Qualifier("projectDAO")
	ProjectDAO dao;
	
	@Autowired
	@Qualifier("memberDAO")
	MemberDAO memberDao;
	
	@Autowired
	@Qualifier("categoryListDAO")
	private CategoryListDAO categoryListDAO;
	
	@Autowired
	@Qualifier("imageFileDAO")
	private ImageFileDAO imageFileDAO;
	
	@Autowired
	@Qualifier("articleDAO")
	private ArticleDAO articleDAO;
	
	@Autowired
	@Qualifier("sponAmountDAO")
	private SponAmountDAO sponAmountDAO;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView home(
		@RequestParam(value = "searchValue", required = false) String searchValue,
		@RequestParam(value = "categoryName", required = false) String categoryName) {
		
		ModelAndView mav = new ModelAndView();
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if(auth!=null && auth.isAuthenticated()) {
			
			String userId = auth.getName();
			
			MemberDTO dto = memberDao.findById(userId);
			if(dto!=null) {	
				if(dto.getTempPwd().equals("y")) {
					mav.setViewName("redirect:/update.action");
					return mav;
				}
			}
		}
		
		int currentPage = 1;
		int numPerPage = 6;
		int start = 1;
		int end = numPerPage * currentPage;
		
		if (searchValue == null) {
			searchValue = "";
		}
		
		if(categoryName==null) {
			categoryName="";

		}
		
		List<CategoryListDTO> caLists =categoryListDAO.getLists();
		
		String type = "good";
		List<ProjectDTO> goodLists = dao.getLists(start, end, searchValue, categoryName, type, 1);
		
		int totalAmount = 0;
		int totalUser = 0;
		
		List<MainImageDTO> goodMainImages = new ArrayList<MainImageDTO>();
		for(ProjectDTO project : goodLists) {
			
			totalAmount = 0;
			totalUser = 0;
			
			List<MainImageDTO> images = imageFileDAO.getMainImages(project.getNumPro());
			if(!images.isEmpty()) {
	            goodMainImages.add(images.get(0));
	        } else {
	            goodMainImages.add(new MainImageDTO());
	        }
			
			List<SponAmountDTO> sponList = sponAmountDAO.getAmountProject(project.getNumPro());
		    
		    if(sponList != null && !sponList.isEmpty()) {
		    	
		        // 총 후원금액 계산
		        for(SponAmountDTO spdto : sponList) {
		            totalAmount += spdto.getAmount();
		            totalUser++;
		        }
		    }
		    
		    int percent = 0;
		    if(project.getGoalAmount() > 0) {
		        percent = (int) Math.round(
		        		((double) totalAmount / project.getGoalAmount()) * 100);
		    }
		    
		    if(project.getSubject().length()>15) {
		    	project.setSubject(project.getSubject().substring(0, 15) + "...");
		    }
		    if(project.getContent().length()>30) {
		    project.setContent(project.getContent().substring(0, 30) + "...");
		    }
		    project.setPercent(percent);
		    project.setTotalAmount(totalAmount);
		    project.setTotalUser(totalUser);
		}
		
		type = "recommend";
		List<ProjectDTO> reLists = dao.getLists(start, end, searchValue, categoryName, type, 1);
		
		
		
		List<MainImageDTO> reMainImages = new ArrayList<MainImageDTO>();
		for(ProjectDTO project : reLists) {
			
			totalAmount = 0;
			totalUser = 0;
			
			List<MainImageDTO> images = imageFileDAO.getMainImages(project.getNumPro());
			if(!images.isEmpty()) {
				reMainImages.add(images.get(0));
	        } else {
	        	reMainImages.add(new MainImageDTO());
	        }
			
			List<SponAmountDTO> sponList = sponAmountDAO.getAmountProject(project.getNumPro());
		    
		    if(sponList != null && !sponList.isEmpty()) {
		    	
		        // 총 후원금액 계산
		    	for(SponAmountDTO spdto : sponList) {
		            totalAmount += spdto.getAmount();
		            totalUser++;
		        }
		    }
		    
		    int percent = 0;
		    if(project.getGoalAmount() > 0) {
		        percent = (int) Math.round(
		        		((double) totalAmount / project.getGoalAmount()) * 100);
		    }
		    
		    if(project.getSubject().length()>15) {
		    	project.setSubject(project.getSubject().substring(0, 15) + "...");
		    }
		    if(project.getContent().length()>30) {
		    project.setContent(project.getContent().substring(0, 30) + "...");
		    }
		    project.setPercent(percent);
		    project.setTotalAmount(totalAmount);
		    project.setTotalUser(totalUser);
		}
		
		type = "created";
		List<ProjectDTO> crLists = dao.getLists(start, end, searchValue, categoryName, type, 1);
		
		
		
		List<MainImageDTO> crMainImages = new ArrayList<MainImageDTO>();
		for(ProjectDTO project : crLists) {
			
			totalAmount = 0;
			totalUser = 0;
			
			List<MainImageDTO> images = imageFileDAO.getMainImages(project.getNumPro());
			if(!images.isEmpty()) {
				crMainImages.add(images.get(0));
	        } else {
	        	crMainImages.add(new MainImageDTO());
	        }
			
			List<SponAmountDTO> sponList = sponAmountDAO.getAmountProject(project.getNumPro());
		    
		    if(sponList != null && !sponList.isEmpty()) {
		    	
		        // 총 후원금액 계산
		    	for(SponAmountDTO spdto : sponList) {
		            totalAmount += spdto.getAmount();
		            totalUser++;
		        }
		    }
		    
		    int percent = 0;
		    if(project.getGoalAmount() > 0) {
		        percent = (int) Math.round(
		        		((double) totalAmount / project.getGoalAmount()) * 100);
		    }
		    
		    if(project.getSubject().length()>15) {
		    	project.setSubject(project.getSubject().substring(0, 15) + "...");
		    }
		    if(project.getContent().length()>30) {
		    project.setContent(project.getContent().substring(0, 30) + "...");
		    }
		    project.setPercent(percent);
		    project.setTotalAmount(totalAmount);
		    project.setTotalUser(totalUser);
		}
		
		List<Integer> gLists = null;
		
		if(auth != null && auth.getName() != null ) {
			
			gLists = articleDAO.getNumProLists(auth.getName());
			for(int num : gLists) {
				for(ProjectDTO gdto : goodLists) {
					if(num == gdto.getNumPro()) {
						gdto.setUserGood("Y");
						continue;
					}
				}
				
				for(ProjectDTO redto : reLists) {
					if(num == redto.getNumPro()) {
						redto.setUserGood("Y");
						continue;
					}
				}
				
				for(ProjectDTO crdto : crLists) {
					if(num == crdto.getNumPro()) {
						crdto.setUserGood("Y");
						continue;
					}
				}
			}
		}
		
		int dataCount = dao.getDataCount(searchValue, categoryName);
		
		mav.addObject("goodLists", goodLists);
		mav.addObject("goodMainImages", goodMainImages);
		mav.addObject("reMainImages", reMainImages);
		mav.addObject("crMainImages", crMainImages);
		mav.addObject("reLists", reLists);
		mav.addObject("crLists", crLists);
		mav.addObject("dataCount", dataCount);
		mav.addObject("caLists", caLists);
		mav.addObject("searchValue", searchValue);
		mav.addObject("categoryName", categoryName);
		
		mav.setViewName("main");
		return mav;
	}
	
}
