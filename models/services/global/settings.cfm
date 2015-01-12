<cfscript>
	application.wheels.youtubeDevKey			= "1234567";
	application.wheels.passwordSalt				= "OkIeKNKoIvbZMFPuMJ3EMQ==";	// AES HEX Key // passcrypt(type="generateKey");	
	application.wheels.reloadPassword 			= "wheelie";
	application.wheels.dataSourceName			= "wheelie";
	application.wheels.adminFromEmail			= "noreply@getwheelie.com";	
	application.wheels.adminEmail				= "admin@getwheelie.com";
	
	// override admin url scope in /config/Routes.cfm
	
	//application.wheels.showDebugInformation 	= false;	
	application.wheels.isBeta					= false;	
	
	if(find("beta",lcase(cgi.http_host))) 
	{
		//application.wheels.showDebugInformation = true;
		application.wheels.isBeta				= true;
	}
</cfscript>