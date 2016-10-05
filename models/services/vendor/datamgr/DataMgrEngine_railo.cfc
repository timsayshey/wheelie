<cfcomponent>
<cffunction name="getRailoQueryAttributes" access="public" returntype="struct" output="no">
	<cfset var sRailoQuery = StructNew()>
	
	<cfset sRailoQuery["name"] = "qQuery">
	<cfset sRailoQuery["datasource"] = variables.datasource>
	<cfset sRailoQuery["psq"] = "true">
	<cfif StructKeyExists(variables,"username") AND StructKeyExists(variables,"password")>
		<cfset sRailoQuery["username"] = variables.username>
		<cfset sRailoQuery["password"] = variables.password>
	</cfif>
	<cfif variables.SmartCache>
		<cfset sRailoQuery["cachedafter"] = "#variables.CacheDate#">
	</cfif>
	
	<cfreturn sRailoQuery>
</cffunction>

<cffunction name="runSQL" access="public" returntype="any" output="no" hint="I run the given SQL.">
	<cfargument name="sql" type="string" required="yes">
	
	<cfset var qQuery = 0>
	<cfset var thisSQL = "">
	
	<cfif Len(arguments.sql)>
		<cfquery attributeCollection="#getRailoQueryAttributes()#">#Trim(arguments.sql)#</cfquery>
	</cfif>
	
	<cfif IsDefined("qQuery") AND isQuery(qQuery)>
		<cfreturn qQuery>
	</cfif>
	
</cffunction>

<cffunction name="runSQLArray" access="public" returntype="any" output="no" hint="I run the given array representing SQL code (structures in the array represent params).">
	<cfargument name="sqlarray" type="array" required="yes">
	
	<cfset var qQuery = 0>
	<cfset var ii = 0>
	<cfset var temp = "">
	<cfset var aSQL = cleanSQLArray(arguments.sqlarray)>
	
	<cftry>
		<cfif ArrayLen(aSQL)>
			<cfquery attributeCollection="#getRailoQueryAttributes()#"><cfloop index="ii" from="1" to="#ArrayLen(aSQL)#" step="1"><cfif IsSimpleValue(aSQL[ii])><cfset temp = aSQL[ii]>#Trim(temp)#<cfelseif IsStruct(aSQL[ii])><cfset aSQL[ii] = queryparam(argumentCollection=aSQL[ii])><cfswitch expression="#aSQL[ii].cfsqltype#"><cfcase value="CF_SQL_BIT">#getBooleanSqlValue(aSQL[ii].value)#</cfcase><cfcase value="CF_SQL_DATE,CF_SQL_DATETIME">#CreateODBCDateTime(aSQL[ii].value)#</cfcase><cfdefaultcase><!--- <cfif ListFindNoCase(variables.dectypes,aSQL[ii].cfsqltype)>#Val(aSQL[ii].value)#<cfelse> ---><cfqueryparam value="#sqlvalue(aSQL[ii].value,aSQL[ii].cfsqltype)#" cfsqltype="#aSQL[ii].cfsqltype#" maxlength="#aSQL[ii].maxlength#" scale="#aSQL[ii].scale#" null="#aSQL[ii].null#" list="#aSQL[ii].list#" separator="#aSQL[ii].separator#"><!--- </cfif> ---></cfdefaultcase></cfswitch></cfif> </cfloop></cfquery>
		</cfif>
	<cfcatch>
		<cfthrow message="#CFCATCH.Message#" detail="#CFCATCH.detail#" extendedinfo="#readableSQL(aSQL)#">
	</cfcatch>
	</cftry>
	
	<cfif IsDefined("qQuery") AND isQuery(qQuery)>
		<cfreturn qQuery>
	</cfif>
	
</cffunction>

</cfcomponent>