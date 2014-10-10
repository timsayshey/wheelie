<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{		
		super.init();	
	}
	
	function error()
	{
		
	}	
		
	function newsletter()
	{
		usesLayout("/layouts/layout.bstrap");
	}
	
	function newsletterSubmit()
	{
		if(isValidEmail(params.email))
		{
			checkSubscriber = model("emails").findAll(where="email = '#params.email#'");		
			if(checkSubscriber.recordcount)
			{
				flashInsert(success="You're already signed up.");
			} else {
				subscriber = model("emails").new(email=params.email);		
				if(subscriber.save())
				{
					flashInsert(success="Thanks for signing up!");
					mailgun(
						mailTo	= application.wheels.adminEmail,
						from	= application.wheels.adminFromEmail,				
						subject	= "FB Newsletter Subscriber",
						html	= "#params.email#"
					);
				} else {
					flashInsert(error="Sorry, there was an issue. Please try again.");			
				}
			}
		} else {
			flashInsert(error="Oops, that's not a valid email. Please try again.");			
		}
		redirectTo(route="public~otherPages", action="newsletter");
	}
	
	function blueimpUpload()
	{		
		var loc = {};
		
		if(len(form.uploadedFile) AND FileExists(form.uploadedFile))
		{				
			uploadResult = privateFileMgr.uploadFile(FieldName="uploadedFile", NameConflict="MakeUnique", Folder="sharedpics");	
			writeOutput('{"status":"success","error":false}');
			loc.fullname = "";
			if(!isNull(session.user.fullname))
			{
				loc.fullname = session.user.fullname;
			}
			mailgun(
				mailTo	= application.wheels.adminEmail,
				from	= application.wheels.adminFromEmail,				
				subject	= "New image uploaded",
				html	= "C:\inetpub\private\sharedpics\#uploadResult.serverfile#<br>
							#cgi.HTTP_USER_AGENT#<br>
							#getIpAddress()#<br>
							#loc.fullname#"
			);
		}
		abort;
	}
	
}
</cfscript>