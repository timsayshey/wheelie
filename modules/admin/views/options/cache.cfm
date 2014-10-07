<cfif LEFT(cgi.REMOTE_ADDR,5) neq "10.1.">
	<cfabort>
</cfif>

<!---  Import Report Tags: use /cachebox/system if using standalone --->
<cfimport prefix="cachebox" taglib="/models/services/cachebox/system/cache/report">

<!---  Create CacheBox with default configuration --->
<cfif structKeyExists(url,"reinit") OR NOT structKeyExists(application,"cacheBox")>
    <cfset application.cacheBox   = createObject("component","cachebox.coldbox.system.cache.CacheFactory").init()>
<cfelse>
    <cfset cachebox = application.cacheBox>
</cfif>

<cfoutput>
<html>

    <head>
        <title>CacheBox Monitor Tool</title>
    </head>
    <body>

    <!---  Special ToolBar --->
    <div id="toolbar">
        <input type="button" value="Reinit" onClick="window.location='index.cfm?reinit'"/>
    </div>
    
    <!---  Render Report Here --->
    <cachebox:monitor cacheFactory="#cacheBox#"/>

    </body>
</html>
</cfoutput> 