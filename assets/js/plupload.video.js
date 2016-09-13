GLOBAL = {};

// Custom example logic
$(function() {
	
	var uploader = new Array();
	
	// Loop over to apply multiple btn selectors
	for (var i=0; i<=1; i++)
	{ 
		if(i == 0) {
			btnId = 'uploadvideo';
		} else {
			btnId = 'uploadyoutube';
		}		
		
		uploader[i] = new plupload.Uploader({
			runtimes : 'gears,html5,flash,silverlight,browserplus',
			browse_button : btnId,
			container : 'container',
			chunk_size : '10mb',
			max_file_count: 1,
			multi_selection:false,
			url : '/m/admin/upload/videoUpload',
			flash_swf_url : '/assets/vendor/plupload/Moxie.swf',
			silverlight_xap_url : '/assets/vendor/plupload/Moxie.xap',
			filters : [
				{title : "Video files", extensions : "avi,flv,ogv,swf,webm,wmv,mov,mp4,flv,mpg,m4v"}
				//,{title : "Image files", extensions : "jpg,gif,png"},
				//{title : "Zip files", extensions : "zip"}
			]
			// , resize : {width : 320, height : 240, quality : 90}
		});
		
		uploader[i].bind('Init', function(up, params) {
			// $('#filelist').html("<div>Current runtime: " + params.runtime + "</div>");
		});
	
		$('#uploadfiles').click(function(e) {
			uploader[i].start();
			e.preventDefault();
		});
	
		uploader[i].init();
	
		uploader[i].bind('FilesAdded', function(up, files) {
			$.each(files, function(i, file) {
				$('#filelist').append(
					'<div id="' + file.id + '">' +
					file.name + ' (' + plupload.formatSize(file.size) + ') <b></b>' +
				'</div>');
			});
	
			up.refresh(); // Reposition Flash/Silverlight
			up.start();
		});
		
		uploader[i].bind('UploadProgress', function(up, file) {
			$('#progress .progress-bar').css(
				'width',
				file.percent + '%'
			);
		});
	
		uploader[i].bind('Error', function(up, err) {
			$('#filelist').append("<div>Error: " + err.code +
				", Message: " + err.message +
				(err.file ? ", File: " + err.file.name : "") +
				"</div>"
			);
	
			up.refresh(); // Reposition Flash/Silverlight
		});
	
		uploader[i].bind('FileUploaded', function(up, file, info) 
		{			
			$('#' + file.id + " b").html("100%");
			
			videoid = $("#videoid").val();
			
			$.ajax({
				type: "GET",
				url: "/m/admin/upload/videoFinished",
				data: { fileid: file.id, filename: file.name, videoid: videoid, uploadTo: $("#typeId").val() },
				success: function(data) {				
					ext 	= file.name.split(".");
					extPos	= ext.length - 1;
					ext 	= ext[extPos];
					
					data = $.parseJSON(data);
					console.log(data);
					
					GLOBAL.videoid = data.VIDEOID;
					GLOBAL.filename = file.name;
					
					if(data.UPLOADTO == "yt")
					{						
						
						if($("#oauthWindowType").val() == "popup") 
						{										
							oAuthPopup(data.VIDEOID);
														
						} else {
							redirUrl = $("#baseOauthUrl").val() + "%3Fext=" + data.EXT + "%26id=" + data.VIDEOID; // ? = %3F
							location = redirUrl;
						}						
					}
					else
					{
						if($("#uploadType").val() == "gallery")
						{
							$('#uploadVideo').modal('hide');
							
							// Add and select new video							
							window.$videoSelector.addOption({ 
									id : data.VIDEOID,
									name : data.NAME,
									thumb : "/assets/uploads/videos/thumbs/_nothumb.jpg"
							});
							window.$videoSelector.addItem(data.VIDEOID);
							
							window.$videoSelector.refreshOptions();
							
						} else	{
							location = "/m/admin/files/";
						}
					}
				}
			});		
		});	
	}
	
});

function oAuthPopup(videoid)
{
	oauthpopup = $.popupWindow($("#baseOauthUrlPopup").val(), {
		width: 400,
		height: 400,
		centerOn: 'parent'
	});
	
	var tokenChecker = setInterval(function()
	{			
		oauth = {};
		oauth.token = gup(oauthpopup.location.href, 'token');
		oauth.name  = gup(oauthpopup.location.href, 'name');
		oauth.email = gup(oauthpopup.location.href, 'email');		
		
		if(typeof oauth.token !== 'undefined' && oauth.token.length > 1)
		{										
			oauthpopup.close();
			
			$('#uploadVideo').modal('hide');
			
			// get model via ajax
			confirmOauthAccount(videoid,oauth);
			
			// Save token and open account confirmation modal
			clearInterval(tokenChecker);
		} 
		else if (typeof oauthpopup.location.href == 'undefined')
		{
			$.jGrowl("Your Google Login Failed", {
				header: 'Oops, there was an issue',
				sticky: true,
				theme: 'red'
			});
			clearInterval(tokenChecker);
		}
	},3000);
}

function confirmOauthAccount(videoid,oauth)
{
	console.log("oauth",oauth);
	
	$.ajax({
		type: "GET",
		url: "/m/admin/files/videoConfirmModal",
		data: { id : videoid, token : oauth.token, name : decodeURI(oauth.name), email : oauth.email, baseOauthUrl : "" },
		success: function(data) {
			$(document).off("click", "#toYoutubeBtn");
			$(document).on("click", "#toYoutubeBtn", function(e) { 
				toYoutube(videoid,oauth.token);
				e.preventDefault();
			});	
			
			$("#oauthConfirmModal").html(data);	
			$('#youtubeconfirm').modal({
				show: true
			});			
		}
	});	
}

function toYoutube(videoid,oauthToken)
{
	$.ajax({
		type: "GET",
		url: "/m/admin/upload/toyoutube",
		data: { id : videoid, token : oauthToken, isAjax : 1 },
		success: function(data) {
			
			if($("#uploadType").val() == "gallery")
			{				
				// Add and select new video							
				window.$videoSelector.addOption({ 
						id : videoid,
						name : GLOBAL.filename,
						thumb : "/assets/uploads/videos/thumbs/_nothumb.jpg"
				});
				window.$videoSelector.addItem(data.VIDEOID);
				
				window.$videoSelector.refreshOptions();				
				
				$('#youtubeconfirm').modal('hide');	
				
			} else	{
				location = "/m/admin/files/";
			}
		}
	});	
}

// Redirect after google iframe logout
function redirectAfterGoogleLogout() {
	
	$("#modal_loader").fadeIn(100);
	
	setTimeout(function() 
	{				
		if($("#oauthWindowType").val() == "popup") {
			$('#youtubeconfirm').modal('hide');	
			if(typeof GLOBAL.videoid !== 'undefined')
			{
				oAuthPopup(GLOBAL.videoid);
			}			
		} else {
			location = $("#baseOauthUrlFull").val();
		}
	}, 2000);
}