<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{			
			// Properties
			defaultScope(where=wherePermission('Option'));
			
			// Other
			super.init();
		}		
		
		function saveOptions(options)
		{
			options = arguments.options;
			
			if(isStruct(options))
			{
				optionIds = StructKeyList(options);
				
				for(i=1; i LTE ListLen(optionIds); i = i + 1)
				{
					optionId = ListGetAt(optionIds,i);
					optionParams = options[optionId];
					
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
					
					// Save Option
					option = model("Option").findByKey(optionId);
					response = option.update(optionParams);					
				}
			}
		}
	</cfscript>	
</cfcomponent>
	