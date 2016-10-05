<cfcomponent mixin="controller">

	<cffunction name="init">
		<cfset this.version = "1.3,1.3.1,1.3.2,1.3.3,1.4.4,1.4.5,1.4.6,1.4.7,1.4.8,1.4.9,1.5,1.5.0,1.5.1,1.5.2">
		<cfreturn this>
	</cffunction>

	<cffunction name="errorMessageOn" returntype="string" access="public" output="false" hint="Returns the error message, if one exists, on the object's property. If multiple error messages exist, the first one is returned.">
		<cfargument name="objectName" type="string" required="true" hint="The variable name of the object to display the error message for.">
		<cfargument name="association" type="string" required="false" default="" hint="See documentation for @textfield.">
		<cfargument name="position" type="string" required="false" default="" hint="See documentation for @textfield.">
		<cfargument name="property" type="string" required="true" hint="The name of the property to display the error message for.">
		<cfargument name="prependText" type="string" required="false" hint="String to prepend to the error message.">
		<cfargument name="appendText" type="string" required="false" hint="String to append to the error message.">
		<cfargument name="wrapperElement" type="string" required="false" hint="HTML element to wrap the error message in.">
		<cfargument name="class" type="string" required="false" hint="CSS class to set on the wrapper element.">
		<cfscript>
			var loc = {
				coreErrorMessageOn=core.errorMessageOn
			};

			arguments.objectName = $objectName(argumentCollection=arguments);
		</cfscript>
		<cfreturn loc.coreErrorMessageOn(argumentCollection=arguments)>
	</cffunction>

</cfcomponent>