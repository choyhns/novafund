package com.exe.fund.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import com.exe.fund.dao.ArticleDAO;
import com.exe.fund.dao.CategoryListDAO;
import com.exe.fund.dao.MemberDAO;
import com.exe.fund.dao.ProjectDAO;
import com.exe.fund.dao.SponAmountDAO;
import com.exe.fund.dao.SponDetailDAO;
import com.exe.fund.dto.CategoryListDTO;
import com.exe.fund.dto.ContentImageDTO;
import com.exe.fund.dto.MainImageDTO;
import com.exe.fund.dto.MemberDTO;
import com.exe.fund.dto.PaymentDTO;
import com.exe.fund.dto.ProjectDTO;
import com.exe.fund.dto.ReviewDTO;
import com.exe.fund.dto.RewardDTO;
import com.exe.fund.dto.SponAmountDTO;
import com.exe.fund.dto.SponDetailDTO;
import com.exe.fund.util.MyUtil;

@Controller
public class ArticleController {

	@Autowired
	ArticleDAO dao;

	@Autowired
	MemberDAO memberDao;

	@Autowired
	@Qualifier("sponDetailDAO")
	SponDetailDAO sponDetailDAO;

	@Autowired
	@Qualifier("projectDAO")
	ProjectDAO proDAO;

	@Autowired
	SponAmountDAO sponAmountDao;
	
	@Autowired
	@Qualifier("categoryListDAO")
	CategoryListDAO categoryListDAO;
	
	
	
	
	@RequestMapping(value = "/article.action/{numPro}", method = { RequestMethod.GET })
	public ModelAndView article(HttpServletRequest req, Authentication auth,
			@PathVariable int numPro)
			throws Exception {

		String userId = "";

		if (auth != null) {
			userId = auth.getName();
		}

		String cp = req.getContextPath();

		MyUtil myUtil = new MyUtil();

		String page= req.getParameter("page");

		// int numPro = 1;

		int currentPage = 1;

		if (page != null && !page.equals("")) {

			currentPage = Integer.parseInt(page);

		}

		int dataCount = dao.getDataCount(numPro);

		int numPerPage = 10;

		//int totalPage = myUtil.getPageCount(numPerPage, dataCount);

		int totalPages = 0;
		
		totalPages = dataCount / numPerPage;
		if(dataCount % numPerPage != 0) totalPages++;
		if(totalPages == 0) totalPages = 1;
		
		if (currentPage > totalPages) {

			currentPage = totalPages;
		}

		int start = (currentPage - 1) * numPerPage;
		int end = currentPage * numPerPage -1 ;

		dao.updateHitCount(numPro);

		ProjectDTO proDto = dao.getReadData(numPro);

		if (proDto == null) {

			ModelAndView mav = new ModelAndView();
			mav.setViewName("redirect:/list.action");

			return mav;
		}

		int paid = 0;

		if (proDto.getStatus() == 3) {
			paid = 1;
		} else if (proDto.getStatus() == -1) {
			paid = -1;
		}

		List<ReviewDTO> reviewLists = dao.getReadReviewLists(numPro, start, end);

		List<RewardDTO> rewardLists = dao.getReadRewardLists(numPro);

		List<MainImageDTO> mainImageLists = dao.getReadMainImageLists(numPro);

		List<ContentImageDTO> contentImageLists = dao.getReadContentImageLists(numPro);

		List<SponAmountDTO> sponLists = dao.getReadSponLists(numPro, paid);

		List<ProjectDTO> categoryLists = dao.getRandomCategoryLists(proDto.getCategoryName(), numPro);

		// List<MainImageDTO> categotyImageLists = new ArrayList<MainImageDTO>();

		if (categoryLists.size() < 6 && categoryLists.size() > 3) {

			categoryLists = categoryLists.subList(0, 3);

		}

		for (ProjectDTO dto : categoryLists) {

			dto.setMainImage(dao.getCategoryMainImage(dto.getNumPro()));

		}

		for (RewardDTO dto : rewardLists) {

			dto.setRewardContent(dto.getRewardContent().replaceAll("\r\n", "<br/>"));

		}

		
		
		double reviewGradeAvg = dao.getReviewGradeAVG(numPro);

		int sponAmount = dao.getSponAmountSum(numPro, paid);

		boolean searchGood = dao.searchGood(numPro, userId);

		String startDay = proDto.getStartDate();
		String endDay = proDto.getEndDate();
		LocalDate today = LocalDate.now();
		
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		LocalDate startDate = LocalDate.parse(startDay, formatter);
		LocalDate endDate = LocalDate.parse(endDay, formatter);

		//long daysBetween = ChronoUnit.DAYS.between(startDate, endDate);
		long daysBetween = ChronoUnit.DAYS.between(today, endDate);

		

		String listUrl = cp + "/article.action/" + numPro;

		String pageIndexList = myUtil.pageIndexList(currentPage, totalPages, listUrl);

		ModelAndView mav = new ModelAndView();
		
		List<CategoryListDTO> caLists = categoryListDAO.getLists();
		mav.addObject("caLists",caLists);
		mav.addObject("proDto", proDto);
		mav.addObject("reviewLists", reviewLists);
		mav.addObject("rewardLists", rewardLists);
		mav.addObject("sponAmount", sponAmount);
		mav.addObject("daysBetween", daysBetween);
		mav.addObject("good", searchGood);
		mav.addObject("mainImageLists", mainImageLists);
		mav.addObject("contentImageLists", contentImageLists);
		//mav.addObject("pageIndexList", pageIndexList);
		mav.addObject("reviewGradeAvg", reviewGradeAvg);
		mav.addObject("sponLists", sponLists);
		mav.addObject("categoryLists", categoryLists);
		mav.addObject("dataCount", dataCount);
		mav.addObject("status", proDto.getStatus());
		mav.addObject("start", start);
		mav.addObject("end", end);
		mav.addObject("totalPages", totalPages);
		mav.addObject("currentPage", currentPage);
		// mav.addObject("categotyImageLists", categotyImageLists);

		mav.setViewName("article");

		return mav;

	}

	@ResponseBody
	@RequestMapping(value = "/article/good/{numPro}", method = { RequestMethod.POST })
	public String updateGood(@PathVariable Integer numPro, HttpSession session, Authentication auth) throws Exception {

		if (auth == null || !auth.isAuthenticated()) {

			return "notLogin";
		}

		String userId = "";

		if (auth != null) {
			userId = auth.getName();
		}

		boolean searchGood = dao.good(numPro, userId);

		return searchGood ? "addGood" : "removeGood";

	}

	@RequestMapping(value = "/reviewUpload.action/{numPro}", method = { RequestMethod.POST })
	public String reviewUpload(MultipartHttpServletRequest request, ReviewDTO reviewDTO, @PathVariable Integer numPro,
			Authentication auth) {

		String userId = "";

		if (auth != null) {
			userId = auth.getName();
		}

		String path = request.getSession().getServletContext().getRealPath("/resources/image");

		MultipartFile file = request.getFile("realFile");
		String originalFileName = null;
		String saveFileName = null;

		if (file != null && file.getSize() > 0) {

			originalFileName = file.getOriginalFilename();
			String ext = originalFileName.substring(originalFileName.lastIndexOf("."));
			saveFileName = UUID.randomUUID().toString() + ext;

			File dir = new File(path);
			if (!dir.exists()) {
				dir.mkdirs(); // ���� �ڵ� ����
			}

			try {
				InputStream is = file.getInputStream();

				FileOutputStream fos = new FileOutputStream(path + "/" + saveFileName);
				FileCopyUtils.copy(is, fos);

				is.close();
				fos.close();

			} catch (Exception e) {
				System.out.println(e.toString());
			}
		}

		reviewDTO.setNumPro(numPro);
		reviewDTO.setNumRev(dao.getMaxNumReview() + 1);
		reviewDTO.setOriginalFileName(originalFileName);
		reviewDTO.setSaveFileName(saveFileName);
		reviewDTO.setUserId(userId);

		reviewDTO.setGroupNum(reviewDTO.getNumRev());
		reviewDTO.setDepth(0);
		reviewDTO.setOrderNo(0);
		reviewDTO.setParent(0);

		dao.insertReview(reviewDTO);

		return "redirect:/article.action/" + numPro;
	}

	@ResponseBody
	@RequestMapping(value = "reviewUpdate.action", method = RequestMethod.POST)
	public String updateReview(MultipartHttpServletRequest request, ReviewDTO reviewDTO, Authentication auth) {

		String userId = "";

		if (auth != null) {
			userId = auth.getName();
		}

		String imagePath = "";

		String originalFileName = null;
		String ext = null;
		String saveFileName = null;

		try {

			if (reviewDTO.getModifyFile() != null && !reviewDTO.getModifyFile().isEmpty()) {

				String path = request.getSession().getServletContext().getRealPath("/resources/image");

				File file = new File(path, reviewDTO.getOriginalFileName());

				file.delete();

				originalFileName = reviewDTO.getModifyFile().getOriginalFilename();
				ext = originalFileName.substring(originalFileName.lastIndexOf("."));
				saveFileName = UUID.randomUUID().toString() + ext;

				InputStream is = reviewDTO.getModifyFile().getInputStream();

				FileOutputStream fos = new FileOutputStream(path + "/" + saveFileName);
				FileCopyUtils.copy(is, fos);

				is.close();
				fos.close();

				imagePath = "image/" + saveFileName;

			}

			reviewDTO.setOriginalFileName(originalFileName);
			reviewDTO.setSaveFileName(saveFileName);
			reviewDTO.setUserId(userId);

			dao.updateReview(reviewDTO);

		} catch (Exception e) {
			e.toString();
			return "fail|" + e.getMessage();
		}

		return "success|" + imagePath;

	}

	@RequestMapping(value = "/reviewDelete.action/{numRev}/{numPro}/{userId}/{page}", method = { RequestMethod.GET })
	public String deleteReview(ReviewDTO reviewDTO, @PathVariable Integer numRev, @PathVariable Integer numPro,
			Authentication auth, @PathVariable String page) {

		String userId = "";

		int pageNum = 1;

		if (auth != null) {
			userId = auth.getName();
		}

		if (page != null && !page.equals("null")) {

			pageNum = Integer.parseInt(page);

		}
		dao.deleteReview(numRev, numPro, userId);

		return "redirect:/article.action/" + numPro + "?page=" + pageNum;

	}

	@ResponseBody
	@RequestMapping(value = "/reply.action/{parentNumRev}", method = { RequestMethod.POST })
	public String replyUpload(ReviewDTO reviewDTO, @PathVariable Integer parentNumRev, Authentication auth) {

		String userId = "";

		if (auth != null) {
			userId = auth.getName();
		}

		ReviewDTO parentDto = dao.getReviewData(parentNumRev, reviewDTO.getNumPro());

		dao.updateOrderNo(parentDto.getGroupNum(), reviewDTO.getNumPro(), parentDto.getOrderNo());

		reviewDTO.setGroupNum(parentDto.getGroupNum());
		reviewDTO.setDepth(parentDto.getDepth() + 1);
		reviewDTO.setOrderNo(parentDto.getOrderNo() + 1);
		reviewDTO.setParent(parentNumRev);
		reviewDTO.setNumRev(dao.getMaxNumReview() + 1);
		reviewDTO.setUserId(userId);

		dao.insertReview(reviewDTO);

		return "success";
	}

	@RequestMapping(value = "/user/reward.action/{numPro}/{rewardIndex}", method = { RequestMethod.GET })
	public String reward(@PathVariable Integer numPro, HttpServletRequest req, @PathVariable Integer rewardIndex) {

		if (rewardIndex != null) {

			req.setAttribute("rewardIndex", rewardIndex);

		}

		ProjectDTO dto = dao.getReadData(numPro);

		List<RewardDTO> rewardLists = dao.getReadRewardLists(numPro);

		for (RewardDTO rd : rewardLists) {

			rd.setRewardSubject(rd.getRewardSubject().replaceAll("\r\n", "<br/>"));

			rd.setRewardContent(rd.getRewardContent().replaceAll("\r\n", "<br/>"));
			;

		}

		req.setAttribute("dto", dto);
		req.setAttribute("numPro", numPro);
		req.setAttribute("rewardLists", rewardLists);

		return "reward";

	}

	@RequestMapping(value = "/purchase.action/{numPro}", method = { RequestMethod.POST })
	public String purchase(HttpServletRequest req, Authentication auth, @PathVariable Integer numPro) {

		String userId = "";

		String mailNum = "";
		String address = "";
		String detailAddress = "";

		if (auth != null) {

			userId = auth.getName();

		}

		MemberDTO memberDto = memberDao.findById(userId);

		if (memberDto.getAddress() != null && !memberDto.getAddress().equals("")) {

			String[] arr = memberDto.getAddress().split("\\|");

			mailNum = arr[0];
			address = arr[1];
			detailAddress = arr[2];

		}

		String[] selectedIndexes = req.getParameterValues("rewardSelected");
		String[] selectedSubject = req.getParameterValues("rewardSubject");
		String[] selectedContents = req.getParameterValues("rewardContent");
		String[] quantities = req.getParameterValues("rewardQuantity");
		String[] amounts = req.getParameterValues("amount");
		String[] rewardIds = req.getParameterValues("rewardId");

		String subject = "";
		String content = "";
		int quantity = 0;
		int amount = 0;
		int rewardId = 0;

		String reward = "";

		int sum = 0;

		List<RewardDTO> rewardLists = new ArrayList<RewardDTO>();

		if (selectedIndexes != null && selectedIndexes.length > 0) {

			for (String idx : selectedIndexes) {

				RewardDTO rewardDto = new RewardDTO();

				subject = req.getParameter("rewardSubject" + idx);
				content = req.getParameter("rewardContent" + idx);
				quantity = Integer.parseInt(req.getParameter("rewardQuantity" + idx));
				amount = Integer.parseInt(req.getParameter("amount" + idx));
				rewardId = Integer.parseInt(req.getParameter("rewardId" + idx));

				reward += rewardId + "," + quantity + ",";

				rewardDto.setRewardSubject(subject);
				rewardDto.setRewardContent(content);
				rewardDto.setRewardQuantity(quantity);
				rewardDto.setAmount(amount);
				rewardDto.setRewardId(rewardId);

				sum += amount * quantity;

				rewardLists.add(rewardDto);

			}

		} else {
			System.out.println("에러");
		}

		String money = req.getParameter("addMoney");
		int addMoney = 0;

		if (money != null) {
			addMoney = Integer.parseInt(money);
			System.out.println(addMoney);

			sum += addMoney;

		}

		reward = reward.substring(0, reward.length() - 1);

		req.setAttribute("addMoney", addMoney);
		req.setAttribute("sum", sum);
		req.setAttribute("rewardLists", rewardLists);
		req.setAttribute("mailNum", mailNum);
		req.setAttribute("address", address);
		req.setAttribute("detailAddress", detailAddress);
		req.setAttribute("numPro", numPro);
		req.setAttribute("point", memberDto.getCashPoint());
		req.setAttribute("reward", reward);

		return "purchase";
	}

	@RequestMapping(value = "/complete.action/{numPro}", method = { RequestMethod.POST })
	public String complete(@PathVariable Integer numPro, HttpServletRequest req, Authentication auth) {


		String userId = "";

		int sum = 0;

		if (auth != null) {
			userId = auth.getName();
		}

		String s = req.getParameter("sum");

		if (s != null) {
			sum = Integer.parseInt(s);
		}

		String address = req.getParameter("address");

		MemberDTO memberDto = memberDao.findById(userId);

		if (memberDto.getAddress() == null || memberDto.getAddress().equals("")
				|| !address.equals(memberDto.getAddress())) {

			dao.insertAddress(userId, address);
		}

		dao.updateCashPoint(userId, (memberDto.getCashPoint() - sum));

		SponDetailDTO spondto = new SponDetailDTO();
		spondto.setUserId(userId);
		spondto.setDetail("-" + sum);
		spondto.setNumPro(numPro);
		spondto.setActiontype("use");

		String desription = "";

		if (proDAO.getReadData(numPro).getSubject().length() < 8) {
			spondto.setDescription("프로젝트 후원_" + proDAO.getReadData(numPro).getSubject());
		} else {
			spondto.setDescription("프로젝트 후원_" + proDAO.getReadData(numPro).getSubject().substring(0, 8) + "..");
		}

		spondto.setStatus("success");

		int sponNum = dao.getMaxNumSpon() + 1;

		spondto.setSponNum(sponNum);

		sponDetailDAO.insertData(spondto);

		String rewardId = req.getParameter("reward");

		dao.insertSpon(userId, sum, numPro, sponNum, rewardId);

		ProjectDTO proDto = dao.getReadData(numPro);

		SponAmountDTO sponAmountDTO = sponAmountDao.getSponData(sponNum);

		req.setAttribute("proDto", proDto);
		req.setAttribute("sum", sum);
		req.setAttribute("time", sponAmountDTO.getCreated());
		req.setAttribute("sponNum", sponNum);

		return "complete";

	}

	

}
