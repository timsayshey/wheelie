<cfinclude template="page.cfm">
<!---<cfoutput>
	<cfset contentFor(siteTitle = getOption(qOptions,'seo_homepage_title').label)>
	<cfset contentFor(siteDesc = getOption(qOptions,'seo_homepage_description').label)>
	<cfset contentFor(siteKeywords = getOption(qOptions,'seo_homepage_keywords').label)>	
    
	<!--- Check Static Page --->
    <cfset staticDir = "/views/static/">	
	<cfset staticPathFull = expandPath(staticDir)>
	
	<!--- Find Static Folder ie "3 - My Site" --->
	<cfdirectory action="list" directory="#staticPathFull#" listinfo="name" name="qStaticDir" filter="#request.site.id#_*" />
	
	<cfset staticPath = "#staticDir##qStaticDir.name#/home.cfm">
    <cfset staticPathFull = expandPath(staticPath)>
    
    <cfif FileExists(staticPathFull)>
    	<!--- Load Static Page --->
		<cfset contentFor(staticPage = true)>
    	<cfinclude template="#staticPath#">
    <cfelse>
    	<!--- Load DB Page --->
		<cfset pagetitleTemplate = getThemeTemplate("page-home")>
		
		<cfset page.content = processShortcodes(page.content)>
		
    	<cfif len(pagetitleTemplate)>
			<cfset pagetitle = capitalize(page.name)>
			<cfset pagecontent = page.content>
			<cfinclude template="#pagetitleTemplate#">
		<cfelse>
			<h1>#capitalize(page.name)#</h1>
        	<br class="clear"><br>	
			#page.content#
		</cfif>		   
        
    </cfif>    
	
</cfoutput>--->