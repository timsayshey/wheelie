<!--- Initialize Cachbox
<cfscript>
	application.cacheBox = createObject("component","cachebox.system.cache.CacheFactory").init();
</cfscript>

<cfloop list="sql,image,main,action,page,partial,query" index="category">
	<cfset application.wheels.cache[category] = application.cachebox.addDefaultCache("wheels_#category#")>
</cfloop>  ---> 

<!--- Initialize Shortcode plugins --->
<cfset application.shortcodes={}>
<cfinclude template="/views/plugins/plugins-init.cfm">
