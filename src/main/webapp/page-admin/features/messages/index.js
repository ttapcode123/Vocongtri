
$(document).ready(function () {

	var $pagination = $('#postsPagination');
	var inpSearchPostsName = '';
	// Init twbsPagination with defaultOpts /assets/global.settings.js)
	$pagination.twbsPagination(defaultOpts);

	// Listener event onChange when user typing on input search.
	this.onSearchByName = function () {
		// Get value from input search.
		inpSearchPostsName = $('#inpSearchPostsName').val();
		// Call function search filter value from input.
		this.getPosts(0, defaultPageSize, inpSearchPostsName);
	}

	// Function search and pagination Posts. 
	this.getPosts = function (page = 0, size = defaultPageSize, name = '') {
		// Use Ajax call API search posts (/assets/http.js).
		Http.get(`${domain}/admin/api/messages?type=filter&page=${page}&size=${size}&name=${name}`)
			.then(res => {
				let appendHTML = '';
				// Clear all elements in table content.
				$('#tblPosts').empty();
				// Reset pagination.
				$pagination.twbsPagination('destroy');
				// Check api error or no data response.
				if (!res.success || res.data.totalRecord === 0) {
					// Append text No Data when records empty;
					$('#tblPosts').append(`<tr><td colspan='9' style='text-align: center;'>No Data</td></tr>`);
					// End function.
					return;
				}
				console.log(res.data.records);

				// Build table content from data responses.
				for (const record of res.data.records) {
					appendHTML += '<tr>';
					appendHTML += `<td>${record.id}</td>`;
					appendHTML += `<td>${record.subject || ''}</td>`;
					appendHTML += `<td>${record.email || ''}</td>`;
					appendHTML += `<td>${moment(record.createdDate,"YYYY-MM-DD HH:mm:ss").fromNow()}</td>`;
					appendHTML +=
					`<td>
						<span class='badge ${record.status.toLowerCase() === 'active' ? 'bg-success' : 'bg-danger'}'>
							${record.status}
						</span>
					</td>`;
					appendHTML += `<td>${record.message || ''}</td>`;
					appendHTML +=
					`<td class='text-right'>
						<a class='btn btn-danger btn-sm' onclick='deletePosts(${record.id})'>
							<i class='fas fa-trash'></i>
						</a>
					</td>`;
					appendHTML += '</tr>';
				}

				// Build pagination with twbsPagination.
				// More detail: https://josecebe.github.io/twbs-pagination/
				$pagination.twbsPagination($.extend({}, defaultOpts, {
					startPage: res.data.page + 1,
					totalPages: Math.ceil(res.data.totalRecord / res.data.size)
				}));
				// Add event listener when page change.
				$pagination
					.on('page', (event, num) => {
						this.getPosts(num - 1, defaultPageSize, inpSearchPostsName);
					});

				// Append html table into tBody.
				$('#tblPosts').append(appendHTML);
			})
			.catch(err => {
				toastr.error(err.errMsg);
			})
	}

	// Function delete posts by id.
	this.deletePosts = function (id) {
		// Use Ajax call API get posts by id (/assets/http.js).
		Http.delete(`${domain}/admin/api/messages?id=${id}`)
			.then(res => {
				if (res.success) {
					this.swicthViewPosts(true);
					toastr.success('Delete posts success !')
				} else {
					toastr.error(res.errMsg);
				}
			})
			.catch(err => {
				toastr.error(err.errMsg);
			})
	}

	// Call API get posts by id.
	this.getPostsById = function (id) {
		Http.get(`${domain}/admin/api/messages?type=getOne&id=${id}`)
			.then(res => {
				if (res.success) {
					$('#inpPostsId').val(id);
					$('#inpPostsTitle').val(res.data.subject);
					$('#inpEmailTitle').val(res.data.email);
					$('#inpMessageTitle').val(res.data.message);
				} else {
					toastr.error(res.errMsg);
				}
			})
			.catch(err => {
				toastr.error(err.errMsg);
			})
	}

	this.savePosts = function () {
		const currentId = $('#inpPostsId').val();
		const payload = {
			'subject': $('#inpPostsTitle').val(),
			'email': $('#inpEmailTitle').val(),
			'message': $('#inpMessageTitle').val()
		}
		
		if (currentId) {
			Http.put(`${domain}/admin/api/messages?id=${currentId}`, payload)
				.then(res => {
					if (res.success) {
						this.swicthViewPosts(true);
						toastr.success(`Update message success !`)
					} else {
						toastr.error(res.errMsg);
					}
				})
				.catch(err => {
					toastr.error(err.errMsg);
				});
		} else {
			Http.post(`${domain}/admin/api/messages`, payload)
				.then(res => {
					if (res.success) {
						this.swicthViewPosts(true);
						toastr.success(`Create message success !`)
					} else {
						toastr.error(res.errMsg);
					}
				})
				.catch(err => {
					toastr.error(err.errMsg);
				});
		}
	};
	// TODO: Handle after.
	this.draftPosts = function () {
		alert("Làm biếng chưa có code");
	}
	// Using select2 query data categories.
	// More detail: https://select2.org/data-sources/ajax
	this.initSelect2Category = function () {
		// Init value for select2 on id #selPostsCategory.
		$('#selPostsCategory').select2({
			theme: 'bootstrap4',
			// Call api search category with select2.
			ajax: {
				url: `${domain}/admin/api/category`,
				headers: {
					// Get token from localStore and append on API.
					// Read more function: /assets/http.js
					'Authorization': 'Bearer ' + Http.getToken(),
					'Content-Type': 'application/json',
				},
				data: function (params) {
					var query = {
						type: 'filter',
						page: 0,
						size: 10,
						// params.term is value input on select2.
						name: params.term
					}
					// Query parameters will be ?type=[type]&page=[page]&size=[size]&name=[params.term]
					return query;
				},
				// Transform the data returned by your API into the format expected by Select2
				// Default format when use select2 is [{id: [id], text: [text]}]
				// So we need convert data from response to format of select2.
				processResults: function (res) {
					return {
						// Why we need using function [map] ?
						// Read more: https://viblo.asia/p/su-dung-map-filter-va-reduce-trong-javascript-YWOZrxm75Q0 
						results: res.data.records.map(elm => {
							return {
								id: elm.id,
								text: elm.name
							}
						})
					};
				}
			}
		});
	}

	// Action change display screen between Table and Form Create/Edit.
	this.swicthViewPosts = function (isViewTable, id = null) {
		if (isViewTable) {
			$('#posts-table').css('display', 'block');
			$('#posts-form').css('display', 'none');
			this.getPosts(0, defaultPageSize);
		} else {
			$('#posts-table').css('display', 'none');
			$('#posts-form').css('display', 'block');
			if (id == null) {
				$('#inpPostsId').val(null);
				$('#inpPostsTitle').val('');
				$('#inpEmailTitle').val('');
				$('#inpMessageTitle').val('');
			} else {
				this.getPostsById(id);
			}
		}
	};

	// Fix issues Bootstrap 4 not show file name.
	// More detail: https://stackoverflow.com/questions/48613992/bootstrap-4-file-input-doesnt-show-the-file-name

	// Set default view mode is table.
	this.swicthViewPosts(true);

});