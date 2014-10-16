<cfoutput>

	<cffunction name="siteIdEqualsCheck">
		<cfargument name="allowAllSiteRecords" default="true">
		
		<cfif !arguments.allowAllSiteRecords>
			<cfreturn "siteid = #getSiteId()#">
		</cfif>
		<cfreturn "(siteid=#getSiteId()# OR globalized = 1)">
	</cffunction>
	
	<cffunction name="getAdminTemplate">
		<cfargument name="templateId" default="">		
		<cfset themeTemplatePath = "/views/layouts/admin/templates/#templateId#.cfm">
		<cfset themeTemplatePathFull = expandPath(themeTemplatePath)>
		<cfif FileExists(themeTemplatePathFull)>
			<cfreturn themeTemplatePath>
		<cfelse>
			<cfreturn ""> 
		</cfif>
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
    
    <cffunction name="getAllUserFieldData">
    	<cfargument name="userid">
    	<cfscript>
			var loc = {};
			loc.user = model("UserGroupJoin").findAll(where="userid = '#arguments.userid#'", include="User,UserGroup");
			return model("FieldData").getAllFieldsAndUserData(
				modelid 	  = loc.user.usergroupid,
				foreignid	  = loc.user.userid,
				metafieldType = "usergroupfield"
			);
		</cfscript> 
    </cffunction>
    
    <!--- 
		<cfset qUserfieldData = getAllUserFieldData(session.user.id)>
		#getDatafieldVal(identifier="my-hairs-color",qData=qUserfieldData)#
		#getDatafieldVal(identifier="my-hairs-color",userid=session.user.id)#
	--->
    <cffunction name="getDatafieldVal">
		<cfargument name="identifier">
        <cfargument name="qData" default="">
        <cfargument name="userid" default="">
        
        <cfif isNumeric(arguments.userid)>
			<cfset arguments.qData = getAllUserFieldData(arguments.userid)>        
        </cfif>
        
        <cfif IsQuery(arguments.qData)>
            <cfquery dbtype="query" name="qQuery">
                SELECT * FROM arguments.qData
                WHERE identifier = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.identifier#">
            </cfquery>                
            <cfreturn qQuery.fielddata>
        </cfif>
	</cffunction>  
	
</cfoutput>