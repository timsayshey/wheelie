<cfoutput>
	
	<cfif !isNull(session.referer)>
		<strong>Referrer:</strong> 
		#session.referer#<br><br>		
	</cfif>
	
	<cfif !isNull(session.entryPage)>
		<strong>Entry Page:</strong> 
		#session.entryPage#<br><br>
	</cfif>
	
	<strong>From Page:</strong>  
	#cgi.HTTP_REFERER#<br><br>
	
	<strong>Mobile:</strong>  
	#isMobile()#<br><br>
	
	<strong>State Lookup (May be innaccurate):</strong> 
	<a href='http://www.geoiptool.com/en/?IP=#getIpAddress()#'>Click Here</a><br><br>
	
	<cfif !isNull(session.user.fullname)>
		<strong>Logged in user:</strong> <a href="mailto:#session.user.email#">#session.user.fullname#</a><br><br>
	</cfif>

</cfoutput>