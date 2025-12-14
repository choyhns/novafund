package com.exe.fund.dao;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.exe.fund.dto.CategoryListDTO;


@Repository
public class CategoryListDAO {
	
	@Autowired
	@Qualifier("sessionTemplate")
	private SqlSessionTemplate sessionTemplate;
	
	
	
	public List<CategoryListDTO> getLists(){
		
		List<CategoryListDTO> lists = sessionTemplate.selectList("com.fund.categoryList.getLists");
		
		return lists;
		
	}
	
}
