package com.se4f7.prj301.controller.admin.api;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.se4f7.prj301.constants.ErrorMessage;
import com.se4f7.prj301.constants.QueryType;
import com.se4f7.prj301.model.PaginationModel;
import com.se4f7.prj301.model.request.SettingsModelRequest;
import com.se4f7.prj301.model.response.SettingsModelResponse;
import com.se4f7.prj301.service.SettingsService;
import com.se4f7.prj301.service.impl.SettingsServiceImpl;
import com.se4f7.prj301.utils.HttpUtil;
import com.se4f7.prj301.utils.ResponseUtil;

@WebServlet(urlPatterns = { "/admin/api/settings" })
// Add @MultipartConfig for enable upload file.
@MultipartConfig
public class SettingsController extends HttpServlet {

	private static final long serialVersionUID = -331986167361646886L;

	private SettingsService settingsService;

	public void init() {
		settingsService = new SettingsServiceImpl();
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			// Get JSON payload from request.
			// Parse JSON stringify from request to Java Class.
			SettingsModelRequest requestBody = HttpUtil.ofFormData(req.getPart("payload"))
					.toModel(SettingsModelRequest.class);
			// Get username from header request.
			String username = req.getAttribute("username").toString();
			// Call service create a new Posts.
			boolean result = settingsService.create(requestBody, req.getPart("image"), username);
			ResponseUtil.success(resp, result);
		} catch (Exception e) {
			ResponseUtil.error(resp, e.getMessage());
		}
	}

	@Override
	protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			// Get JSON payload from request.
			// Parse JSON stringify from request to Java Class.
			SettingsModelRequest requestBody = HttpUtil.ofFormData(req.getPart("payload"))
					.toModel(SettingsModelRequest.class);
			// Get username from header request.
			String username = req.getAttribute("username").toString();
			// Call service update Posts.
			boolean result = settingsService.update(req.getParameter("id"), requestBody, req.getPart("image"),
					username);
			ResponseUtil.success(resp, result);
		} catch (Exception e) {
			ResponseUtil.error(resp, e.getMessage());
		}
	}

	@Override
	protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			boolean result = settingsService.deleteById(req.getParameter("id"));
			ResponseUtil.success(resp, result);
		} catch (Exception e) {
			ResponseUtil.error(resp, e.getMessage());
		}
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {
			String type = req.getParameter("type");
			switch (type) {
			case QueryType.FILTER:
				String name = req.getParameter("name");
				String page = req.getParameter("page");
				String size = req.getParameter("size");
				PaginationModel results = settingsService.filter(page, size, name);
				ResponseUtil.success(resp, results);
				break;
			case QueryType.GET_ONE:
				String id = req.getParameter("id");
				SettingsModelResponse result = settingsService.getById(id);
				ResponseUtil.success(resp, result);
				break;

			default:
				ResponseUtil.error(resp, ErrorMessage.TYPE_INVALID);
			}
		} catch (Exception e) {
			ResponseUtil.error(resp, e.getMessage());
		}
	}
}
