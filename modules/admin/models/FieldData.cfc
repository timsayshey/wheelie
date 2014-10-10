<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{
			// Set
			table("metadata");
			
			// Other
			super.init();
			
			// Properties				
			this.setWhere = setWhere;	
			
			// Relations
			belongsTo(name="User", foreignKey="id", joinType="outer");
			hasOne(name="User", foreignKey="id", joinType="outer");
			
			// Map column
			property(name="fieldid", column="metafieldid");
		}		
		
		function setWhere()
		{
			return "#wherePermission('FieldData')#";
		}			
		
		function saveFielddata(fields,foreignid)
		{
			fields = arguments.fields;
			response = "";
			if(isStruct(fields))
			{
				fieldIds = StructKeyList(fields);
				
				for(i=1; i LTE ListLen(fieldIds); i = i + 1)
				{
					fieldId = ListGetAt(fieldIds,i);
					thisField = fields[fieldId];
					
					fielddataParams = {
						foreignid	= arguments.foreignid,
						Fieldid		= fieldId,
						fielddata	= thisField
					};
					
					// Save field
					FieldData = model("FieldData").findOne(where="foreignid = #arguments.foreignid# AND Fieldid = #fieldId#");
					 
					if(isObject(FieldData))
					{
						response = ListAppend(response,FieldData.update(fielddataParams));
					}
					else
					{
						FieldData = model("FieldData").new(fielddataParams);
						response = ListAppend(response,FieldData.save());
					}
				}
			}
		}
	</cfscript>	
	
	<cffunction name="getAllFieldsAndUserData">
		<cfargument name="foreignid" type="numeric">
		<cfargument name="modelid" type="numeric">
		<cfargument name="metafieldType" type="any">
		
		<cfquery name="fieldQuery" datasource="#application.wheels.dataSourceName#">
			SELECT
				metafields.id,
				metafields.modelid,
				metafields.name,
				metafields.type,
				metafields.fieldvalues,
				metafields.contentblock,
				metafields.wysiwyg,
				metafields.sortorder,
				metafields.siteid,
				metafields.createdat,
				metafields.createdby,
				metafields.updatedat,
				metafields.updatedby,
				metafields.deletedat,
				metafields.deletedby,
				metadata.foreignid,
				metadata.metafieldid,
				metadata.fielddata
			FROM
				metafields
			LEFT OUTER JOIN metadata AS metadata ON 
				metafields.id = metadata.metafieldid AND 
				(
					metadata.foreignid = <cfqueryparam value="#arguments.foreignid#" cfsqltype="cf_sql_integer"> 
					OR metadata.foreignid IS NULL
				) 	
				AND metadata.deletedat IS NULL
			WHERE
			(
				metafields.modelid = <cfqueryparam value="#arguments.modelid#" cfsqltype="cf_sql_integer"> AND
				metafields.metafieldType = <cfqueryparam value="#arguments.metafieldType#" cfsqltype="cf_sql_varchar">
			)				
			AND (metafields.deletedat IS NULL)
			ORDER BY
				metafields.sortorder ASC
		</cfquery>
		
		<cfreturn fieldQuery>
	</cffunction>
</cfcomponent>
	