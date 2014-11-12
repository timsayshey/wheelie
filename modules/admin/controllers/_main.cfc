<cfscript>
component output="false" extends="controllers.Controller"  
{	
	function init()
	{
		super.init();
		
		forceHttps(except="");
		
		filters(through="loginServerUser,deleteEmptyPassword,adminMenuDefaults,customAdminAppFilters,checkUserSessionSite,preHandler,filterDefaults,handleRedirect");
		filters(through="loggedOutOnly",except="login,loginPost,recovery,recoveryPost,jobapp,emailForm,register,registerPost,verifyEmail,formsubmissionSave");	//
		filters(through="loggedInExcept",only="login,recovery");	
		filters(through="setUserInfo");	
	}
	
	private function deleteEmptyPassword()
	{
		if(!isNull(params.user.password) AND !len(params.user.password) AND !isNull(params.user.passwordConfirmation))
		{
			StructDelete(params.user,"password");
			StructDelete(params.user,"passwordConfirmation");
		}
	}
	
	private function customAdminAppFilters()
	{
		include "/modules/adminapp/adminfilters.cfm";
	}
	
	private function checkUserSessionSite()
	{
		// Make sure user is on correct sitesession.user.globalized
		if(!isNull(session.user.siteid) AND session.user.siteid neq request.site.id AND (!isNull(session.user.globalized) AND session.user.globalized eq 0))
		{
			StructDelete(session,"user");
			redirectTo(route="admin~Action", module="admin", controller="users", action="login");
		}
	}
	
	private function loginServerUser()
	{		
		if(FindNoCase("cfschedule",lcase(CGI.HTTP_USER_AGENT)))
		{			
			request.isScheduledTask = true;
			session.user.id = 1;
			mailgun(
				mailTo	= application.wheels.adminEmail,
				from	= application.wheels.adminFromEmail,				
				subject	= "Railo Task Started",
				html	= "IP: #getIpAddress()#"
			);
		}		
	}
	
	private function handleRedirect()
	{		
		if(isNull(params.redir) AND isNull(session.loginRedir) AND isNull(session.user.id) AND !find("user",lcase(cgi.PATH_INFO)))
		{
			session.loginRedir = cgi.PATH_INFO;
		}
		
		if(!isNull(params.redir) AND isNull(session.loginRedir))
		{
			session.loginRedir = URLDecode(params.redir);
		}
		
		if(!isNull(session.loginRedir) AND !isNull(session.user.id) AND !find("http",session.loginRedir))
		{
			tempRedir = session.loginRedir;
			StructDelete(session,"loginRedir");
			location(tempRedir,false); abort;	
		}
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
	
	private function statusTabs(modelName, prepend="", include="")
	{
		count = {};
		
		count.published = model(arguments.modelName).
			findAll(
				where=buildWhereStatement(modelName=arguments.modelName, prepend=arguments.prepend, status='published'), 
				select="id",
				include=arguments.include
			).recordcount;
			
		count.draft = model(arguments.modelName).
			findAll(
				where=buildWhereStatement(modelName=arguments.modelName, prepend=arguments.prepend, status='draft'), 
				select="id",
				include=arguments.include
			).recordcount;
			
		count.all = model(arguments.modelName).
			findAll(
				where=buildWhereStatement(modelName=arguments.modelName, prepend=arguments.prepend, status='all'), 
				select="id",
				include=arguments.include
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
	
	private function loggedOutOnly()
	{			
		// Authenticate
		if(!StructKeyExists(session,"user"))
		{			
			redirectTo(route="admin~Action", module="admin", controller="users", action="login");
		}	
	}
	
	private function loggedInExcept()
	{	
		// Authenticate
		if(StructKeyExists(session,"user"))
		{			
			redirectTo(route="admin~Action", module="admin", controller="main", action="home");
		}	
	}
	
	function setUserInfo()
	{	
		// Authenticate
		if(StructKeyExists(session,"user"))
		{
			var user = model("UserGroupJoin").findAll(where="userid = '#session.user.id#'", include="User,UserGroup");
			//var user = model("User").findAll(where="id = '#session.user.id#'");
			session.user = {
				id 			= user.userid,
				fullname 	= user.firstname & " " & user.lastname,
				firstname 	= user.firstname,
				lastname 	= user.lastname,
				role		= user.usergrouprole,
				email 		= user.email,
				siteid		= user.siteid,
				globalized	= user.globalized
			};
			
			if(len(trim(user.role)))
			{
				session.user.role = user.role;
			}
			
			if(len(trim(session.user.id)) eq 0)
			{
				flashInsert(error="There was an issue with your account. Try again.");			
				StructDelete(session,"user");
			}
		}
	}
	
	private function preHandler()
	{	
		usesLayout("/layouts/admin/layout");
		
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