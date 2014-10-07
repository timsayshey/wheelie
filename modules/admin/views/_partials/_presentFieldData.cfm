<cfoutput>

	<cfparam name="dataFields" type="query">
	
	<cfloop query="dataFields">			
		<cfset selectTagValues = ListToArray(replaceLineBreaksWithCommas(dataFields.fieldvalues))>
		<cfif dataFields.type eq "headline">
			<span><strong>#dataFields.name#</strong></span>
			<br><br>
		<cfelseif dataFields.type eq "separator">
			<br><hr><br>
		<cfelseif len(trim(dataFields.fielddata))>
			<span><strong>#dataFields.name#:</strong></span>
			#dataFields.fielddata#
			<br><br>
		</cfif>
	</cfloop>

</cfoutput>