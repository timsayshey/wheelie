<cfcomponent>
	 <cffunction name="init">
		<cfset this.version = "1.3,1.3.1,1.3.2,1.3.3,1.4.4,1.4.5,1.4.6,1.4.7,1.4.8,1.4.9,1.5,1.5.0,1.5.1,1.5.2">
		<cfreturn this>
	</cffunction>	

	<!--- 
		Just added isNull(session.user) to 2 conditions so cache doesn't run for logged in users -- Per is working on fixing this for 1.3.3 or 2.0
		https://github.com/cfwheels/cfwheels/issues/439
	 --->
	
	<cffunction name="$CFQueryParameters" returntype="struct" access="public" output="false">
		<cfargument name="settings" type="struct" required="true">
		<cfscript>
			var loc = {};
			if (!StructKeyExists(arguments.settings, "value"))
			{
				arguments.settings.value = "0";
				//$throw(type="Wheels.QueryParamValue", message="The value for `cfqueryparam` cannot be determined", extendedInfo="This is usually caused by a syntax error in the `WHERE` statement, such as forgetting to quote strings for example.");
			}
			loc.rv = {};
			loc.rv.cfsqltype = arguments.settings.type;
			loc.rv.value = arguments.settings.value;
			if (StructKeyExists(arguments.settings, "null"))
			{
				loc.rv.null = arguments.settings.null;
			}
			if (StructKeyExists(arguments.settings, "scale") && arguments.settings.scale > 0)
			{
				loc.rv.scale = arguments.settings.scale;
			}
			if (StructKeyExists(arguments.settings, "list") && arguments.settings.list)
			{
				loc.rv.list = arguments.settings.list;
				loc.rv.separator = Chr(7);
				loc.rv.value = $cleanInStatementValue(loc.rv.value);
			}
		</cfscript>
		<cfreturn loc.rv>
	</cffunction>

</cfcomponent>