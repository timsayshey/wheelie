// Init
$(function() {

	$(window).keydown(function(event){
		if(event.keyCode == 13) {
		  event.preventDefault();
		  return false;
		}
	});

	// listeners
	$(document).on("click", ".deleteMedia", function(e) { 
		deleteMediafile($(this).attr("data-fileid"),this);
	});

	$(document).on("click", ".captionMedia", function(e) {
		$("#caption").val($(this).attr("data-original-title"));
		$("#caption").attr("data-id",$(this).attr("data-id"));
	});

	$(document).on("click", "#saveCaption", function(e) { 
		$.ajax({
			type: "POST",
			url: window.mediaSettings.update_endpoint,
			data: {'mediafile[id]':$("#caption").attr("data-id"),'mediafile[name]':$("#caption").val()},
			success: function(data)
			{			
				if(data.success == true) {
					$('a[data-id="'+$("#caption").attr("data-id")+'"]').attr("data-original-title",$("#caption").val());
					$('#captionModal').modal('hide');
				} else {
					alert("Update failed, refresh and try again.");
				}
			}
		});
	});

	// init
	loadPhotos();	
	initDropzone();
});

function loadPhotos() {
	$.ajax({
		type: "GET",
		url: window.mediaSettings.photos_endpoint,
		success: function(data,a)
		{			
			$("#photos").html(data);
			initMediaSorting();
			$("[title]").tooltip(); 
		}
	});
}

function initDropzone() {
	Dropzone.autoDiscover = false;
	$("#dZUpload").dropzone({
	    url: window.mediaSettings.upload_endpoint,
	    addRemoveLinks: false,
	    success: function (file, response) {
	        var imgName = response;
	        file.previewElement.classList.add("dz-success");
	        loadPhotos();
	    },
	    error: function (file, response) {
	        file.previewElement.classList.add("dz-error");
	    }
	});
}

function initMediaSorting() {

	$('.sortable').sortable({
		revert: 100,
		placeholder: 'placeholder',
		update: function() {
			$.ajax({
				url : window.mediaSettings.sorting_endpoint,
				type: "POST",
				data : {orderValues:$('.sortable').sortable("toArray")},
				success: function(data, textStatus, jqXHR)
				{
				},
				error: function (jqXHR, textStatus, errorThrown)
				{
				}
			});
		}
	});
}

function deleteMediafile(fileid,el)
{	
	window.deletemedia = {
		fileid:fileid,
		el:el
	};
	$.ajax({
		type: "POST",
		url: window.mediaSettings.delete_endpoint,
		data: {'fileid':fileid},
		success: function(data)
		{			
			if(data.success == true) {
				$(window.deletemedia.el).closest("li").fadeOut(300, function() { $(this).remove(); })
			} else {
				alert("Delete failed, refresh and try again.");
			}
		}
	});
}