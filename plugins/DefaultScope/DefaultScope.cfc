<cfcomponent output="false">

	<cffunction name="init">
		<cfscript>
			this.version = "1.0.5,1.0.4,1.0.3,1.0.2,1.0.1,1.0,1.1,1.1.1";
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="findAll" access="public" mixin="model">
		<cfscript>
			var findAllOriginal = core.findAll; // this is to avoid a bug in CF8 where a method called as part of a struct will throw an error when passed an argument collection.
			var key = "";
			if(not structKeyExists(arguments, "exclusive")) arguments.exclusive = false;
			// Note: we could use a less similar/ambiguous key name such as `stack` or `stackArguments`... thinking out loud..
			if(not structKeyExists(arguments, "inclusive")) arguments.inclusive = false;
			if(arguments.exclusive && arguments.inclusive)
				$throw(type="Wheels.invalidFormat"
					, message="Both arguments `exclusive` and `inclusive` are mutually exclusive. Both cannot be true in the same request.");
			// loop over the default arguments
			if (StructKeyExists(variables.wheels.class,"defaultScope") && not arguments.exclusive) {
				for(key in variables.wheels.class.defaultScope) {
					// if not present in the arguments, copy the default value
					if($IsValidFindAllArgument(key)) {
						if (not StructKeyExists(arguments,key)) {
							arguments[key] = variables.wheels.class.defaultScope[key];
						}
						// Don't use the new stack mode unless we use the `inclusive` argument
						// This should help keep backward compatilbility
						else if (arguments.inclusive) {
							switch(key) {
								case "select": case "order":
									arguments[key] = "#arguments[key]#, #variables.wheels.class.defaultScope[key]#";
									break;
								case "where":
									arguments[key] = "(#arguments[key]#) AND (#variables.wheels.class.defaultScope[key]#)";
									break;
							}
						}
					}
				}
			}
			//Cleanup before passing our arguments to Wheels, to be on the safe side...
			StructDelete(arguments, "exclusive");
			StructDelete(arguments, "inclusive");

			return findAllOriginal(argumentCollection=arguments);
		</cfscript>
	</cffunction>


	<cffunction name="defaultScope" access="public" mixin="model">
		<cfscript>
			var key = "";
			// create/clear the settings struct
			variables.wheels.class.defaultScope = {};
			//loop over the incoming arguments and set them into the struct
			for(key in arguments) {
				if ($IsValidFindAllArgument(key))
					variables.wheels.class.defaultScope[key] = arguments[key];
			}
		</cfscript>
	</cffunction>


	<cffunction name="$IsValidFindAllArgument">
		<cfargument name="scopeName" type="string" required="true">
		<cfscript>
			return ( ListFindNoCase("where,order,select,distinct,include,maxRows,page,perPage,count,handle,cache,reload,parameterize,returnAs,returnIncluded",arguments.scopeName) gt 0);
		</cfscript>
	</cffunction>



	<!--- adding default ordering will break column statistics, so force remove it in the following overrides --->

	<cffunction name="count" access="public" mixin="model">
		<cfset var coreMethod = core.count>
		<cfset arguments.order = "">
		<cfreturn coreMethod(argumentCollection=arguments)>
	</cffunction>


	<cffunction name="average" access="public" mixin="model">
		<cfset var coreMethod = core.average>
		<cfset arguments.order = "">
		<cfreturn coreMethod(argumentCollection=arguments)>
	</cffunction>


	<cffunction name="minimum" access="public" mixin="model">
		<cfset var coreMethod = core.minimum>
		<cfset arguments.order = "">
		<cfreturn coreMethod(argumentCollection=arguments)>
	</cffunction>


	<cffunction name="maximum" access="public" mixin="model">
		<cfset var coreMethod = core.maximum>
		<cfset arguments.order = "">
		<cfreturn coreMethod(argumentCollection=arguments)>
	</cffunction>


	<cffunction name="sum" access="public" mixin="model">
		<cfset var coreMethod = core.sum>
		<cfset arguments.order = "">
		<cfreturn coreMethod(argumentCollection=arguments)>
	</cffunction>

</cfcomponent>
