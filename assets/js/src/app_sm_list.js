import Vue from 'vue'
//import 'bootstrap';
import './app_main.js';
//require("imports-loader?$=jquery!./plugins/adminlte.js")

var app_sm_list = new Vue({
	delimiters : [ '${', '}' ],
	el : '#main-content',
	data : {
		sites_list:[],
		site_on_delete: '',
		site_on_edit: '',
		new_hostname:'',
		css_status : {
				'success':'label-success',
				'redirect':'label-warning',
				'error':'label-danger'
		},
	},
	
	computed: {
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
			url : '/api/sm_list',
			success : function(msg) {
				self.sites_list = msg;
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
		refresh_site_list(){
			self = this;
			$.ajax({
				method : "GET",
				url : '/api/sm_list',
				success : function(msg) {
					self.sites_list = msg;
				}
			});
		},
		save_site(){
			self = this;
			$.ajax({
				method : "POST",
				url : '/api/sm_site/'+self.site_on_edit,
				data : {
					domain : self.new_hostname,
				},
				success : function(msg) {
					self.refresh_site_list();
				}
			});
			self.new_hostname = '';
			self.site_on_edit = '';
		},
		edit_site(hostname){
			self = this;
			self.new_hostname = hostname;
			self.site_on_edit = hostname;
		},
		cancel_site_edit(){
			self = this;
			self.new_hostname = '';
			self.site_on_edit = '';
		},
		get_status_css(status){
			var css = {
					'success':'label-success',
					'redirect':'label-warning',
					'error':'label-danger'
			}
			return css[status];
		},
		delete_site(){
			self = this;
			$.ajax({
				method : "DELETE",
				url : '/api/sm_site/'+self.site_on_delete,
				success : function(msg) {
					this.site_on_delete = '';
					self.refresh_site_list();
				}
			});
			$('#modal-delete-confirmation').modal('hide');
		},
		do_not_delete_site(){
			this.site_on_delete = '';
			$('#modal-delete-confirmation').modal('hide');
		},
		select_on_delete_site : function(hostname){
			this.site_on_delete = hostname;
			$('#modal-delete-confirmation').modal('show');
		},
	},
});


window.app_sm_list = app_sm_list;