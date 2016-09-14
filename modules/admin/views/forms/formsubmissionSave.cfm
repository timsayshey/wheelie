<cfoutput>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> #qform.name#')>
	<cfif saveResult>		
		#qform.successcontent#
	<cfelse>
		#qform.failcontent#
	</cfif>
	
</cfoutput>	