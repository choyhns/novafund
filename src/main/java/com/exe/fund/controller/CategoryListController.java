package com.exe.fund.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.exe.fund.dao.CategoryListDAO;
import com.exe.fund.dto.CategoryListDTO;

@Controller
public class CategoryListController {
	
	@Autowired
	@Qualifier("categoryListDAO")
	private CategoryListDAO categoryListDAO;
	

	
	

}
