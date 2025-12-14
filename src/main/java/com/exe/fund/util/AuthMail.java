package com.exe.fund.util;

import java.net.PasswordAuthentication;
import java.security.SecureRandom;
import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import lombok.Data;

@Data
public class AuthMail {
	
	private String receiverEmail;
	private String senderEmail;
	private String senderName;
	private String subject;
	private String content;
	private String authNum;
	private String tempPwd;
	
	private String mailHost;
	private String mailType;
	
	public AuthMail() {
		this.mailHost = "smtp.naver.com";
		this.mailType = "text/html;charset=UTF-8";
		this.senderEmail = "choyhns@naver.com";
		this.senderName = "NovaFunding";
		this.subject = "NovaFunding 인증번호";
		SecureRandom sr = new SecureRandom();
		this.authNum = "" +  (100000 + sr.nextInt(900000));
		
		int length = 10;
		String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
		StringBuilder sb = new StringBuilder();
		SecureRandom random = new SecureRandom();
		
		for (int i = 0; i < length; i++) {
			sb.append(chars.charAt(random.nextInt(chars.length())));
		}

		this.tempPwd = sb.toString();
	}
	
	public void setContentAuthNum(String authNum) {
		this.content = "<div style='font-family:Arial,sans-serif; padding:20px; border:1px solid #ddd; border-radius:8px;'>"
	             + "<h2 style='color:#20b2aa;'>NovaFunding 이메일 인증</h2>"
	             + "<p>안녕하세요, NovaFunding 회원님 👋</p>"
	             + "<p>아래 인증번호를 입력하시면 이메일 인증이 완료됩니다.</p>"
	             + "<div style='margin:20px 0; padding:15px; border:1px dashed #20b2aa; text-align:center;'>"
	             + "<span style='font-size:24px; font-weight:bold; color:#20b2aa;'>" + authNum + "</span>"
	             + "</div>"
	             + "<p style='color:#888;'>※ 본 메일은 발신전용입니다. 인증번호는 5분간만 유효합니다.</p>"
	             + "</div>";
	}
	
	public void setContentTempPwd(String tempPwd) {
		this.content = "<div style='font-family:Arial,sans-serif; padding:20px; border:1px solid #ddd; border-radius:8px;'>"
	             + "<h2 style='color:#20b2aa;'>NovaFunding 임시 비밀번호 안내</h2>"
	             + "<p>안녕하세요, NovaFunding 회원님 👋</p>"
	             + "<p>요청하신 계정의 임시 비밀번호가 발급되었습니다.<br>"
	             + "아래 임시 비밀번호로 로그인 후 반드시 새 비밀번호로 변경해 주세요.</p>"
	             + "<div style='margin:20px 0; padding:15px; border:1px dashed #20b2aa; text-align:center;'>"
	             + "<span style='font-size:24px; font-weight:bold; color:#20b2aa;'>" + tempPwd + "</span>"
	             + "</div>"
	             + "<p style='color:#888;'>※ 본 메일은 발신전용입니다.<br>"
	             + "※ 임시 비밀번호는 보안을 위해 최초 로그인 시 즉시 변경하시길 권장합니다.</p>"
	             + "</div>";
	}
	
	public boolean sendMail() {
		
		try {
			Properties props = System.getProperties();
			props.put("mail.smtp.host", mailHost);
			props.put("mail.smtp.port", "587");
			props.put("mail.smtp.auth", "true");
			props.put("mail.smtp.starttls", "true");
			
			Session session = Session.getInstance(props, new Authenticator() {
				@Override
				protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
					return new javax.mail.PasswordAuthentication(senderEmail, "NJNMUFQMZ5QT");
				}
			});
			
			Message msg = new MimeMessage(session);
			
			msg.setFrom(new InternetAddress(senderEmail, senderName, "UTF-8"));
			
			msg.setRecipients(Message.RecipientType.TO, 
					InternetAddress.parse(receiverEmail));
			
			msg.setSubject(subject);
			msg.setContent(content,mailType);
			msg.setHeader("X-Mailer", senderEmail);
			msg.setSentDate(new Date());
			
			Transport.send(msg);
			
		} catch (MessagingException e) {
			System.out.println(e.toString());
			return false;
		}catch (Exception e) {
			System.out.println(e.toString());
			return false;
		}
		return true;
	}
}