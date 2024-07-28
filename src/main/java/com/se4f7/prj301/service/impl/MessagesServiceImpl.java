package com.se4f7.prj301.service.impl;

import com.se4f7.prj301.constants.ErrorMessage;
import com.se4f7.prj301.model.PaginationModel;
import com.se4f7.prj301.model.request.MessagesModelRequest;
import com.se4f7.prj301.model.response.MessagesModelResponse;
import com.se4f7.prj301.repository.MessagesRepository;
import com.se4f7.prj301.service.MessagesService;

import com.se4f7.prj301.utils.StringUtil;

public class MessagesServiceImpl implements MessagesService {
	private MessagesRepository messageRepository = new MessagesRepository();

	@Override
	public boolean create(MessagesModelRequest request, String username) {
		// Call repository to save message
		return messageRepository.create(request, username);
	}

	@Override
	public boolean update(String id, MessagesModelRequest request, String username) {
		// Parse String to Long
		Long idNumber = StringUtil.parseLong("Id", id);

		// Get old Message
		MessagesModelResponse oldMessage = messageRepository.getById(idNumber);

		// If Message is not exists, cannot update so will throw Error
		if (oldMessage == null) {
			throw new RuntimeException(ErrorMessage.RECORD_NOT_FOUND);
		}

		// Call repository to update message
		return messageRepository.update(idNumber, request, username);
	}

	@Override
	public boolean deleteById(String id) {
		Long idNumber = StringUtil.parseLong("Id", id);
		MessagesModelResponse oldMessage = messageRepository.getById(idNumber);
		if (oldMessage == null) {
			throw new RuntimeException(ErrorMessage.RECORD_NOT_FOUND);
		}
		return messageRepository.deleteById(idNumber);
	}

	@Override
	public MessagesModelResponse getById(String id) {
		Long idNumber = StringUtil.parseLong("Id", id);
		MessagesModelResponse oldMessage = messageRepository.getById(idNumber);
		if (oldMessage == null) {
			throw new RuntimeException(ErrorMessage.RECORD_NOT_FOUND);
		}
		return oldMessage;
	}

	@Override
	public PaginationModel filter(String page, String size, String name) {
		int pageNumber = StringUtil.parseInt("Page", page);
		int sizeNumber = StringUtil.parseInt("Size", size);
		return messageRepository.filterByEmail(pageNumber, sizeNumber, name);
	}
}