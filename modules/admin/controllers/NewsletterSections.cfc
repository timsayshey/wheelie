<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function sharedObjects(newsletterSectionid)
	{		
		
	}
	
	function index()
	{
		newsletter = model("Newsletter").findAll(where="id = '#params.id#'#wherePermission("User","AND")#", order="createdat DESC");
		sections = model("NewsletterSection").findAll(where="newsletterid = '#params.id#'#wherePermission("User","AND")#", order="createdat DESC");
	}
	
	function edit()
	{						
		if(isDefined("params.id")) 
		{
			// Queries
			sharedObjects(params.id);
			newsletterSection = model("NewsletterSection").findAll(
				where="id = '#params.id#'#wherePermission("NewsletterSection","AND")#", 
				maxRows=1, 
				returnAs="Object"
			);
			
			if(ArrayLen(newsletterSection))
			{				
				newsletterSection = newsletterSection[1];
			}
			
			// NewsletterSection not found?
			if (!IsObject(newsletterSection))
			{
				flashInsert(error="Not found");
				redirectTo(route="admin~Index", module="admin", controller="newsletterSections");
			}			
		}
		
		renderPage(action="editor");		
	}
	
	function new()
	{
		// Queries
		sharedObjects(0);
		newsletterSection = model("NewsletterSection").new(colStruct("NewsletterSection"));
		
		// If not allowed redirect
		wherePermission("NewsletterSection");
		
		// Show newsletterSection
		renderPage(action="editor");
	}


	function delete()
	{
		newsletterSection = model("NewsletterSection").findByKey(params.id);
		
		if(newsletterSection.delete())
		{
			flashInsert(success="The section was deleted successfully.");							
		} else 
		{
			flashInsert(error="The section could not be found.");
		}
		
		redirectTo(
			route="admin~Index",
			module="admin",
			controller="newsletterSections",
			params="id=#params.newsletterid#"
		);
	}

	function save()
	{						
		// Handle submit button type (publish,draft,trash,etc)
		if(!isNull(params.submit))
		{
			params.newsletterSection.status = handleSubmitType("newsletterSection", params.submit);	
		}	
		
		// Get newsletterSection object
		if(!isNull(params.newsletterSection.id)) 
		{
			newsletterSection = model("NewsletterSection").findByKey(params.newsletterSection.id);
			saveResult = newsletterSection.update(params.newsletterSection);
		} else {
			newsletterSection = model("NewsletterSection").new(params.newsletterSection);
			saveResult = newsletterSection.save();
			isNewSection = true;
		}
		
		// Insert or update newsletterSection object with properties
		if (saveResult)
		{	
			flashInsert(success='Newsletter section saved.');
			if(isNull(isNewSection))
			{
				redirectTo(route="admin~Id", module="admin", controller="newsletterSections", action="edit", id=newsletterSection.id, params="newsletterid=#params.newsletterSection.newsletterid#");				
			}
			else 
			{
				redirectTo(route="admin~Id", module="admin", controller="newsletterSections", action="index", id=params.newsletterSection.newsletterid);
			}
							
					
		} else {						
			
			errorMessagesName = "newsletterSection";
			param name="newsletterSection.id" default="0";
			sharedObjects(newsletterSection.id);
			
			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="newsletterSections", action="editor", params="newsletterid=#params.newsletterSection.newsletterid#");		
		}		
	}
	
	function preHandler()
	{
		super.preHandler();
	}
}
</cfscript>