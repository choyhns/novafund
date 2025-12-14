package com.exe.fund.dao;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.exe.fund.dao.CategoryListDAO;
import com.exe.fund.dto.CategoryListDTO;
import com.exe.fund.dto.ContentImageDTO;
import com.exe.fund.dto.ProjectDTO;


@Repository
public class ProjectDAO {
	
	@Autowired
	@Qualifier("sessionTemplate")
	private SqlSessionTemplate sessionTemplate;
	
	
	public int getMaxNum() {
		
		int maxNum = 0;
		maxNum = sessionTemplate.selectOne("com.fund.project.maxNum");

		return maxNum;
	}
	
	public void insertData(ProjectDTO pdto) {

		sessionTemplate.insert("com.fund.project.insertData", pdto);

	}
	
	// 검색어와 카테고리 조건으로 전체 데이터 개수 조회
	public int getDataCount(String searchValue,String categoryName) {

		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("searchValue", searchValue);
		params.put("categoryName", categoryName);
		
		return sessionTemplate.selectOne("com.fund.project.getDataCount", params);
		
	}
	
	// 시작/끝 번호, 검색어, 카테고리명, 정렬 타입(today/created 등)을 조건으로 조회
	public List<ProjectDTO> getLists(int start, int end,
			String searchValue, String categoryName, String type, int status){

		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("start", start);
		params.put("end", end);
		params.put("searchValue", searchValue);
		params.put("categoryName", categoryName);
		params.put("status", status);
		
		if (type == null || type.trim().isEmpty()) {
	        type = "created";
	    }
		params.put("sortType", type);
		
		List<ProjectDTO> lists = null;
		
		lists = sessionTemplate.selectList("com.fund.project.getLists", params);
		   
		return lists;

	}
	
	// 전체 프로젝트 개수 조회 (검색어/카테고리 없이)
	public int getAllDataCount() {
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("searchValue", "");
		params.put("categoryName", "");
		
		return sessionTemplate.selectOne("com.fund.project.getDataCount", params);
		
	}

	
	public List<ProjectDTO> getCategorys(int start, int end, String categoryName){
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("start", start);
		params.put("end", end);
		params.put("searchValue", "");
		params.put("categoryName", categoryName);
		
		return sessionTemplate.selectList("com.project.getLists", params);

	}

	
	//단일 프로젝트 상세 조회
	public ProjectDTO getReadData(int numPro) {
		
		return sessionTemplate.selectOne("com.fund.project.getReadData", numPro);
	}
	
	public List<ProjectDTO> getListsById(String userId){
		return sessionTemplate.selectList("com.fund.project.findById",userId);
	}
	
	public List<ProjectDTO> getWishListById(String userId){
		return sessionTemplate.selectList("com.fund.project.wishlist",userId);
	}
	
	public void updateData(ProjectDTO dto) {
		sessionTemplate.update("com.fund.project.updateData", dto);
	}
	

	public void updateStatus(int numPro,int status) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("numPro", numPro);
		map.put("status", status);
		sessionTemplate.update("com.fund.project.updateStatus",map);
	}

	public int deleteData(int numPro) {
		return sessionTemplate.delete("com.fund.project.deleteData", numPro);
	}
	
	public List<ProjectDTO> getProgressLists(){
		return sessionTemplate.selectList("com.fund.project.getProgressLists");
	}
	
	public List<ProjectDTO> getSuccessLists(){
		return sessionTemplate.selectList("com.fund.project.getSuccessLists");
	}
	
	public List<ProjectDTO> getFailedLists(){
		return sessionTemplate.selectList("com.fund.project.getFailedLists");
	}
	
	public List<ProjectDTO> getPendingLists(){
		return sessionTemplate.selectList("com.fund.project.getPendingLists");
	}
}
