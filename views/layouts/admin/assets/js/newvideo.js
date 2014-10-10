// Init
$(function() {
		
	setListeners();
	
	if($(".youtubeid").val().length > 0 || $(".vimeoid").val().length > 0)
	{
		$(".videoNotExists").hide();
		$(".videoExists").show();	
	} else {
		$(".videoNotExists").show();
		$(".videoExists").hide();	
	}	
});

// Add listeners 
function setListeners()
{		
	$(document).off("input", ".videoUrl");
	$(document).on("input", ".videoUrl", function(e) { 
		parsedVideo = parseVideoURL($(".videoUrl").val());
		if(parsedVideo.provider == 'youtube') {
			$(".vimeoid").val("");
			$(".youtubeid").val(parsedVideo.id);
			console.log(parsedVideo.provider);
		} else if(parsedVideo.provider == 'vimeo') {
			$(".vimeoid").val(parsedVideo.id);
			$(".youtubeid").val("");
			console.log(parsedVideo.provider);
		}
		console.log(parsedVideo.id);
	});
	
	$(".replaceVideo").click(function() {
		$(".videoNotExists").show();
		$(".videoExists").hide();
	});
	
	$(".replaceVideoCancel").click(function() {
		$(".videoNotExists").hide();
		$(".videoExists").show();
	});	
}

function parseVideoURL(url) {
    
    function getParm(url, base) {
        var re = new RegExp("(\\?|&)" + base + "\\=([^&]*)(&|$)");
        var matches = url.match(re);
        if (matches) {
            return(matches[2]);
        } else {
            return("");
        }
    }
    
    var retVal = {};
    var matches;
    
    if (url.indexOf("youtube.com/watch") != -1) {
        retVal.provider = "youtube";
        retVal.id = getParm(url, "v");
    } else if (matches = url.match(/vimeo.com\/(\d+)/)) {
        retVal.provider = "vimeo";
        retVal.id = matches[1];
    }
    return(retVal);
}