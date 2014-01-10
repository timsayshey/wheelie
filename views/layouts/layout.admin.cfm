<cfoutput>

<!DOCTYPE html>
<!--[if lt IE 7]> <html lang="en" class="lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>    <html lang="en" class="lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>    <html lang="en" class="lt-ie9"> <![endif]-->
<!--[if IE 9]>    <html lang="en" class="ie9"> <![endif]-->
<!--[if gt IE 9]><!--> <html lang="en"> <!--<![endif]-->
	<head>	
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		
		<title>#sanitize(includeContent("headerTitle"))# | Web Panel</title>
		
		<meta name="description" content="">
		<meta name="robots" content="index, follow">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
 
		<cfscript>		
			includeCSS = styleSheetLinkTag(sources='
					vendor/css/plugins/lightbox/lightbox.css, 
					css/admin/bootstrap.min.css,	
					css/admin/todc-bootstrap.min.css,	
					vendor/css/plugins/jgrowl/jquery.jgrowl.css,
					vendor/nestedSortable/nestedSortable.css,
					css/admin/admin.css,
					vendor/css/font/icons.css,
					css/admin/style.css			
			');
			includeIECSS = styleSheetLinkTag(sources='
			');
			
			includeJS = javaScriptIncludeTag(sources='
					vendor/js/libs/jquery.js,
					js/utilities.js,					
					vendor/js/libs/modernizr.js,
					vendor/js/bootstrap/bootstrap.min.js,
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
					vendor/nestedSortable/jquery.mjs.nestedSortable.js,
					vendor/js/plugins/fileupload/bootstrap-fileupload.js,
					js/admin/shared.js
			');
			
			includeIEJS = javaScriptIncludeTag(sources='
					vendor/js/libs/respond.min.js,
					vendor/js/libs/selectivizr.js
			');
		</cfscript>
		
		<!-- Fav and touch icons 
		<link rel="shortcut icon" href="img/icons/favicon.ico">
		<link rel="apple-touch-icon-precomposed" sizes="114x114" href="img/icons/apple-touch-icon-114-precomposed.png">
		<link rel="apple-touch-icon-precomposed" sizes="72x72" href="img/icons/apple-touch-icon-72-precomposed.png">
		<link rel="apple-touch-icon-precomposed" href="img/icons/apple-touch-icon-57-precomposed.png">-->
		
		<!-- CSS Libs -->
		#includeCSS#
		
		<!-- JS Libs -->
		#includeJS#
		
		<!-- IE8 support of media queries and CSS 2/3 selectors -->
		<!--[if lt IE 9]>
			#includeIECSS#
			#includeIEJS#
		<![endif]-->
		
	</head>
	<body>
	
		<div id="preloader">
			<div id="status">&nbsp;</div>
		</div>
		
		<!-- Full height wrapper -->
		<div id="wrapper">

			<!-- Main page header -->
			<header id="header" class="container">

				<h1 id="logo">
					<a href='#urlFor(route="moduleAction", module="admin", controller="main", action="home")#' title="Dashboard"><img src="/assets/css/admin/wheelie_cms_logo.png"></a>
				</h1>
				
				<!-- User profile -->
				<div class="userinfo col-sm-3 pull-right">
					<figure>

						<!-- User profile avatar -->
						<img src="#session.user.portrait#">

						<!-- User profile info -->
						<figcaption>
							<cfset editAccount = urlFor(									
									route		= "moduleId",
									module	= "admin",
									controller	= "users",
									action		= "edit",
									id			= session.user.id
								)>
							<strong><a href='#editAccount#'>#session.user.fullname#</a></strong>
							<ul>
								<li><a href='#editAccount#'>account</a></li>
								<li><a href='#urlFor(route="moduleAction", module="admin", controller="users", action="logout")#'>logout</a></li>
							</ul>
						</figcaption>
						<!-- /User profile info -->

					</figure>
				</div>
				<!-- /User profile -->
				
				<br class="clear">
				
				<!-- Main navigation -->
				<nav class="main-navigation navbar navbar-masthead navbar-default" role="navigation">

					<!-- Collapse navigation for mobile -->
					<div class="navbar-header">
						<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".main-navigation-collapse">
							Menu
						</button>
					</div>
					<!-- /Collapse navigation for mobile -->

					<!-- Navigation -->
					<div class="main-navigation-collapse collapse navbar-collapse">

						<!-- Navigation items -->
						<ul class="nav navbar-nav">

							<li>
								<a href='#urlFor(route="moduleAction", module="admin", controller="main", action="home")#'><span class="elusive icon-dashboard"></span> Dashboard</a>
							</li>
							
							<li class="dropdown">
								<a href="##" class="dropdown-toggle" data-toggle="dropdown"><span class="elusive icon-th-list"></span> Content <b class="caret"></b></a>
								<ul class="dropdown-menu">
									
									<li class="dropdown-submenu">
										<a href='#urlFor(route="moduleAction", module="admin", controller="pages", action="index")#'><span class="elusive icon-file-new"></span> Pages</a>
										<ul class="dropdown-menu">
											<li><a href='#urlFor(route="moduleAction", module="admin", controller="pages", action="index")#'>All Pages</a></li>
											<li><a href='#urlFor(route="moduleAction", module="admin", controller="pages", action="new")#'>Add New</a></li>
										</ul>
									</li>
									
									<li class="dropdown-submenu">
										<a href='#urlFor(route="moduleAction", module="admin", controller="posts", action="index")#'><span class="elusive icon-pencil"></span> Posts</a>
										<ul class="dropdown-menu">
											<li><a href='#urlFor(route="moduleAction", module="admin", controller="posts", action="index")#'>All Posts</a></li>
											<li><a href='#urlFor(route="moduleAction", module="admin", controller="posts", action="new")#'>Add New</a></li>
										</ul>
									</li>
									
									<li class="dropdown-submenu">
										<a href='#urlFor(route="moduleAction", module="admin", controller="videos", action="index")#'><span class="elusive icon-youtube"></span> Videos</a>
										<ul class="dropdown-menu">
											<li><a href='#urlFor(route="moduleAction", module="admin", controller="videos", action="index")#'>All Videos</a></li>
											<li><a href='#urlFor(route="moduleAction", module="admin", controller="videos", action="new")#'>Add New</a></li>											
											<li><a href='#urlFor(route="admin~Category", action="rearrange", modelName="videoCategory")#'>Categories</a></li>
										</ul>
									</li>
									
									<li>
										<a href='#urlFor(route="moduleAction", module="admin", controller="menuitems", action="rearrange")#'><span class="elusive icon-list"></span> Menus</a>
									</li>									
								
								</ul>
							</li>
							
							<li>
								
							</li>
							<li class="dropdown">
								<a href="##" class="dropdown-toggle" data-toggle="dropdown"><span class="elusive icon-user"></span> Users <b class="caret"></b></a>
								<ul class="dropdown-menu">
									<li><a href='#urlFor(route="moduleAction", module="admin", controller="users", action="index")#'>All Users</a></li>
									<li><a href='#urlFor(route="admin~Category", action="rearrange", modelName="userTag")#'>User Tags</a></li>
								</ul>
							</li>	
							<li class="dropdown">
								<a href="##" class="dropdown-toggle" data-toggle="dropdown" title="Coming sooner"><span class="elusive icon-fire"></span> Plugins <b class="caret"></b></a>
								<ul class="dropdown-menu">
									<li><a href='##' title="Or later">Sliders</a></li>
									<li><a href='##' title="Any takers?">Podcast</a></li>
									<li><a href='##'>Forms</a></li>
								</ul>
							</li>						
							<li>
								<a href='#urlFor(route="moduleAction", module="admin", controller="options", action="index")#' class="hidden-md hidden-lg"><span class="elusive icon-cog"></span> Settings</a>
							</li>
						</ul>
						<!-- /Navigation items -->

						<!-- Navigation form -->
						<ul class="navbar-right nav navbar-nav hidden-xs hidden-sm" style="margin-right:10px;">
							<li></li>
							<li>
								<a href='#urlFor(route="moduleAction", module="admin", controller="options", action="index")#' class="pull-right"><span class="elusive icon-cog"></span> Settings</a>
							</li>
						</ul>
						<!-- /Navigation form -->

					</div>
					<!-- /Navigation -->

			</header>
			<!-- /Main page header -->
			
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
										</cfif>	
									</cfif>
								</header>
								<section>							
								
				</cfif>			
					
				<cfif len(includeContent("mainBody"))>
					#includeContent("mainBody")#
				<cfelse>
					#includeContent()#
				</cfif>
								
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
			
		</div>
		<!-- /Full height wrapper -->
		
		<!-- Main page footer -->
		<footer id="footer">
			<div class="container">
					<a href="##top" class="btn btn-primary pull-right" title="Back to top"><span class="elusive icon-arrow-up"></span></a>
				<!-- Footer info -->
				<p>Copyright &copy; #DateFormat(now(),"YYYY")# #capitalize(cgi.SERVER_NAME)#</p>

				<!-- Footer nav -->
				<ul>
					<li><a href="##">Support</a></li>
					<li class="muted">&middot;</li>
					<li><a href="##">Documentation</a></li>
					<li class="muted">&middot;</li>
					<li><a href="##">API</a></li>
				</ul>
				<!-- /Footer nav -->

				<!-- Footer back to top -->
				

			</div>
		</footer>
		<!-- /Main page footer -->
		
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
			#javaScriptIncludeTag(sources='vendor/selectize/js/standalone/selectize.js')#
			
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
		
	</body>
</html>

</cfoutput>