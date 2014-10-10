<cfscript>
	component extends="_main" 
	{
		function init() 
		{
			super.init();
		}
		
		function index()
		{			
			qEmails = model("Email").findAll();	
			qOptouts = model("EmailOptout").findAll();
		}	
		
		function download()
		{
			qEmails = model("Email").findAll(distinct=true,select="email");	
			qInquiries = model("Enquiry").findAll(where="optin = 1",distinct=true,select="email");	
			qOptouts = model("EmailOptout").findAll();
		}
	}
</cfscript>