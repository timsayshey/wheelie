<cffunction name="checkPermission" hint="Checks a permission against permissions loaded into application scope for the user">
	<cfargument name="permission" required="true" hint="The permission name to check against">
	<cfscript>
		if(_permissionsSetup() AND structKeyExists(application.rbs.permission, arguments.permission))
		{			
			var permissionVal = application.rbs.permission[arguments.permission][_returnUserRole()];
			
			if(IsNumeric(permissionVal))
			{
				return permissionVal eq 1 ? "true" : "false";
			}
			else 
			{
				return permissionVal;
			}
			
		} else {
			return true;
		}
	</cfscript>
</cffunction>

<cffunction name="whereSiteid">
	<cfargument name="prepend" default="">
	<cfargument name="quoteSymbol" default="">
	<cfscript>			
		return "siteid=#getSiteId()#";
	</cfscript>
</cffunction>

<cffunction name="wherePermission">
	<cfargument name="modelName" default="">
	<cfargument name="prepend" default="">
	<cfargument name="quoteSymbol" default="">
	<cfscript>			
		if(checkPermission("#arguments.modelName#_read_others"))
		{
			return " #arguments.prepend# (siteid=#getSiteId()# OR globalized = 1)";
		
		} else if (checkPermission("#arguments.modelName#_read") OR (!isNull(params.id) AND params.id eq session.user.id)) {
			
			if(arguments.modelName eq "User") {
				return " #arguments.prepend# (id = '#session.user.id#' OR createdby = '#session.user.id#') AND (siteid=#getSiteId()# OR globalized = 1)";
			} else {
				return " #arguments.prepend# createdby = #quoteSymbol##session.user.id##quoteSymbol# AND (siteid=#getSiteId()# OR globalized = 1)";
			}
								
		} else {
			if(!isNull(flashInsert))
			{
				flashInsert(error="Sorry, you don't have permission to do that.");
			}
			Location("/m/admin");
		}
	</cfscript>
</cffunction>

<cffunction name="checkPermissionAndRedirect" hint="Checks a permission and redirects away to access denied, useful for use in filters etc">
	<cfargument name="permission" required="true" hint="The permission name to check against">
	<cfscript>
		if(!checkPermission(arguments.permission)){
			redirectTo(route="denied", error="Sorry, you have insufficient permission to access this. If you believe this to be an error, please contact an administrator.");
		}
	</cfscript>
</cffunction>
 
<cffunction name="_permissionsSetup" hint="Checks for the relevant permissions structs in application scope">
	<cfscript>
		if(structKeyExists(application, "rbs") AND structKeyExists(application.rbs, "permission")){
			return true;
		}
		else
		{
			return false;
		}
	</cfscript>
</cffunction>
 
<cffunction name="_returnUserRole" hint="Looks for user role in session, returns guest otherwise">
	<cfscript>
		if(_permissionsSetup() AND structKeyExists(session, "user") AND structKeyExists(session.user, "role") AND len(session.user.role)){
			return session.user.role;
		} else {
			return "guest";
		}
	</cfscript>
</cffunction>

<cffunction name="passcrypt">
	<cfargument name="password" default="changethis123">
	<cfargument name="type" default="encrypt">
	<cfset salt = application.wheels.passwordSalt>
	
	<cfscript>		
		if(arguments.type eq "encrypt")	{
			return encrypt(arguments.password, salt, "AES", "hex");	
		} 
		else if (arguments.type eq "decrypt") {
			return decrypt(arguments.password, salt, "AES", "hex");
		}
		else if (arguments.type eq "generateKey") {
			writeDump(generateSecretKey("AES")); abort;
		}
	</cfscript>
</cffunction>