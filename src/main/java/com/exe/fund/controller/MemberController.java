package com.exe.fund.controller;

import java.security.SecureRandom; 
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.exe.fund.dao.ArticleDAO;
import com.exe.fund.dao.CategoryListDAO;
import com.exe.fund.dao.ImageFileDAO;
import com.exe.fund.dao.MemberDAO;
import com.exe.fund.dao.ProjectDAO;
import com.exe.fund.dao.RewardDAO;
import com.exe.fund.dao.SponAmountDAO;
import com.exe.fund.dao.SponDetailDAO;
import com.exe.fund.dto.CategoryListDTO;
import com.exe.fund.dto.MainImageDTO;
import com.exe.fund.dto.MemberDTO;
import com.exe.fund.dto.PaymentDTO;
import com.exe.fund.dto.ProjectDTO;
import com.exe.fund.dto.RewardDTO;
import com.exe.fund.dto.SponAmountDTO;
import com.exe.fund.dto.SponDetailDTO;
import com.exe.fund.dto.WithdrawDTO;
import com.exe.fund.util.AuthMail;
import com.exe.fund.util.RefererAuthenticationSuccessHandler;
import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping
public class MemberController {
	
	@Autowired
	private MemberDAO dao;
	
	@Autowired
	@Qualifier("categoryListDAO")
	CategoryListDAO categoryListDAO;
    
	@Autowired
	@Qualifier("sponAmountDAO")
	private SponAmountDAO sponDAO;
	
	@Autowired
	@Qualifier("projectDAO")
	ProjectDAO proDao;
	
	@Autowired
	@Qualifier("imageFileDAO")
	private ImageFileDAO imageFileDAO;
	
	@Autowired
	@Qualifier("authenticationManager")
	private AuthenticationManager authenticationManager;
	
	@Autowired
	@Qualifier("articleDAO")
	private ArticleDAO articleDAO;
	
	@Autowired
	@Qualifier("sponDetailDAO")
	private SponDetailDAO sponDetailDAO;
	
	@Autowired
	@Qualifier("rewardDAO")
	private RewardDAO rewardDAO;

	@Autowired
	private RefererAuthenticationSuccessHandler authSuccessHandler;
	
	@RequestMapping(value = "/join.action")
	public ModelAndView join() {
		
		ModelAndView mav = new ModelAndView();
		
		List<MemberDTO> lists = dao.getLists();
		List<CategoryListDTO> caLists = categoryListDAO.getLists();
		mav.addObject("caLists",caLists);
		mav.addObject("lists",lists);
		mav.setViewName("member/join");
		
		return mav;
	}
	
	//회원가입
	@RequestMapping(value = "/join.action", method = {RequestMethod.POST})
	public ModelAndView join_ok(MemberDTO dto) {
		
		ModelAndView mav = new ModelAndView();
		
		dto.setPwd(new BCryptPasswordEncoder().encode(dto.getPwd()));
		dto.setUserId(dto.getEmail());
		
		dao.insertData(dto);
		
		mav.setViewName("redirect:/");
		return mav;
		
	}
	
	
	@RequestMapping(value = "/update.action")
	public ModelAndView update(Authentication auth) {
		
		ModelAndView mav = new ModelAndView();
		
		String userId = auth.getName();
		
		MemberDTO dto = dao.findById(userId);
		
		boolean social = userId.startsWith("kakaoId_");
		if(dto.getAddress()!=null) {
			String addr[] = dto.getAddress().split("\\|");
			dto.setAddress(addr[1] + addr[2]);
			String userPostCode = addr[0];
			String userAddress = addr[1];
			String detailAddress = addr[2];
			
			mav.addObject("userPostCode",userPostCode);
			mav.addObject("userAddress",userAddress);
			mav.addObject("detailAddress",detailAddress);
		}
		
		if(dto.getEmail().startsWith("noemail_")) {
			dto.setEmail("");
		}
		
		List<CategoryListDTO> caLists = categoryListDAO.getLists();
		mav.addObject("caLists",caLists);
		mav.addObject("dto",dto);
		
		mav.addObject("social",social);
		
		mav.setViewName("member/update");
		
		return mav;
	}
	
	@RequestMapping(value = "/login.action", method = {RequestMethod.GET})
	public String login(HttpServletRequest request) {
		
		String referer = request.getHeader("referer");
		
		if (referer != null && !referer.contains("/login.action")) {
	        request.getSession().setAttribute("prevPage", referer);
	    }
		
		return "member/login";
	}
	
	//인증번호 이메일 발송
	@RequestMapping(value = "/sendAuthMail.action")
	@ResponseBody
	public String sendMail(@RequestParam("email") String email,
			HttpServletRequest request) {
		
		MemberDTO dto = dao.findByEmail(email);
		
		if(dto!=null) {
			return "exist";
		}
		
		AuthMail authMail = new AuthMail();
		
		authMail.setReceiverEmail(email);
		authMail.setContentAuthNum(authMail.getAuthNum());
		if(authMail.sendMail()) {
			HttpSession session = request.getSession();
			session.setAttribute("authCode", authMail.getAuthNum());
			
			return "success";
		}else {
			return "fail";
		}
		
	}
	
	//인증번호 인증 확인
	@RequestMapping(value = "/verifyCode")
	@ResponseBody
	public String verifyAuthCode(@RequestParam("code") String code,
			HttpServletRequest request) {
		HttpSession session = request.getSession();
		String authCode = (String)session.getAttribute("authCode");
		
		if(authCode != null && authCode.equals(code)) {
			return "verified";
		}else {
			return "fail";
		}
		
	}
	
	@RequestMapping(value = "/login.action/oauth2/code/kakao")
	public void kakaoLogin(@RequestParam("code") String code,
			HttpServletRequest request,HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		
		RestTemplate restTemplate = new RestTemplate();
		
		MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
		params.add("grant_type", "authorization_code");
		params.add("client_id", "42037fb805891476dc04c0876f4eb812");
		params.add("redirect_uri", "http://192.168.0.34:8080/fund/login.action/oauth2/code/kakao");
		params.add("code", code);
		
		HttpHeaders headers = new HttpHeaders();
		headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");
		
		HttpEntity<MultiValueMap<String, String>> tokenRequest =
				new HttpEntity<MultiValueMap<String,String>>(params,headers);
        ResponseEntity<String> tokenResponse = restTemplate.exchange(
                "https://kauth.kakao.com/oauth/token",
                HttpMethod.POST,
                tokenRequest,
                String.class
        );
        
        ObjectMapper objectMapper = new ObjectMapper();
        Map<String, Object> tokenMap = objectMapper.readValue(tokenResponse.getBody(), Map.class);
        String accessToken = (String) tokenMap.get("access_token");
        
        headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);
        HttpEntity<?> userInfoRequest = new HttpEntity(headers);

        ResponseEntity<String> userInfoResponse = restTemplate.exchange(
                "https://kapi.kakao.com/v2/user/me",
                HttpMethod.POST,
                userInfoRequest,
                String.class
        );
	
        Map<String, Object> userInfo = objectMapper.readValue(userInfoResponse.getBody(), Map.class);
        Long kakaoId = ((Number)userInfo.get("id")).longValue();
        String userId = "kakaoId_" + kakaoId;
        
        Map<String, Object> kakaoAccount = (Map<String, Object>) userInfo.get("kakao_account");
        String email = (String) kakaoAccount.get("email");
        if(email==null) {
        	email = "noemail_" + kakaoId + "kakao.local";
        }
        String nickname = (String) ((Map<String, Object>) kakaoAccount.get("profile")).get("nickname");
        
        MemberDTO dto = dao.findById(userId);
        
        if(dto==null) {
        	dto = new MemberDTO();
        	
	        dto.setUserId(userId);
	        dto.setPwd(new BCryptPasswordEncoder().encode("social"));
	        dto.setEmail(email);
	        dto.setNickname(nickname);
	        dto.setEnabled(1);
	        
	        dao.insertData(dto);
        }
        
        Authentication authentication =  new UsernamePasswordAuthenticationToken(userId, null,
                Arrays.asList(new SimpleGrantedAuthority("USER")));
        
        SecurityContextHolder.getContext().setAuthentication(authentication);
        
        authSuccessHandler.onAuthenticationSuccess(request, response, authentication);
        
      
        
	}
	
	@RequestMapping(value = "/search.action")
	public String search() {
	
		return "member/search";
	
	}
	
	@RequestMapping(value = "/searchId.action")
	public String searchId() {
		return "member/searchId";
	}
	
	@RequestMapping(value = "/searchPwd.action")
	public String searchPwd() {
		return "member/searchPwd";
	}
	
	@RequestMapping(value = "/searchId.action", method = {RequestMethod.POST})
	@ResponseBody
	public String searchIdCheck(@RequestParam("userId") String userId) {
		
		MemberDTO dto = dao.findById(userId);
		
		if(dto==null) {
			return "fail";
		}else {
			return "success";
		}
				
	}
	
	@RequestMapping(value = "/searchPwd.action", method = {RequestMethod.POST})
	@ResponseBody
	public String searchPwdCheck(@RequestParam("userId") String userId
			,HttpServletRequest request) {
		
		MemberDTO dto = dao.findById(userId);
		
		if(dto==null) {
			return "notexist";
		}
		
		AuthMail authMail = new AuthMail();
		
		authMail.setReceiverEmail(dto.getEmail());
		authMail.setContentTempPwd(authMail.getTempPwd());
		
		if(authMail.sendMail()) {
			dto.setPwd(new BCryptPasswordEncoder().encode(authMail.getTempPwd()));
			dto.setTempPwd("y");
			
			dao.updatePwd(dto);
			
			return "success";
		}else {
			return "fail";
		}
	}
	
	@RequestMapping(value = "/memberInfo.action")
	public ModelAndView memberInfo() {
		
		ModelAndView mav = new ModelAndView();
		
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		String userId = auth.getName();
		
		MemberDTO dto = dao.findById(userId);
		
		List<CategoryListDTO> caLists =categoryListDAO.getLists();
		
		List<SponAmountDTO> sponLists = sponDAO.getUserAmount(userId);
		
		List<ProjectDTO> mLists = proDao.getListsById(userId);
		
		List<MainImageDTO> mImageLists = new ArrayList<MainImageDTO>();
		
		int totalAmount = 0;
		int totalUser = 0;
		
		for(ProjectDTO project: mLists) {
			List<MainImageDTO> img = imageFileDAO.getMainImages(project.getNumPro());
			
			totalAmount = 0;
			totalUser = 0;
			
			if(img!=null && img.size()>0) {
			mImageLists.add(img.get(0));
			}else {
				mImageLists.add(null);
			}
			
			List<SponAmountDTO> sponList = sponDAO.getAmountProject(project.getNumPro());
		    
		    if(sponList != null && !sponList.isEmpty()) {
		    	
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
		
		List<ProjectDTO> pLists = new ArrayList<ProjectDTO>();
		
				
		for(SponAmountDTO spondto : sponLists) {
			ProjectDTO prodto = proDao.getReadData(spondto.getNumPro());
			pLists.add(prodto);
		}
		
		List<MainImageDTO> pImageLists = new ArrayList<MainImageDTO>();
		for(ProjectDTO project: pLists) {
			
			totalAmount = 0;
			totalUser = 0;
			
			List<MainImageDTO> img = imageFileDAO.getMainImages(project.getNumPro());
			if(img!=null && img.size()>0) {
				pImageLists.add(img.get(0));
			}else {
				pImageLists.add(null);
			}
			
			List<SponAmountDTO> sponList = sponDAO.getAmountProject(project.getNumPro());
		    
		    if(sponList != null && !sponList.isEmpty()) {
		    	
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
		
		List<ProjectDTO> gLists = proDao.getWishListById(userId);
		
		List<MainImageDTO> gImageLists = new ArrayList<MainImageDTO>();
		
		for(ProjectDTO project: gLists) {
			
			totalAmount = 0;
			totalUser = 0;
			
			List<MainImageDTO> img = imageFileDAO.getMainImages(project.getNumPro());
			
			if(img!=null && img.size()>0) {
				gImageLists.add(img.get(0));
				}else {
				gImageLists.add(null);
				}
			
			List<SponAmountDTO> sponList = sponDAO.getAmountProject(project.getNumPro());
		    
		    if(sponList != null && !sponList.isEmpty()) {
		    	
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
		
		String type = "good";
		List<ProjectDTO> reLists = proDao.getLists(1, 8, "", "", type,1);
		
		List<MainImageDTO> reImageLists = new ArrayList<MainImageDTO>();
		for(ProjectDTO project : reLists) {
			
			totalAmount = 0;
			totalUser = 0;
			
			List<MainImageDTO> img = imageFileDAO.getMainImages(project.getNumPro());
			
			if(img!=null && img.size()>0) {
				reImageLists.add(img.get(0));
				}else {
				reImageLists.add(null);
				}
			
			List<SponAmountDTO> sponList = sponDAO.getAmountProject(project.getNumPro());
		    
		    if(sponList != null && !sponList.isEmpty()) {
		    	
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
		
		mav.addObject("mLists",mLists);
		mav.addObject("mImageLists",mImageLists);
		mav.addObject("gLists",gLists);
		mav.addObject("gImageLists",gImageLists);
		mav.addObject("pLists",pLists);
		mav.addObject("pImageLists",pImageLists);
		mav.addObject("reLists",reLists);
		mav.addObject("reImageLists",reImageLists);
		mav.addObject("sponLists",sponLists);
		mav.addObject("dto",dto);
		mav.addObject("caLists",caLists);
		mav.setViewName("member/memberInfo");
		
		return mav;
		
	}

	
	@RequestMapping(value = "/cashPoint.action/{numPro}")
	public ModelAndView cashPointView(@PathVariable Integer numPro) {
		ModelAndView mav = new ModelAndView();
		
		mav.addObject("numPro",numPro);
		mav.setViewName("cashPoint");
		return mav;
	}
	
	@RequestMapping(value = "/cashPoint.action")
	public ModelAndView cashPointView2() {
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName("cashPoint");
		return mav;
	}
	
	
	
	@RequestMapping(value = "/updateCash_ok.action", method = {RequestMethod.POST})
	public ModelAndView updateCashPoint(
			HttpServletRequest request,Authentication auth,
			HttpSession session, @RequestParam Integer numPro) throws Exception{
		
		int amount=0;
		
		if (request.getParameter("amount")!=null && !request.getParameter("amount").equals("")) {
			amount = Integer.parseInt(request.getParameter("amount"));
			amount = (int)Math.floor((double)amount*1.1);
		}
		
		System.out.println(amount);
		
		ModelAndView mav = new ModelAndView();
		
		String userId = auth.getName();
		System.out.println(userId);
		
		MemberDTO memberDTO = dao.findById(userId);
		
		SponDetailDTO sponDetailDto = new SponDetailDTO();
		
		sponDetailDto.setUserId(userId);
		sponDetailDto.setDetail("+" + amount);
		sponDetailDto.setActiontype("charge");
		sponDetailDto.setDescription("충전_"+amount);
		sponDetailDto.setStatus("success");
		
		sponDetailDAO.insertData(sponDetailDto);
		
		articleDAO.updateCashPoint(userId, memberDTO.getCashPoint()+amount);
		
		PaymentDTO paymentDto = (PaymentDTO)session.getAttribute("paymentDto");
		
		if (numPro != null) {
			
			mav.setViewName("redirect:/article.action/"+numPro);
			return mav;
			
		}
		
		mav.setViewName("redirect:/memberInfo.action");
		
		return mav;
	}
	
	@RequestMapping(value = "/delete.action")
	public String deleteMember(Authentication auth) {
		
		String userId = auth.getName();
		
		List<ProjectDTO> proLists = proDao.getListsById(userId);
		
		for(ProjectDTO dto: proLists) {
			if(dto.getStatus()==1) {
				List<SponAmountDTO> sp = sponDAO.getAmountProject(dto.getNumPro());
				for(SponAmountDTO spdto: sp) {
					if(spdto.getPaid()==0) {
						MemberDTO smdto = dao.findById(spdto.getUserId());
						
						SponDetailDTO sponDetailDTO = new SponDetailDTO();
						sponDetailDTO.setUserId(smdto.getUserId());
						sponDetailDTO.setDetail("+" + spdto.getAmount());
						sponDetailDTO.setNumPro(dto.getNumPro());
						sponDetailDTO.setActiontype("fail");
						String subject = dto.getSubject(); 
						sponDetailDTO.setDescription("프로젝트취소_" +
						(subject.length()>8 ? subject.substring(0,8) + "...":subject));
						sponDetailDTO.setStatus("success");
						
						articleDAO.updateCashPoint(smdto.getUserId(), spdto.getAmount());
						sponDAO.updatePaid(spdto.getNumPro(), -1);
					}
				}
				proDao.updateStatus(dto.getNumPro(), -1);
			}
		}
		MemberDTO dto = dao.findById(userId);
		
		dto.setEnabled(0);
		dao.updateEnabled(dto);
		
		return "redirect:/logout.action";
	}
	
	@RequestMapping(value = "/checkPwd.action", method = {RequestMethod.POST})
	@ResponseBody
	public String checkPwd(@RequestParam("pwd") String pwd,Authentication auth) {
		
		String userId = auth.getName();
		
		
		if(userId.startsWith("kakao")) {
			return "success";
		}
		
		MemberDTO dto = dao.findById(userId);
		
		if(new BCryptPasswordEncoder().matches(pwd, dto.getPwd())) {
			return "success";
		}else {
			return "fail";
		}
	}
	
	@RequestMapping(value = "/updateNickname.action",method = {RequestMethod.POST})
	@ResponseBody
	public String updateNickname(Authentication auth,
			@RequestParam("nickname") String nickname) {
		String userId = auth.getName();
		
		MemberDTO dto = dao.findById(userId);
		dto.setNickname(nickname);
		
		dao.updateNickname(dto);
		
		return "success";
		
	}
	
	@RequestMapping(value = "/updateEmail.action",method = {RequestMethod.POST})
	@ResponseBody
	public String updateEmail(Authentication auth,
			@RequestParam("email") String email) {
		String userId = auth.getName();
		
		MemberDTO dto = dao.findById(userId);
		dto.setEmail(email);
		
		dao.updateEmail(dto);
		
		return "success";
		
	}
	
	@RequestMapping(value = "/updatePwd.action",method = {RequestMethod.POST})
	@ResponseBody
	public String updatePwd(Authentication auth,
			@RequestParam("currentPwd") String currentPwd,
			@RequestParam("changePwd") String changePwd) {
		String userId = auth.getName();
		
		MemberDTO dto = dao.findById(userId);
		
		if(!new BCryptPasswordEncoder().matches(currentPwd, dto.getPwd())) {
			return "mismatch";
		}
		
		dto.setPwd(new BCryptPasswordEncoder().encode(changePwd));
		dto.setTempPwd("n");
		
		dao.updatePwd(dto);
		
		return "success";
		
	}
	
	@RequestMapping(value = "/updatePhone.action",method = {RequestMethod.POST})
	@ResponseBody
	public String updatePhone(Authentication auth,
			@RequestParam("phone") String phone) {
		String userId = auth.getName();
		
		MemberDTO dto = dao.findById(userId);
		dto.setPhone(phone);
		
		dao.updatePhone(dto);
		
		return "success";
		
	}
	
	@RequestMapping(value = "/updateAddress.action",method = {RequestMethod.POST})
	@ResponseBody
	public String updateAddress(Authentication auth,
			@RequestParam("address") String address) {
		String userId = auth.getName();
		
		MemberDTO dto = dao.findById(userId);
		dto.setAddress(address);
		
		dao.updateAddress(dto);
		
		return "success";
		
	}
	
	@RequestMapping(value = "/cashUseList.action")
	public ModelAndView cashUseList(Authentication auth,HttpServletRequest request) {
		String userId = auth.getName();
		
		List<SponDetailDTO> sponLists = sponDetailDAO.getLists(userId);
		
		List<ProjectDTO> proLists = new ArrayList<ProjectDTO>();
		
		MemberDTO memdto = dao.findById(userId);
		
		for(SponDetailDTO dto : sponLists) {
			ProjectDTO prodto = proDao.getReadData(dto.getNumPro());
			
			dto.setAmount(Integer.parseInt(dto.getDetail().substring(1)));
			dto.setCreated(dto.getCreated().substring(0, 16));
			
			proLists.add(prodto);
		}
		
		String page = request.getParameter("page");
		
		int numPerPage = 10;
		int totalPages = 0;
		
		if(sponLists.size()%numPerPage!=0) {
			totalPages = sponLists.size()/numPerPage+1;
		}else if(sponLists.size()>0) {
			totalPages = sponLists.size()/numPerPage;
		}
		
		int currentPage = 1;
		
		if(page!=null && !page.equals("")) {
			currentPage = Integer.parseInt(page);
		}
		
		int start = (currentPage-1)*numPerPage;
		int end = currentPage*numPerPage-1;
		
		ModelAndView mav = new ModelAndView();
		
		List<CategoryListDTO> caLists = categoryListDAO.getLists();
		mav.addObject("caLists",caLists);
		
		mav.addObject("member",memdto);
		mav.addObject("sponLists",sponLists);
		mav.addObject("proLists",proLists);
		mav.addObject("totalPages",totalPages);
		mav.addObject("currentPage",currentPage);
		mav.addObject("start",start);
		mav.addObject("end",end);
		
		mav.setViewName("member/cashUseList");
		
		return mav;
	}
	
	@RequestMapping(value = "/sponList.action")
	public ModelAndView sponList(Authentication auth,HttpServletRequest request) {
		String userId = auth.getName();
		
		List<SponAmountDTO> sponLists = sponDAO.getSponLists(userId);
		
		List<ProjectDTO> proLists = new ArrayList<ProjectDTO>();
		
		for(SponAmountDTO spon : sponLists) {
			ProjectDTO prodto = proDao.getReadData(spon.getNumPro());
			spon.setCreated(spon.getCreated().substring(0,16));
			System.out.println(prodto.getNumPro() + " : " + prodto.getStatus());
			proLists.add(prodto);
			if(spon.getRewardId()!=null) {
				String[] reward = spon.getRewardId().split(",");
				String rewardId = "";
				for(int i=0;i<reward.length;i=i+2) {
					RewardDTO redto = rewardDAO.getRewardData(Integer.parseInt(reward[i]));
					rewardId += redto.getRewardSubject() + "-" + reward[i+1] + "개<br/>";
				}
				
				spon.setRewardId(rewardId);
			}
		}
		
		String page = request.getParameter("page");
		
		int numPerPage = 10;
		int totalPages = 0;
		
		if(sponLists.size()%numPerPage!=0) {
			totalPages = sponLists.size()/numPerPage+1;
		}else if(sponLists.size()>0) {
			totalPages = sponLists.size()/numPerPage;
		}
		
		int currentPage = 1;
		
		if(page!=null && !page.equals("")) {
			currentPage = Integer.parseInt(page);
		}
		
		int start = (currentPage-1)*numPerPage;
		int end = currentPage*numPerPage-1;
		
		ModelAndView mav = new ModelAndView();
		
		List<CategoryListDTO> caLists = categoryListDAO.getLists();
		mav.addObject("caLists",caLists);
		mav.addObject("sponLists",sponLists);
		mav.addObject("proLists",proLists);
		mav.addObject("totalPages",totalPages);
		mav.addObject("currentPage",currentPage);
		mav.addObject("start",start);
		mav.addObject("end",end);
		
		mav.setViewName("member/sponList");
		
		return mav;
		
	}
	
	@RequestMapping(value = "/sponCancel.action", method = {RequestMethod.POST})
	@ResponseBody
	public String sponCancel(@RequestParam("sponNum") int sponNum,
			Authentication auth) {

		System.out.println("aa1");
		
		String userId = auth.getName();
		
		SponAmountDTO spondto = sponDAO.getSponData(sponNum);
		
		spondto.setPaid(-2);
		
		sponDAO.sponCancel(spondto);
		
		MemberDTO memberDTO = dao.findById(userId);
		
		articleDAO.updateCashPoint(userId, memberDTO.getCashPoint()+spondto.getAmount());
		
		SponDetailDTO sponDetailDTO = sponDetailDAO.getSponDetailBySponNum(sponNum);
		
		sponDetailDTO.setStatus("cancel");
		sponDetailDAO.cancelSpon(sponDetailDTO);
		
		sponDetailDTO.setDetail("+" + spondto.getAmount());
		sponDetailDTO.setNumPro(spondto.getNumPro());
		sponDetailDTO.setActiontype("cancel");
		sponDetailDTO.setDescription("후원취소_" + 
				proDao.getReadData(spondto.getNumPro()).getSubject());
		if(proDao.getReadData(spondto.getNumPro()).getSubject().length()>8) {
			sponDetailDTO.setDescription("후원취소_" +
					proDao.getReadData(spondto.getNumPro()).getSubject().substring(0,8) + "..");
		}
		
		sponDetailDTO.setStatus("success");
		sponDetailDTO.setRewardId(0);
		
		sponDetailDAO.insertData(sponDetailDTO);
		
		return "success";
		
	}
	
	@RequestMapping(value = "/withdraw.action")
	public ModelAndView withdraw(Authentication auth) {
		String userId = auth.getName();
				
		List<WithdrawDTO> withdrawLists = dao.getWithdrawListsByUserId(userId);
		MemberDTO memberDTO = dao.findById(userId);
		for(WithdrawDTO wd:withdrawLists) {
			wd.setRequestDate(wd.getRequestDate().substring(0,16));
			if(wd.getProcessDate()!=null) {
				wd.setProcessDate(wd.getProcessDate().substring(0,16));
			}
		}
		ModelAndView mav = new ModelAndView();
		
		List<CategoryListDTO> caLists = categoryListDAO.getLists();
		mav.addObject("caLists",caLists);
		mav.addObject("withdrawLists",withdrawLists);
		mav.addObject("dto",memberDTO);
		
		mav.setViewName("member/withdraw");
		
		return mav;
	}
	
	@RequestMapping(value = "/cashWithdraw.action", method = {RequestMethod.POST})
	public ModelAndView cashWithdraw(Authentication auth,WithdrawDTO withdrawDTO) {
		
		String userId = auth.getName();
		
		withdrawDTO.setUserId(userId);
		withdrawDTO.setStatus("PENDING");
		int maxNum = dao.getWithdrawMaxNum();
		withdrawDTO.setWithdrawId(maxNum+1);
		
		dao.inserdWithdrawData(withdrawDTO);
		
		SponDetailDTO sponDetailDTO = new SponDetailDTO();
		
		sponDetailDTO.setUserId(userId);
		sponDetailDTO.setAmount(withdrawDTO.getAmount());
		sponDetailDTO.setStatus("PENDING");
		sponDetailDTO.setActiontype("withdraw");
		sponDetailDTO.setDescription("출금_" + withdrawDTO.getAmount());
		sponDetailDTO.setDetail("-" + withdrawDTO.getAmount());
		
		MemberDTO memberDTO = dao.findById(userId);
		
		sponDetailDAO.insertData(sponDetailDTO);
		articleDAO.updateCashPoint(userId, memberDTO.getCashPoint()-withdrawDTO.getAmount());
		
		ModelAndView mav = new ModelAndView();
		
		mav.setViewName("redirect:/withdraw.action");
		
		return mav;
		
	}
	
	@RequestMapping(value = "/cancelWithdraw.action/{id}")
	public String cancelWithdraw(@PathVariable("id") Integer withdrawId) {
		WithdrawDTO withdrawDTO = dao.getWithdrawDataByWithdrawId(withdrawId);
		withdrawDTO.setStatus("cancel");
		dao.processWithdraw(withdrawDTO);
		
		MemberDTO memberDTO = dao.findById(withdrawDTO.getUserId());
		memberDTO.setCashPoint(memberDTO.getCashPoint()+withdrawDTO.getAmount());
		articleDAO.updateCashPoint(withdrawDTO.getUserId(), memberDTO.getCashPoint());
		
		SponDetailDTO sponDetailDTO = sponDetailDAO.getSponDetail(withdrawDTO.getUserId(),
				withdrawDTO.getRequestDate().substring(0,19));
		
		sponDetailDTO.setCreated(sponDetailDTO.getCreated().substring(0,19));
		sponDetailDTO.setStatus("cancel");
		sponDetailDAO.cancelWithdraw(sponDetailDTO);
		sponDetailDTO.setStatus("success");
		sponDetailDTO.setActiontype("cancel");
		sponDetailDTO.setDescription("출금취소_" + withdrawDTO.getAmount());
		sponDetailDTO.setDetail("+" + withdrawDTO.getAmount());
		
		sponDetailDAO.insertData(sponDetailDTO);
		
		return "redirect:/withdraw.action";
	}
	
	@RequestMapping(value = "/adminBoard.action")
	public ModelAndView adminBoard() {
		ModelAndView mav = new ModelAndView();
		
		List<ProjectDTO> projectPendingLists = proDao.getPendingLists();
		List<ProjectDTO> projectSuccessLists = proDao.getSuccessLists();
		List<ProjectDTO> projectFailedLists = proDao.getFailedLists();
		List<WithdrawDTO> withdrawPendingLists = sponDetailDAO.getPendingWithdrawLists();
		List<CategoryListDTO> caLists = categoryListDAO.getLists();
		mav.addObject("caLists",caLists);
		mav.addObject("projectPendingLists",projectPendingLists);
		mav.addObject("projectSuccessLists",projectSuccessLists);
		mav.addObject("projectFailedLists",projectFailedLists);
		mav.addObject("withdrawPendingLists",withdrawPendingLists);
		mav.setViewName("member/adminBoard");
		
		return mav;
	}
	
	@RequestMapping(value = "/projectApprove.action",method = {RequestMethod.POST})
	@ResponseBody
	public String projectApprove(@RequestParam("id") Integer numPro) {
		proDao.updateStatus(numPro, 1);
		
		return "success";
	}
	
	@RequestMapping(value = "/projectReject.action",method = {RequestMethod.POST})
	@ResponseBody
	public String projectReject(@RequestParam("id") Integer numPro) {
		proDao.updateStatus(numPro, -2);
		
		return "success";
	}
	
	@RequestMapping(value = "/projectSuccessApprove.action",method = {RequestMethod.POST})
	@ResponseBody
	public String projectSuccessApprove(@RequestParam("id") Integer numPro) {
		
		proDao.updateStatus(numPro, 3);
		
		ProjectDTO dto = proDao.getReadData(numPro);
		
		MemberDTO memberDTO = dao.findById(dto.getUserId());
		
		List<SponAmountDTO> sponLists = sponDAO.getAmountProject(numPro);
		
		SponDetailDTO sponDetailDTO = new SponDetailDTO();
		
		int totalAmount = 0;
		for(SponAmountDTO sponDTO : sponLists) {
			totalAmount += sponDTO.getAmount();
			
			sponDAO.updatePaid(sponDTO.getSponNum(), 1);
		}
		
		articleDAO.updateCashPoint(memberDTO.getUserId(), memberDTO.getCashPoint()+totalAmount);
		
		sponDetailDTO.setActiontype("SUCCESS");
		String subject = dto.getSubject();
		sponDetailDTO.setDescription("프로젝트성공_" + 
		(subject.length()>8 ? (subject.substring(0,8) + ".."):subject));
		sponDetailDTO.setDetail("+" + totalAmount);
		sponDetailDTO.setNumPro(numPro);
		sponDetailDTO.setStatus("success");
		sponDetailDTO.setUserId(dto.getUserId());
		
		return "success";
	}
	
	@RequestMapping(value = "/projectSuccessReject.action",method = {RequestMethod.POST})
	@ResponseBody
	public String projectSuccessReject(@RequestParam("id") Integer numPro) {
		proDao.updateStatus(numPro, -2);
		
		return "success";
	}
	
	@RequestMapping(value = "/projectFailedApprove.action",method = {RequestMethod.POST})
	@ResponseBody
	public String projectFailedApprove(@RequestParam("id") Integer numPro) {
		proDao.updateStatus(numPro, -1);
		
		ProjectDTO dto = proDao.getReadData(numPro);
		
		List<SponAmountDTO> sponLists = sponDAO.getAmountProject(numPro);
		
		for(SponAmountDTO spondto : sponLists) {
			MemberDTO sponMemberDTO = dao.findById(spondto.getUserId());
			articleDAO.updateCashPoint(spondto.getUserId(), 
					sponMemberDTO.getCashPoint() + spondto.getAmount());
			
			sponDAO.updatePaid(spondto.getSponNum(), -1);
			
			SponDetailDTO sponDetailDTO = new SponDetailDTO();
			
			sponDetailDTO.setActiontype("failed");
			String subject = dto.getSubject();
			sponDetailDTO.setDescription("프로젝트실패_" + 
			(subject.length()>8 ? (subject.substring(0,8) + ".."):subject));
			sponDetailDTO.setDetail("+" + spondto.getAmount());
			sponDetailDTO.setNumPro(numPro);
			sponDetailDTO.setStatus("success");
			sponDetailDTO.setUserId(spondto.getUserId());
			
			sponDetailDAO.insertData(sponDetailDTO);
			
		}
		
		return "success";
	}
	
	@RequestMapping(value = "/projectFailedReject.action",method = {RequestMethod.POST})
	@ResponseBody
	public String projectFailedReject(@RequestParam("id") Integer numPro) {
		proDao.updateStatus(numPro, -2);
		
		return "success";
	}
	
	@RequestMapping(value = "/withdrawApprove",method = {RequestMethod.POST})
	@ResponseBody
	public String withdrawApprove(@RequestParam("id") Integer withdrawId) {
		WithdrawDTO withdrawDTO = dao.getWithdrawDataByWithdrawId(withdrawId);
		
		withdrawDTO.setStatus("success");
		
		dao.processWithdraw(withdrawDTO);
		
		return "success";
	}
	
	@RequestMapping(value = "/withdrawReject",method = {RequestMethod.POST})
	@ResponseBody
	public String withdrawReject(@RequestParam("id") Integer withdrawId) {
		WithdrawDTO withdrawDTO = dao.getWithdrawDataByWithdrawId(withdrawId);
		
		withdrawDTO.setStatus("failed");
		
		dao.processWithdraw(withdrawDTO);
		
		return "success";
	}
}
