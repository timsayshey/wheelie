<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function index()
	{
		newsletters = model("Newsletter").findAll(where="#wherePermission("Newsletter")#",order="createdat DESC");	
	}		
	
	function sharedObjects(newsletterid)
	{		
		newsletter = model("Newsletter").findAll(where="id = '#arguments.newsletterid#'#wherePermission("User","AND")#", order="createdat DESC");
		sections = model("NewsletterSection").findAll(where="newsletterid = '#arguments.newsletterid#'#wherePermission("User","AND")#", order="createdat DESC");
	}
	
	function newsletter()
	{
		sharedObjects(params.id);
	}
	
	function preview()
	{
		sharedObjects(params.id);
	}
	
	function generate()
	{
		usesLayout("/layouts/layout.blank");
		sharedObjects(params.id);
	}
	
	function edit()
	{						
		if(isDefined("params.id")) 
		{
			// Queries
			sharedObjects(params.id);
			newsletter = model("Newsletter").findAll(where="id = '#params.id#'#wherePermission("Newsletter","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(newsletter))
			{				
				newsletter = newsletter[1];
			}
			
			// Newsletter not found?
			if (!IsObject(newsletter))
			{
				flashInsert(error="Not found");
				redirectTo(route="admin~Index", module="admin", controller="newsletters");
			}			
		}
		
		renderPage(action="editor");		
	}
	
	function new()
	{
		// Queries
		sharedObjects(0);
		newsletter = model("Newsletter").new(colStruct("Newsletter"));
		
		// If not allowed redirect
		wherePermission("Newsletter");
		
		// Show newsletter
		renderPage(action="editor");
	}


	function delete()
	{
		newsletter = model("Newsletter").findByKey(params.id);
		
		if(newsletter.delete())
		{
			flashInsert(success="The newsletter was deleted successfully.");							
		} else 
		{
			flashInsert(error="The newsletter could not be found.");
		}
		
		redirectTo(
			route="admin~Index",
			module="admin",
			controller="newsletters"
		);
	}

	function save()
	{						
		// Handle submit button type (publish,draft,trash,etc)
		if(!isNull(params.submit))
		{
			params.newsletter.status = handleSubmitType("newsletter", params.submit);	
		}		
		
		// Auto generate meta tags
		if(StructKeyExists(params.newsletter,"metagenerated") AND params.newsletter.metagenerated eq 1)
		{
			params.newsletter.metatitle 		= generatePageTitle(params.newsletter.name);
			params.newsletter.metadescription = generateMetaDescription(params.newsletter.content);
			params.newsletter.metakeywords 	= generateMetaKeywords(params.newsletter.content);
		}
		
		// Get newsletter object
		if(!isNull(params.newsletter.id)) 
		{
			newsletter = model("Newsletter").findByKey(params.newsletter.id);
			saveResult = newsletter.update(params.newsletter);
		} else {
			newsletter = model("Newsletter").new(params.newsletter);
			saveResult = newsletter.save();
			isNewNewsletter = true;
		}
		
		// Insert or update newsletter object with properties
		if (saveResult)
		{	
			flashInsert(success='Newsletter saved.');
			
			if(isNull(isNewNewsletter))
			{
				redirectTo(route="admin~Id", module="admin", controller="newsletters", action="edit", id=newsletter.id);				
			}
			else 
			{
				redirectTo(route="admin~Id", module="admin", controller="newsletterSections", action="index", id=newsletter.id);
			}
		} else {						
			
			errorMessagesName = "newsletter";
			param name="newsletter.id" default="0";
			sharedObjects(newsletter.id);
			
			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="newsletters", action="editor");		
		}		
	}
	
	function preHandler()
	{
		super.preHandler();
	}
}
</cfscript>