package com.exe.fund.controller;

import java.beans.PropertyEditorSupport;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.print.DocFlavor.STRING;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.exe.fund.dao.ArticleDAO;
import com.exe.fund.dao.BizCheckDAO;
import com.exe.fund.dao.CategoryListDAO;
import com.exe.fund.dao.ImageFileDAO;
import com.exe.fund.dao.MemberDAO;
import com.exe.fund.dao.ProjectDAO;
import com.exe.fund.dao.RewardDAO;
import com.exe.fund.dao.SponAmountDAO;
import com.exe.fund.dao.SponDetailDAO;
import com.exe.fund.dto.BizCheckDTO;
import com.exe.fund.dto.CategoryListDTO;
import com.exe.fund.dto.ContentImageDTO;
import com.exe.fund.dto.MainImageDTO;
import com.exe.fund.dto.MemberDTO;
import com.exe.fund.dto.ProjectDTO;
import com.exe.fund.dto.RewardDTO;
import com.exe.fund.dto.SponAmountDTO;
import com.exe.fund.dto.SponDetailDTO;

@Controller
public class ProjectController {

	@Autowired
	@Qualifier("projectDAO")
	ProjectDAO projectDAO;
	
	@Autowired
	@Qualifier("categoryListDAO")
	CategoryListDAO categoryListDAO;
    
	@Autowired
	@Qualifier("rewardDAO")
	private RewardDAO rewardDAO;
	
	@Autowired
	private ImageFileDAO imageFileDAO;	
	
	@Autowired
	private BizCheckDAO bizCheckDAO;

	@Autowired
	private MemberDAO memberDAO;
	
  	@Autowired
	@Qualifier("articleDAO")
	private ArticleDAO articleDAO;

	
	@Autowired
	@Qualifier("sponAmountDAO")
	private SponAmountDAO sponAmountDAO;
	
	@Autowired
	@Qualifier("sponDetailDAO")
	private SponDetailDAO sponDetailDAO;
	
	@InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(int.class, "goalAmount", new PropertyEditorSupport() {
            @Override
            public void setAsText(String text) throws IllegalArgumentException {
                if (text != null && !text.trim().isEmpty()) {
                    setValue(Integer.parseInt(text.replaceAll(",", "")));
                } else {
                    setValue(0);
                }
            }
        });
    }

    @RequestMapping(value = "/form.action")
    public String projectForm() {
    	
    	return "project/projectForm";
    }

    @RequestMapping(value = "/bizCheck.action")
    public String bizCheck() {
    	
    	return "project/bizCheck";
    }
	
	@RequestMapping(value = "/rewardUpload.action")
	public String reward() {
			
			return "project/rewardUpload";
		}
		
	@RequestMapping(value = "/projectUpload.action")
	public ModelAndView created(Authentication auth) {
		ModelAndView mav = new ModelAndView();
		
		
		if(auth == null || auth.getName() == null || auth.getName().equals("annoymousUser")) {
			
			mav.setViewName("redirect:/login.action");
			return mav;
		}
		List<CategoryListDTO> caLists = categoryListDAO.getLists();
		mav.addObject("caLists",caLists);
		List<CategoryListDTO> lists = categoryListDAO.getLists();
		mav.addObject("lists", lists);
		mav.setViewName("/project/projectUpload");
		System.out.println(lists);
		return mav;
	}
	
	String originalFileName="";
	String ext="";
	String saveFileName="";
	
	@RequestMapping(value = "/created_ok.action", method = {RequestMethod.POST})
	public ModelAndView created_ok(
			ProjectDTO pdto,
			@RequestParam("categoryName") String categoryName,
			MultipartHttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			Authentication auth
			) throws Exception{

		ModelAndView mav = new ModelAndView();			
		System.out.println("aaa");
		String userId = auth.getName();
		
		pdto.setUserId(userId);	
		
		pdto.setSubject(request.getParameter("subject"));
		pdto.setCategoryName(request.getParameter("categoryName"));
		pdto.setStartDate(request.getParameter("startDate"));
		pdto.setEndDate(request.getParameter("endDate"));
		pdto.setContent(request.getParameter("content"));		
		
		projectDAO.insertData(pdto);
		
		int numPro = pdto.getNumPro(); //시퀀스 값이 자동으로 들어있음.
		
		//ServletContext context = request.getSession().getServletContext();
		String path = 
				request.getSession().getServletContext().getRealPath("/resources/image");
		
		//메인이미지
		List<MultipartFile> mainImages = request.getFiles("mainImages");
		if(mainImages != null && mainImages.size() >0) {

			for(MultipartFile file : mainImages) {
				if(file.isEmpty()) continue;
				originalFileName = file.getOriginalFilename();
				
				ext = originalFileName.substring(originalFileName.lastIndexOf("."));
				
				saveFileName = UUID.randomUUID().toString() + ext;
				
				File dest = new File(path, saveFileName);
				file.transferTo(dest);
				
				MainImageDTO midto = new MainImageDTO();
				midto.setNumPro(numPro);
				midto.setOriginalName(originalFileName);
				midto.setSaveName(saveFileName);
				midto.setFilePath(path);
				
				imageFileDAO.insertMainImage(midto); 
			}
		}
		
		//내용이미지
		List<MultipartFile> contentImages = request.getFiles("contentImages");
		if(contentImages != null && contentImages.size() >0) {

			for(MultipartFile file : contentImages) {
				if(file.isEmpty()) continue;
				
				originalFileName = file.getOriginalFilename();
				
				ext = originalFileName.substring(originalFileName.lastIndexOf("."));
				
				saveFileName = UUID.randomUUID().toString() + ext;
				
				File dest = new File(path, saveFileName);
				
				file.transferTo(dest);
				
				ContentImageDTO cidto = new ContentImageDTO();
				cidto.setNumPro(numPro);
				cidto.setOriginalName(originalFileName);
				cidto.setSaveName(saveFileName);
				cidto.setFilePath(path);
				
				imageFileDAO.insertContentImage(cidto); 
			}
		}
	
	
		//reward
		String[] rewardSubjects = request.getParameterValues("rewardSubject");
		String[] rewardContents = request.getParameterValues("rewardContent");
		String[] amountStr = request.getParameterValues("amount");
		
		if(rewardSubjects != null && rewardSubjects.length >0) {
			for(int i=0;i<rewardSubjects.length;i++) {
				RewardDTO rdto = new RewardDTO();
				rdto.setNumPro(numPro);
				rdto.setRewardSubject(rewardSubjects[i]);
				rdto.setRewardContent(rewardContents[i]);
				rdto.setAmount(Integer.parseInt(amountStr[i].replaceAll(",", "")));
				
				rewardDAO.insertReward(rdto);
				
				
			}
		}
//		//사업자번호 등록
//		BizCheckDTO bdto = new BizCheckDTO();
//		String bizStatus = (String)session.getAttribute("bizStatus");
//		if(bizStatus !=null) {
//			bdto.setResult(bizStatus);
//		}else {
//			bdto.setResult("N/A");
//		}
//		bdto.setUserId(userId);
//		System.out.println("bdto = " + bdto);	
//		
//		//bizCheckDAO.insertBizNum(bdto);
		
		mav.setViewName("redirect:/");
		return mav;
	}

		
	@RequestMapping(value = "/list.action", method = {RequestMethod.GET, RequestMethod.POST})
	public ModelAndView getLists(String searchValue, String categoryName, String type, String pageNum,
			Authentication authentication) {

		if (searchValue == null) {
			searchValue = "";
		}
		
		if(categoryName==null) {
			categoryName="";
		}
		
		if(type == null || type.trim().isEmpty()) {
			type = "today";

		}
		
		if(categoryName.equals("전체")) {
			categoryName = "";

		}
		
		ModelAndView mav = new ModelAndView();

		int currentPage = 1;
		
		if(pageNum !=null) {
			currentPage = Integer.parseInt(pageNum);
		}
		
		int numPerPage = 8;
		int start = (currentPage - 1) * numPerPage + 1;
		int end = currentPage * numPerPage;

		List<CategoryListDTO> caLists =categoryListDAO.getLists();
		
		List<ProjectDTO> searchLists = projectDAO.getLists(start, end, searchValue, categoryName, type, 1);
		int dataCount = projectDAO.getDataCount(searchValue, categoryName);
		

		// --- 달성률(percent) 계산, 후원자 추가 ---
		int totalAmount = 0;
		int totalUser = 0;
		
		List<MainImageDTO> seMainImages = new ArrayList<MainImageDTO>();
		for(ProjectDTO project : searchLists) {
			
			totalAmount = 0;
			totalUser = 0;
			
			List<MainImageDTO> images = imageFileDAO.getMainImages(project.getNumPro());
			if(!images.isEmpty()) {
				seMainImages.add(images.get(0));
	        } else {
	        	seMainImages.add(new MainImageDTO());
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
		
		List<Integer> goodLists = null;
				
				if(authentication != null && authentication.getName() != null ) {
					String userId = authentication.getName();
					
					goodLists = articleDAO.getNumProLists(userId);
					for(ProjectDTO pdto : searchLists) {
						for(int num : goodLists) {
							if(num == pdto.getNumPro()) {
								pdto.setUserGood("Y");
								continue;
							}
						}
					}
				}
				
		
		mav.addObject("lists", searchLists);
		mav.addObject("seMainImages", seMainImages);
		mav.addObject("dataCount", dataCount);
		mav.addObject("caLists", caLists);
		mav.addObject("searchValue", searchValue);
		mav.addObject("categoryName", categoryName);
		mav.addObject("type", type);
		mav.addObject("pageNum", currentPage); 
		
		mav.setViewName("search");
		return mav;
		
	}

	@RequestMapping(value = "/more.action/{type}")
	public ModelAndView getMoreList(@PathVariable("type") String type,
			ProjectDTO dto,
			@RequestParam(value = "categoryName", required = false) String categoryName,
	        @RequestParam(value = "searchValue", required = false) String searchValue,
	        @RequestParam(value = "pageNum", defaultValue = "1") String pageNum,
	        Authentication authentication) {
		
		ModelAndView mav = new ModelAndView();
		
		int currentPage = 1;
		if(pageNum !=null) {
			currentPage = Integer.parseInt(pageNum);
		}
		
		int numPerPage = 8;
		int start = (currentPage - 1) * numPerPage + 1;
	    int end = currentPage * numPerPage;
		
		List<CategoryListDTO> caLists = categoryListDAO.getLists();
		List<ProjectDTO> lists = projectDAO.getLists(start, end, "", "", type, 1);
		
		int dataCount = projectDAO.getDataCount("", type);
		
		int totalAmount = 0;
		int totalUser = 0;
		
		List<MainImageDTO> mainImages = new ArrayList<MainImageDTO>();
		
		for(ProjectDTO project : lists) {
			
			totalAmount = 0;
			totalUser = 0;
			
			List<MainImageDTO> imgs = imageFileDAO.getMainImages(project.getNumPro());
			mainImages.add(imgs.get(0));
			
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
		
		List<Integer> goodLists = null;
		
		if(authentication != null && authentication.getName() != null ) {
			String userId = authentication.getName();
			
			goodLists = articleDAO.getNumProLists(userId);
			for(ProjectDTO pdto : lists) {
				for(int num : goodLists) {
					if(num == pdto.getNumPro()) {
						pdto.setUserGood("Y");
						continue;
					}
				}
			}
		}
		
		mav.addObject("mainImages", mainImages);
		mav.addObject("lists", lists);
		mav.addObject("caLists", caLists);
		mav.addObject("dataCount", dataCount);
        mav.addObject("type", type);
        mav.addObject("categoryName", categoryName);
        mav.addObject("searchValue", searchValue);
        mav.addObject("goodLists", goodLists);
        
		mav.setViewName("more");
		return mav;
	}
	


	// 좋아용
	@ResponseBody
	@RequestMapping(value = "/project/userGood", method = RequestMethod.POST)
	public String userGood(
			@RequestParam("numPro") int numPro,
			Authentication authentication) {
				
		if(authentication == null || authentication.getName() == null) {
			return "notLogin";
		}
		
		String userId = authentication.getName();
		System.out.println(numPro);
		
		// true면 좋아요! false면 취소
		boolean isGood = articleDAO.good(numPro, userId);
		if(isGood) {
			return "addGood";
		}else {
			return "removeGood";

		}
	}
	
	@RequestMapping(value = "/projectUpdate", method = {RequestMethod.GET})
	public ModelAndView projectUpdated(@RequestParam("numPro") int numPro,
			Authentication auth) {
	
		ProjectDTO pdto = projectDAO.getReadData(numPro);
		List<RewardDTO> rewards = rewardDAO.getReadData(numPro);
		List<MainImageDTO> mainImages = imageFileDAO.getMainImages(numPro);
		List<ContentImageDTO> contentImages = imageFileDAO.getContentImages(numPro);
		List<CategoryListDTO> lists = categoryListDAO.getLists();
		
		String userId = auth.getName();
		pdto.setUserId(userId);	
		
		//BizCheckDTO bdto = bizCheckDAO.getReadBizNum("asd");
		
//		if (bdto == null) {
//		    bdto = new BizCheckDTO();
//		}
		
		String startDate = pdto.getStartDate();
		String endDate = pdto.getEndDate();
		
		if(startDate != null) {
			pdto.setStartDate(startDate.substring(0,10));
		}
		if(endDate != null) {
			pdto.setEndDate(endDate.substring(0,10));
		}
		
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("project",pdto);
		mav.addObject("rewards",rewards);
		mav.addObject("mainImages",mainImages);
		mav.addObject("contentImages",contentImages);
		mav.addObject("lists",lists);
		//mav.addObject("bizCheck",bdto);
		mav.setViewName("/project/projectUpdate");
		
		return mav;
		
	}

	@RequestMapping(value = "/projectUpdated_ok",
			method = {RequestMethod.POST,RequestMethod.GET})
	public ModelAndView projectUpdated_ok(
			BizCheckDTO bdto,
			ProjectDTO pdto,
			@RequestParam("rewardSubject") String[] rewardSubjects,
			@RequestParam("amount") Integer[] amounts,
			@RequestParam("rewardContent") String[] rewardContents,
		    @RequestParam("rewardIds")Integer[] rewardIds,
			MultipartHttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			Authentication auth
			) throws Exception{

		ModelAndView mav = new ModelAndView();			
		
		List<MultipartFile> mainFiles = request.getFiles("mainImages");
		List<MultipartFile> contentFiles = request.getFiles("contentImages");
		List<MultipartFile> newMainFiles = request.getFiles("newMainImages");
		List<MultipartFile> newContentFiles = request.getFiles("newContentImages");
		
		
		//String userId = mdto.getUserId();
		int numPro = pdto.getNumPro();
		
		String userId = auth.getName();
		pdto.setUserId(userId);	
		
		
		pdto.setNumPro(numPro);
		pdto.setSubject(request.getParameter("subject"));
		pdto.setCategoryName(request.getParameter("categoryName"));
		pdto.setStartDate(request.getParameter("startDate"));
		pdto.setEndDate(request.getParameter("endDate"));
		try {
			pdto.setGoalAmount((Integer.parseInt(request.getParameter("goalAmount").replaceAll(",", ""))));
		} catch (Exception e) {
			pdto.setGoalAmount(0);
		}
		pdto.setContent(request.getParameter("content"));
		pdto.setCategoryName(request.getParameter("categoryName"));

		projectDAO.updateData(pdto);
		
		
		
		if(rewardSubjects != null && rewardSubjects.length >0) {
			for(int i=0; i<rewardSubjects.length; i++) {
				RewardDTO rdto = new RewardDTO();
				rdto.setNumPro(numPro);
				
				Integer rewardId = (rewardIds != null && rewardIds.length > i) ? rewardIds[i] : null;
				rdto.setRewardId(rewardId);  // null일 경우 DB 시퀀스로 insert
				
				rdto.setRewardSubject(rewardSubjects[i]);
				rdto.setAmount(amounts[i]);
				rdto.setRewardContent(rewardContents[i]);
			
				if(rewardId != null && rewardId >0) {
					rewardDAO.updateData(rdto);
				}else {
					rewardDAO.insertReward(rdto);
								
				}

			}
			
		}
		
		//ServletContext context = request.getSession().getServletContext();
		String path = 
				request.getSession().getServletContext().getRealPath("/resources/image");

			if(newMainFiles != null && newMainFiles.size()>0) {
				for(MultipartFile file : newMainFiles) {
					
					if(file.isEmpty() || file.getOriginalFilename() ==null || file.getOriginalFilename().trim().equals("")) {
						continue;
					}
					originalFileName = file.getOriginalFilename();
					
					ext = originalFileName.substring(originalFileName.lastIndexOf("."));
					
					saveFileName = UUID.randomUUID().toString() + ext;
					
					File dest = new File(path, saveFileName);
					file.transferTo(dest);
					
					MainImageDTO midto = new MainImageDTO();
					midto.setNumPro(numPro);
					midto.setOriginalName(originalFileName);
					midto.setSaveName(saveFileName);
					midto.setFilePath(path);
					
					imageFileDAO.insertMainImage(midto); 
					
				}
					
			}
				
				
			if(newContentFiles != null && newContentFiles.size() >0) {
				for(MultipartFile file : newContentFiles) {
					
					if(file.isEmpty() || file.getOriginalFilename() ==null || file.getOriginalFilename().trim().equals("")) {
						continue;
					}
					originalFileName = file.getOriginalFilename();
					
					ext = originalFileName.substring(originalFileName.lastIndexOf("."));
					
					saveFileName = UUID.randomUUID().toString() + ext;
					
					File dest = new File(path, saveFileName);
					
					file.transferTo(dest);
					
					ContentImageDTO cidto = new ContentImageDTO();
					cidto.setNumPro(numPro);
					cidto.setOriginalName(originalFileName);
					cidto.setSaveName(saveFileName);
					cidto.setFilePath(path);
					
					imageFileDAO.insertContentImage(cidto); 
					
				}
			}
		
//		String bizStatus = (String)session.getAttribute("bizStatus");
//		if(bizStatus !=null) {
//			bdto.setResult(bizStatus);
//		}else {
//			bdto.setResult("N/A");
//		}
//		
//		
//		System.out.println("bdto = " + bdto);	
//		
//		BizCheckDTO existing = bizCheckDAO.getReadBizNum(bdto.getUserId());
//		if(existing != null) {
//			bizCheckDAO.updateBizCheck(bdto);
//		}else {
//			bizCheckDAO.insertBizNum(bdto);
//		}
		
		
		mav.setViewName("redirect:/memberInfo.action");
		return mav;
		
	}
	
	@RequestMapping(value = "/deleteMainImage.action", method = {RequestMethod.POST})
	@ResponseBody
	public String deleteImages(
			@RequestParam Integer numPro,
			@RequestParam String saveName,
			HttpSession session){
		
		String result="";
		
		try {
			String root = session.getServletContext().getRealPath("/");
			String savePath = 
					session.getServletContext().getRealPath("/resources/image");
			
			MainImageDTO midto = imageFileDAO.getMainImageBySaveNameAndNumPro(numPro, saveName);
			
			if(midto !=null) {
				File file = new File(savePath,saveName);
				if(file.exists()) {
					file.delete();
				}				
			
			int count = imageFileDAO.deleteMainImage(midto);
			System.out.println("a");
			if(count > 0) {
				result="success";
				System.out.println("abb");
			} else {
				result="success";
				System.out.println("aaaa11");
			}
			
			} else {
				result="success";
				System.out.println("aaaa");
			}
			
			
		} catch (Exception e) {
			result="err";
			System.out.println("aacc");
		}
		System.out.println(result);
		
		return result;
		
	}
	
		@RequestMapping(value = "/deleteContentImage.action", method = {RequestMethod.POST})
		@ResponseBody
		public String deleteContentImages(
				@RequestParam Integer numPro,
				@RequestParam String saveName,
				HttpSession session){
			
			String result = "";
			
			try {
				String savePath = 
						session.getServletContext().getRealPath("/resources/image");
				
				ContentImageDTO cidto = imageFileDAO.getContentImageBySaveNameAndNumPro(numPro, saveName);
				
				if(cidto !=null) {
					File file = new File(savePath,saveName);
					if(file.exists()) {
						file.delete();
					}				
				
				int count = imageFileDAO.deleteContentImage(cidto);
				
				if(count > 0) {
					result="success";
				} else {
					result="success";
				}
				
				} else {
					result="success";
				}
				
				
			} catch (Exception e) {
				result="fail";
			}
			
			return result;
			
		}
	
	
	@RequestMapping(value = "/deleted_ok.action", 
			method = {RequestMethod.POST ,RequestMethod.GET})
	public String deleted_ok(HttpServletRequest request,
			HttpServletResponse response,
			Authentication auth) {
		int numPro = Integer.parseInt(request.getParameter("numPro"));
		
		String userId = auth.getName();		
		
		List<SponAmountDTO> sponLists = sponAmountDAO.getAmountProject(numPro);
		for(SponAmountDTO spondto : sponLists) {
			MemberDTO sponMemberDTO = memberDAO.findById(spondto.getUserId());
			articleDAO.updateCashPoint(spondto.getUserId(), 
					sponMemberDTO.getCashPoint() + spondto.getAmount());
			
			sponAmountDAO.updatePaid(spondto.getSponNum(), -1);
			
			SponDetailDTO sponDetailDTO = new SponDetailDTO();
			
			sponDetailDTO.setActiontype("failed");
			String subject = projectDAO.getReadData(numPro).getSubject();
			sponDetailDTO.setDescription("프로젝트취소_" + 
			(subject.length()>8 ? (subject.substring(0,8) + ".."):subject));
			sponDetailDTO.setDetail("+" + spondto.getAmount());
			sponDetailDTO.setNumPro(numPro);
			sponDetailDTO.setStatus("success");
			sponDetailDTO.setUserId(spondto.getUserId());
			
			sponDetailDAO.insertData(sponDetailDTO);
		}
		
		imageFileDAO.deleteMainImagesAll(numPro);
		imageFileDAO.deleteContentImagesAll(numPro);
		//bizCheckDAO.deleteBizAll(numPro);
		articleDAO.deleteWishList(numPro);
		articleDAO.deleteGoodByNumPro(numPro);
		rewardDAO.deleteData(numPro);
		articleDAO.deleteReviewLists(numPro);
		projectDAO.deleteData(numPro);
		return "redirect:/memberInfo.action";
	}
		

}





