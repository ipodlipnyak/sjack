import Vue from 'vue';
//import 'bootstrap';
import './app_main.js';
//require("imports-loader?$=jquery!./plugins/adminlte.js")


var app_sm_page = new Vue({
	delimiters : [ '${', '}' ],
	el : '#main-content',
	data : {
		save_inprogress_app : 0,
		protocol : 'http',
		hostname : '',
		url : '',
		name : '',
		
		css_protocol : '',
		css_hostname : '',
		css_url : '',
		css_name : '',
		
		has_error : 0,
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
//		$.ajax({
//			method : "GET",
//			url : '/api/sm_list/'+sm_domain+'/http_status_code/desc',
//			success : function(msg) {
//				self.pages_list = msg;
//			}
//		});
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
		save_page : function(){
			self = this;
			self.check_form();
			
			if (self.has_error == 0) {
				self.save_inprogress_app = 1;
				$.ajax({
					method : "POST",
					url : '/api/sm_new_page',
					data : {
						name : self.name,
						protocol : self.protocol,
						domain : self.hostname,
						url : self.url
					},
					success : function(msg) {
						self.save_inprogress_app = 0;
						self.refresh_form();
//						window.location.href = "/admin";
					}
				});
			} else {
				self.has_error = 0;
			}

			
		},
		
		check_form : function(){
			self = this;
			
			['name','protocol','hostname','url'].forEach(function(el){
				var prop_name = 'css_'+el;
				if (app_sm_page[el] === '') {
					app_sm_page[prop_name] = 'has-error';
					app_sm_page.has_error = 1;
				}
			});
			
		},
		
		refresh_form : function() {
			self = this;
			self.protocol = 'http';
			self.hostname = '';
			self.url = '';
			self.name = '';
			
			['name','protocol','hostname','url'].forEach(function(el){
				var prop_name = 'css_'+el;
				app_sm_page[prop_name] = '';
			});
			
			$('#name input').focus();
		},
	},
});


window.app_sm_page = app_sm_page;