<cfscript>
	// Your custom routes
	
	adminUrlPath = application.info.adminUrlPath; // default "/manager"
	
	addRoute( 
        name="public~pageapps", 
		pattern="/y/[action]",
        controller="pageapps"
    );
	
</cfscript>