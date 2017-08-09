// CSS3 animated & responsive dropdown menu
// http://www.red-team-design.com/css3-animated-dropdown-menu
(function(){
		/* Mobile */
		$('#menu-wrap').prepend('<div id="menu-trigger"><span class="elusive icon-align-justify"></span> &nbsp; Menu</div>');
		$("#menu-trigger").on("click", function(){
			$("#menu").slideToggle();
		});

		// iPad
		var isiPad = navigator.userAgent.match(/iPad/i) != null;
		if (isiPad) $('#menu ul').addClass('no-transition');
})();
