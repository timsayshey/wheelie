<cfoutput>	
	
	<h1>Upload Photos</h1>
	<br class="clear"><br>
	
	<span class="btn btn-lg btn-success fileinput-button" style="display:inline-block;">
		<i class="glyphicon glyphicon-plus"></i>
		<span>Select files...</span>
		<!-- The file input field used as target for the file upload widget -->
		<input id="fileupload" type="file" name="uploadedFile" multiple>
	</span>
	<h2 style="display:inline-block; padding:0; padding-left:10px; margin:0;">or Drag & Drop anywhere</h2> 
	<br>
	<br>
	
	<div id="success" class="alert alert-success" style="display:none">
		<strong>Upload successful!</strong>
	</div>
	
	<div id="fail" class="alert alert-danger" style="display:none">
		<strong>Upload failed. Please try again.</strong>
	</div>
	
	<!-- The global progress bar -->
	<div id="progress" class="progress" style="display:none">
		<div class="progress-bar progress-bar-success"></div>
	</div>
	
	<!-- The container for the uploaded files -->
	<div id="files" class="files"></div>
	
	<link rel="stylesheet" href="/assets/vendor/blueimp/css/jquery.fileupload.css">
	<script src="/assets/vendor/blueimp/js/vendor/jquery.ui.widget.js"></script>
	<script src="/assets/vendor/blueimp/js/jquery.iframe-transport.js"></script>
	<script src="/assets/vendor/blueimp/js/jquery.fileupload.js"></script>
	<script>
	/*jslint unparam: true */
	/*global window, $ */ 
	$(function () {
		'use strict';
		// Change this to the location of your server-side upload handler:
		var url = '#urlFor(route="public~otherPages",action="blueimpUpload")#';
		$('##fileupload').fileupload({
			url: url,
			dataType: 'json',
			done: function (e, data) {
				$.each(data.result.files, function (index, file) 
				{
					$('<p/>').text(file.name).appendTo('##files');
				});
			},
			success: function (result, textStatus, jqXHR) {
				$(".alert").hide();
				$("##success").show();
			},
			error: function (jqXHR, textStatus, errorThrown) {
				$(".alert").hide();
				$("##fail").show();
				$('##progress .progress-bar').css(
					'width',
					'0%'
				);
			},
			progressall: function (e, data) {
				$(".alert").hide();
				$('##progress').show();
				var progress = parseInt(data.loaded / data.total * 100, 10);				
				$('##progress .progress-bar').css(
					'width',
					progress + '%'
				);
			}
		}).prop('disabled', !$.support.fileInput)
			.parent().addClass($.support.fileInput ? undefined : 'disabled');
	});
	</script>

</cfoutput>