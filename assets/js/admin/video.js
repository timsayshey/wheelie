// Init
$(function() {
	selectVal = "";
	url = "";
	
	loadYoutubeThumbs(selectVal);
	
	setListeners();
});

// Add listeners 
function setListeners()
{		
	// Listen to youtube link typing
	$(document).off("input", ".youtubeurl");
	$(document).on("input", ".youtubeurl", function(e) { 
		loadYoutubeThumbs(selectVal);
	});	
		
	$(document).off("click", "#submitYoutubeURL");
	$(document).on("click", "#submitYoutubeURL", function(e) { 
		submitYoutubeURL();		
	});
	
	// Listen to button clicks
	$(document).off("click", "#uploadvideo,#uploadyoutube,#youtubelink");
	$(document).on("click", "#uploadvideo,#uploadyoutube,#youtubelink", function(e) {
		btnVal = $(this).attr("rel");
		handleTypeButton();
	});
	
	// Delete selected video
	$(document).off("click", ".delete-video");
	$(document).on("click", ".delete-video", function(e) { 
		deleteSelectedVideo();
	});	
	
	// Preview selected video
	$(document).off("click", ".preview-video");
	$(document).on("click", ".preview-video", function(e) { 
		previewSelectedVideo();
	});
}

function deleteSelectedVideo()
{	
	var videoid = $("#videoSelector").val();
	
	$.ajax({
		type: "GET",
		url: "/m/admin/files/restDelete/" + videoid + "?ajax",
		success: function(data)
		{			
			if($.parseJSON(data).Success == true)
			{					
				window.$videoSelector.removeOption(videoid);				
				window.$videoSelector.refreshOptions();		
			} else {
				alert("Delete failed, refresh and try again.");
			}
		}
	});
}

function previewSelectedVideo()
{
	$('#details_' + $("#videoSelector").val()).modal('toggle');
}

function submitYoutubeURL()
{
	$.ajax({
		type: "GET",
		url: "/m/admin/files/save",
		data: { youtubeid : $("#youtubeIDInput").val(), returnJSON : true, thumbid : $(".thumbid:checked").val() },
		success: function(data) {
			
			data = $.parseJSON(data);
			
			if($("#uploadType").val() == "gallery")
			{
				$('#uploadVideo').modal('toggle');
				
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
	});		
}

function handleTypeButton() 
{				
	$(".typeId").val(btnVal.split("-")[0]);
	selectVal = btnVal;
	
	if(selectVal == "yt-u")
	{
		selectVal = "loc-u";
	}
	
	$("#selectType").val(selectVal);
	switchType();
	loadYoutubeThumbs(selectVal);
}

// Thumb Functions
function switchType()
{
	selectVal = $("#selectType").val();
	
	$(".type-wrap").hide();
	console.log(selectVal);
	$(".type-wrap[data-type=" + selectVal + "]").show();
	
	setListeners();
}
	
function getPlaylistVideoThumbs(pid)
{
	var playListURL = 'https://gdata.youtube.com/feeds/api/playlists/' + pid + '?v=2&alt=json&callback=?';
	
	$.ajax({
		dataType: "json",
		url: playListURL,
		async: false,
		data: [],
		success: function(data) {
			var idlist = new Array();
			$.each(data.feed.entry, function(i, item) {				
				var feedURL = item.link[1].href;
				var fragments = feedURL.split("/");
				var videoId = fragments[fragments.length - 2];
				idlist.push(videoId);
			});
			thumbLoader(idlist);
		}
	});
}

function thumbLoader(ids) {		
	var $thumbChooser = $(".type-wrap[data-type=" + selectVal + "] .yt_thumb_chooser");
	videos = ids;	
	html = tmpl("tmpl_ytThumbs", {});	
	$thumbChooser.html(html);	
}

function loadYoutubeThumbs()
{		
	var $thumbChooser = $(".type-wrap[data-type=" + selectVal + "] .yt_thumb_chooser");
	var idFieldVal = $(".type-wrap[data-type=" + selectVal + "] .youtubeurl").val();		
	var ytParsedUrl;
	
	if(typeof idFieldVal !== 'undefined') 
	{
		ytParsedUrl = $.parseParams( idFieldVal.split('?')[1] || '' );
	} else {
		ytParsedUrl = "";
	}
	
	$thumbChooser.html("");
	
	if(typeof ytParsedUrl.p !== 'undefined')
	{
		getPlaylistVideoThumbs(ytParsedUrl.p);
		$(".youtubeId").val(ytParsedUrl.p);		
	}
	else if(typeof ytParsedUrl.list !== 'undefined')
	{
		getPlaylistVideoThumbs(ytParsedUrl.list);
		$(".youtubeId").val(ytParsedUrl.list);		
	}
	else if(typeof ytParsedUrl.v !== 'undefined')
	{
		thumbLoader([ytParsedUrl.v]);
		$(".youtubeId").val(ytParsedUrl.v);
	}
	
	// Show thumbs block
	$thumbChooser.show();
}

