<cfoutput>

	<cfset contentFor(headerTitle	= '<span class="fa fa-user"></span> #qform.name#')>

	<!--- Get Custom Fields --->
	#generateForm(formid=params.id)#
	<br class="clear"><br>

</cfoutput>
