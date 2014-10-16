<cfscript>
	// Your custom routes
	
	addRoute( 
        name="public~pageapps", 
		pattern="/y/[action]",
        controller="pageapps"
    );
	
</cfscript>