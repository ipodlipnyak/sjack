import Vue from 'vue'
//import 'bootstrap';
import './app_main.js';
import Paginate from 'vuejs-paginate';
//require("imports-loader?$=jquery!./plugins/adminlte.js")


Vue.component('paginate', Paginate);

function check_url(object) {
	var regex = RegExp('^'+app_sm_page.filter_url,'i');
	return regex.test(object.url);
}

function check_name(object) {
	var regex = RegExp('^'+app_sm_page.filter_name,'i');
	return regex.test(object.name);
}

function check_status(object) {
	var regex = RegExp('^'+app_sm_page.filter_status,'i');
	return regex.test(object.http_status_code);
}

var app_sm_page = new Vue({
	delimiters : [ '${', '}' ],
	el : '#main-content',
	data : {
		pagination_num:1,
		pagin_max_el_input:12,
		
		pages_list:[],
		pages_order_by:'http_status_code',
		pages_order:'desc',
		
		show_filter: 0,
		filter_name: '',
		filter_url: '',
		filter_status: '',
		
		pages_on_delete:[],
		page_on_edit: '',
		css_status : {
				'success':'label-success',
				'redirect':'label-warning',
				'error':'label-danger'
		},
	},
	
	computed: {
		pages_on_delete_count: function(){
			return this.pages_on_delete.length;
		},
		delete_confirmation_title: function(){
			if (this.pages_on_delete_count == 1) {
				return 'Вы уверены, что хотите удалить страницу?';
			} else {
				return 'Вы уверены, что хотите удалить выбранные страницы?';
			}
		},
		delete_confirmation_info: function(){
			if (this.pages_on_delete_count == 1) {
				return 'Будет удалена страница с id '+this.pages_on_delete[0];
			} else {
				return 'Будет удалено '+this.pages_on_delete_count+' страниц(ы)';
			}
		},
		
		pagin_offset_up: function(){
			return ((this.pagination_num-1)*this.pagin_max_el)+parseInt(this.pagin_max_el);
		},
		pagin_offset_down: function(){
			return (this.pagination_num-1)*this.pagin_max_el;
		},
		
		pages_list_count: function(){
			return this.filtered_pages.length;
		},
		pagin_max_el: function(){
			return this.pagin_max_el_input > 0 ? this.pagin_max_el_input : 12;
		},
		pagin_count: function(){
			var p_count = Math.ceil(this.pages_list_count/this.pagin_max_el);
			return p_count > 0 ? p_count : 1;
		},
		
		filtered_pages: function(){
			if ((this.filter_status != '')||(this.filter_url != '')||(this.filter_name != '')){
				var filtered_list = this.pages_list.filter(check_url);
				filtered_list = filtered_list.filter(check_status);
//				var filtered_list = this.pages_list.filter(check_status);
				return filtered_list.filter(check_name);
			} else {
				return this.pages_list;
			}
		},
		
		pages_to_display: function(){
			return this.filtered_pages.slice(this.pagin_offset_down,this.pagin_offset_up);
		},
//	    show_submit_btn: function () {
//	    	if ((this.all_banners_selected == 1)&&(this.all_auto_selected == 1)){
//	    		return 1;
//	    	} else {
//	    		return 0;
//	    	}
//	    },
	},

	beforeCreate : function() {
		self = this;
		$.ajax({
			method : "GET",
			url : '/api/sm_list/'+sm_domain+'/http_status_code/desc',
			success : function(msg) {
				self.pages_list = msg;
			}
		});
	},
	
	created: function() {
		var self = this;
	},
	
	updated : function() {
		self=this;

	},
	mounted: function(){
		self=this;
		
	},
	watch : {
		pages_order_by : function(val,oldVal){
			self = this;
		},
		pagin_max_el_input : function(val, oldVal){
			self = this;
			self.pagination_num = 1;
		},
		pagination_num : function(val, oldVal){
//			console.log(oldVal+' > '+val);
		},
//		posts_list : function(){
//			self = this;
//			if (self.selected_post){
//				self.selected_post = self.posts_list.find(function(post) {
//					  return post.post_id = self.selected_post.post_id;
//				});
//			}
//		}
	},
	methods : {
		toggle_search(){
			self = this;
			self.show_filter = self.show_filter == 1 ? 0 : 1;
		},
		save_page(){
			self = this;
			$.ajax({
				method : "POST",
				url : '/api/sm_page',
				data : self.page_on_edit,
				success : function(msg) {
					self.page_on_edit = '';
					self.refresh_pages_list();
				}
			});
		},
		edit_page(page){
			self = this;
			self.page_on_edit = page;
		},
		cancel_page_edit(){
			self = this;
			self.page_on_edit = '';
			self.refresh_pages_list();
		},
		
		page_on_delete(page_id){
			self = this;
			if (page_id) {
				self.pages_on_delete.push(page_id);
			}
			
			if(self.pages_on_delete_count > 0){
				$('#modal-delete-confirmation').modal('show');
			}
		},
		delete_pages(){
			self = this;
			console.log(self.pages_on_delete);
			$.ajax({
				method : "DELETE",
				url : '/api/sm_pages',
				data : {
					pages_on_delete: self.pages_on_delete,
				},
				success : function(msg) {
					self.pages_on_delete = [];
					self.refresh_pages_list();
				}
			});
			$('#modal-delete-confirmation').modal('hide');
		},
		do_not_delete_pages(){
			self = this;
			self.pages_on_delete = [];
			$('#modal-delete-confirmation').modal('hide');
		},
//		change_pagination(pageNum){
//		      console.log(pageNum)
//		},
		toggle_sort(filed_name){
			self = this;
			if(self.pages_order_by == filed_name){
				self.pages_order = self.pages_order == 'asc' ? 'desc' : 'asc';
			} else {
				self.pages_order_by = filed_name;
				self.pages_order = 'asc';
			}
			
			self.refresh_pages_list();
			
		},
		
		refresh_pages_list(){
			self = this;
			$.ajax({
				method : "GET",
				url : '/api/sm_list/'+sm_domain+'/'+self.pages_order_by+'/'+self.pages_order,
				success : function(msg) {
					self.pages_list = msg;
				}
			});
		},
	},
});


window.app_sm_page = app_sm_page;