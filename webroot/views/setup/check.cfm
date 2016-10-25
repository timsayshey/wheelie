<cfscript>	
	if(!isNull(url.reload)) {
		structDelete(application.wheels, "dbtype");
		structDelete(application, "dbSetupCheck");
		structDelete(application, "appSettings");
	}

	if(!application.wheels.containsKey("dbtype")) {
		application.wheels.dbtype = getSqlAdapter(application.wheels.dataSourceName);
	}	

	if(!application.containsKey("dbSetupCheck")) setupDatabase();
	function setupDatabase() {
		var SQL = "SELECT EXISTS(
				    SELECT * 
				    FROM information_schema.tables 
				    WHERE 
				      table_name = 'sites'
				) AS tableExists;";
		var q = new Query(sql=sql,datasource=application.wheels.dataSourceName);
		var qCheckDB = q.execute().getResult();

		if(!qCheckDB.tableExists && form.containsKey("setupDatabase") && form.setupDatabase) {	
			var sqlPath = "/setup/wheelie";
			if(application.wheels.dbtype eq "PostgreSQL") {
				sqlPath &= ".psql";
			} else if(application.wheels.dbtype eq "MySQL") {
				sqlPath &= ".mysql";
			} else {
				throw("#application.wheels.dbtype# is not supported by Wheelie. Feel free to add support and send pull request.");
			}
			var q = new Query(sql=FileRead(expandPath(sqlPath)),datasource=application.wheels.dataSourceName);
			var loadDB = q.execute();
		} else if(!qCheckDB.tableExists) {
			include template="/views/setup/dbconfirm.cfm"; abort;
		} else {
			application.dbSetupCheck = true;
		}
	}

	if(!application.containsKey("appSettings")) checkSetup();
	function checkSetup() {
		var SQL = "SELECT content FROM options WHERE siteid = 0 AND id = 'site_settings'";
		var q = new Query(sql=sql,datasource=application.wheels.dataSourceName);
		var qSettings = q.execute().getResult();

		if(!application.containsKey("appSettings") && qSettings.recordcount && isJson(qSettings.content)) {
			application.appSettings = deserializeJson(qSettings.content);
		} else if (!qSettings.recordcount && form.containsKey("firstTimeSetupInstall")) {
			var SQL =  "INSERT INTO options 
					(id,siteid,content)
	             	VALUES
	            	('site_settings',0,'#serializeJSON(FORM)#')";
			var q = new Query(sql=sql,datasource=application.wheels.dataSourceName);
			q.execute();
			checkSetup();
		} else if (!qSettings.recordcount) {
			include template="/views/setup/index.cfm"; abort;
		}
	}	

	function getSqlAdapter(datasourceName) {
		var loc = {};
		try {
			cfdbinfo(name="loc.info",type="version",datasource=arguments.datasourceName);
		} catch(any e) {
			if(findNoCase("datasource",e.message)) {
				include template="/views/setup/datasource.cfm"; abort;
			}
		}

		if (FindNoCase("SQLServer", loc.info.driver_name) || FindNoCase("SQL Server", loc.info.driver_name))
		{
			loc.adapterName = "SQLServer";
		}
		else if (FindNoCase("MySQL", loc.info.driver_name))
		{
			loc.adapterName = "MySQL";
		}
		else if (FindNoCase("Oracle", loc.info.driver_name))
		{
			loc.adapterName = "Oracle";
		}
		else if (FindNoCase("PostgreSQL", loc.info.driver_name))
		{
			loc.adapterName = "PostgreSQL";
		}
		else if (FindNoCase("H2", loc.info.driver_name))
		{
			loc.adapterName = "H2";
		}
		else
		{
			throw(type="Wheels.DatabaseNotSupported", message="#loc.info.database_productname# is not supported by CFWheels.", extendedInfo="Use SQL Server, MySQL, Oracle, PostgreSQL or H2.");
		}
		return loc.adapterName;
	}
</cfscript>