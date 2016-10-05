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
			var response = "";
			if(isStruct(fields))
			{
				var fieldIds = StructKeyList(fields);
				
				for(var i=1; i LTE ListLen(fieldIds); i = i + 1)
				{
					var fieldId = ListGetAt(fieldIds,i);
					var thisField = fields[fieldId];
					
					var fielddataParams = {
						foreignid	= arguments.foreignid,
						Fieldid		= fieldId,
						fielddata	= thisField
					};
					
					// Save field
					var FieldData = model("FieldData").findOne(where="foreignid = #arguments.foreignid# AND Fieldid = #fieldId#");
					 
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
		<cfargument name="identifier" type="any" default="">
		
		<cfquery name="fieldQuery" datasource="#application.wheels.dataSourceName#">
			SELECT
				metafields.id,
                metafields.identifier,
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
				metafields.divwrap,
				metafields.divclass,
				metafields.checked,
				metafields.labelplacement,
				metafields.prepend,
				metafields.append,
				metafields.styleattribute,
				metafields.class,
				metafields.codeblock,
				metafields.wrapoptions,
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
				<cfif len(arguments.identifier)>AND metafields.identifier = <cfqueryparam value="#arguments.identifier#" cfsqltype="cf_sql_varchar"></cfif>
			)				
			AND (metafields.deletedat IS NULL)
			ORDER BY
				metafields.sortorder ASC
		</cfquery>
		
		<cfreturn fieldQuery>
	</cffunction>
</cfcomponent>
	