<cfset application.name = "Tools">
<cfset db = CreateObject("component","models.services.datamgr.DataMgr").init("db")>
<cffunction name="cleanUrlId" output="no">
	<cfargument name="dirtystring">
	
	<cfscript>
		cleanstring = removehtml(dirtystring);
		cleanstring = REReplace(cleanstring,"[^0-9A-Za-z_ -]","","all");
		cleanstring = replace(trim(cleanstring)," ","-","ALL");	 
	</cfscript>
	
	<cfreturn trim(cleanstring)>
</cffunction>

<cffunction name="removehtml" output="no">
	<cfargument name="dirtystring">
	<cfreturn REReplace(dirtystring,'<[^>]*>','','all')>
</cffunction>