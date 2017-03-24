<cfoutput>
	<cfset contentFor(headerTitle	= '<span class="fa fa-user"></span> #qform.name#')>
	<cfif params.saveResult>		
		#qform.successcontent#
		#qform.successembed#
	<cfelse>
		#qform.failcontent#
		#qform.failembed# 
	</cfif>
	
</cfoutput>	