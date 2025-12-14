package com.exe.fund.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

import com.exe.fund.dto.CategoryListDTO;
import com.exe.fund.dto.ContentImageDTO;
import com.exe.fund.dto.MainImageDTO;
import com.exe.fund.dto.ProjectDTO;
import com.exe.fund.dto.ReviewDTO;
import com.exe.fund.dto.RewardDTO;
import com.exe.fund.dto.SponAmountDTO;

import oracle.net.aso.h;

@Repository
public class ArticleDAO {
	
	@Autowired
	@Qualifier("sessionTemplate")
	private SqlSessionTemplate sessionTemplate;
	
	
	//numPro�� ������Ʈ �ϳ� ��������
	public ProjectDTO getReadData(int numPro) {
		
		
		ProjectDTO projectDTO = sessionTemplate.selectOne("com.article.getReadProject"
				,numPro);
		
		return projectDTO;
		
	}
	
	//hitCount update
	public void updateHitCount(int numPro) {
		
		sessionTemplate.update("com.article.updateHitCount",numPro);
		
	}
	

		
		//select amountSum
		public int getSponAmountSum(int numPro,int paid) {
			
			Map<String, Integer> hMap = new HashMap<String, Integer>();
			
			hMap.put("numPro", numPro);
			hMap.put("paid", paid);
			
			return sessionTemplate.selectOne("com.article.getSponAmountSum", hMap);
			
		}
		
		
		//search good
		public boolean good(int numPro,String userId) {
							
			Map<String, Object> hMap = new HashMap<String, Object>();
			
			hMap.put("numPro", numPro);
			hMap.put("userId", userId);
			
			int result = sessionTemplate.selectOne("com.article.searchGood", hMap);
			
			String flag = "";
			
			if (result > 0) {
				
				sessionTemplate.update("com.article.decreaseGood",numPro);
				sessionTemplate.delete("com.article.deleteGood",hMap);
				flag = "delete";
				hMap.put("flag", flag);
				sessionTemplate.update("com.article.insertOrDeleteWishlist", hMap);
				
				return false;
				
			}else {
			
				sessionTemplate.update("com.article.increaseGood",numPro);
				sessionTemplate.insert("com.article.insertGood",hMap);
				flag = "insert";
				hMap.put("flag", flag);
				sessionTemplate.update("com.article.insertOrDeleteWishlist", hMap);
				
				return true;
				
			}
		}
			
			//search good
			public boolean searchGood(int numPro,String userId) {
								
				Map<String, Object> hMap = new HashMap<String, Object>();
				
				hMap.put("numPro", numPro);
				hMap.put("userId", userId);
				
				int result = sessionTemplate.selectOne("com.article.searchGood", hMap);
				
				if (result > 0) {
					
					return false;
					
				}else {
					
					return true;
					
				}
			
		}
			
			public List<MainImageDTO> getReadMainImageLists(int numPro){
				
				List<MainImageDTO> lists = new ArrayList<MainImageDTO>();
				
				lists = sessionTemplate.selectList("com.article.getReadMainImageLists", numPro);
				
				return lists;
				
			}
			
			public List<ContentImageDTO> getReadContentImageLists(int numPro){
				
				List<ContentImageDTO> lists = new ArrayList<ContentImageDTO>();
				
				lists = sessionTemplate.selectList("com.article.getReadContentImageLists", numPro);
				
				return lists;
				
			}
			
			public int getMaxNumReview() {
				
				return sessionTemplate.selectOne("com.article.getMaxNumReview");
			}
			
			public int getMaxNumSpon() {
				
				return sessionTemplate.selectOne("com.article.getMaxNumSpon");
			}
			
			//select reviewList
			public List<ReviewDTO> getReadReviewLists(int numPro,int start,int end){
				
				List<ReviewDTO> lists = new ArrayList<ReviewDTO>();
				
				Map<String, Integer> hMap = new HashMap<String, Integer>();
				
				hMap.put("numPro", numPro);
				hMap.put("start", start);
				hMap.put("end", end);
				
				lists = sessionTemplate.selectList("com.article.getReadReviewLists", hMap);
				
				return lists;
				
			}
			
			//select rewardLists
				public List<RewardDTO> getReadRewardLists(int numPro){
					
					List<RewardDTO> lists = new ArrayList<RewardDTO>();
					
					lists = sessionTemplate.selectList("com.article.getReadRewardLists", numPro);
					
					return lists;
					
				}
				
				//insert review
				public void insertReview(ReviewDTO dto) {
					
					sessionTemplate.insert("com.article.insertReview",dto);
					
				}
				
				
				//update Review
				public void updateReview(ReviewDTO dto) {
					
					sessionTemplate.update("com.article.updateReview",dto);
					
				}
				
				
				//delete Review
				public void deleteReview(int numRev,int numPro,String userId) {
					
					Map<String, Object> hMap = new HashMap<String, Object>();
					
					hMap.put("numRev",numRev);
					hMap.put("numPro",numPro);
					hMap.put("userId",userId);
					
					sessionTemplate.update("com.article.deleteReview",hMap);
					
				}
				
				public int getDataCount(int numPro) {
					
					return sessionTemplate.selectOne("com.article.getDataCount",numPro);
					
				}
				
				//update orderNo
				public void updateOrderNo(int groupNum,int numPro,int orderNo) {
					
					Map<String, Integer> hMap = new HashMap<String, Integer>();
					
					hMap.put("groupNum",groupNum);
					hMap.put("numPro",numPro);
					hMap.put("orderNo",orderNo);
					
					sessionTemplate.update("com.article.updateOrderNo",hMap);
					
				}
				
				public ReviewDTO getReviewData(int numRev,int numPro) {
					
					Map<String, Object> hMap = new HashMap<String, Object>();
					
					hMap.put("numRev",numRev);
					hMap.put("numPro",numPro);
					
					return sessionTemplate.selectOne("com.article.getReviewData",hMap);
					
				}
				
				//get reviewGradeAVG
				public double getReviewGradeAVG(int numPro) {
					
					return sessionTemplate.selectOne("com.article.getReviewGradeAVG",numPro);
					
				}
				
				//getReadSponLists
				public List<SponAmountDTO> getReadSponLists(int numPro,int paid) {
					
					Map<String, Integer> hMap = new HashMap<String, Integer>();
					
					hMap.put("numPro", numPro);
					hMap.put("paid", paid);
					
					List<SponAmountDTO> lists = new ArrayList<SponAmountDTO>();
					
					lists = sessionTemplate.selectList("com.article.getReadSponLists",hMap);
					
					return lists;
				}
				
				//getRandomCategoryLists
				public List<ProjectDTO> getRandomCategoryLists(String categoryName,int numPro) {
					
					Map<String, Object> hMap = new HashMap<String, Object>();
					
					hMap.put("categoryName",categoryName);
					hMap.put("numPro",numPro);
					
					List<ProjectDTO> lists = new ArrayList<ProjectDTO>();
					
					lists = sessionTemplate.selectList("com.article.getRandomCategoryLists",hMap);
					
					return lists;
				}
				
				//getCategoryMainImage
				public MainImageDTO getCategoryMainImage(int numPro) {
					
					return sessionTemplate.selectOne("com.article.getCategoryMainImage",numPro);
					
				}
				

				//insertAddress
				public void insertAddress(String userId,String address) {
					
					Map<String, Object> hMap = new HashMap<String, Object>();
					
					hMap.put("userId",userId);
					hMap.put("address",address);
					
					sessionTemplate.insert("com.article.insertAddress",hMap);
					
				}
				
				//updateCashPoint
				public void updateCashPoint(String userId,int cashPoint) {
					
					Map<String, Object> hMap = new HashMap<String, Object>();
					
					hMap.put("userId",userId);
					hMap.put("cashPoint",cashPoint);
					
					sessionTemplate.insert("com.article.updateCashPoint",hMap);
					
				}
				
				//insertSpon

				public void insertSpon(String userId,int amount,int numPro,int sponNum,String rewardId) {

					
					Map<String, Object> hMap = new HashMap<String, Object>();
					
					hMap.put("userId",userId);
					hMap.put("amount",amount);
					hMap.put("numPro",numPro);

					hMap.put("sponNum",sponNum);
					hMap.put("rewardId",rewardId);

					
					sessionTemplate.insert("com.article.insertSpon",hMap);
					
				}
				
				

				public List<Integer> getNumProLists(String userId) {
					return sessionTemplate.selectList("com.article.goodLists", userId);
				}
				
				public int getPointByUserId(String userId) {
					
					return sessionTemplate.selectOne("com.article.getPointByUserId",userId);
				}
				public void deleteWishList(int numPro) {
					sessionTemplate.delete("com.article.deleteWishList",numPro);
				}

				public void deleteGoodByNumPro(int numPro) {
					sessionTemplate.delete("com.article.deleteGoodByNumPro",numPro);
				}
				
				public void deleteReviewLists(int numPro) {
					sessionTemplate.delete("com.article.deleteReviewLists",numPro);
				}
	

}
