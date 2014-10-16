<cfscript>
	application.wheels.youtubeDevKey			= "1234567";
	application.wheels.passwordSalt				= "LKjx1/Yp+xy28SlcEh4EUQ==";	// AES HEX Key // passcrypt(type="generateKey");
	application.wheels.reloadPassword 			= "wheelie";
	application.wheels.dataSourceName			= "wheelie";
	//application.wheels.URLRewriting			= "On";	
	application.wheels.adminFromEmail			= "admin@getwheelie.com";	
	application.wheels.adminEmail				= "admin@getwheelie.com";
	application.wheels.facebookid				= "ANYTHING%2F1234567";
		
	application.wheels.showDebugInformation 	= false;	
	application.wheels.isBeta					= false;	
	
	if(find("beta",lcase(cgi.http_host))) 
	{
		application.wheels.showDebugInformation = true;
		application.wheels.isBeta				= true;
	}
</cfscript>