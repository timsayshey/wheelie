<cfscript>
component extends="Wheels" 
{
	function init()
	{
		logUserActions();
		
		afterCreate('logCreate');
		afterUpdate('logUpdate');
		afterDelete('logDelete');
		
		// Permission check override	
		beforeValidation("setSiteId");		
		beforeDelete('checkForDeletePermission');
		beforeCreate('checkForCreatePermission');
		beforeUpdate('checkForUpdatePermission');
		beforeSave("setSiteId");
	}		
	
	function setSiteId()
	{
		if(!isNull(request.site.id) AND isNumeric(request.site.id) AND isNull(this.siteid_override))
		{
			this.siteid = request.site.id;
		} else if (!isNull(this.siteid_override) AND isNumeric(this.siteid_override)) {
			this.siteid = this.siteid_override;			
		}
	}
	
	// Set this.setWhere in Model to default where statement
	function findAll()
	{
		if(!isNull(this.setWhere) AND isCustomFunction(this.setWhere))
		{
			if(!StructKeyExists(arguments, "where") OR !Len(arguments.where))
			{
				//arguments.where = wherePermission(getModelName());
				arguments.where = this.setWhere();
			}
		}	
		return super.findAll(argumentCollection=arguments);
	}
	
	// Clean strings
	private function sanitizeNameAndURLId()
	{
		if(!isNull(this.urlid) AND !isNull(this.name))
		{
			this.urlid 	= lcase(cleanUrlId(this.urlid));
			this.name 	= removehtml(this.name);
			
			if(!len(this.urlid))
			{
				this.urlid 	= lcase(cleanUrlId(this.name));
			}			
		}
	}
	
	// Permission Checks
	private function checkForCreatePermission()	{
		checkForPermission(type="save", checkid=0);
	}
	
	private function checkForUpdatePermission()	{
		checkForPermission(type="save", checkid=this.createdby);
	}
	
	private function checkForDeletePermission()	{
		checkForPermission(type="delete", checkid=this.createdby);
	}
	
	private function checkForPermission(string type="", checkid="")
	{		
		var permissionType = arguments.type;
		variables.checkid = arguments.checkid;
		
		if(checkPermission("#getModelName()#_#permissionType#_others"))
		{
			// Good to go
		}
		else if (checkPermission("#getModelName()#_#permissionType#"))
		{
			if(!isNull(request.newRegistration) AND isNull(session.user.id) OR structKeyExists(url,"token") AND findNoCase("users/verifyEmail",cgi.path_info)) 
			{ 			
				// Override for registration
				// Override for email verification
			} else {
				if(!ListFindNoCase(checkid, session.user.id) AND checkid neq 0)
				{
					session.flash.error="You only have access to #permissionType# your own #getModelName()#s";
					
					Location(cgi.http_referer,false); abort;
				}
			}

		}
		else
		{
			session.flash.error="You don't have permission to #permissionType# #getModelName()#s";
			Location(cgi.http_referer,false); abort;
		}
	}
	
	private function getModelName()
	{
		try {
			return ListLast(getMetaData(this).fullname,".");
		} catch(any e) {
			return "";
		}
	}
	
	// before save check if can insert
	
	private function logCreate() 
	{				
		logIt("Create");	
	}
	
	private function logUpdate() 
	{				
		logIt("Update");	
	}
	
	private function logDelete()
	{
		logIt("Delete");	
	}
	
	private function logIt(savetype)
	{
		var loc = {};
		param name="this.id" default="";
		
		if (StructKeyExists(request, "logit") AND IsStruct(request.logit)) 
		{			
			loc.thisModelName = getModelName();
			
			loc.logit 			 = request.logit;
			loc.logit.model		 = loc.thisModelName;
			loc.logit.modelid	 = this.id;
			loc.logit.savetype	 = arguments.savetype;	
			loc.logit.useragent  = CGI.HTTP_USER_AGENT;
			loc.logit.ip         = getIpAddress();		
			loc.logit.siteid     = request.site.id;		
			
			// Can't use the Model().create function here because it'll throw an error, gotta go vanilla
			db.insertRecord("logs", loc.logit);
		}
	}

}
</cfscript>