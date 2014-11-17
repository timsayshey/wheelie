<cfset themeDir = "/views/layouts/admin/">
<cfset request.page.hideSidebar = true>
<cfset request.page.hideFooterCallToAction = true>
<cfset request.page.clearThemeWrapper = true>
<cfset request.page.noBgImage = true>
<cfset contentFor(siteTitle = "#sanitize(includeContent('headerTitle'))# | Web Panel")>
<cfoutput>  
	<cfsavecontent variable="adminbody">
		<style type="text/css">
			.admin-content *, .admin-content strong, .admin-content h1, .admin-content h2, .admin-content h3, .admin-content h4 {
				font-family:'Montserrat', sans-serif !important;
			}
			.contentwrapper {
				margin-top:0;
			}			
			.admin-content {
				background:##eee;	
				padding-top: 20px;
			}
			.admin-content .leftside .data-block {
				border-bottom: 3px solid ##ddd;
				background:white;
			}		
			.admin-content .rightbar .data-block {
				border-bottom: 3px solid ##ddd;
				background:white;
				color:##333
			}
.admin-content h2 span { display: inline-block; } .admin-content article, .admin-content aside, .admin-content details, .admin-content figcaption, .admin-content figure, .admin-content footer, .admin-content header, .admin-content hgroup, .admin-content nav, .admin-content section, .admin-content summary{display:block} .admin-content audio, .admin-content canvas, .admin-content video{display:inline-block;*display:inline;*zoom:1} .admin-content audio:not([controls]){display:none;height:0} .admin-content [hidden]{display:none}.admin-content, .admin-content button, .admin-content input, .admin-content select, .admin-content textarea{font-family:sans-serif}.admin-content{margin:0} .admin-content a:focus{outline:thin dotted} .admin-content a:active, .admin-content a:hover{outline:0} .admin-content h1, .admin-content h2, .admin-content h3, .admin-content h4, .admin-content h5 { background:none; } .admin-content h1{font-size:2em;} .admin-content h2{font-size:1.5em;} .admin-content h3{font-size:1.17em;} .admin-content h4{font-size:1em;} .admin-content h5{font-size:.83em;} .admin-content h6{font-size:.75em;} .admin-content abbr[title]{border-bottom:1px dotted} .admin-content b, .admin-content strong{font-weight:bold} .admin-content blockquote{margin:1em 40px} .admin-content dfn{font-style:italic} .admin-content mark{background:##ff0;color:##000} .admin-content p, .admin-content pre{margin:1em 0} .admin-content code, .admin-content kbd, .admin-content pre, .admin-content samp{font-family:monospace,serif;_font-family:'courier new',monospace;font-size:1em} .admin-content pre{white-space:pre;white-space:pre-wrap;word-wrap:break-word} .admin-content q{quotes:none} .admin-content q:before, .admin-content q:after{content:'';content:none} .admin-content small{font-size:75%} .admin-content sub, .admin-content sup{font-size:75%;line-height:0;position:relative;vertical-align:baseline} .admin-content sup{top:-0.5em} .admin-content sub{bottom:-0.25em} .admin-content dl, .admin-content menu, .admin-content ol, .admin-content dd{margin:0 0 0 40px} .admin-content menu, .admin-content ol, .admin-content ul{padding:0 0 0 40px} .admin-content nav ul, .admin-content nav ol{list-style:none;list-style-image:none} .admin-content img{border:0;-ms-interpolation-mode:bicubic} .admin-content svg:not(:root){overflow:hidden} .admin-content figure{margin:0} .admin-content form{margin:0} .admin-content fieldset{border:1px solid ##c0c0c0;margin:0 2px;padding:.35em .625em .75em} .admin-content legend{border:0;padding:0;white-space:normal;*margin-left:-7px} .admin-content button, .admin-content input{line-height:normal} .admin-content button, .admin-content input[type="button"], .admin-content input[type="reset"], .admin-content input[type="submit"]{-webkit-appearance:button;cursor:pointer;*overflow:visible} .admin-content button[disabled], .admin-content input[disabled]{cursor:default} .admin-content input[type="checkbox"], .admin-content input[type="radio"]{box-sizing:border-box;padding:0;*height:13px;*width:13px} .admin-content input[type="search"]{-webkit-appearance:textfield;-moz-box-sizing:content-box;-webkit-box-sizing:content-box;box-sizing:content-box} .admin-content input[type="search"]::-webkit-search-cancel-button, .admin-content input[type="search"]::-webkit-search-decoration{-webkit-appearance:none} .admin-content button::-moz-focus-inner, .admin-content input::-moz-focus-inner{border:0;padding:0} .admin-content textarea{overflow:auto;vertical-align:top} .admin-content table{border-collapse:collapse;border-spacing:0}
			.admin-content div, .admin-content input, .admin-content label, .admin-content select, .admin-content textarea {
				font-size:12px;
			}
			.topnav {
				margin-bottom:0;	
			}
			.admin-content h1,.admin-content h2,.admin-content h3,.admin-content h4,.admin-content h5,.admin-content h6,.admin-content h7 {
				border:0;	
			}			
		</style>
		<cfscript>		
			includeCSS = styleSheetLinkTag(sources='
					vendor/css/plugins/lightbox/lightbox.css, 	
					vendor/css/plugins/jgrowl/jquery.jgrowl.css,
					vendor/nestedSortable/nestedSortable.css,
					vendor/css/font/icons.css	
			');
			
			//includeIECSS = styleSheetLinkTag(sources='');
			
			/*  
				vendor/js/libs/modernizr.js,
				vendor/js/bootstrap/bootstrap.min.js,
			*/
			
			includeJS = javaScriptIncludeTag(sources='
					js/utilities.js,
					vendor/js/plugins/wysihtml5/wysihtml5-0.3.0.js,
					vendor/js/plugins/wysihtml5/bootstrap-wysihtml5.js,
					vendor/js/plugins/lightbox/lightbox-2.6.min.js,
					vendor/js/plugins/jGrowl/jquery.jgrowl.js,					
					vendor/ckeditor/ckeditor.js,
					vendor/tmpl.js,
					vendor/jquery.popupwindow.js,
					vendor/jquery.form.js,
					vendor/serializeAnything.jquery.js,
					vendor/nestedSortable/jquery-ui-1.10.3.custom.min.js,
					vendor/nestedSortable/jquery.ui.touch-punch.min.js,
					vendor/nestedSortable/jquery.mjs.nestedSortable2.js,
					vendor/js/plugins/fileupload/bootstrap-fileupload.js,
					vendor/jquery.responsivetable.min.js
			');
			
			includeIEJS = javaScriptIncludeTag(sources='
					vendor/js/libs/respond.min.js,
					vendor/js/libs/selectivizr.js
			');
		</cfscript>
		<link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
		<!-- Fav and touch icons 
		<link rel="shortcut icon" href="img/icons/favicon.ico">
		<link rel="apple-touch-icon-precomposed" sizes="114x114" href="img/icons/apple-touch-icon-114-precomposed.png">
		<link rel="apple-touch-icon-precomposed" sizes="72x72" href="img/icons/apple-touch-icon-72-precomposed.png">
		<link rel="apple-touch-icon-precomposed" href="img/icons/apple-touch-icon-57-precomposed.png">-->
		
		<!--- <cfif isNull(request.page.jqueryLoaded)>
			<script src="//code.jquery.com/jquery-1.10.1.min.js"></script>
			<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
			<cfset request.page.jqueryLoaded = true>
		</cfif> --->
		
		<!-- CSS Libs -->
		#includeCSS#
		
		<link href="#themeDir#assets/css/admin-bootstrap.css" rel="stylesheet">
		<link href="#themeDir#style.css" rel="stylesheet">
		
		<!-- JS Libs -->
		#includeJS#
		
		<script src="#themeDir#assets/js/shared.js" type="text/javascript"></script>
		<!-- IE8 support of media queries and CSS 2/3 selectors -->
		<!--[if lt IE 9]>
			<!---#includeIECSS#--->
			#includeIEJS#
		<![endif]-->
		<link href='http://fonts.googleapis.com/css?family=Montserrat:400,700' rel='stylesheet' type='text/css'>  
		
		<div id="wrapper" class="admin-content">
		
			<cfif NOT flashIsEmpty()>
				<div class="container">				
					<cfif flashKeyExists("error")>
						<div class="alert alert-danger alert-dismissable fade in">
							<button class="close" data-dismiss="alert">&times;</button>
							<strong>#flash("error")#</strong> 
							<cfif !isNull(errorMessagesName)>												
								#errorMessagesFor(errorMessagesName)#
							</cfif>
						</div>
					</cfif>
					
					<cfif flashKeyExists("success")>
						<div class="alert alert-success">
							<button type="button" class="close" data-dismiss="alert">&times;</button>
							<strong>#flash("success")#</strong>
						</div>
					</cfif>
				</div>
			</cfif>			
			
			#includeContent("formWrapStart")#			
			
			<!-- Main page container -->
			<section class="container" role="main">	
				
				<cfif len(includeContent("rightColumn"))>
					<cfset mainClass = "col-sm-9 leftside">
				<cfelse>
					<cfset mainClass = "col-sm-12">
				</cfif>
				
				#includeContent("extraSection")#
				
				<cfif !len(includeContent("clearLayout"))>
				
					<!-- Grid row -->
					<div class="row contentwrapper">
	
						<!-- Data block -->
						<div class="#mainClass#">
							<div class="data-block">
								<header>
									<cfif len(includeContent("headerTitle"))>
										<h2>#includeContent("headerTitle")# #includeContent("headerTitleAppend")#</h2>
										<cfif len(includeContent("headerButtons"))>
											<ul class="data-header-actions">#includeContent("headerButtons")#</ul>
											<br class="clear">
										</cfif>	
									</cfif>
								</header>
								<section>							
								
				</cfif>	
					
				#includeContent()#
								
				<cfif !len(includeContent("clearLayout"))>		
						
								</section>
							</div>
						</div>
						<!-- /Data block -->
						
						<cfif len(includeContent("rightColumn"))>
							<div class="col-sm-3 rightbar">
								#includeContent("rightColumn")#
							</div>
						</cfif>
						
					</div>
					<!-- /Grid row -->
				</cfif>
				
			</section>
			<!-- /Main page container -->
						
			<!-- Sticky footer push -->
			<div id="push"></div>
			
			#includeContent("formWrapEnd")#
			
			<cfif len(includeContent("plupload"))>
				<script type="text/javascript" src="/assets/vendor/plupload/plupload.full.min.js"></script>
				<script type="text/javascript" src="/assets/vendor/plupload/jquery.plupload.queue/jquery.plupload.queue.js"></script>
				<link rel="stylesheet" href="/assets/vendor/plupload/plupload.bootstrap/css/plupload.bootstrap.css" type="text/css" media="screen" />
				<script type="text/javascript" src="/assets/js/plupload.video.js"></script>
				
				<script type="text/html" id="tmpl_ytThumbs">	
					<div class="form-group">
						#bLabel(label="Choose a Thumbnail",class="control-label")#
						<div class="controls">
							<% for ( var id = 0; id < videos.length; id++ ) { %>	
							
								<div class="wiz_thumb">
									<label for="img">
										<img class="img" src="http://i.ytimg.com/vi/<%=videos[id]%>/hqdefault.jpg" />
										<input type="radio" name="thumbid" class="thumbid" value="<%=videos[id]%>" checked />
									</label>
								</div>
							
							<% } %>
							<br class="clear" />
						</div>
					</div>	
				</script>
				
			</cfif>
			
			<cfif len(includeContent("selectize")) OR len(includeContent("formy"))>
			
				#styleSheetLinkTag(sources='vendor/selectize/css/selectize.bootstrap3.css')#
				#javaScriptIncludeTag(sources='
					vendor/selectize/js/standalone/microplugin.min.js,
					vendor/selectize/js/standalone/sifter.min.js,
					vendor/selectize/js/standalone/selectize.js
				')#
				
				<script type="text/javascript">
					$(function() {
						$('.multiselectize').selectize({
							maxItems: null
						});
						$('.selectize').selectize();
						$('.selectizetags').selectize({
							delimiter: ',',
							persist: false,
							create: function(input) {
								return {
									value: input,
									text: input
								}
							}
						});
					});
				</script>	
			</cfif>
			
			<cfif len(includeContent("checkable")) OR len(includeContent("formy"))>
			
				#javaScriptIncludeTag(sources='vendor/js/plugins/prettyCheckable/prettyCheckable.js')#
				#styleSheetLinkTag(sources='vendor/css/plugins/prettycheckable/prettyCheckable.css')#
		
				<script>
					$(document).ready(function() {
		
						$('.styled-checkbox input, .styled-radio input').prettyCheckable();
		
					});
				</script>
		
			</cfif>
			
			<cfif len(includeContent("ajaxModal")) OR len(includeContent("formy"))>
				#javaScriptIncludeTag(
					sources="
						vendor/jquery.form.js,
						js/ajax.js				
				")#	
				<div id="ajax-modal" class="modal primary container hide fade" tabindex="-1"></div>
			</cfif>
		
		</div>
		
	</cfsavecontent>
	
	<!--- Inject the above variable into the parent layout --->
	<cfset contentFor(adminbody=adminbody)>
	
	<!--- Include the parent layout --->
	#includeLayout("/themes/#request.site.theme#/layout.cfm")#	
</cfoutput>