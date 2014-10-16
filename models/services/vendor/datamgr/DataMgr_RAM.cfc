<!--- 2.5.1 (Build 173) --->
<!--- Last Updated: 2013-09-16 --->
<!--- Created by Steve Bryant 2004-12-08 --->
<cfcomponent extends="DataMgr_Derby" displayname="Data Manager for Apache Derby in RAM" hint="I manage data interactions with an in-memory Derby database.">

<cffunction name="init" access="public" returntype="DataMgr" output="no" hint="I instantiate and return this object.">
	<cfargument name="datasource" type="string" required="no" default="#variables.DefaultDatasource#">
	<cfargument name="database" type="string" required="no">
	<cfargument name="username" type="string" required="no">
	<cfargument name="password" type="string" required="no">
	<cfargument name="SmartCache" type="boolean" default="false">
	<cfargument name="SpecialDateType" type="string" default="CF">
	<cfargument name="XmlData" type="string" required="no">
	
	<cfset var me = super.init(argumentCollection=arguments)>
	
	<cfset variables.conn = createObject('java','java.sql.DriverManager').getConnection('jdbc:derby:memory:#arguments.datasource#;create=true')>
	
	<cfreturn me>
</cffunction>

</cfcomponent>