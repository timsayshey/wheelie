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

<cfscript>
try {
	// Location to your properties file
	var pFile = expandPath('../system.properties');
	// Init Props
	var props = CreateObject("java","java.util.Properties").init();
	// Load the file into the props
	props.load( CreateObject("java","java.io.FileInputStream").init(pFile) );
	props = Duplicate(props);
	application.runtimeconfig = {};

	for(var key in structKeyList(props)) {
		application.runtimeconfig[key] = props[key];
	}
} catch(any e){
	application.runtimeconfig = {"error":"system.properties file is missing."};
}
</cfscript>
