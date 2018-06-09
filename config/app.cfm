<cfscript>
	include template="/models/services/global/app/systemvars.cfm";
	this.runtimeconfig = setRuntimeSettings();

	this.applicationTimeout = createTimespan(30,0,0,0);
	this.sessionManagement 	= "true";
	this.sessionTimeout 	= createTimeSpan(30,0,0,0);
	this.name 				= "Wheelie";
	rootPath 				= getDirectoryFromPath(getBaseTemplatePath());

	request.wheelieInDocker=len(getSiteSetting('WHEELIE_DATASOURCE')) && len(getSiteSetting('WHEELIE_DATABASE'));
	if(request.wheelieInDocker){
			// this.tag.mail.server=getSiteSetting('WHEELIE_SMTP_SERVER');
			// this.tag.mail.username=getSiteSetting('WHEELIE_SMTP_USERNAME');
			// this.tag.mail.password=getSiteSetting('WHEELIE_SMTP_PASSWORD');
			// this.tag.mail.port=getSiteSetting('WHEELIE_SMTP_PORT');
			// this.tag.mail.usetls=getSiteSetting('WHEELIE_SMTP_USETLS');

			this.mailservers =[ {
					host: getSiteSetting('WHEELIE_SMTP_SERVER')
				, port: getSiteSetting('WHEELIE_SMTP_PORT')
				, username: getSiteSetting('WHEELIE_SMTP_USERNAME')
				, password: getSiteSetting('WHEELIE_SMTP_PASSWORD')
				, ssl: false
				, tls: getSiteSetting('WHEELIE_SMTP_USETLS')
				, lifeTimespan: createTimeSpan(0,0,1,0)
				, idleTimespan: createTimeSpan(0,0,0,10)
			}];

	  	if(server.coldfusion.productname == 'lucee'){
			driverVarName='type';

			switch(getSiteSetting('WHEELIE_DBTYPE')){
				case 'mysql':
					driverName='mysql';
					break;
				case 'mssql':
					driverName='mssql';
					break;
				case 'oracle':
					driverName='Oracle';
					break;
				case 'postgresql':
					driverName='PostgreSQL';
					break;
			}
		} else {
			driverVarName='driver';

			switch(getSiteSetting('WHEELIE_DBTYPE')){
				case 'mysql':
					driverName='MySQL5';
					break;
				case 'mssql':
					driverName='MSSQLServer';
					break;
				case 'oracle':
					driverName='Oracle';
					break;
				case 'postgresql':
					driverName='PostgreSQL';
					break;
			}
		}

		this.datasources={
			'#getSiteSetting('WHEELIE_DATASOURCE')#' =  {
						'#driverVarName#' = driverName
					 , host = getSiteSetting('WHEELIE_DBHOST')
					 , database = getSiteSetting('WHEELIE_DATABASE')
					 , port = getSiteSetting('WHEELIE_DBPORT')
					 , username = getSiteSetting('WHEELIE_DBUSERNAME')
					 , password = getSiteSetting('WHEELIE_DBPASSWORD')
				},
				nodatabase=  {
						'#driverVarName#' = driverName
					 , host = getSiteSetting('WHEELIE_DBHOST')
					 , database = ''
					 , port = getSiteSetting('WHEELIE_DBPORT')
					 , username = getSiteSetting('WHEELIE_DBUSERNAME')
					 , password = getSiteSetting('WHEELIE_DBPASSWORD')
				}
		};

		this.webadminpassword=getSiteSetting('WHEELIE_ADMIN_PASSWORD');

	}
</cfscript>
<!--- <cferror type="exception" template="/assets/scripts/error.cfm">
<cferror type="request" template="/assets/scripts/error.cfm"> --->
