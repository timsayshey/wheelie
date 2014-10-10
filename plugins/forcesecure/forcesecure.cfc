<cfcomponent mixin="controller">

	<cffunction name="init">
		<cfset this.version = "1.0,1.0.1,1.0.2,1.0.3,1.0.4,1.0.5,1.0.6,1.1,1.1.1,1.1.2,1.1.3,1.1.4,1.1.5,1.1.6,1.1.7,1.1.8">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="redirectSecureSubdomain">						
		<cfscript>
			var loc = {};
			if(getHttpSubdomain() eq "secure" AND !cgi.SERVER_PORT_SECURE)
			{
				$goForceHttp();
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="forceHttps" hint="Call this in a controller's `init()` method to add a before filter for forcing an HTTPS connection. If the requirement is not met, this will redirect the client to the HTTPS version of the URL.">
		<cfargument name="environments" type="string" required="false" default="" hint="List of environments in which to force the HTTPS connection. This is useful if you do not have SSL configured in your design and development environments, for example. This argument is aliased as `environment` if you want to use it for readability when specifying only one environment.">
		<cfargument name="only" type="string" required="false" default="" hint="Similar to the `only` argument for `filters()`, this allows you to specify a list of actions to only run the forced HTTPS on.">
		<cfargument name="except" type="string" required="false" default="" hint="Similar to the `except` argument for `filters()`, this allows you to specify a list of actions to exclude the forced HTTPS from running on.">
		<cfscript>
			var loc = {};
			loc.componentName = $getComponentNameKey();
			loc.reloadPassword = get('reloadPassword');

			// Allow app reload to clear settings
			if (
				StructKeyExists(url, "reload") && Len(url.reload)
				&& (!Len(loc.reloadPassword) || (StructKeyExists(url, "password") && loc.reloadPassword == url.password))
			)
			{
				StructDelete(application, "forceHttps");
			}

			// Argument is also aliased as `environment` singular
			if (!Len(arguments.environments) && StructKeyExists(arguments, "environment"))
				arguments.environments = arguments.environment;

			if (!StructKeyExists(application, "forceHttps"))
				application.forceHttps = {};

			if (!StructKeyExists(application.forceHttps, loc.componentName))
				application.forceHttps[loc.componentName] = {};

			if (!StructKeyExists(application.forceHttps[loc.componentName], "environments"))
				application.forceHttps[loc.componentName].environments = arguments.environments;

			filters(through="$forceHttps", only=arguments.only, except=arguments.except);
			
		</cfscript>
	</cffunction>

	<cffunction name="$forceHttps" hint="FILTER: Redirects user to HTTPS connection (same URL) if required for the current environment.">
		<cfset var loc = {}>
		<cfset loc.componentName = $getComponentNameKey()>		
		<cfif not cgi.SERVER_PORT_SECURE AND checkSiteSSL() eq 1>
			<cfscript>
				if(getHttpSubdomain() eq "secure")
				{
					loc.subdomain = "";
				}
				else
				{
					loc.subdomain = "secure.";
				}
				
				loc.redirectUrl = "https://" & loc.subdomain & cgi.HTTP_HOST & cgi.PATH_INFO; 

				if (Len(cgi.QUERY_STRING))
					loc.redirectUrl &= "?" & cgi.QUERY_STRING;
			</cfscript>
			
			<cflocation url="#loc.redirectUrl#" addtoken="false">
		</cfif>
		
	</cffunction>
	
	<cffunction name="forceHttp" hint="Call this in a controller's `init()` method to add a before filter for forcing an HTTPS connection. If the requirement is not met, this will redirect the client to the HTTPS version of the URL.">
		<cfargument name="environments" type="string" required="false" default="" hint="List of environments in which to force the HTTP connection. This is useful if you do not have SSL configured in your design and development environments, for example. This argument is aliased as `environment` if you want to use it for readability when specifying only one environment.">
		<cfargument name="only" type="string" required="false" default="" hint="Similar to the `only` argument for `filters()`, this allows you to specify a list of actions to only run the forced HTTP on.">
		<cfargument name="except" type="string" required="false" default="" hint="Similar to the `except` argument for `filters()`, this allows you to specify a list of actions to exclude the forced HTTP from running on.">
		<cfscript>
			var loc = {};
			loc.componentName = $getComponentNameKey();
			loc.reloadPassword = get('reloadPassword');

			// Allow app reload to clear settings
			if (
				StructKeyExists(url, "reload") && Len(url.reload)
				&& (!Len(loc.reloadPassword) || (StructKeyExists(url, "password") && loc.reloadPassword == url.password))
			)
			{
				StructDelete(application, "forceHttp");
			}

			// Argument is also aliased as `environment` singular
			if (!Len(arguments.environments) && StructKeyExists(arguments, "environment"))
				arguments.environments = arguments.environment;

			if (!StructKeyExists(application, "forceHttp"))
				application.forceHttp = {};

			if (!StructKeyExists(application.forceHttp, loc.componentName))
				application.forceHttp[loc.componentName] = {};

			if (!StructKeyExists(application.forceHttp[loc.componentName], "environments"))
				application.forceHttp[loc.componentName].environments = arguments.environments;

			filters(through="$forceHttp", only=arguments.only, except=arguments.except);
			
		</cfscript>
	</cffunction>
	
	<cffunction name="checkSiteSSL">
		<cfif !isNull(request.site.ssl) AND IsNumeric(request.site.ssl)>
			<cfreturn request.site.ssl>
		<cfelse>
			<cfreturn 0>
		</cfif>
	</cffunction>
	
	<cffunction name="$forceHttp" hint="FILTER: Redirects user to HTTP connection (same URL) if required for the current environment.">
		<cfset var loc = {}>
		<cfset loc.componentName = $getComponentNameKey()>
		
		<cfif cgi.SERVER_PORT_SECURE>
			<cfset $goForceHttp()>
		</cfif>
		
	</cffunction>
	<cffunction name="$goForceHttp">
		<cfset var loc = {}>
		<cfscript>
			loc.redirectDomain = Replace(lcase(cgi.HTTP_HOST),"secure.","","ALL");
			loc.redirectUrl = "http://" & loc.redirectDomain & cgi.PATH_INFO;

			if (Len(cgi.QUERY_STRING))
				loc.redirectUrl &= "?" & cgi.QUERY_STRING;
		</cfscript>
		
		<cflocation url="#loc.redirectUrl#" addtoken="false">
	</cffunction>
	<cffunction name="getHttpDomain">
		<cfset var loc = {}>
		<cfscript>
			loc.redirectDomain = Replace(lcase(cgi.HTTP_HOST),"secure.","","ALL");
			loc.redirectUrl = "http://" & loc.redirectDomain;
			
			return trim(loc.redirectUrl);
		</cfscript>
	</cffunction>
	
	<cffunction name="getHttpSubdomain">
		<cfset var loc = {}>
		<cfscript>
			loc.domain = lcase(cgi.HTTP_HOST);
			if(listlen(loc.domain,".") LTE 2)
			{
				return "";
			}
			else
			{
				return ListFirst(loc.domain,".");
			}
		</cfscript>
	</cffunction>
	
	<cffunction name="getHttpsDomain"><cfsilent>
		<cfset var loc = {}>
		<cfscript>
			if(!isNull(request.site.domain))
			{
				loc.domainname = request.site.domain;
			}
			else
			{
				loc.domainname = cgi.HTTP_HOST;
			}
			if(request.site.ssl neq 0)
			{
				loc.redirectUrl = "https://secure." & request.site.domain;		
			} else {
				loc.redirectUrl = "http://" & request.site.domain;		
			}
			return trim(loc.redirectUrl);
		</cfscript>
	</cfsilent></cffunction>	
	
	<cffunction name="$getComponentNameKey" returntype="string" hint="Returns current component name minus `controllers.`.">
		<cfreturn Replace(GetMetaData(this).name, "controllers.", "", "all")>
	</cffunction>

</cfcomponent>