<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function index()
	{	
		forms = model("form").findAll(order="name ASC");
	}	
	
	function show()
	{			
		qform = model("form").findAll(where="id = '#params.id#'");
		dataFields = model("FormField").findAll(where="metafieldType = 'formfield' AND modelid = '#params.id#'",order="sortorder ASC");
	}	
	
	function formsubmissions()
	{			
		qform = model("Form").findByKey(params.id);
		formsubmissions = model("formsubmission").findAll(where="formid = '#qform.id#'",order="createdat DESC");
	}	
		
	function formsubmission()
	{
		formsubmission = model("formsubmission").findByKey(params.id);	
		qform = model("Form").findByKey(formsubmission.formid);		
		
		dataFields = model("FieldData").getAllFieldsAndUserData(
			modelid = qform.id,
			foreignid = formsubmission.id,
			metafieldType = "formfield"
		);	
	}
	
	function formsubmissionSave()
	{	
		if(params.containsKey("fielddata")) {

			// Spam Checks
			params.formsubmission.isSpam = spamChecker(params.fielddata);
			if(params.formsubmission.isSpam)
			{
				// Spam From Bad Country?
				try {
					http method="GET" url="http://ip-api.com/json/#getIpAddress()#" result="jsonResult";
					jsonResult = DeserializeJSON(jsonResult.filecontent);
					if(jsonResult.countryCode eq 'CN')
					{
						isSpamFromBadCountry = true;
					}
				} catch(e) {
				}
			}
			
			// Get Form
			qform = model("Form").findByKey(params.qform.id);		
			
			// If not bad country spam, continue
			if(isNull(isSpamFromBadCountry))
			{				
				if(!isNull(params.qform.optin))
				{
					params.formsubmission.optin = params.qform.optin;
				}
				
				// Set Meta Data
				if(!isNull(session.referer))
				{
					params.formsubmission.referrer = session.referer;
				}			
				
				if(!isNull(session.entryPage))
				{
					params.formsubmission.entryPage = session.entryPage;
				}	
				
				params.formsubmission.fromPage = cgi.HTTP_REFERER;		
				params.formsubmission.mobile = isMobile();			
				params.formsubmission.ip = getIpAddress();		
				params.formsubmission.useragent = cgi.HTTP_USER_AGENT;
				params.formsubmission.formid = qform.id;
				
				// Insert into database
				if(!isNull(params.formsubmission.id)) 
				{
					formsubmission = model("formsubmission").findByKey(params.formsubmission.id);
					saveResult = formsubmission.update(params.formsubmission);
				} else {
					formsubmission = model("formsubmission").new(params.formsubmission);
					saveResult = formsubmission.save();
				}
				
				//writeDump(formsubmission.ALLERRORS()); abort;		
				if (saveResult)   
				{			
					// Save custom metafeild data
					if(!isNull(params.fielddata))
					{ 
						model("FieldData").saveFielddata(
							fields		= params.fielddata,
							foreignid	= formsubmission.id
						);
					}
					
					// Get Form Meta Data
					dataFields = model("FieldData").getAllFieldsAndUserData(
						modelid = qform.id,
						foreignid = formsubmission.id,
						metafieldType = "formfield"
					);	
					
					emailSubject = "#qform.name#";
					
					if(params.formsubmission.isSpam) // IS SPAM!
					{
						emailToList = application.wheels.adminEmail;
						emailCCList = "";
						emailSubject = "[SPAM] " & emailSubject;
					}
					else
					{
						emailToList = model("FormUserJoin").findAll(where="formid = #qform.id# AND type = 'to'",include="User,Form");
						emailToList = ValueList(emailToList.email);
						
						emailCCList = model("FormUserJoin").findAll(where="formid = #qform.id# AND type = 'cc'",include="User,Form");
						emailCCList = ValueList(emailCCList.email);
						
						// Inject custom application code
						customFormHandler = getAdminTemplate("formhandling");
						if(len(customFormHandler))
						{
							include template="#customFormHandler#";
						}
					}				
					
					// Generate and Send Email			
					mailgun(
						mailTo	= emailToList,
						cc		= emailCCList,
						bcc		= application.wheels.adminEmail,
						from	= application.wheels.adminFromEmail,
						subject	= emailSubject,
						html	= "<div style='font-family:Arial'>#includePartial(partial="/_partials/presentFieldData")# #includePartial(partial="/_partials/presentFormMeta")#</div>"
					);
				}
			} else {
				saveresult = false;
			}

		} else {
			saveresult = false;
		}
		
		if(isNull(params.adminLayout) AND !isNull(params.formid))
		{			
			params.saveResult = saveResult;
			request.bypassAdminBody = true;
			qform = isNull(qform) ? model("Form").findByKey(params.formid) : qform;
			renderPage(controller="pforms", action="formsubmissionSave", id=params.formid);
		} else {
			location("/");
		}
		
		// route to response page with success or fail message
	}
	
	function toggleRecord()
	{
		var loc = {};
		forms = model("form").findByKey(params.id);
		if(forms[params.col] eq 1)
		{
			loc.toggleValue = 0;
		} else {
			loc.toggleValue = 1;
		}
		
		loc.newInsert = StructNew();
		StructInsert(loc.newInsert,params.col,loc.toggleValue);
		forms.update(loc.newInsert);		
		
		flashInsert(success="form updated successfully.");
		redirectTo(route="admin~Index", controller="forms");
	}
	
	function new()
	{
		sharedObjects();
		
		// Queries
		qform = model("form").new(colStruct("form"));
		
		// If not allowed redirect
		wherePermission("form");
		
		// Show form
		renderPage(action="editor");
	}
	
	function edit()
	{			
		sharedObjects(params.id);

		metafields = model("formfield").findAll(where="modelid = #params.id# AND metafieldType = 'formfield'", order="sortorder ASC");
		
		if(isDefined("params.id")) 
		{			
			// Queries
			qform = model("form").findAll(where="id = '#params.id#'", maxRows=1, returnAs="Object");
			
			if(ArrayLen(qform))
			{				
				qform = qform[1];
			}
			
			// form not found?
			if (!IsObject(qform))
			{
				flashInsert(error="Not found");
				redirectTo(route="admin~Index", module="admin", controller="forms");
			}			
		}
		
		renderPage(action="editor");		 
	}
	
	function save()
	{								
		// Get form object
		if(!isNull(params.qform.id)) 
		{
			qform = model("form").findByKey(params.qform.id);
			saveResult = qform.update(params.qform);
		} else {
			qform = model("form").new(params.qform);
			saveResult = qform.save();
			isNewForm = true;
		}
		
		// Insert or update form object with properties
		if (saveResult)
		{							
			if(!isNull(params.formusers))
			{		
				// Clear existing user category associations
				model("FormUserJoin").deleteAll(where="formid = #qform.id# AND type = 'to'");	
				
				// Insert new user category associations	
				for(id in ListToArray(params.formusers))
				{				
					model("FormUserJoin").create(userid = id, formid = qform.id, type = 'to');				
				}
			}
						
			if(!isNull(params.ccformusers))
			{		
				// Clear existing user category associations
				model("FormUserJoin").deleteAll(where="formid = #qform.id# AND type = 'cc'");	
				
				// Insert new user category associations	
				for(id in ListToArray(params.ccformusers))
				{				
					model("FormUserJoin").create(userid = id, formid = qform.id, type = 'cc');				
				}
			}
			
			flashInsert(success='Form saved.');
			redirectTo(route="admin~Id", module="admin", controller="forms", action="edit", id=qform.id);
		} else {						
			
			errorMessagesName = "qform";
			param name="qform.id" default="0";
			
			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="forms", action="editor");		
		}		
	}
	
	function delete()
	{
		forms = model("form").findByKey(params.id);
		
		if(forms.delete())
		{
			flashInsert(success="The form was deleted successfully.");							
		} else 
		{
			flashInsert(error="The form could not be found.");
		}
		
		redirectTo(route="admin~Index", controller="forms");
	}
	
	function sharedObjects(formid=0)
	{					
		formusers = model("User").findAll(where="#wherePermission("User")#");
		
		selectedformusers = model("FormUserJoin").findAll(
			where="formid = #arguments.formid# AND type = 'to'#wherePermission("Form","AND")#",
			include="User,Form"
		);
		selectedformusers = ValueList(selectedformusers.userid);
		
		selectedccformusers = model("FormUserJoin").findAll(where="formid = #arguments.formid# AND type = 'cc'#wherePermission("Form","AND")#",include="User,Form");
		selectedccformusers = ValueList(selectedccformusers.userid);
	}
}
</cfscript>