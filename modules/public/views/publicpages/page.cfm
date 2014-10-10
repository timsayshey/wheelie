<cfoutput>
	
	<cfscript>
		if(!isNull(page.template))
		{
			if(page.template eq 'hide_sidebar')
			{
				request.page.hideSidebar = true;
			}
			else if(page.template eq 'normal_form')
			{
				request.page.regularContactForm = true;		
			}
			else if(page.template eq 'hide_sidebar_and_call_to_action')
			{
				request.page.hideSidebar = true;
				request.page.hideFooterCallToAction = true;	
			}
		}
	</cfscript>
	
	<cfif !isNull(page.quoteImg)>
		<cfif len(page.redirect)>
			<cflocation addtoken="no" url="#page.redirect#">
		</cfif>
		
		<cfset checkUrlExtension(checkUrl="/#page.urlid#")>
		
		<cfset contentFor(quoteImg = page.quoteImg)>
		<cfset contentFor(youtubeId = page.youtubeId)>
		<cfset contentFor(sideContent = page.sideContent)>
		<cfset contentFor(siteTitle = "#capitalize(page.name)# | #getOption(qOptions,'seo_subpage_title').label#")>		
		<cfset contentFor(siteDesc = page.metadescription)>
		<cfset contentFor(siteKeywords = page.metakeywords)>
	<cfelseif !isNull(params.format) AND !isNull(params.id) AND ListFind("jpg,pdf,mp3",lcase(params.format))>
		<!--- For Old CALO Files // Should Remove Later --->
		<cfheader statuscode="301" statustext="Moved Permanently">
		<cfheader name="Location" value="/assets/site/#params.id#.#params.format#">
		<cfabort>
	<cfelse>
		<cfheader statusCode="404" statusText="Not Found">
		<cfset log404()>
	</cfif>
    
	<cfset staticPath = "/views/static/#request.site.urlid#/#params.id#.cfm">
    <cfset staticPathFull = expandPath(staticPath)>
    
    <cfif FileExists(staticPath)>
    	<cfset contentFor(staticPage = true)>
    	<cfinclude template="#staticPath#">
    <cfelse>
		<cfset pageTemplate = getThemeTemplate("page-single")>
    	<cfset page.content = processShortcodes(page.content)>
		
		<cfif len(pageTemplate)>
			<cfset pagetitle = capitalize(page.name)>
			<cfset pagecontent = page.content>
			<cfinclude template="#pageTemplate#">
		<cfelse>
			<h1>#capitalize(page.name)#</h1>        
			<br class="clear">
			#facebookLikeButton()#	
			#page.content#	
		</cfif>		            
        
    </cfif>    
    
</cfoutput>