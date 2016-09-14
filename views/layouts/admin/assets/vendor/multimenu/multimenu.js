// CSS3 animated & responsive dropdown menu
// Latest version: https://github.com/catalinred/Animenu

/* Credit: http://codepen.io/catalinred/pen/ngBJF */

$(function(){
		/* Mobile */
		$('#adminmenu-wrap').prepend('<div id="adminmenu-trigger">Menu</div>');		
		$("#adminmenu-trigger").on("click", function(){
			$("#adminmenu").slideToggle();
		});

		// iPad
		var isiPad = navigator.userAgent.match(/iPad/i) != null;
		if (isiPad) $('#adminmenu ul').addClass('no-transition');    

		// Fix disappearing menu
		window.addEventListener('resize', function(){
	    	$("#adminmenu").removeAttr("style");
	    }, true);  
});