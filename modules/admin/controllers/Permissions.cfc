<cfscript>
	component extends="_main" 
	{
		function init() 
		{
			super.init();
		}
		function index()
		{
			permissions = model("Permission").findAll();
			permissionCols = application.rbs.roleslist;
		}
		function permissionsSubmit()
		{
			permissions = model("Permission").findAll();
			permissionCols = application.rbs.roleslist;
			
			if(!isNull(params.permissions))
			{
				for(permission in permissions)
				{
					if(!isNull(params.permissions[permission.id]) AND IsStruct(params.permissions[permission.id]))
					{
						model("Permission").
							findByKey(permission.id).
								update(params.permissions[permission.id]);
					}
				}
				flashInsert(success="Updated successfully.");
				redirectTo(route="admin~index", controller="permissions");	
			}
		}
	}
</cfscript>