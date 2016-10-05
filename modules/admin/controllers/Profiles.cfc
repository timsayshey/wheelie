<cfscript>
	component extends="_main" 
	{
		function init() 
		{
			super.init();
		}
		
		function index()
		{					
			users = model("User").findAll(where="status = 'published'",order="firstname asc");
			
		}
		
		function profile()  
		{					
			user = model("UserGroupJoin").findAll(where="userid = '#params.id#'", include="User,UserGroup");
			try {
				dataFields = model("FieldData").getAllFieldsAndUserData(
					modelid = user.usergroupid,
					foreignid = user.userid,
					metafieldType = "usergroupfield"
				);
			} catch(e) {
				Location("/#application.info.adminUrlPath#/users/edit/#params.id#"); abort;
			}
		}			
	}
</cfscript>