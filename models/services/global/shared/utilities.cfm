<cfoutput>

	<cffunction name="siteIdEqualsCheck">
		<cfargument name="allowAllSiteRecords" default="true">
		
		<cfif !arguments.allowAllSiteRecords>
			<cfreturn "siteid = #getSiteId()#">
		</cfif>
		<cfreturn "(siteid=#getSiteId()# OR globalized = 1)">
	</cffunction>
	
	<cffunction name="getThemeTemplate">
		<cfargument name="templateId" default="">		
		<cfset themeTemplatePath = "/views/themes/#request.site.theme#/templates/#templateId#.cfm">
		<cfset themeTemplatePathFull = expandPath(themeTemplatePath)>
		<cfif FileExists(themeTemplatePathFull)>
			<cfreturn themeTemplatePath>
		<cfelse>
			<cfreturn "">
		</cfif>
	</cffunction>
	
</cfoutput>