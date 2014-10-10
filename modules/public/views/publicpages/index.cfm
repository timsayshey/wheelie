<cfoutput>
	<cfset contentFor(siteTitle = getOption(qOptions,'seo_homepage_title').label)>
	<cfset contentFor(siteDesc = getOption(qOptions,'seo_homepage_description').label)>
	<cfset contentFor(siteKeywords = getOption(qOptions,'seo_homepage_keywords').label)>	
	
	<cfset staticPath = "/views/static/#request.site.urlid#/home.cfm">
    <cfset staticPathFull = expandPath(staticPath)>
    
    <cfif FileExists(staticPath)>
    	<cfset contentFor(staticPage = true)>
    	<cfinclude template="#staticPath#">
    <cfelse>
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
	
</cfoutput>