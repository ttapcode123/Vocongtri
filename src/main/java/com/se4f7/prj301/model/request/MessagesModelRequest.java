package com.se4f7.prj301.model.request;

import com.se4f7.prj301.enums.StatusEnum;

public class MessagesModelRequest {
	private Long id;
	private String createdDate;
	private String subject;
	private String email;
	private StatusEnum status;
	private String message;

	public MessagesModelRequest() {
		super();
	}

	public MessagesModelRequest(Long id, String createdDate, String subject, String email, StatusEnum status,
			String message) {
		this.id = id;
		this.createdDate = createdDate;
		this.subject = subject;
		this.email = email;
		this.status = status;
		this.message = message;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCreatedDate() {
		return createdDate;
	}

	public void setCreatedDate(String createdDate) {
		this.createdDate = createdDate;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public StatusEnum getStatus() {
		return status;
	}

	public void setStatus(StatusEnum status) {
		this.status = status;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
}