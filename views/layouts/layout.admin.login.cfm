<cfoutput>
	<!DOCTYPE html>
	<html class="no-js" lang="en">
		<head>
			<meta charset="utf-8">
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<title>Login | Web Panel</title>
			<meta name="description" content="">
			<meta name="robots" content="index, follow">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
			<cfscript>		
				includeCSS = styleSheetLinkTag(sources='
						vendor/css/bootstrap.min.css,
						css/admin/admin.css, 
						vendor/css/font/icons.css,
						css/admin/style.css			
				');			
				
				includeJS = javaScriptIncludeTag(sources='
					vendor/js/libs/jquery.js,
					vendor/js/libs/modernizr.js,
					vendor/js/bootstrap/bootstrap.min.js
				');	
			</cfscript>
			
			<!-- CSS Libs -->
			#includeCSS#
			
			#includeJS#
			
			<script>
				$(document).ready(function(){					
					// Tooltips
					$('[title]').tooltip();					
				});
			</script>
			
			<style type="text/css">
				body { 
					background: ##4d90fe; 
					padding: 220px 0 0 0;
				}		
				.panel-default {
					margin-top:30px;
				}
				.form-group.last { 
					margin-bottom:0px; 
				}
			</style>
		</head>
		
		<body class="login">
			
			<!-- Main page container -->
			<section class="container" role="main">
			
				<cfif flashKeyExists("error")>
					<div class="alert alert-danger alert-dismissable fade in">
						<button class="close" data-dismiss="alert">&times;</button>
						<strong>#flash("error")#</strong> 
						<cfif !isNull(errorMessagesName)>												
							#errorMessagesFor(errorMessagesName)#
						</cfif>
					</div>
				<cfelseif flashKeyExists("success")>
					<div class="alert alert-success">
						<button type="button" class="close" data-dismiss="alert">&times;</button>
						<strong>#flash("success")#</strong>
					</div>
				</cfif>
				
				<cfoutput>#includeContent()#</cfoutput>
				
			</section>
			
		</body>
	</html>

</cfoutput>