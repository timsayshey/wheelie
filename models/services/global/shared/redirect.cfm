<cfoutput>

	<!--- Shared Redirects --->
	<cffunction name="redirects" hint="Redirects for SEO and other purposes">
		<cfscript>
			/* DB Redirects */
			if(!application.containsKey("qRedirects")) {
				application.qRedirects = new Query(sql="SELECT * FROM redirects WHERE siteid='#request.site.id#'",datasource=application.wheels.dataSourceName).execute().getResult();
			}
			for (var redirect in application.qRedirects) findThenRedirect(redirect.if_matches_this,redirect.then_redirect_to);
		</cfscript>
	</cffunction>

	<cffunction name="redirectUrl">
		<cfargument name="URL" required="yes">
		<cfset prepend = "">
		<cfif !findNoCase('http', arguments.url)>
			<cfset prepend = "http://#cgi.SERVER_NAME#">
		</cfif>
		<cfset redirectFullUrl(prepend&"#arguments.URL##len(cgi.query_string) ? "?" : ""##cgi.query_string#")>
	</cffunction>

	<cffunction name="golocation">
		<cfargument name="URL" required="yes">
		<cfset prepend = "">
		<cfif !findNoCase('http', arguments.url)>
			<cfset prepend = "http://#cgi.SERVER_NAME#">
		</cfif>
		<cfset urlPath = prepend&"#arguments.URL#">
		<cfset replaceNoCase(urlPath, "//", "/")>
		<cfset redirectFullUrl(urlPath)>
	</cffunction>

	<cffunction name="redirectFullUrl">
		<cfargument name="URL" required="yes">
		<cfheader statuscode="301" statustext="Moved Permanently">
		<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
		<cfheader name="Location" value="#arguments.URL#">
		<cfabort>
	</cffunction>

	<cffunction name="findThenRedirect">
		<cfargument name="searchString" required="yes">
		<cfargument name="redirectTo" required="yes">

		<cfset cgiPathInfo = ListFirst(cgi.path_info,"?")>
		<cfset cgiPathInfo = LCase(cgiPathInfo)>
		<cfset searchString = LCase(arguments.searchString)>

		<cfif Find(searchString,cgiPathInfo)>
			<cfset redirectUrl(arguments.redirectTo)>
		</cfif>
	</cffunction>

</cfoutput>
