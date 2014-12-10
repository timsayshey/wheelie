// Init
$(function() {
	selectVal = "";
	url = "";
	
	if(typeof $(".youtubeId").val() !== 'undefined') 
	{
		loadYoutubeThumbs(selectVal);
		
		setListeners();
		
		if($(".youtubeId").val().length > 0)
		{
			$(".videoNotExists").hide();
			$(".videoExists").show();	
		} else {
			$(".videoNotExists").show();
			$(".videoExists").hide();	
		}	
	}
});

// Add listeners 
function setListeners()
{		
	// Listen to youtube link typing
	$(document).off("input", ".youtubeurl");
	$(document).on("input", ".youtubeurl", function(e) { 
		loadYoutubeThumbs(selectVal);
	});
	
	$(".replaceVideo").click(function() {
		$(".videoNotExists").show();
		$(".videoExists").hide();
	});
	
	$(".replaceVideoCancel").click(function() {
		$(".videoNotExists").hide();
		$(".videoExists").show();
	});
	
	loadYoutubeThumbs($(".youtubeId").val());
	getPlaylistVideoThumbs($(".youtubeId").val());
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
	var $thumbChooser = $(".yt_thumb_chooser");
	videos = ids;	
	html = tmpl("tmpl_ytThumbs", {});	
	$thumbChooser.html(html);	
}

function loadYoutubeThumbs()
{		
	var $thumbChooser = $(".yt_thumb_chooser");
	var idFieldVal = $(".youtubeurl").val();		
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
		$("#isPlaylist").val(1);	
	}
	else if(typeof ytParsedUrl.list !== 'undefined')
	{
		getPlaylistVideoThumbs(ytParsedUrl.list);
		$(".youtubeId").val(ytParsedUrl.list);	
		$("#isPlaylist").val(1);	
	}
	else if(typeof ytParsedUrl.v !== 'undefined')
	{
		thumbLoader([ytParsedUrl.v]);
		$(".youtubeId").val(ytParsedUrl.v);
	}
	
	// Show thumbs block
	$thumbChooser.show();
}
