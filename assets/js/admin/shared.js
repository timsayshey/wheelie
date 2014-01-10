// Init
$(function() {
	// Align save box to bottom of content area		
		
	// Tooltips
	$('[title]').tooltip();				
	$('.wysihtml').wysihtml5();			
		
	// Highlight gallery item when checkbox is clicked
	$('.thumbnail-checkbox').click(function() {
		$(this).next('.thumbnail').toggleClass('active');
	});

	// Add .active class for checked checkboxes on page load (back button etc)
	$('.form-gallery .thumbnail-checkbox:checked').next('a').addClass('active');
	
	// Change Per Page
	$('.perPage').on('change', function (e) {
		var optionSelected = $("option:selected", this);
		var valueSelected = this.value;
		location = $("#perPagePath").val() + "/" + this.value;		
	});
	
	// Checkall delete selection button
	$('.checkall').on('click', function () {			
		$(".itemselector").prop('checked', this.checked);
	});
	
	// Show/hide filter
	$(".togglediv").hide();
	$(".togglediv#show").show();
	$(".toggle").click(function() {
			$(".togglediv").toggle( "slow", function() {
		});
	});	
	
	// Delete confirmation	
	$(document).off("click", ".confirmDelete");
	$(document).on("click", ".confirmDelete", function(e) { 
		if (!confirm("Are you sure you want to delete this? No turning back.")){
			e.preventDefault();	
			e.stopImmediatePropagation();
			return false;
		} 
	});
});

$(window).load(function() { // makes sure the whole site is loaded
	$('#status').fadeOut(); // will first fade out the loading animation
	$('#preloader').delay(350).fadeOut('slow'); // will fade out the white DIV that covers the website.
	$('body').delay(350).css({'overflow':'visible'});
});