package com.exe.fund.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.exe.fund.dto.ContentImageDTO;
import com.exe.fund.dto.MainImageDTO;

@Repository
public class ImageFileDAO {

	@Autowired
	@Qualifier("sessionTemplate")
	private SqlSessionTemplate sessionTemplate;
	
	public void insertContentImage(ContentImageDTO cidto) {
		
		sessionTemplate.insert("com.fund.image.insertContentImage",cidto);
		
	}
	
	public void insertMainImage(MainImageDTO midto) {
		
		sessionTemplate.insert("com.fund.image.insertMainImage",midto);
		
	}
	
	public List<ContentImageDTO> getContentImages(int numPro){
		return sessionTemplate.selectList("com.fund.image.getContentImages", numPro);
		
	}

	public List<MainImageDTO> getMainImages(int numPro){
		return sessionTemplate.selectList("com.fund.image.getMainImages", numPro);
	}

	public void updateMainImages(MainImageDTO midto) {
		sessionTemplate.update("com.fund.image.updateMainImage",midto);
	}
	
	public void updateContentImages(ContentImageDTO cidto) {
		sessionTemplate.update("com.fund.image.updateContentImage",cidto);
	}
	
	
	public int deleteMainImage(MainImageDTO midto) {		
		return sessionTemplate.delete("com.fund.image.deleteMainImage",midto);
	}
	
	public int deleteContentImage(ContentImageDTO cidto) {
		return sessionTemplate.delete("com.fund.image.deleteContentImage", cidto);
	}
	
	public MainImageDTO getMainImageBySaveNameAndNumPro(int numPro,String saveName){
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("numPro", numPro);
		param.put("saveName", saveName);		
		return sessionTemplate.selectOne("com.fund.image.getMainImageBySaveNameAndNumPro", param);
		
	}
	
	public ContentImageDTO getContentImageBySaveNameAndNumPro(int numPro,String saveName){
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("numPro", numPro);
		param.put("saveName", saveName);		
		return sessionTemplate.selectOne("com.fund.image.getContentImageBySaveNameAndNumPro", param);
		
	}
	
	public int deleteMainImagesAll(int numPro) {
		return sessionTemplate.delete("com.fund.image.deleteMainImagesAll", numPro);
	}
	public int deleteContentImagesAll(int numPro) {
		return sessionTemplate.delete("com.fund.image.deleteContentImagesAll", numPro);
	}
}
