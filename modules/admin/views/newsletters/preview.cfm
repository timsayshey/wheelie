<cfoutput>	
	<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Preview')>
	<cfset contentFor(headerButtons = 
		'<li class="headertab">
			<a href="##" class="btn btn-default" onclick="javascript:window.history.back(-1);return false;">
				<span class="elusive icon-arrow-left"></span> Go Back
			</a>	
		</li>')>
	
	<div style="max-width:700px; margin:0 auto">
	
		<h2>#newsletter.subject#</h2>
		<h4>#request.site.name# (info@#request.site.domain#)</h4>
		<h5>Sent: #DateFormat(now(),"ddd M/D/YYYY")# 12:16 PM
		
		</h5>
		<h5>To: Bob Johnson</h5>
		
		<iframe src='#urlFor(
			route		= "admin~Id", 
			module		= "admin",
			controller	= "newsletters", 
			action		= "generate", 
			id			= params.id
		)#' 
		class="newsletterPreview">
	
	</div>
	
</cfoutput>