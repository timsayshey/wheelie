jQuery(function($) {
	"use strict";

	baguetteBox.run('.gallery');

	$('[data-original]').each(function(){
		$(this).attr('src', $(this).attr('data-original'));
	});

	new WOW().init();
		$("##justifiedGallery").justifiedGallery({
		rowHeight : 130,
		margins : 10
	});

	$('.maps').click(function () {
		$('.maps iframe').css("pointer-events", "auto");
	});
});
