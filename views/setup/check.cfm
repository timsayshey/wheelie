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
	string function keepSingleQuotes(str) output=false {
			return preserveSingleQuotes(arguments.str);
		}
	function setupDatabase() {
		setting requesttimeout=99999;
		cfdbinfo(name="dbtables",type="tables",datasource=application.wheels.dataSourceName);

		var tableExists = false;
		for(var table in dbtables) {
			if(table.TABLE_NAME eq "sites") {
				tableExists = true; break;
			}
		}

		if(!tableExists && form.containsKey("setupDatabase") && form.setupDatabase) {
			var sqlPath = "/setup/wheelie";
			if(application.wheels.dbtype eq "PostgreSQL") {
				sqlPath &= ".psql";
				var q = new Query(sql=FileRead(expandPath(sqlPath)),datasource=application.wheels.dataSourceName);
				var loadDB = q.execute();
			} else if(application.wheels.dbtype eq "MySQL") {
				sqlPath &= ".mysql";
				var aSql = ListToArray(FileRead(expandPath(sqlPath)), ';');

				for (var x=1 ; x<=arrayLen(aSql) - 1 ; x++ ) {
					if ( len( trim( aSql[x] ) ) ) {
						cfquery(datasource=application.wheels.dataSourceName) {
							writeOutput( keepSingleQuotes(aSql[x]) );
						}
					}
				}
			} else {
				throw("#application.wheels.dbtype# is not supported by Wheelie. Feel free to add support and send pull request.");
			}
		} else if(!tableExists) {
			include template="/views/setup/dbconfirm.cfm"; abort;
		} else {
			application.dbSetupCheck = true;
		}
	}

	/*if(!application.containsKey("appSettings")) checkSetup();
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
	}*/

	function getSqlAdapter(datasourceName) {
		var loc = {};
		try {
			cfdbinfo(name="loc.info",type="version",datasource=arguments.datasourceName);
		} catch(any e) {
			// Notify dev that he needs to setup his Datasource
			if(findNoCase("datasource",e.message)) {
				include template="/views/setup/datasource.cfm"; abort;
			}
			// Notify dev that his Datasource can't connect to the DB
			if(findNoCase("Communications link failure",e.message)) {
				writeOutput("<h1 style='color:darkred'>DB Connection Failed!</h1><h3>There is likely an issue with your DB settings.<br><br> Please check the DB settings in your system.properties file or docker-compose.yml if you're using Docker.</h3>");
				abort;
			}
			// Notify dev that this is something else
			writeDump(e); abort;
		}

		if (FindNoCase("SQLServer", loc.info.driver_name) || FindNoCase("SQL Server", loc.info.driver_name)) {
			loc.adapterName = "SQLServer";
		}
		else if (FindNoCase("MySQL", loc.info.driver_name)) {
			loc.adapterName = "MySQL";
		}
		else if (FindNoCase("Oracle", loc.info.driver_name)) {
			loc.adapterName = "Oracle";
		}
		else if (FindNoCase("PostgreSQL", loc.info.driver_name)) {
			loc.adapterName = "PostgreSQL";
		}
		else if (FindNoCase("H2", loc.info.driver_name)) {
			loc.adapterName = "H2";
		} else {
			throw(type="Wheels.DatabaseNotSupported", message="#loc.info.database_productname# is not supported by CFWheels.", extendedInfo="Use SQL Server, MySQL, Oracle, PostgreSQL or H2.");
		}
		return loc.adapterName;
	}
</cfscript>
