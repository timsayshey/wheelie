<cfinclude template="/models/services/global/settings.cfm">
<cfscript>
	
	set(sendEmailOnError=true);
	
	set(errorEmailAddress=application.wheels.adminFromEmail);	
	set(errorEmailFromAddress=application.wheels.adminFromEmail);	
	set(errorEmailToAddress=application.wheels.adminEmail);	
	set(environment="production");	
	
</cfscript>
