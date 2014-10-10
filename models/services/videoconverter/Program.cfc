<cfcomponent output="false">
	
<cffunction name="config" access="public" returntype="void" output="no">
	<cfargument name="Config" type="any" required="yes">
	
</cffunction>

<cffunction name="components" access="public" returntype="string" output="yes">
<program name="Video Converter">
	<components>
		<component name="VideoConverter" path="[path_component]VideoConverter">
			<argument name="FileMgr" component="Manager" />
		</component>
	</components>
</program>
</cffunction>

</cfcomponent>