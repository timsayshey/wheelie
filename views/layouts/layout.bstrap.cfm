<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Welcome</title>
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<cfoutput>
				
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
			
		#includeContent()#
	
	</cfoutput>
</body>
</html>