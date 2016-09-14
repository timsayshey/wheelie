<cfoutput>
	<!--- Register all plugins here - called by functions.cfm to register plugins --->
	<cfset pluginsDir = '/views/plugins/'>
	<cfset pluginsDirFull = expandPath(pluginsDir)>
	
	<cfdirectory name="pluginsList" action="list" directory="#pluginsDirFull#">
	
	<cfloop query="pluginsList">
		<cfif pluginsList.type eq "dir">
			<cfif FileExists("#pluginsDirFull##pluginsList.name#\index.cfm") AND !isNull(variables["plugin_shortcode_#pluginsList.name#"])>
				<cfset addShortcode("#pluginsList.name#", variables["plugin_shortcode_#pluginsList.name#"])>
			</cfif>
		</cfif>
	</cfloop>
</cfoutput>