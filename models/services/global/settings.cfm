<cfscript>
	application.wheels.reloadPassword 			= "wheelie";
	application.wheels.dataSourceName			= "wheelie";

	

	application.wheels.youtubeDevKey			= "1234567";
	application.wheels.passwordSalt				= "OkIeKNKoIvbZMFPuMJ3EMQ==";	// AES HEX Key // passcrypt(type="generateKey");
	application.wheels.stripeKey				= "";

	include template="/views/setup/check.cfm";
	application.s3 = {
		"accessKeyId" : application.appSettings.accessKeyId, 
		"awsSecretKey" : application.appSettings.awsSecretKey,
		"defaultLocation" : application.appSettings.defaultLocation,
		"host" : application.appSettings.host
	};
	application.s3info = {
		"defaultBucket" : application.appSettings.defaultBucket
	};
	application.wheels.defaultEmail				= application.appSettings.defaultEmail;	

	application.wheels.noReplyEmail				= "noreply@wheelie.com";	
	application.wheels.adminFromEmail			= application.wheels.noReplyEmail;	
	application.wheels.adminEmail				= application.wheels.defaultEmail;
	application.wheels.errorEmailAddress		= application.wheels.defaultEmail;
	application.wheels.sendEmailOnError			= true;
	application.wheels.urlRewriting				= "On";
	application.wheels.rewriteFile 				= "index.cfm";
</cfscript>