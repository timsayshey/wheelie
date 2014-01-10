<cfcomponent displayname="Log User Actions" output="false" mixin="model">

	
	<cffunction name="init">
		<cfset this.version = "1.0,1.1,1.1.4,1.1.5">
		<cfreturn this>
	</cffunction>

	
	<cffunction name="logUserActions" returntype="void" output="false" mixin="model">
		<cfargument name="userIdLocation" type="string" required="true" hint="I am the literal variable that contains the user Id (e.g. session.userId).">
		<cfargument name="createProperty" type="string" default="createdBy" hint="I am the name of the column to contain the id of the user who created this record.">
		<cfargument name="updateProperty" type="string" default="updatedBy" hint="I am the name of the column to contain the id of the user who last modified this record.">
		<cfargument name="deleteProperty" type="string" default="deletedBy" hint="I am the name of the column to contain the id of the user who deleted this record.">
		<cfset variables.wheels.class.logUserActions = Duplicate(arguments)>
		<cfset beforeValidationOnCreate(methods="$logUserActionsSetCreatedBy")>
		<cfset beforeValidation(methods="$logUserActionsSetUpdatedBy")>
	</cffunction>


	<cffunction name="$logUserActionsSetCreatedBy" returntype="boolean" output="false" mixin="model">
		<cfif StructKeyExists(variables.wheels.class.properties, variables.wheels.class.logUserActions.createProperty)and !IsNull(variables.wheels.class.logUserActions.userIdLocation)>
			<cfset this[variables.wheels.class.logUserActions.createProperty] = Evaluate(variables.wheels.class.logUserActions.userIdLocation)>
		</cfif> 
		<cfreturn true>
	</cffunction>


	<cffunction name="$logUserActionsSetUpdatedBy" returntype="boolean" output="false" mixin="model">
		<cfif StructKeyExists(variables.wheels.class.properties, variables.wheels.class.logUserActions.updateProperty) and !IsNull(variables.wheels.class.logUserActions.userIdLocation)>
			<cfset this[variables.wheels.class.logUserActions.updateProperty] = Evaluate(variables.wheels.class.logUserActions.userIdLocation)>
		</cfif> 
		<cfreturn true>
	</cffunction>


	<cffunction name="$addDeleteClause" returntype="array" access="public" output="false" mixin="model">
		<cfargument name="sql" type="array" required="true">
		<cfargument name="softDelete" type="boolean" required="true">
		<cfset var stuParam = {}>
		<cfset arguments.sql = core.$addDeleteClause(arguments.sql, arguments.softDelete)>
		<cfif StructKeyExists(variables.wheels.class, "logUserActions") and variables.wheels.class.softDeletion and arguments.softDelete and StructKeyExists(variables.wheels.class.properties, variables.wheels.class.logUserActions.deleteProperty) and !IsNull(variables.wheels.class.logUserActions.userIdLocation)>
			<cfset ArrayAppend(arguments.sql, ", #variables.wheels.class.logUserActions.deleteProperty# = ")>
			<cfset stuParam = {value=Evaluate(variables.wheels.class.logUserActions.userIdLocation), type=variables.wheels.class.properties[variables.wheels.class.logUserActions.deleteProperty].type}>
			<cfset ArrayAppend(arguments.sql, stuParam)>
		</cfif>
		<cfreturn arguments.sql>
	</cffunction>


</cfcomponent>
