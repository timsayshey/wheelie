<cfsilent>
	<!--- Register all plugins here - called by functions.cfm to register plugins --->
	<cfset pluginsDir = '/views/plugins/'>
	<cfset pluginsDirFull = expandPath(pluginsDir)>
	
	<cfdirectory name="pluginsList" action="list" directory="#pluginsDirFull#">
	
	<cfloop query="pluginsList">
		<cfif pluginsList.type eq "dir">
			<cfif FileExists("#pluginsDirFull##pluginsList.name#\index.cfm")>
				<cfinclude template="#pluginsDir##pluginsList.name#/index.cfm">
			</cfif>
		</cfif>
	</cfloop>
</cfsilent>