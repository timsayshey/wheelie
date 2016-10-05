<cfcomponent>
	 <cffunction name="init">
		<cfset this.version = "1.3,1.3.1,1.3.2,1.3.3,1.4.4,1.4.5,1.4.6,1.4.7,1.4.8,1.4.9,1.5,1.5.0,1.5.1,1.5.2">
		<cfreturn this>
	</cffunction>	

<!--- 

	My notes on why I needed to fix urlFor()

	It keeps reformatting the slash in the url, gotta fix for LTC slashes in permalink

	See line 87 Where I replace the encoded slash manuually!

 --->


<cffunction name="URLFor" returntype="string" access="public" output="false" hint="Creates an internal URL based on supplied arguments."
	examples=
	'
		<!--- Create the URL for the `logOut` action on the `account` controller, typically resulting in `/account/log-out` --->
		##URLFor(controller="account", action="logOut")##

		<!--- Create a URL with an anchor set on it --->
		##URLFor(action="comments", anchor="comment10")##

		<!--- Create a URL based on a route called `products`, which expects params for `categorySlug` and `productSlug` --->
		##URLFor(route="product", categorySlug="accessories", productSlug="battery-charger")##
	'
	categories="global,miscellaneous" chapters="request-handling,linking-pages" functions="redirectTo,linkTo,startFormTag">
	<cfargument name="route" type="string" required="false" default="" hint="Name of a route that you have configured in `config/routes.cfm`.">
	<cfargument name="controller" type="string" required="false" default="" hint="Name of the controller to include in the URL.">
	<cfargument name="action" type="string" required="false" default="" hint="Name of the action to include in the URL.">
	<cfargument name="key" type="any" required="false" default="" hint="Key(s) to include in the URL.">
	<cfargument name="params" type="string" required="false" default="" hint="Any additional parameters to be set in the query string (example: `wheels=cool&x=y`). Please note that Wheels uses the `&` and `=` characters to split the parameters and encode them properly for you (using `URLEncodedFormat()` internally). However, if you need to pass in `&` or `=` as part of the value, then you need to encode them (and only them), example: `a=cats%26dogs%3Dtrouble!&b=1`.">
	<cfargument name="anchor" type="string" required="false" default="" hint="Sets an anchor name to be appended to the path.">
	<cfargument name="onlyPath" type="boolean" required="false" hint="If `true`, returns only the relative URL (no protocol, host name or port).">
	<cfargument name="host" type="string" required="false" hint="Set this to override the current host.">
	<cfargument name="protocol" type="string" required="false" hint="Set this to override the current protocol.">
	<cfargument name="port" type="numeric" required="false" hint="Set this to override the current port number.">
	<cfargument name="$URLRewriting" type="string" required="false" default="#application.wheels.URLRewriting#">
	<cfscript>
		var loc = {};
		$args(name="URLFor", args=arguments);
		loc.params = {};
		if (StructKeyExists(variables, "params"))
			StructAppend(loc.params, variables.params, true);
		if (application.wheels.showErrorInformation)
		{
			if (arguments.onlyPath && (Len(arguments.host) || Len(arguments.protocol)))
				$throw(type="Wheels.IncorrectArguments", message="Can't use the `host` or `protocol` arguments when `onlyPath` is `true`.", extendedInfo="Set `onlyPath` to `false` so that `linkTo` will create absolute URLs and thus allowing you to set the `host` and `protocol` on the link.");
		}

		// get primary key values if an object was passed in
		if (IsObject(arguments.key))
		{
			arguments.key = arguments.key.key();
		}

		// build the link
		loc.returnValue = application.wheels.webPath & ListLast(request.cgi.script_name, "/");
		if (Len(arguments.route))
		{
			// link for a named route
			loc.route = $findRoute(argumentCollection=arguments);
			if (arguments.$URLRewriting == "Off")
			{
				loc.returnValue = loc.returnValue & "?controller=";
				if (Len(arguments.controller))
					loc.returnValue = loc.returnValue & hyphenize(arguments.controller);
				else
					loc.returnValue = loc.returnValue & hyphenize(loc.route.controller);
				loc.returnValue = loc.returnValue & "&action=";
				if (Len(arguments.action))
					loc.returnValue = loc.returnValue & hyphenize(arguments.action);
				else
					loc.returnValue = loc.returnValue & hyphenize(loc.route.action);
				// add it the format if it exists
				if (StructKeyExists(loc.route, "formatVariable") && StructKeyExists(arguments, loc.route.formatVariable))
					loc.returnValue = loc.returnValue & "&#loc.route.formatVariable#=#arguments[loc.route.formatVariable]#";
				loc.iEnd = ListLen(loc.route.variables);
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.property = ListGetAt(loc.route.variables, loc.i);
					if (loc.property != "controller" && loc.property != "action")
						loc.returnValue = loc.returnValue & "&" & loc.property & "=" & $URLEncode(arguments[loc.property]);
				}
			}
			else
			{
				loc.iEnd = ListLen(loc.route.pattern, "/");
				for (loc.i=1; loc.i <= loc.iEnd; loc.i++)
				{
					loc.property = ListGetAt(loc.route.pattern, loc.i, "/");
					if (loc.property Contains "[")
					{
						loc.property = Mid(loc.property, 2, Len(loc.property)-2);
						if (application.wheels.showErrorInformation && !StructKeyExists(arguments, loc.property))
							$throw(type="Wheels", message="Incorrect Arguments", extendedInfo="The route chosen by Wheels `#loc.route.name#` requires the argument `#loc.property#`. Pass the argument `#loc.property#` or change your routes to reflect the proper variables needed.");
						loc.param = $URLEncode(arguments[loc.property]);
						if (loc.property == "controller" || loc.property == "action")
						{
							loc.param = hyphenize(loc.param);
						}
						else if (application.wheels.obfuscateUrls)
						{
							// wrap in double quotes because in lucee we have to pass it in as a string otherwise leading zeros are stripped
							loc.param = obfuscateParam("#loc.param#");
						}
						loc.returnValue = loc.returnValue & "/" & loc.param; // get param from arguments
					}
					else
					{
						loc.returnValue = loc.returnValue & "/" & loc.property; // add hard coded param from route
					}
				}
				// add it the format if it exists
				if (StructKeyExists(loc.route, "formatVariable") && StructKeyExists(arguments, loc.route.formatVariable))
					loc.returnValue = loc.returnValue & ".#arguments[loc.route.formatVariable]#";
			}
		}
		else // link based on controller/action/key
		{
			// when no controller or action was passed in we link to the current page (controller/action only, not query string etc) by default
			if (!Len(arguments.controller) && !Len(arguments.action) && StructKeyExists(loc.params, "action"))
				arguments.action = loc.params.action;
			if (!Len(arguments.controller) && StructKeyExists(loc.params, "controller"))
				arguments.controller = loc.params.controller;
			if (Len(arguments.key) && !Len(arguments.action) && StructKeyExists(loc.params, "action"))
				arguments.action = loc.params.action;
			loc.returnValue = loc.returnValue & "?controller=" & hyphenize(arguments.controller);
			if (Len(arguments.action))
				loc.returnValue = loc.returnValue & "&action=" & hyphenize(arguments.action);
			if (Len(arguments.key))
			{
				loc.param = $URLEncode(arguments.key);
				if (application.wheels.obfuscateUrls)
				{
					// wrap in double quotes because in lucee we have to pass it in as a string otherwise leading zeros are stripped
					loc.param = obfuscateParam("#loc.param#");
				}
				loc.returnValue = loc.returnValue & "&key=" & loc.param;
			}
		}

		if (arguments.$URLRewriting != "Off")
		{
			loc.returnValue = Replace(loc.returnValue, "?controller=", "/");
			loc.returnValue = Replace(loc.returnValue, "&action=", "/");
			loc.returnValue = Replace(loc.returnValue, "&key=", "/");
		}
		if (arguments.$URLRewriting == "On")
		{
			loc.returnValue = Replace(loc.returnValue, application.wheels.rewriteFile, "");
			loc.returnValue = Replace(loc.returnValue, "//", "/");
		}

		if (Len(arguments.params))
			loc.returnValue = loc.returnValue & $constructParams(params=arguments.params, $URLRewriting=arguments.$URLRewriting);
		if (Len(arguments.anchor))
			loc.returnValue = loc.returnValue & "##" & arguments.anchor;

		if (!arguments.onlyPath)
		{
			if (arguments.port != 0)
				loc.returnValue = ":" & arguments.port & loc.returnValue; // use the port that was passed in by the developer
			else if (request.cgi.server_port != 80 && request.cgi.server_port != 443)
				loc.returnValue = ":" & request.cgi.server_port & loc.returnValue; // if the port currently in use is not 80 or 443 we set it explicitly in the URL
			if (Len(arguments.host))
				loc.returnValue = arguments.host & loc.returnValue;
			else
				loc.returnValue = request.cgi.server_name & loc.returnValue;
			if (Len(arguments.protocol))
			{
				loc.returnValue = arguments.protocol & "://" & loc.returnValue;
			}
			else if (request.cgi.server_port_secure)
			{
				loc.returnValue = "https://" & loc.returnValue;
			}
			else
			{
				loc.returnValue = "http://" & loc.returnValue;
			}
		}
	</cfscript>
	<cfset loc.returnValue = replaceNoCase(loc.returnValue,"%2F","/","ALL")>
	<cfreturn loc.returnValue>
</cffunction>

</cfcomponent>