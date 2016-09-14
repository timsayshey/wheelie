<cfoutput>

<!DOCTYPE html>
<html lang="en"> 
	<head>	
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		
		<title>#sanitize(includeContent("headerTitle"))# | Web Panel</title>
		
		<meta name="description" content="">
		<meta name="robots" content="index, follow">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
 		<cfset existingEntry = false>
		<cfif existingEntry>
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
				includeIECSS = styleSheetLinkTag(sources='');	
			</cfscript>
			<!-- CSS Libs -->
			#includeCSS#
			
			<!-- IE8 support of media queries and CSS 2/3 selectors -->
			<!--[if lt IE 9]>
				#includeIECSS#
			<![endif]-->
		</cfif>
		<style media="all">
			* {
				font-size:11px !important;
				font-family:arial;
			}
			##logo, header, ##st-launcher-tab {
				display:none !important;
			}
			section {
				padding:0 !important;	
			}
			.data-block {
				border-bottom: none !important;
				margin:0 !important;	
			}
			.separator, hr {
				padding: 0 !important;
				margin: 0 !important;
			}
			.separator {
				margin-bottom:4px !important; 	
			}
			label {
				margin-bottom:none !important;
				font-size:10px !important;
				font-weight:bold;
			}			
			.container {
				padding-right: 15px;
				padding-left: 15px;
				margin-right: auto;
				margin-left: auto
			}
			.container:before, .container:after {
				display: table;
				content: " "
			}
			.container:after {
				clear: both
			}
			.container:before, .container:after {
				display: table;
				content: " "
			}
			.container:after {
				clear: both
			}
			.row {
				margin-right: -15px;
				margin-left: -15px
			}
			.row:before, .row:after {
				display: table;
				content: " "
			}
			.row:after {
				clear: both
			}
			.row:before, .row:after {
				display: table;
				content: " "
			}
			.row:after {
				clear: both
			}
			.col-xs-1, .col-sm-1, .col-md-1, .col-lg-1, .col-xs-2, .col-sm-2, .col-md-2, .col-lg-2, .col-xs-3, .col-sm-3, .col-md-3, .col-lg-3, .col-xs-4, .col-sm-4, .col-md-4, .col-lg-4, .col-xs-5, .col-sm-5, .col-md-5, .col-lg-5, .col-xs-6, .col-sm-6, .col-md-6, .col-lg-6, .col-xs-7, .col-sm-7, .col-md-7, .col-lg-7, .col-xs-8, .col-sm-8, .col-md-8, .col-lg-8, .col-xs-9, .col-sm-9, .col-md-9, .col-lg-9, .col-xs-10, .col-sm-10, .col-md-10, .col-lg-10, .col-xs-11, .col-sm-11, .col-md-11, .col-lg-11, .col-xs-12, .col-sm-12, .col-md-12, .col-lg-12 {
				position: relative;
				min-height: 1px;
				padding-right: 15px;
				padding-left: 15px
			}
			.col-xs-1, .col-xs-2, .col-xs-3, .col-xs-4, .col-xs-5, .col-xs-6, .col-xs-7, .col-xs-8, .col-xs-9, .col-xs-10, .col-xs-11, .col-xs-12 {
				float: left
			}
			.col-xs-12 {
				width: 100%
			}
			.col-xs-11 {
				width: 91.66666666666666%
			}
			.col-xs-10 {
				width: 83.33333333333334%
			}
			.col-xs-9 {
				width: 75%
			}
			.col-xs-8 {
				width: 66.66666666666666%
			}
			.col-xs-7 {
				width: 58.333333333333336%
			}
			.col-xs-6 {
				width: 50%
			}
			.col-xs-5 {
				width: 41.66666666666667%
			}
			.col-xs-4 {
				width: 33.33333333333333%
			}
			.col-xs-3 {
				width: 25%
			}
			.col-xs-2 {
				width: 16.666666666666664%
			}
			.col-xs-1 {
				width: 8.333333333333332%
			}
			.col-xs-pull-12 {
				right: 100%
			}
			.col-xs-pull-11 {
				right: 91.66666666666666%
			}
			.col-xs-pull-10 {
				right: 83.33333333333334%
			}
			.col-xs-pull-9 {
				right: 75%
			}
			.col-xs-pull-8 {
				right: 66.66666666666666%
			}
			.col-xs-pull-7 {
				right: 58.333333333333336%
			}
			.col-xs-pull-6 {
				right: 50%
			}
			.col-xs-pull-5 {
				right: 41.66666666666667%
			}
			.col-xs-pull-4 {
				right: 33.33333333333333%
			}
			.col-xs-pull-3 {
				right: 25%
			}
			.col-xs-pull-2 {
				right: 16.666666666666664%
			}
			.col-xs-pull-1 {
				right: 8.333333333333332%
			}
			.col-xs-pull-0 {
				right: 0
			}
			.col-xs-push-12 {
				left: 100%
			}
			.col-xs-push-11 {
				left: 91.66666666666666%
			}
			.col-xs-push-10 {
				left: 83.33333333333334%
			}
			.col-xs-push-9 {
				left: 75%
			}
			.col-xs-push-8 {
				left: 66.66666666666666%
			}
			.col-xs-push-7 {
				left: 58.333333333333336%
			}
			.col-xs-push-6 {
				left: 50%
			}
			.col-xs-push-5 {
				left: 41.66666666666667%
			}
			.col-xs-push-4 {
				left: 33.33333333333333%
			}
			.col-xs-push-3 {
				left: 25%
			}
			.col-xs-push-2 {
				left: 16.666666666666664%
			}
			.col-xs-push-1 {
				left: 8.333333333333332%
			}
			.col-xs-push-0 {
				left: 0
			}
			.col-xs-offset-12 {
				margin-left: 100%
			}
			.col-xs-offset-11 {
				margin-left: 91.66666666666666%
			}
			.col-xs-offset-10 {
				margin-left: 83.33333333333334%
			}
			.col-xs-offset-9 {
				margin-left: 75%
			}
			.col-xs-offset-8 {
				margin-left: 66.66666666666666%
			}
			.col-xs-offset-7 {
				margin-left: 58.333333333333336%
			}
			.col-xs-offset-6 {
				margin-left: 50%
			}
			.col-xs-offset-5 {
				margin-left: 41.66666666666667%
			}
			.col-xs-offset-4 {
				margin-left: 33.33333333333333%
			}
			.col-xs-offset-3 {
				margin-left: 25%
			}
			.col-xs-offset-2 {
				margin-left: 16.666666666666664%
			}
			.col-xs-offset-1 {
				margin-left: 8.333333333333332%
			}
			.col-xs-offset-0 {
				margin-left: 0
			}
			.clear, hr {
				clear: both;
			}
			hr {
				border: 0;
				border-top: 1px solid ##aaa;
				height: 0;
				box-sizing: content-box;
			}
		</style>
	</head>
	<body>
	
		<div id="preloader">
			<div id="status">&nbsp;</div>
		</div>
		
		<div id="wrapper">
		
			<div id="header" class="container">

				<h1 id="logo">
					<img src="/assets/uploads/logoSmall.png">
				</h1>

			</div>
			
			
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
			
			<div class="container" role="main">	
				
				<cfif len(includeContent("rightColumn"))>
					<cfset mainClass = "col-sm-9 leftside">
				<cfelse>
					<cfset mainClass = "col-sm-12">
				</cfif>
				
				#includeContent("extraSection")#
				
				<cfif !len(includeContent("clearLayout"))>
				
					<div class="row contentwrapper">
					
						<div class="#mainClass#">
							<div class="data-block">
								<div>
									<cfif len(includeContent("headerTitle"))>
										<h2>#includeContent("headerTitle")# #includeContent("headerTitleAppend")#</h2>
										<cfif len(includeContent("headerButtons"))>
											<ul class="data-header-actions">#includeContent("headerButtons")#</ul>
										</cfif>	
									</cfif>
								</div>
								<div>							
								
				</cfif>			
					
				<cfif len(includeContent("mainBody"))>
					#includeContent("mainBody")#
				<cfelse>
					#includeContent()#
				</cfif>
								
				<cfif !len(includeContent("clearLayout"))>		
						
								</div>
							</div>
						</div>
						
						<cfif len(includeContent("rightColumn"))>
							<div class="col-sm-3 rightbar">
								#includeContent("rightColumn")#
							</div>
						</cfif>
						
					</div>
				</cfif>
				
			</div>
			
			<div id="push"></div>
			
			#includeContent("formWrapEnd")#
			
		</div>
		
	</body>
</html>

</cfoutput>