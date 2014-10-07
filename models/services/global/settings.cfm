<cfscript>
	application.wheels.youtubeDevKey			= "1234567";
	application.wheels.passwordSalt				= "LKjx1/Yp+xy28SlcEh4EUQ==";	// AES HEX Key // passcrypt(type="generateKey");
	application.wheels.reloadPassword 			= "wheelie";
	application.wheels.dataSourceName			= "wheeliedb";
	application.wheels.URLRewriting				= "On";	
	application.wheels.adminFromEmail			= "noreply@wheelie.com";	
	application.wheels.adminEmail				= "changethis@wheelie.com";
	application.wheels.facebookid				= "ANYTHING%2F1234567";
		
	application.wheels.showDebugInformation 	= false;	
	application.wheels.isBeta					= false;	
	
	if(find("beta",lcase(cgi.http_host))) 
	{
		application.wheels.showDebugInformation 	= true;
		application.wheels.isBeta					= true;
	}
	
</cfscript>