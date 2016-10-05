// Init
$(function() {

	$.ajax({
		type: "GET",
		url: "/app/panoJson/" + window.propertyid + "?editorUrls="+window.mediafileid,
		success: function(config)
		{			
			pannellum.viewer('panorama',config);
		}
	});

	$(document).on("contextmenu", "#panorama", function(e){
		$('#LinkModal').modal('show');
		return false;
	});

	$(document).on("contextmenu", "#panorama", function(e){
		$('#LinkModal').modal('show');
		return false;
	});

	$(document).on("click", ".saveCaption", function(e) {
		$.ajax({
			type: "POST",
			url: window.update_link_endpoint,
			data: { "parentid": window.mediafileid, "uuid": $(this).attr("data-uuid"), "caption": $(this).parent().find("input.caption").val() },
			success: function(data)
			{			
				loadLinks();
				//location.reload();
			}
		});
	});

	$(document).on("click", ".panochoices div", function(e) {
		$.ajax({
			type: "POST",
			url: window.add_link_endpoint,
			data: {"yaw":window.yaw,"parentid":window.mediafileid,"childid":$(this).attr("id"),"childfileid":$(this).attr("data-childfileid"),"type": $(this).attr("data-type")},
			success: function(data)
			{			
				$('#LinkModal').modal('hide');
				loadLinks();
				location.reload();
			}
		});
		
	});

	$(document).on("click", ".delete", function(e) {
		$.ajax({
			type: "POST",
			url: window.remove_link_endpoint,
			data: {"parentid":window.mediafileid,"uuid":$(this).attr("data-uuid")},
			success: function(data)
			{			
				loadLinks();
				location.reload();
			}
		});
		
	});

	loadLinks();
	
});
function loadLinks() {
	$.ajax({
		type: "GET",
		url: window.get_link_endpoint,
		success: function(data,a)
		{			
			$("#links").html(data);
		}
	});
}