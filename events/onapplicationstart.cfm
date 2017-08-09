<cfscript>
	include template="/views/setup/check.cfm";

	// Initialize Shortcode plugins
	include template="/models/services/global/settings.cfm";

	setSiteInfo();

	//  Set User Permissions
	if ( isNull(application.rbs.permissionsQuery) || isReload ) {

		var q = new query( datasource="wheelie" );
		        q.addParam( name="lastModifiedTime", cfsqltype="cf_sql_timestamp", value=now());
		        application.rbs.permissionsQuery = q.execute( sql="SELECT * FROM permissions" ).getResult();
		//  Get role columns from permissions table - removed non role columns - convert array to remove list nulls - convert back to list
		application.rbs.roleslist = ArrayToList(ListToArray(ReplaceList(lcase(application.rbs.permissionsQuery.columnList),lcase("CREATEDBY,UPDATEDBY,UPDATEDAT,CREATEDAT,DELETEDAT,DELETEDBY"),"")));
		application.rbs.roleslist = replaceNoCase(application.rbs.roleslist, "ID,", "");
		for (var thisRole in listToArray(application.rbs.roleslist) ) {
			for (var row in application.rbs.permissionsQuery ) {
				application.rbs.permission[row.id][thisRole] = application.rbs.permissionsQuery[thisRole];
			}
		}
	}

	application.shortcodes={};
	include template="/views/plugins/plugins-init.cfm";
</cfscript>
