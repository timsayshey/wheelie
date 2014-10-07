<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{			
			// Properties
			this.setWhere = setWhere;
			
			// Other
			super.init();
		}	
		function setWhere()
		{
			return wherePermission('Option');
		}	
		
		function saveOptions(options,siteid="false")
		{	
			if(!isNumeric(arguments.siteid))
			{
				arguments.siteid = request.site.id;
			}
			options = arguments.options;
			//writeDump(options); abort;
			
			if(isStruct(options))
			{
				try {
					optionIds = StructKeyList(options);
				
					for(i=1; i LTE ListLen(optionIds); i = i + 1)
					{
						optionId = ListGetAt(optionIds,i);
						optionParams = options[optionId];
						optionParams.siteid_override = arguments.siteid;
						optionParams.id = optionId;
						
						// Save file
						if(StructKeyExists(optionParams,"attachment"))
						{						
							if(len(optionParams.attachment) AND FileExists(optionParams.attachment))
							{
								formName = listSearch(StructKeyList(form),optionId,"attachment");								
								uploadResult = fileMgr.uploadFile(FieldName=formName, NameConflict="MakeUnique");	
								
								if(StructKeyExists(uploadResult,"filewassaved") AND uploadResult.filewassaved)
								{
									optionParams.attachment = fileMgr.getFileURL(uploadResult.serverfile);
								} else {
									optionParams.attachment = "";
								}
							}
							
							if(!len(optionParams.attachment))
							{
								StructDelete(optionParams,"attachment");
							}
						}
						
						// Check Option to see if it exists, if not set defaults
						option = model("Option").findOne(where="id = '#optionId#' AND siteid = '#optionParams.siteid_override#'");						
						if(!isObject(option))
						{							
							// Copy Default Records For New Site
							defaultOptions = model("Option").findAll(where="siteid = '0'");
							
							for(defaultOption in defaultOptions)
							{								
								defaultOption.siteid_override = optionParams.siteid_override;
								option = model("Option").new(defaultOption);
								response = option.save();	
							}		
						}	
						
						// Save option for real this time
						option = model("Option").findOne(where="id = '#optionId#' AND siteid = '#optionParams.siteid_override#'");
						if(isObject(option))
						{
							response = option.update(optionParams);		
						}
					}
				
				} catch(e) {
					writeDump(e);abort;	
				}
			}
		}
	</cfscript>	
</cfcomponent>
	