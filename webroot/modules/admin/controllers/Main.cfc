<cfscript>
component extends="_main" 
{
	function init() 
	{
		super.init();
	}
	
	function usermenu()
	{
		usesLayout("/layouts/layout.blank");
	}
	
	function home() 
	{
		if(checkPermission("log_read_others"))
		{
			qLog = model("Log").findAll(where=wherePermission("Log"),include="User", maxRows=3, order="createdAt DESC");	
			qLogFull = model("Log").findAll(where=wherePermission("Log"),include="User", maxRows=50, order="createdAt DESC");	
		}
	}

	function scaffold() 
	{
		var nameVars = {
			"@tableNamew@" 		: "api_provider",
			"@capLcasePlural@" 	: "Providers",
			"@ucaseSingular@" 	: "Provider",
			"@lcaseSingular@" 	: "provider",
			"@ucasePlural@" 	: "Providers",
			"@lcasePlural@" 	: "providers"
		};

		var SQL = "SELECT * FROM #nameVars['@tableNamew@']#";
		var q = new Query(sql=sql,datasource=application.wheels.dataSourceName);
		var qModel = q.execute().getResult();

		var SQL = "SHOW COLUMNS FROM #nameVars['@tableNamew@']#";
		var q = new Query(sql=sql,datasource=application.wheels.dataSourceName);
		var qColumns = q.execute().getResult();

		var columns = {};
		for(var column in qColumns) {
			columns[column.field] = column.type;
		}

		var templates = {
			'/modules/adminapp/controllers/_Template.cfc'					:'/modules/adminapp/controllers/@capLcasePlural@.cfc',
			'/modules/adminapp/controllers/_Templatefields.cfc'				:'/modules/adminapp/controllers/@capLcasePlural@fields.cfc',
			'/modules/adminapp/models/templates/_Template.cfc'				:'/modules/adminapp/models/@ucaseSingular@.cfc',
			'/modules/adminapp/models/templates/_TemplateCategory.cfc'		:'/modules/adminapp/models/@ucaseSingular@Category.cfc',
			'/modules/adminapp/models/templates/_TemplateCategoryJoin.cfc'	:'/modules/adminapp/models/@ucaseSingular@CategoryJoin.cfc',
			'/modules/adminapp/models/templates/_TemplateField.cfc'			:'/modules/adminapp/models/@ucaseSingular@Field.cfc',
			'/modules/adminapp/models/templates/_TemplateMediafile.cfc'		:'/modules/adminapp/models/@ucaseSingular@Mediafile.cfc',
			'/modules/adminapp/models/templates/_TemplateMetafield.cfc'		:'/modules/adminapp/models/@ucaseSingular@Metafield.cfc',
			'/modules/adminapp/views/_templates/editor.cfm'					:'/modules/adminapp/views/@lcasePlural@/editor.cfm',
			'/modules/adminapp/views/_templates/index.cfm'					:'/modules/adminapp/views/@lcasePlural@/index.cfm',
			'/modules/adminapp/views/_templates/photos.cfm'					:'/modules/adminapp/views/@lcasePlural@/photos.cfm'
		};

		// vuild form
		savecontent variable="formfields" {
			for(var column in columns) {
				include template="/modules/adminapp/views/_templates/formfield.cfm";
			}
		}
		nameVars["@formfields@"] = formfields;

		var viewDir = expandPath("/modules/adminapp/views/#nameVars['@lcasePlural@']#/");
		if(!directoryExists(viewDir)) {
			directoryCreate(viewDir);
		}

		for(var sourcePath in templates) {
			var destinationPath = templates[sourcePath];
			var template = fileRead(expandPath(sourcePath));

			for(var nameVar in nameVars) {
				destinationPath = replaceNoCase(destinationPath, nameVar, nameVars[nameVar],"ALL");
				template = replaceNoCase(template, nameVar, nameVars[nameVar],"ALL");
			}
			try {
				if(fileExists( destinationPath )) {
					fileDelete( destinationPath );
				}
				fileWrite(expandPath(destinationPath), template);
			}catch(any e) {
				writeDump([e, destinationPath, template]); abort;
			}
		}

		writeDump("SUCCESS"); abort;

	}




}
</cfscript>