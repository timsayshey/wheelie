<cfscript>
	// Your custom routes
	
	adminUrlPath = application.info.adminUrlPath;
	
	addRoute( 
        name="public~pageapps", 
		pattern="/y/[action]",
        controller="pageapps"
    );
	
</cfscript>