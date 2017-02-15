<cfcomponent>
	 <cffunction name="init">
		<cfset this.version = "1.3,1.3.1,1.3.2,1.3.3,1.4.4,1.4.5,1.4.6,1.4.7,1.4.8,1.4.9,1.5,1.5.0,1.5.1,1.5.2">
		<cfreturn this>
	</cffunction>	

<!--- 

	By default wheels sends errors to and from the same email -- let's fix that

 --->

<cffunction name="$runOnError" returntype="string" access="public" output="false">
	<cfargument name="exception" type="any" required="true">
	<cfargument name="eventName" type="any" required="true">
	<cfscript>
		var loc = {};
		if (StructKeyExists(application, "wheels") && StructKeyExists(application.wheels, "initialized"))
		{
			if (application.wheels.sendEmailOnError && Len(application.wheels.errorEmailAddress))
			{
				loc.mailArgs = {};
				$args(name="sendEmail", args=loc.mailArgs);
				if (StructKeyExists(application.wheels, "errorEmailServer") && Len(application.wheels.errorEmailServer))
				{
					loc.mailArgs.server = application.wheels.errorEmailServer;
				}
				loc.mailArgs.from = application.wheels.adminFromEmail;
				loc.mailArgs.to = application.wheels.errorEmailAddress;
				loc.mailArgs.subject = application.wheels.errorEmailSubject;
				loc.mailArgs.type = "html";
				loc.mailArgs.tagContent = $includeAndReturnOutput($template="wheels/events/onerror/cfmlerror.cfm", exception=arguments.exception);
				StructDelete(loc.mailArgs, "layouts", false);
				StructDelete(loc.mailArgs, "detectMultiPart", false);
				
					$mail(argumentCollection=loc.mailArgs);
				try
				{}
				catch (any e) {}
			}
			if (application.wheels.showErrorInformation)
			{
				if (StructKeyExists(arguments.exception, "rootCause") && Left(arguments.exception.rootCause.type, 6) == "Wheels")
				{
					loc.wheelsError = arguments.exception.rootCause;
				}
				else if (StructKeyExists(arguments.exception, "cause") && StructKeyExists(arguments.exception.cause, "rootCause") && Left(arguments.exception.cause.rootCause.type, 6) == "Wheels")
				{
					loc.wheelsError = arguments.exception.cause.rootCause;
				}
				if (StructKeyExists(loc, "wheelsError"))
				{
					loc.rv = $includeAndReturnOutput($template="wheels/styles/header.cfm");
					loc.rv &= $includeAndReturnOutput($template="wheels/events/onerror/wheelserror.cfm", wheelsError=loc.wheelsError);
					loc.rv &= $includeAndReturnOutput($template="wheels/styles/footer.cfm");
				}
				else
				{
					$throw(object=arguments.exception);
				}
			}
			else
			{
				$header(statusCode=500, statusText="Internal Server Error");
				loc.rv = $includeAndReturnOutput($template="#application.wheels.eventPath#/onerror.cfm", exception=arguments.exception, eventName=arguments.eventName);
			}
		}
		else
		{
			$throw(object=arguments.exception);
		}
	</cfscript>
	<cfreturn loc.rv>
</cffunction>
</cfcomponent>