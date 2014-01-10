<cfscript>

	// Public Routes 
	addRoute(
        name="public~secondaryPage", 
		pattern="/p/[id]",
        controller="publicPages", 
		action="page"
    );
	
	addRoute(
        name="public~usertags", 
		pattern="/users/t/[id]",
        controller="publicUsers", 
		action="usertag"
    );	
	
	// Admin Routes
	addRoute(
        name="admin~CategoryId", 
		pattern="/m/admin/categories/[action]/[modelName]/[id]/",
        controller="categories"
    );
	
	addRoute(
        name="admin~Category", 
		pattern="/m/admin/categories/[action]/[modelName]",
        controller="categories"	
    );
	
	// Default Module Routes
	addRoute(
        name="moduleId", 
		pattern="/m/[module]/[controller]/[action]/[id].[format]",
		id=""
    );
	addRoute(
        name="moduleAction", 
		pattern="/m/[module]/[controller]/[action]"
    );
	
	addRoute(
        name="moduleIndex", 
		pattern="/m/[module]/[controller]",
		action="index"
    );
	
	addRoute(
        name="moduleHome", 
		pattern="/m/[module]",
		action="home",
		controller="main"
    );
	
	// Home root has to be last otherwise it will takeover every route
	addRoute(
        name="public~home", 
		pattern="/",
        controller="publicPages", 
		action="index"
    ); 
	
</cfscript>