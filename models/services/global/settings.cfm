<cfscript>
	application.wheels.noReplyEmail				= "noreply@wheelie.com";
	application.wheels.defaultEmail				= "your@email.com";	

	application.wheels.youtubeDevKey			= "1234567";
	application.wheels.passwordSalt				= "OkIeKNKoIvbZMFPuMJ3EMQ==";	// AES HEX Key // passcrypt(type="generateKey");	

	application.wheels.stripeKey				= "";

	application.wheels.reloadPassword 			= "wheelie";
	application.wheels.dataSourceName			= "wheelie";
	application.wheels.adminFromEmail			= application.wheels.noReplyEmail;	
	application.wheels.adminEmail				= application.wheels.defaultEmail;
	application.wheels.errorEmailAddress		= application.wheels.defaultEmail;
	application.wheels.sendEmailOnError			= true;
	application.wheels.urlRewriting				= "On";
	application.wheels.rewriteFile 				= "index.cfm";
</cfscript>