<cfoutput>
	<cfset contentFor(headerTitle	= '<span class="fa fa-user"></span> #qform.name#')>
	<cfif saveResult>
		#qform.successcontent#
	<cfelse>
		#qform.failcontent#
	</cfif>

</cfoutput>
