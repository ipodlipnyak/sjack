import Vue from 'vue'
//import 'bootstrap';
import './app_main.js';
//require("imports-loader?$=jquery!./plugins/adminlte.js")

var app_config = new Vue({
	delimiters : [ '${', '}' ],
	el : '#main-content',
	data : {
		user: [],
		new_password: '',
		password_confirmation: '',
		app_config: [],
		
		save_inprogress_app: 0,
		save_inprogress_user: 0,
		save_inprogress_password: 0,
	},
	
	computed: {
		pass_confirmed: function () {
			if (this.new_password == this.password_confirmation) {
				return 1;
			} else {
				return 0;
			}
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
			method : "POST",
			url : '/api/get_config',
			success : function(msg) {
				self.app_config = msg;
			}
		});
		
		$.ajax({
			method : "POST",
			url : '/api/get_user',
			success : function(msg) {
				self.user = msg;
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
		save_password: function(){
			self = this;
			if (self.password_confirmation == self.new_password) {
				self.save_inprogress_password = 1;
				$.ajax({
					method : "POST",
					url : '/api/update_password',
					data : {
						user_id: self.user.user_id,
						password: self.new_password,
					},
					success : function(msg) {
						self.save_inprogress_password = 0;
					}
				});
			} else {
				
			}
		},
		save_user : function(){
			self = this;
			self.save_inprogress_user = 1;
			$.ajax({
				method : "POST",
				url : '/api/update_user',
				data : self.user,
				success : function(msg) {
					self.save_inprogress_user = 0;
				}
			});
		},
		save_app : function(){
			self = this;
			self.save_inprogress_app = 1;
			$.ajax({
				method : "POST",
				url : '/api/update_config',
				data : self.app_config,
				success : function(msg) {
					self.save_inprogress_app = 0;
//					if (self.new_post.files){
//						multiple_files_upload(msg.post_id,self.new_post.files[0]);
//					}
//					window.location.href = "/admin";
				}
			});
			
		},
		
	},
});


window.app_config = app_config;