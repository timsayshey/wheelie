<cfoutput>
	<cfparam name="fieldclass" default="">
	<cfparam name="dataFields" type="query">
	
	<cfloop query="dataFields">	
		
		<cfset field = dataFields>
		#includePartial("/_partials/formfield")#
		
	</cfloop>

</cfoutput>