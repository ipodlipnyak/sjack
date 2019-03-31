import Vue from 'vue'
import 'bootstrap';
require("imports-loader?$=jquery!./plugins/adminlte.js")

var app_main = new Vue({
	delimiters : [ '${', '}' ],
	el : '#app-main',
	data : {
		test: 'hi',
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
//			method : "POST",
//			url : '/admin/get_posts_list',
//			success : function(msg) {
//				self.posts_list = msg;
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
		create_new_post : function(){
			self = this;
//			$.ajax({
//				method : "POST",
//				url : '/admin/new_post',
//				data : {
//					post_name : self.new_post.post_name,
//					post_text : self.new_post.post_text,
//					post_text_brief : self.new_post.post_text_brief
//				},
//				success : function(msg) {
//					if (self.new_post.files){
//						multiple_files_upload(msg.post_id,self.new_post.files[0]);
//					}
//					window.location.href = "/admin";
//				}
//			});
			
		},
		
	},
});

function multiple_files_upload(post_id, file){
	var data = new FormData();
//	var count_loaded_files = 0;
	data.append('ajax', 'upload_files');
	data.append('post_id', post_id);
	data.append('file[]', file);
	$.ajax({
//		indexValue: i,
		// Your server script to process the upload
		url : '/admin/upload_post_image',
		type : 'POST',

		// Form data
		data : data,

		// Tell jQuery not to process data or worry about content-type
		// You *must* include these options!
		cache : false,
		contentType : false,
		processData : false,
		
		complete: function(){
//			var new_count = parseInt($('#count-loaded-files').val(),10)+1;
//			$('#count-loaded-files').val(new_count);
//			
//			if ($('#count-loaded-files').val() == $('#count-query-files').val()){
//				send_email(message_id);
//				$("#auditionform #files-images p").text('Изображения загружены');
//			}
		},

		// Custom XMLHttpRequest
		xhr : function() {
			var myXhr = $.ajaxSettings.xhr();
//			myXhr.addEventListener("load", function(e){
//				if ((i+1) == $("#files-input").prop('files').length){
//					send_email(msg.new_request_id);
//				}
//			});
			if (myXhr.readyState)
			if (myXhr.upload) {
				// For handling the progress of the upload
				myXhr.upload.addEventListener('progress', function(e) {
					if (e.lengthComputable) {
						$('progress').attr({
							value : e.loaded,
							max : e.total,
						});
					}
				}, false);
			}
			return myXhr;
		}
	});
}

window.app_main = app_main;