<cfoutput>
	
	<!DOCTYPE html>
	<html class="no-js" lang="en">
		<head>
			<meta charset="utf-8">
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<title>Recovery | Web Panel</title>
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
					vendor/js/plugins/fileupload/bootstrap-fileupload.js,
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
			
		</head>
		
		<body class="lost-password">
			
			<!-- Main page container -->
			<section class="container" role="main">
			
				<div class="row">
					<div class="col-sm-offset-2 col-sm-8">
						
						<!-- Header -->
						<h2>#includeContent("headerTitle")#</h2>
						
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
	
					</div>
				</div>
				
			</section>
			
		</body>
	</html>

</cfoutput>