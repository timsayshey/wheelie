<cfoutput>
	<cfscript>		
		includeCSS = styleSheetLinkTag(sources='
				vendor/css/plugins/lightbox/lightbox.css, 	
				vendor/nestedSortable/nestedSortable.css
		');
		
		/* Disable
			vendor/js/plugins/jGrowl/jquery.jgrowl.js,
			vendor/jquery.popupwindow.js,
			vendor/jquery.form.js,			
		*/
		
		includeJS = javaScriptIncludeTag(sources='
				js/utilities.js,					
				vendor/js/plugins/lightbox/lightbox-2.6.min.js,									
				vendor/ckeditor/ckeditor.js,
				vendor/tmpl.js,
				vendor/serializeAnything.jquery.js,
				vendor/nestedSortable/jquery-ui-1.10.3.custom.min.js,
				vendor/nestedSortable/jquery.ui.touch-punch.min.js,
				vendor/nestedSortable/jquery.mjs.nestedSortable2.js,
				vendor/js/plugins/fileupload/bootstrap-fileupload.js,
				vendor/jquery.responsivetable.min.js,
				vendor/underscore.js
		');
		
		includeIEJS = javaScriptIncludeTag(sources='
				vendor/js/libs/respond.min.js,
				vendor/js/libs/selectivizr.js
		');
	</cfscript>
	<link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
			
	<!-- CSS Libs -->
	#includeCSS#
	
	<link href="#themeDir#assets/css/admin-bootstrap.css" rel="stylesheet">
	<link href="#themeDir#style.css" rel="stylesheet">
	
	<!-- JS Libs -->
	#includeJS#
	
	<script src="#themeDir#assets/js/shared.js" type="text/javascript"></script>
	<!-- IE8 support of media queries and CSS 2/3 selectors -->
	<!--[if lt IE 9]>
		#includeIEJS#
	<![endif]-->
	<link href='//fonts.googleapis.com/css?family=Montserrat:400,700' rel='stylesheet' type='text/css'>  
</cfoutput>