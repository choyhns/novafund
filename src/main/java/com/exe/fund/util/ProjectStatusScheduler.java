package com.exe.fund.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.exe.fund.dao.ProjectDAO;
import com.exe.fund.dao.SponAmountDAO;
import com.exe.fund.dto.ProjectDTO;

@Component
public class ProjectStatusScheduler {

	@Autowired
	@Qualifier("projectDAO")
	ProjectDAO projectDAO;
	
	@Autowired
	@Qualifier("sponAmountDAO")
	SponAmountDAO sponAmountDAO;
	
	@Scheduled(cron = "0 0/60 * * * ?")
	public void checkProjectAndUpdateStatus() {

		List<ProjectDTO> lists = projectDAO.getProgressLists();
		
		LocalDateTime now = LocalDateTime.now();
		
		DateTimeFormatter format = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.S");
		for(ProjectDTO project: lists) {
			
			Integer numPro = project.getNumPro();
			
			LocalDateTime endDate = LocalDateTime.parse(project.getEndDate(),format);
			
			if(endDate.isBefore(now)) {
				
				if(project.getGoalAmount()<=
						sponAmountDAO.getTotalSponAmount(numPro)) {
						System.out.println("suc");
					project.setStatus(2);
				}else {
					project.setStatus(-1);
				}
				
				projectDAO.updateStatus(numPro, project.getStatus());
			}
		}
	}
	
}
