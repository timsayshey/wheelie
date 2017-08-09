<!--- <cferror type="exception" template="/assets/scripts/error.cfm">
<cferror type="request" template="/assets/scripts/error.cfm"> --->
<cfscript>
	include template="/models/services/global/app/systemvars.cfm";
	this.runtimeconfig = setRuntimeSettings();

	this.applicationTimeout = createTimespan(30,0,0,0);
	this.sessionManagement 	= "true";
	this.sessionTimeout 	= createTimeSpan(30,0,0,0);
	this.name 				= "Wheelie";
	rootPath 				= getDirectoryFromPath(getBaseTemplatePath());

	request.muraInDocker=len(getSiteSetting('WHEELIE_DATASOURCE')) && len(getSiteSetting('WHEELIE_DATABASE'));
	if(request.muraInDocker){
		this.tag.mail.server=getSiteSetting('WHEELIE_SMTP_SERVER');
	    this.tag.mail.username=getSiteSetting('WHEELIE_SMTP_USERNAME');
	    this.tag.mail.password=getSiteSetting('WHEELIE_SMTP_PASSWORD');
	    this.tag.mail.port=getSiteSetting('WHEELIE_SMTP_PORT');
	    this.tag.mail.usetls=getSiteSetting('WHEELIE_SMTP_USETLS');

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

	// this.datasources["App"] = {
	//       class: 'org.gjt.mm.mysql.Driver'
	//     , connectionString: 'jdbc:mysql://wheelie_mysql:3306/wheeliedb?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true'
	//     , username: 'root'
	//     , password: "encrypted:2c66b1dd756f915a7984fc9fef742676a9d3c4f6466ff26c3e907fe026a50a70cde804b61f8d1eaa87a69ec4a09f4eb2"
	//     // optional settings
	//     , connectionLimit:100 // default:-1
	// };
</cfscript>
