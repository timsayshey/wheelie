/*
 * More Less Overflow
 * Author: Justin McCandless
 * justinmccandless.com
 */

$(document).ready(function() {

	// Save the original text and height of each exOverflow div, in case they're expanded
	$(".mlOverflow").each(function () {	
		$(this).data('mlOverflow_height', $(this).height());
		$(this).children('.mlOverflow_text').data('mlOverflow_text', $(this).children('.mlOverflow_text').text());
	});
	
	// Add an ellipsis and the more/less button if necessary
	$(".mlOverflow").each(function () {
		var offset = 0;
		if ($(this).children('.mlOverflow_text').outerHeight(true) > $(this).outerHeight(true)) {
			$(this).append('<a href="#" class="mlOverflow_button">'+getMore($(this))+'</a>');
			offset = $('.mlOverflow_button').outerHeight(true);
		}
		while (($(this).children('.mlOverflow_text').outerHeight(true) + offset) > $(this).outerHeight(true)) {
			$(this).children('.mlOverflow_text').text(
				$(this).children('.mlOverflow_text').text().replace(/\W*\s(\S)*$/, '...')
		    );
		}
	});
	
	// Handle clicks by toggling between more and less mode
	$('.mlOverflow_button').click(function (e) {
		var holder = $(this).siblings('.mlOverflow_text').text();
		$(this).siblings('.mlOverflow_text').text($(this).siblings('.mlOverflow_text').data('mlOverflow_text'));
		$(this).siblings('.mlOverflow_text').data('mlOverflow_text', holder);
		if ($(this).text() == getMore($(this).parent('.mlOverflow'))) {
			$(this).text(getLess($(this).parent('.mlOverflow')));
			$(this).parents('.mlOverflow').css('height', 'auto');
		}
		else {
			$(this).text(getMore($(this).parent('.mlOverflow')));
			$(this).parents('.mlOverflow').css('height', $(this).parents('.mlOverflow').data('mlOverflow_height'));
		}
		e.preventDefault();
	});
});

// You can set the mlOverflow_more and mlOverflow_less data parameters in your .mlOverflow
// divs to easily change the text of the more/less buttons
function getMore(obj) {
	if (obj.attr('data-mlOverflow_more') != undefined) {
		return obj.attr('data-mlOverflow_more');
	}
	else
		return "More";
}
function getLess(obj) {
	if (obj.attr('data-mlOverflow_less') != undefined)
		return obj.attr('data-mlOverflow_less');
	else
		return "Less";	
}