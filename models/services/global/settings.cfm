<cfscript>
	application.wheels.youtubeDevKey			= "1234567";
	application.wheels.passwordSalt				= "OkIeKNKoIvbZMFPuMJ3EMQ==";	// AES HEX Key // passcrypt(type="generateKey");	
	application.wheels.reloadPassword 			= "wheelie";
	application.wheels.dataSourceName			= "wheelie";
	application.wheels.adminFromEmail			= "no-reply@getwheelie.com";	
	application.wheels.adminEmail				= "admin@getwheelie.com";
		
	application.wheels.showDebugInformation 	= false;	
	application.wheels.isBeta					= false;	
	
	if(find("beta",lcase(cgi.http_host))) 
	{
		application.wheels.showDebugInformation = true;
		application.wheels.isBeta				= true;
	}
</cfscript>