<cfoutput>
	
	<!--- Shared Redirects --->
	<cffunction name="redirects" hint="Redirects for SEO and other purposes">   
		<cfscript>
			/* Force NO WWW 
			if(listfirst(cgi.server_name,".") eq "www")
			{
				redirectFullUrl(
					"http://" & 
						ListDeleteAt(cgi.server_name,1,'.') & 
							cgi.path_info & 
								(len(cgi.query_string) ? "?" : "") & 
									cgi.query_string
				);
			}
			*/

			/* DB Redirects */
			redirects = db.getRecords("redirects",{siteid=request.site.id});			
			for (redirect in redirects)
			{
				findThenRedirect(redirect.if_matches_this,redirect.then_redirect_to);
			} 
		</cfscript>
	</cffunction> 
	
	<cffunction name="redirectUrl">
		<cfargument name="URL" required="yes">		
		<cfset redirectFullUrl("http://#cgi.SERVER_NAME##arguments.URL##len(cgi.query_string) ? "?" : ""##cgi.query_string#")>	
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