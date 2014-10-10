$(function() {

	// Modal editor
	var $modal = $('#ajax-modal');
		
	$(document).on("click", "[data-ajax]", function(e){
		e.preventDefault();
		e.stopPropagation();
		
		var ajaxUrl = $(this).attr("data-ajax");
		
		// create the backdrop and wait for next modal to be triggered
		$('body').modalmanager('loading');
		 
		setTimeout(function(){
			$modal.load(ajaxUrl, '', function(){
				$modal.modal();
				
				$('form').ajaxForm({
					beforeSubmit: function(){
						$(".modal-scrollable").animate({ scrollTop: 0 }, "slow");
						$modal.modal('loading');
					},
					type: $("_method").attr("value"),
					error: function(e) {
						if(typeof e.responseText !== 'undefined') {							
							$modal
								.modal('loading')
								.find('.modal-body')
								.prepend(e.responseText);
						}
					},
					success: function(e) { 					
						$modal
							.modal('loading')
							.find('.modal-body')
							.prepend(e);
							
						setTimeout(function() {
							location.reload();				
						},1000);
					}
				});
				
			});
		}, 1000);	
	});
	
	
	// Search filter
	$('#searchbox').val("");
	
	$("#sortbox").change(function() {
		goAjax("#data");
	});
	
	$('#searchbox').keyup(function () {
		goAjax("#data");
	});
	
	function goAjax(selector)
	{
		var ajaxPath = $('#searchbox').attr("data-ajaxpath");
		var sSearch = $('#searchbox').val();
		var sSort = $('#sortbox').val();
		
		$.ajax({
			type: "GET",
			url: ajaxPath + '?sSearch=' + sSearch + '&sSort=' + sSort,
			success: function (content) {
				$(selector).html(content);
			},
			error: function () { 
				$(selector).html("There was an issue. Please refresh or try again.");
			}
		});
	}	
	
});

