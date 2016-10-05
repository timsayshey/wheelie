<cftry>
<cfoutput>

	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> Team')>
	
	<cfloop query="users">
		<cfset user = users>		
		<cfset link = urlFor(									
			route		= "admin~Id",
			module		= "admin",
			controller	= "profiles",
			action		= "profile",
			id			= user.id
		)>
		<div class="listbox col-sm-6 col-xs-12 col-md-6 col-lg-4">	
			<div class="well bootsnipp-thumb">								
				<cfset thumbpath = fileExists(expandPath("/assets/userpics/#user.id#.jpg")) ? "/assets/userpics/#user.id#.jpg" : '/assets/img/user_thumbholder.jpg'>
				<cfif len(thumbPath)>
					<a href='#link#' class="filethumb col-md-3 col-sm-3 col-xs-4 roundy" style="												
						<cfif fileExists(thumbPath)>
							background-image:url('#thumbPath#');
						</cfif>
					">
						<img src="/assets/img/overlay.png">
					</a>
					<div class="col-md-9 col-sm-9 col-xs-8">
				<cfelse>
					<div class="col-md-12 col-sm-12 col-xs-12">
				</cfif>
				
					<a href='#link#' class="boxtitle">#capitalize(user.firstName)# #capitalize(user.lastName)#</a>								
					<br class="clear" />
					
					<div class="pull-right">								
						
						
						
					</div>		
					
				</div>
				<br class="clear" />
			</div>
		</div>
	</cfloop>
	<br class="clear">
</cfoutput>
<cfcatch>
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>