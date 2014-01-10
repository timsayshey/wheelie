<cfscript>
component output="false" extends="controllers.Controller"  
{	
	function init()
	{
		filters(through="preHandler,sharedQueries,filterDefaults");
		filters(through="loggedOutOnly",except="login,loginPost,recovery,recoveryPost,register,registerPost");	
		filters(through="loggedInExcept",only="login,recovery");	
		filters(through="setUserInfo");		
		
		super.init();			
	}
	
	private function filterDefaults()
	{
		// Filter defaults
		param name="params.status" default="all";
		param name="session.perPage" default="10";
		param name="session.display" default="grid";		
		param name="params.search" default="";
		param name="params.hosted" default="";
		param name="params.filtercategories" default="";
		
		param name="params.p" default="1";
		
		// Video filter defaults
		param name="session.videos.sortby" default="name";
		param name="session.videos.order" default="asc";		
		
		// User filter defaults
		param name="session.users.sortby" default="firstname";
		param name="session.users.order" default="asc";
		
		// Page filter defaults
		param name="session.pages.sortby" default="name";
		param name="session.pages.order" default="asc";
		
		// Post filter defaults
		param name="session.posts.sortby" default="name";
		param name="session.posts.order" default="asc";
		
		// Option filter defaults
		param name="session.options.sortby" default="label";
		param name="session.options.order" default="asc";
	}
	
	// Usually called when a user clicks the clear button
	private function resetIndexFilters()
	{
		session.perPage = "10";
		//session.display = "grid";
		params.p = "1";		
		params.filtercategories = "";	
		params.search = "";
		params.hosted = "youtube";
		
		// Video filter defaults
		session.videos.sortby = "name";
		session.videos.order = "asc";
		
		// User filter defaults
		session.users.sortby = "firstname";
		session.users.order = "asc";
		
		// Page filter defaults
		session.pages.sortby = "name";
		session.pages.order = "asc";
		
		// Option filter defaults
		session.options.sortby = "label";
		session.options.order = "asc";
		
		Location("http://#cgi.SERVER_NAME##cgi.PATH_INFO#?",false);
	}
	
	private function handleSubmitType(modelName,submitType)
	{
		// If submit button was trash then delete it
		if(submitType eq "trash")
		{
			params.id = params[modelName]["id"];
			delete(); // Calls child's delete function
		} 
		else
		{
			return submitType;
		}
	}
	
	private function statusTabs(modelName, prepend)
	{
		count = {};
		
		count.published = model(arguments.modelName).
			findAll(
				where=buildWhereStatement(modelName=arguments.modelName, prepend=arguments.prepend, status='published'), 
				select="id"
			).recordcount;
			
		count.draft = model(arguments.modelName).
			findAll(
				where=buildWhereStatement(modelName=arguments.modelName, prepend=arguments.prepend, status='draft'), 
				select="id"
			).recordcount;
			
		count.all = model(arguments.modelName).
			findAll(
				where=buildWhereStatement(modelName=arguments.modelName, prepend=arguments.prepend, status='all'), 
				select="id"
			).recordcount;
	}
	
	private function buildWhereStatement(modelName="", prepend="", status=params.status)
	{
		loc = {};
		
		loc.wherestatement = arguments.status EQ "all" ? wherePermission(arguments.modelName) : "status = '#arguments.status#'" & wherePermission(arguments.modelName,"AND");
		
		if(len(arguments.prepend) AND len(loc.wherestatement))
		{
			loc.wherestatement = prepend & " " & loc.wherestatement;
		} 
		else if (len(arguments.prepend)) 
		{
			loc.wherestatement = prepend & " id IS NOT NULL";
		}
		
		return loc.wherestatement;
	}
	
	private function sharedQueries()
	{
		qOptions = model("Option").findAll();
	}
	
	private function loggedOutOnly()
	{	
		// Authenticate
		if(!StructKeyExists(session,"user"))
		{			
			redirectTo(route="moduleAction", module="admin", controller="users", action="login");
		}	
	}
	
	private function loggedInExcept()
	{	
		// Authenticate
		if(StructKeyExists(session,"user"))
		{			
			redirectTo(route="moduleAction", module="admin", controller="main", action="home");
		}	
	}
	
	private function setUserInfo()
	{	
		// Authenticate
		if(StructKeyExists(session,"user"))
		{
			var user = model("User").findAll(where="id = '#session.user.id#'");
			session.user = {
				id 			= user.id,
				fullname 	= user.firstname & " " & user.lastname,
				firstname 	= user.firstname,
				lastname 	= user.lastname,
				role 		= user.role,
				email 		= user.email,
				portrait	= user.portrait
			};
			if(len(trim(session.user.id)) eq 0)
			{
				flashInsert(error="There was an issue with your account. Try again.");			
				StructDelete(session,"user");
			}
		}
	}
	
	private function preHandler()
	{	
		usesLayout("/layouts/layout.admin");
		
		if(!isNull(params.format) AND params.format eq "modal") 
		{
			usesLayout("/layouts/layout.modal");	
		}
		
		if(!isNull(params.ajax))
		{
			isAjaxRequest = 1;
			usesLayout("/layouts/layout.blank");	
		}
	}
}
</cfscript>