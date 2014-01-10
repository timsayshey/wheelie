<!--- 2.5.1 (Build 173) --->
<!--- Last Updated: 2013-09-16 --->
<!--- Created by Steve Bryant 2004-12-08 --->
<!---
TODO:
deleteRecord()
saveSortOrder()
Relation Fields
Day subtraction error
--->
<cfcomponent extends="DataMgr" displayname="Data Manager for WDDX" hint="I manage data interactions with WDDX.">

<cfset variables.WDDX_Data = StructNew()>
<cfset variables.tabledata = StructNew()>

<cffunction name="getDatabase" access="public" returntype="string" output="no" hint="I return the database platform being used (Access,MS SQL,MySQL etc).">
	<cfreturn "WDDX">
</cffunction>

<cffunction name="getDatabaseTables" access="public" returntype="string" output="no" hint="I get a list of all tables in the current database.">

	<cfset var qTables = 0>
	<cfset var result = "">
	
	<cfdirectory directory="#variables.datasource#" action="list" name="qTables">
	<cfloop query="qTables">
		<cfif ListLast(name,".") EQ "wddx">
			<cfset result = ListAppend(result,Left(name,Len(name)-5))>
		</cfif>
	</cfloop>
	
	<cfreturn result>
</cffunction>

<cffunction name="concat" access="public" returntype="string" output="no" hint="I return the SQL to concatenate the given fields with the given delimeter.">
	<cfargument name="fields" type="string" required="yes">
	<cfargument name="delimeter" type="string" default="">
	
	<cfset var colname = "">
	<cfset var result = "">
	
	<cfloop index="colname" list="#arguments.fields#">
		<cfif Len(result)>
			<cfset result =  "#result# + '#arguments.delimeter#' + CAST(#colname# AS varchar)">
		<cfelse>
			<cfset result = "CAST(#colname# AS varchar)">
		</cfif>
	</cfloop>
	
	<cfreturn result>
</cffunction>

<cffunction name="concatFields" access="public" returntype="array" output="no" hint="I return the SQL to concatenate the given fields with the given delimeter.">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="fields" type="string" required="yes">
	<cfargument name="delimeter" type="string" default=",">
	<cfargument name="tablealias" type="string" required="no">
	
	<cfset var col = "">
	<cfset var aSQL = ArrayNew(1)>
	<cfset var fieldSQL = 0>
	
	<cfif NOT StructKeyExists(arguments,"tablealias")>
		<cfset arguments.tablealias = arguments.tablename>
	</cfif>
	
	<cfloop index="colname" list="#arguments.fields#">
		<cfset fieldSQL = getFieldSelectSQL(tablename=arguments.tablename,field=colname,tablealias=arguments.tablealias,useFieldAlias=false)>
		<cfif ArrayLen(aSQL)>
			<cfset ArrayAppend(aSQL," + '#arguments.delimeter#' + ")>
		</cfif>
		<cfif isSimpleValue(fieldSQL)>
			<cfset ArrayAppend(aSQL,"CAST(#fieldSQL# AS varchar)")>
		<cfelse>
			<cfset ArrayAppend(aSQL,"CAST(")>
			<cfset ArrayAppend(aSQL,fieldSQL)>
			<cfset ArrayAppend(aSQL," AS varchar)")>
		</cfif>
	</cfloop>
	
	<cfreturn aSQL>
</cffunction>

<cffunction name="createTable" access="public" returntype="string" output="no" hint="I take a table (for which the structure has been loaded) and create the table in the database.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var sTableInfo = StructNew()>
	
	<cfset variables.WDDX_Data[arguments.tablename]["DataSet"] = QueryNew("test")>
	
	<cfset sTableInfo["TableStruct"] = variables.tables[arguments.tablename]>
	<cfset variables.WDDX_Data[arguments.tablename]["TableStruct"] = sTableInfo["TableStruct"]>
	<cfset sTableInfo["DataSet"] = QueryNew(getDBFieldList(arguments.tablename))>
	<cfset saveWDDXFile(arguments.tablename,sTableInfo)>
	
	<cfreturn "">
</cffunction>

<cffunction name="deleteRecord" access="public" returntype="void" output="no" hint="I delete the record with the given Primary Key(s).">
	<cfargument name="tablename" type="string" required="yes" hint="The name of the table from which to delete a record.">
	<cfargument name="data" type="struct" required="yes" hint="A structure indicating the record to delete. A key indicates a field. The structure should have a key for each primary key in the table.">
	
	<cfset var i = 0><!--- just a counter --->
	<cfset var fields = getUpdateableFields(arguments.tablename)>
	<cfset var pkfields = getPKFields(arguments.tablename)><!--- the primary key fields for this table --->
	<cfset var rfields = getRelationFields(arguments.tablename)><!--- relation fields in table --->
	<cfset var in = arguments.data><!--- The incoming data structure --->
	<cfset var isLogicalDelete = false>
	<cfset var qRelationList = 0>
	<cfset var qRecord = 0>
	<cfset var relatefield = 0>
	<cfset var sqlarray = ArrayNew(1)>
	<cfset var out = 0>
	<cfset var subdatum = StructNew()>
	<cfset var temp2 = 0>
	
	<cfset var pklist = "">
	<cfset var qDataset = getDataset(arguments.tablename)>
	<cfset var isMatch = false>
	<cfset var inpk = StructNew()>
	
	<!--- Make list of primary key fields --->
	<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
		<cfset pklist = ListAppend(pklist,pkfields[i].ColumnName)>
	</cfloop>
	
	<!--- Throw exception if any pkfields are missing from incoming data --->
	<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
		<cfif NOT StructKeyExists(in,pkfields[i].ColumnName)>
			<cfthrow errorcode="RequiresAllPkFields" message="All Primary Key fields (#pklist#) must be used when deleting a record. (Passed = #StructKeyList(in)#)" type="DataMgr">
		</cfif>
	</cfloop>
	
	<!--- Get the record containing the given data --->
	<cfset qRecord = getRecord(arguments.tablename,in)>
	
	<cfif qRecord.RecordCount EQ 1>
		<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
			<cfset inpk[pkfields[i].ColumnName] = qRecord[pkfields[i].ColumnName][1]>
			<cfset in[pkfields[i].ColumnName] = qRecord[pkfields[i].ColumnName][1]>
		</cfloop>
	</cfif>
	
	<!--- Look for DeletionMark field --->
	<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
		<cfif StructKeyExists(fields[i],"Special") AND fields[i].Special eq "DeletionMark">
			<cfif fields[i].CF_DataType eq "CF_SQL_BIT">
				<cfset in[fields[i].ColumnName] = 1>
				<cfset isLogicalDelete = true>
			<cfelseif fields[i].CF_DataType eq "CF_SQL_DATE">
				<cfset in[fields[i].ColumnName] = now()>
				<cfset isLogicalDelete = true>
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- Look for onDelete errors --->
	<cfloop index="i" from="1" to="#ArrayLen(rfields)#" step="1">
		<cfif StructKeyExists(rfields[i].Relation,"onDelete") AND StructKeyExists(rfields[i].Relation,"onDelete") AND rfields[i].Relation["onDelete"] eq "Error">
			<cfif rfields[i].Relation["type"] eq "list" OR ListFindNoCase(variables.aggregates,rfields[i].Relation["type"])>
				
				<cfset subdatum.data = StructNew()>
				<cfset subdatum.advsql = StructNew()>
				
				<cfif StructKeyExists(rfields[i].Relation,"join-table")>
					<cfset subdatum.subadvsql = StructNew()>
					<cfset subdatum.subadvsql.WHERE = "#escape( rfields[i].Relation['join-table'] & '.' & rfields[i].Relation['join-table-field-remote'] )# = #escape( rfields[i].Relation['table'] & '.' & rfields[i].Relation['remote-table-join-field'] )#">
					<cfset subdatum.data[rfields[i].Relation["local-table-join-field"]] = qRecord[rfields[i].Relation["join-table-field-local"]][1]>
					<cfsavecontent variable="subdatum.advsql.WHERE">
					EXISTS (
						#getRecordsSQL(tablename=rfields[i].Relation["join-table"],advsql=subdatum.subadvsql)#
					)
					</cfsavecontent>
				<cfelse>
					<cfset subdatum.data[rfields[i].Relation["join-field-remote"]] = qRecord[rfields[i].Relation["join-field-local"]][1]>
				</cfif>
				
				<cfset qRelationList = getRecords(tablename=rfields[i].Relation["table"],data=subdatum.data,fieldlist=rfields[i].Relation["field"],advsql=subdatum.advsql)>
				
				<cfif qRelationList.RecordCount>
					<cfthrow message="You cannot delete a record in #arguments.tablename# when associated records exist in #rfields[i].Relation.table#." type="DataMgr" errorcode="NoDeletesWithRelated">
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- Look for onDelete cascade --->
	<cfloop index="i" from="1" to="#ArrayLen(rfields)#" step="1">
		<cfif StructKeyExists(rfields[i].Relation,"onDelete") AND StructKeyExists(rfields[i].Relation,"onDelete") AND rfields[i].Relation["onDelete"] eq "Cascade">
			<cfif rfields[i].Relation["type"] eq "list" OR ListFindNoCase(variables.aggregate,rfields[i].Relation["type"])>
				
				<cfset out = StructNew()>
				
				<cfif StructKeyExists(rfields[i].Relation,"join-table")>	
					<cfset out[rfields[i].Relation["join-table-field-local"]] = sval(rfields[i].Relation["local-table-join-field"],in)>
					<cfset deleteRecords(rfields[i].Relation["join-table"],out)>
				<cfelse>
					<cfset out[rfields[i].Relation["join-table-field-remote"]] = sval(rfields[i].Relation["join-table-field-local"],qRecord)>
					<cfset deleteRecords(rfields[i].Relation["table"],out)>
				</cfif>
				
			</cfif>
		</cfif>
	</cfloop>
	
	<!--- Perform the delete --->
	<cfif isLogicalDelete>
		<cfset updateRecord(arguments.tablename,in)>
	<cfelse>
		<!--- Delete Record --->
		<cfoutput query="qDataset">
			<cfset isMatch = true>
			<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
				<cfif inpk[pkfields[i].ColumnName] NEQ qDataset[pkfields[i].ColumnName][CurrentRow]>
					<cfset isMatch = false>
				</cfif>
			</cfloop>
			<cfif isMatch>
				<cfset row = CurrentRow>
			</cfif>
		</cfoutput>
		
		<cfset qDataset = QueryDeleteRows(qDataset,row)>
		<cfset variables.WDDX_Data[arguments.tablename]["Dataset"] = qDataset>
		<cfset saveWDDXFile(arguments.tablename)>
		
		<!--- Log delete --->
		<cfif variables.doLogging AND NOT arguments.tablename eq variables.logtable>
			<cfinvoke method="logAction">
				<cfinvokeargument name="tablename" value="#arguments.tablename#">
				<cfif ArrayLen(pkfields) eq 1 AND StructKeyExists(in,pkfields[1].ColumnName)>
					<cfinvokeargument name="pkval" value="#in[pkfields[1].ColumnName]#">
				</cfif>
				<cfinvokeargument name="action" value="delete">
				<cfinvokeargument name="data" value="#in#">
				<cfinvokeargument name="sql" value="#sqlarray#">
			</cfinvoke>
		</cfif>
		
	</cfif>

</cffunction>

<cffunction name="getCreateSQL" access="public" returntype="string" output="no" hint="I return the SQL to create the given table.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfthrow message="Need to add the table">
	
	<cfreturn "">
</cffunction>

<cffunction name="setColumn" access="public" returntype="any" output="no" hint="I set a column in the given table">
	<cfargument name="tablename" type="string" required="yes" hint="The name of the table to which a column will be added.">
	<cfargument name="columnname" type="string" required="yes" hint="The name of the column to add.">
	<cfargument name="CF_Datatype" type="string" required="no" hint="The ColdFusion SQL Datatype of the column.">
	<cfargument name="Length" type="numeric" default="0" hint="The ColdFusion SQL Datatype of the column.">
	<cfargument name="Default" type="string" required="no" hint="The default value for the column.">
	<cfargument name="Special" type="string" required="no" hint="The special behavior for the column.">
	<cfargument name="Relation" type="struct" required="no" hint="Relationship information for this column.">
	<cfargument name="PrimaryKey" type="boolean" default="false" hint="Indicates whether this column is a primary key.">
	<cfargument name="AllowNulls" type="boolean" required="no" hint="Indicates whether this column allows nulls.">
	
	<cfset var type = "">
	<cfset var sql = "">
	<cfset var FailedSQL = "">
	<cfset var dbfields = getDBFieldList(arguments.tablename)>
	<cfset var dmfields = getFieldList(arguments.tablename)>
	<cfset var qDataset = 0>
	<cfset var aData = ArrayNew(1)>
	
	<!--- Default length to 255 (only used for text types) --->
	<cfif arguments.Length eq 0 AND StructKeyExists(arguments,"CF_Datatype")>
		<cfset arguments.Length = 255>
	</cfif>
	
	<cfif NOT ( StructKeyExists(arguments,"Relation") AND isStruct(arguments.Relation) AND StructCount(arguments.Relation) )>
		<cfset StructDelete(arguments,"Relation")>
	</cfif>
	
	<cfif StructKeyExists(arguments,"CF_Datatype") AND NOT ListFindNoCase(dbfields,arguments.ColumnName)>
		<cfset qDataset = getDataset(arguments.tablename)>
		<cfset type = getDBDataType(arguments.CF_Datatype)>
		
		<cfoutput query="qDataset">
			<cfif StructKeyExists(arguments,"Default") AND Len(Trim(arguments.Default))>
				<cfset ArrayAppend(aData,arguments.Default)>
			<cfelse>
				<cfset ArrayAppend(aData,"")>
			</cfif>
		</cfoutput>
		
		<cfset QueryAddColumn(qDataset,arguments.ColumnName,type,aData)>
		<cfset variables.WDDX_Data[arguments.tablename]["Dataset"] = qDataset>
		<cfset ArrayAppend(variables.WDDX_Data[arguments.tablename]["TableStruct"],arguments)>
		<cfset saveWDDXFile(arguments.tablename)>
		
	</cfif>
	
	
	<cfif NOT Len(FailedSQL)>
		<!--- Add the field to DataMgr if DataMgr doesn't know about the field --->
		<cfif NOT ListFindNoCase(dmfields,arguments.columnname)>
			<cfset ArrayAppend(variables.tables[arguments.tablename], Duplicate(arguments))>
		<cfelse>
			<cfif StructKeyExists(arguments,"Special")>
				<!--- If the field exists but a special is passed, set the special --->
				<cfset setColumnSpecial(arguments.tablename,arguments.columnname,arguments.Special)>
			</cfif>
			<cfif StructKeyExists(arguments,"Relation")>
				<!--- If the field exists but a relation is passed, set the relation --->
				<cfset setColumnRelation(arguments.tablename,arguments.columnname,arguments.Relation)>
			</cfif>
			<cfif StructKeyExists(arguments,"PrimaryKey") AND isBoolean(arguments.PrimaryKey) AND arguments.PrimaryKey>
				<!--- If the field exists but a relation is passed, set the relation --->
				<cfset setColumnPrimaryKey(arguments.tablename,arguments.columnname)>
			</cfif>
		</cfif>
	</cfif>
	
	<cfset variables.tableprops[arguments.tablename] = StructNew()>
	
</cffunction>

<cffunction name="getDBFieldList" access="public" returntype="string" output="no" hint="I get a list of fields in DataMgr for the given table.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var i = 0>
	<cfset var fieldlist = "">
	<cfset var bTable = checkTable(arguments.tablename)>
	
	<cfif StructKeyExists(variables.tableprops,arguments.tablename) AND StructKeyExists(variables.tableprops[arguments.tablename],"fieldlist")>
		<cfset fieldlist = variables.tableprops[arguments.tablename]["fieldlist"]>
	<cfelse>
		<!--- Loop over the fields in the table and make a list of them --->
		<cfif StructKeyExists(variables.WDDX_Data,arguments.tablename) AND StructKeyExists(variables.WDDX_Data[arguments.tablename],"TableStruct")>
			<cfloop index="i" from="1" to="#ArrayLen(variables.WDDX_Data[arguments.tablename].TableStruct)#" step="1">
				<cfif StructKeyExists(variables.WDDX_Data[arguments.tablename].TableStruct[i],"CF_DataType")>
					<cfset fieldlist = ListAppend(fieldlist, variables.WDDX_Data[arguments.tablename].TableStruct[i].ColumnName)>
				</cfif>
			</cfloop>
		</cfif>
		<cfset variables.tableprops[arguments.tablename]["fieldlist"] = fieldlist>
	</cfif>
	
	<cfreturn fieldlist>
</cffunction>

<cffunction name="getDBFieldList2" access="public" returntype="string" output="no" hint="I get a list of fields in DataMgr for the given table.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var i = 0>
	<cfset var fieldlist = "">
	
	<!--- Loop over the fields in the table and make a list of them --->
	<cfif StructKeyExists(variables.WDDX_Data,arguments.tablename) AND StructKeyExists(variables.WDDX_Data[arguments.tablename],"TableStruct")>
		<cfloop index="i" from="1" to="#ArrayLen(variables.WDDX_Data[arguments.tablename].TableStruct)#" step="1">
			<cfif StructKeyExists(variables.WDDX_Data[arguments.tablename].TableStruct[i],"CF_DataType")>
				<cfset fieldlist = ListAppend(fieldlist, variables.WDDX_Data[arguments.tablename].TableStruct[i].ColumnName)>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfreturn fieldlist>
</cffunction>

<cffunction name="getDBTypeList" access="public" returntype="string" output="no" hint="I get a list of fields in DataMgr for the given table.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var i = 0>
	<cfset var typelist = "">
	<!--- <cfset var bTable = checkTable(arguments.tablename)> --->
	
	<!--- Loop over the fields in the table and make a list of them --->
	<cfif StructKeyExists(variables.WDDX_Data,arguments.tablename) AND StructKeyExists(variables.WDDX_Data[arguments.tablename],"TableStruct")>
		<cfloop index="i" from="1" to="#ArrayLen(variables.WDDX_Data[arguments.tablename].TableStruct)#" step="1">
			<cfif StructKeyExists(variables.WDDX_Data[arguments.tablename].TableStruct[i],"CF_DataType")>
				<cfset typelist = ListAppend(typelist, getDBDataType(variables.WDDX_Data[arguments.tablename].TableStruct[i].CF_DataType))>
			</cfif>
		</cfloop>
	</cfif>
	
	<cfreturn typelist>
</cffunction>

<cffunction name="getDBTableStruct" access="public" returntype="any" output="no" hint="I return the structure of the given table in the database.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var sTable = getWDDXInfo(arguments.tablename)>
	<cfset var i = 0>
	<cfset var j = 0>
	<cfset var aFields = ArrayNew(1)>
	<cfset var thisTable = 0>
	<cfset var thisTableName = 0>
	<cfset var varXML = 0>
	<cfset var arrTables = 0>
	
	
	<cfif NOT ( StructKeyExists(sTable,"TableStruct") AND ArrayLen(sTable["TableStruct"]) )>
		<cfif NOT StructKeyExists(sTable,"XML")>
			<cfthrow type="DataMgr" message="WDDX file for #arguments.tablename# is missing TableStruct and XML keys - preventing DataMgr from properly reading the file.">
		</cfif>
		<cfset varXML = XmlParse(sTable.XML,"no")>
		<cfset arrTables = varXML.XmlRoot.XmlChildren>
		<cfscript>
		//  Loop over all root elements in XML
		for (i=1; i lte ArrayLen(arrTables);i=i+1) {
			//  If element is a table and has a name, add it to the data
			if ( arrTables[i].XmlName eq "table" AND StructKeyExists(arrTables[i].XmlAttributes,"name") ) {
				//temp variable to reference this table
				thisTable = arrTables[i];
				//table name
				thisTableName = thisTable.XmlAttributes["name"];
				//  Only add to struct if table doesn't exist or if cols should be altered
				if ( thisTableName EQ arguments.tablename ) {
					//Add to array of tables to add/alter
					fields = "";
					//  Loop through fields in table
					for (j=1; j lte ArrayLen(thisTable.XmlChildren);j=j+1) {
						//  If this xml tag is a field
						if ( thisTable.XmlChildren[j].XmlName eq "field" OR thisTable.XmlChildren[j].XmlName eq "column" ) {
							thisField = thisTable.XmlChildren[j].XmlAttributes;
							tmpStruct = StructNew();
							//If "name" attribute exists, but "ColumnName" att doesn't use name as ColumnName
							if ( StructKeyExists(thisField,"name") AND NOT StructKeyExists(thisField,"ColumnName") ) {
								thisField["ColumnName"] = thisField["name"];
							}
							//Set ColumnName
							tmpStruct["ColumnName"] = thisField["ColumnName"];
							//If "cfsqltype" attribute exists, but "CF_DataType" att doesn't use name as CF_DataType
							if ( StructKeyExists(thisField,"cfsqltype") AND NOT StructKeyExists(thisField,"CF_DataType") ) {
								thisField["CF_DataType"] = thisField["cfsqltype"];
							}
							//Set CF_DataType
							if ( StructKeyExists(thisField,"CF_DataType") ) {
								tmpStruct["CF_DataType"] = thisField["CF_DataType"];
							}
							//Set PrimaryKey (defaults to false)
							if ( StructKeyExists(thisField,"PrimaryKey") AND isBoolean(thisField["PrimaryKey"]) AND thisField["PrimaryKey"] ) {
								tmpStruct["PrimaryKey"] = true;
							}
							//Set AllowNulls (defaults to true)
							if ( StructKeyExists(thisField,"AllowNulls") AND isBoolean(thisField["AllowNulls"]) AND NOT thisField["AllowNulls"] ) {
								tmpStruct["AllowNulls"] = false;
							}
							//Set length (if it exists and isnumeric)
							if ( StructKeyExists(thisField,"Length") AND isNumeric(thisField["Length"]) AND NOT tmpStruct["CF_DataType"] eq "CF_SQL_LONGVARCHAR" ) {
								tmpStruct["Length"] = Val(thisField["Length"]);
							}
							//Set increment (if exists and true)
							if ( StructKeyExists(thisField,"Increment") AND isBoolean(thisField["Increment"]) AND thisField["Increment"] ) {
								tmpStruct["Increment"] = true;
							}
							//Set precision (if exists and true)
							if ( StructKeyExists(thisField,"Precision") AND isNumeric(thisField["Precision"]) ) {
								tmpStruct["Precision"] = Val(thisField["Precision"]);
							}
							//Set scale (if exists and true)
							if ( StructKeyExists(thisField,"Scale") AND isNumeric(thisField["Scale"]) ) {
								tmpStruct["Scale"] = Val(thisField["Scale"]);
							}
							//Set default (if exists)
							if ( StructKeyExists(thisField,"Default") AND Len(thisField["Default"]) ) {
								tmpStruct["Default"] = makeDefaultValue(thisField["Default"],tmpStruct["CF_DataType"]);
							}
							//Set Special (if exists)
							if ( StructKeyExists(thisField,"Special") ) {
								tmpStruct["Special"] = Trim(thisField["Special"]);
								//Sorter or DeletionMark should default to zero
								if (  NOT StructKeyExists(tmpStruct,"Default") ) {
									if ( tmpStruct["Special"] EQ "Sorter" OR tmpStruct["Special"] EQ "DeletionMark" ) {
										tmpStruct["Default"] = 0;
									}
								}
							}
							//Set relation (if exists)
							if ( ArrayLen(thisTable.XmlChildren[j].XmlChildren) eq 1 AND thisTable.XmlChildren[j].XmlChildren[1].XmlName eq "relation" ) {
								tmpStruct["Relation"] = expandRelationStruct(thisTable.XmlChildren[j].XmlChildren[1].XmlAttributes);
							}
							//Copy data set in temporary structure to result storage
							if ( NOT ListFindNoCase(fields, tmpStruct["ColumnName"]) ) {
								fields = ListAppend(fields,tmpStruct["ColumnName"]);
								ArrayAppend(aFields, adjustColumnArgs(tmpStruct));
							}
						}// /If this xml tag is a field
					}// /Loop through fields in table
				}// /Only add to struct if table doesn't exist or if cols should be altered
			}// /If element is a table and has a name, add it to the data
		}// /Loop over all root elements in XML
		</cfscript>
		<cfset sTable["TableStruct"] = aFields>
		<cfset saveWDDXFile(arguments.tablename,sTable)>
	</cfif>
	
	<cfreturn sTable["TableStruct"]>
</cffunction>

<cffunction name="getFieldSelectSQL" access="public" returntype="any" output="no">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="field" type="string" required="yes">
	<cfargument name="tablealias" type="string" required="no">
	<cfargument name="useFieldAlias" type="boolean" default="true">
	
	<cfset var sField = getField(arguments.tablename,arguments.field)>
	<cfset var aSQL = ArrayNew(1)>
	<cfset var sAdvSQL = StructNew()>
	<cfset var sJoin = StructNew()>
	<cfset var sArgs = StructNew()>
	<cfset var temp = "">
	
	<cfif NOT StructKeyExists(arguments,"tablealias")>
		<cfset arguments.tablealias = arguments.tablename>
	</cfif>
	
	<cfif StructKeyExists(sField,"Relation") AND StructKeyExists(sField.Relation,"type")>
		<cfset ArrayAppend(aSQL,"(")>
		<cfswitch expression="#sField.Relation.type#">
		<cfcase value="label">
			<cfset sAdvSQL = StructNew()>
			<cfset sAdvSQL["WHERE"] = "#escape(sField.Relation['table'] & '.' & sField.Relation['join-field-remote'])# = #escape(arguments.tablealias & '.' & sField.Relation['join-field-local'])#">
			<cfset ArrayAppend(aSQL,getRecordsSQL(tablename=sField.Relation["table"],fieldlist=sField.Relation["field"],maxrows=1,advsql=sAdvSQL))>
		</cfcase>
		<cfcase value="list">
			<cfif StructKeyExists(sField.Relation,"join-table")>
				<cfset temp = escape( arguments.tablealias & "." & sField.Relation["local-table-join-field"] )>
			<cfelse>
				<cfset temp = escape( arguments.tablealias & "." & sField.Relation["join-field-local"] )>
			</cfif>
			<cfset ArrayAppend(aSQL,concat(temp))>
		</cfcase>
		<cfcase value="concat">
			<cfset ArrayAppend(aSQL,"#concatFields(arguments.tablename,sField.Relation['fields'],sField.Relation['delimiter'],arguments.tablealias)#")>
		</cfcase>
		<cfcase value="avg,count,max,min,sum" delimiters=",">
			<cfset sAdvSQL = StructNew()>
			<cfif StructKeyExists(sField.Relation,"join-table")>
				<cfset sJoin = StructNew()>
				<cfset sJoin["table"] = sField.Relation["join-table"]>
				<cfset sJoin["onLeft"] = sField.Relation["remote-table-join-field"]>
				<cfset sJoin["onRight"] = sField.Relation["join-table-field-remote"]>
				<cfset sAdvSQL["WHERE"] = "#escape(sField.Relation['join-table'] & '.' & sField.Relation['join-table-field-local'].ColumnName)# = #escape(arguments.tablealias & '.' & sField.Relation['local-table-join-field'])#">
			<cfelse>
				<cfset sAdvSQL["WHERE"] = "#escape(sField.Relation['table'] & '.' & sField.Relation['join-field-remote'])# = #escape(arguments.tablealias & '.' & sField.Relation['join-field-local'])#">
			</cfif>
			<cfset sArgs["tablename"] = sField.Relation["table"]>
			<cfset sArgs["fieldlist"] = sField.Relation["field"]>
			<cfset sArgs["function"] = sField.Relation["type"]>
			<cfset sArgs["advsql"] = sAdvSQL>
			<cfset sArgs["join"] = sJoin>
			<cfif arguments.tablename EQ sField.Relation["table"]>
				<cfset sArgs["tablealias"] = "datamgr_inner_table">
			</cfif>
			<cfset ArrayAppend(aSQL,getRecordsSQL(argumentCollection=sArgs))>
		</cfcase>
		<cfcase value="custom">
			<cfif StructKeyExists(sField.Relation,"sql") AND Len(sField.Relation.sql)>
				<cfset ArrayAppend(aSQL,"#sField.Relation.sql#")>
			<cfelse>
				<cfset ArrayAppend(aSQL,"''")>
			</cfif>
		</cfcase>
		<cfdefaultcase>
			<cfset ArrayAppend(aSQL,"''")>
		</cfdefaultcase>
		</cfswitch>
		<cfset ArrayAppend(aSQL,")")>
		<cfif arguments.useFieldAlias>
			<cfset ArrayAppend(aSQL," AS #escape(sField['ColumnName'])#")>
		</cfif>
	<cfelse>
		<cfset ArrayAppend(aSQL,escape(sField["ColumnName"]))>
	</cfif>
	
	<cfreturn "''">
</cffunction>

<cffunction name="getFieldWhereSQL" access="public" returntype="any" output="no">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="field" type="string" required="yes">
	<cfargument name="data" type="struct" required="yes">
	<!--- <cfargument name="operator" type="string" default="="> --->
	<cfargument name="tablealias" type="string" required="no">
	
	<cfset var sField = getField(arguments.tablename,arguments.field)>
	<cfset var aSQL = ArrayNew(1)>
	<cfset var in = data>
	<cfset var sArgs = StructNew()>
	<cfset var temp = 0>
	<!--- <cfset var operators = "=,>,<,>=,<=,LIKE,NOT LIKE,<>,IN">
	
	<cfif NOT ListFindNoCase(operators,arguments.operator)>
		<cfthrow message="#arguments.operator# is not a valid operator. Valid operators are: #operators#" type="DataMgr" errorcode="InvalidOperator">
	</cfif> --->
	
	<cfif NOT StructKeyExists(arguments,"tablealias")>
		<cfset arguments.tablealias = arguments.tablename>
	</cfif>
	
	<cfif StructKeyExists(sField,"Relation") AND StructKeyExists(sField.Relation,"type")>
		<cfswitch expression="#sField.Relation.type#">
		<cfcase value="label">
			<cfset sArgs.tablename = sField.Relation["table"]>
			<cfset sArgs.fieldlist = sField.Relation["field"]>
			<cfset sArgs.maxrows = 1>
			<cfset sArgs.advsql = StructNew()>
			<cfset sArgs.data = StructNew()>
			
			<cfset ArrayAppend(aSQL,"AND	EXISTS (")>
				<cfset sArgs.data[sField.Relation["field"]] = in[sField.ColumnName]>
				<cfset sArgs.advsql["WHERE"] = "#escape(sField.Relation['table'] & '.' & sField.Relation['join-field-remote'])# = #escape(arguments.tablealias & '.' & sField.Relation['join-field-local'])#">
				<cfset sArgs.advsql["WHERE"] = "#escape(sField.Relation['table'] & '.' & sField.Relation['join-field-remote'])# = #escape(arguments.tablealias & '.' & sField.Relation['join-field-local'])#">
				<cfset ArrayAppend(aSQL,getRecordsSQL(argumentCollection=sArgs))>
			<cfset ArrayAppend(aSQL,")")>
		</cfcase>
		<cfcase value="list">
			<cfset sArgs.tablename = sField.Relation["table"]>
			<cfset sArgs.fieldlist = sField.Relation["field"]>
			<cfset sArgs.maxrows = 1>
			<cfset sArgs.join = StructNew()>
			<cfset sArgs.advsql = StructNew()>
			<cfset sArgs.advsql.WHERE = ArrayNew(1)>
			<cfset temp = ArrayNew(1)>
			
			<cfif StructKeyExists(sField.Relation,"join-table")>
				<cfset sArgs.join.table = sField.Relation["join-table"]>
				<cfset sArgs.join.onLeft = sField.Relation["remote-table-join-field"]>
				<cfset sArgs.join.onRight = sField.Relation["join-table-field-remote"]>
				<cfset ArrayAppend(sArgs.advsql.WHERE,"#escape(sField.Relation['join-table'] & '.' & sField.Relation['join-table-field-local'])# = #escape(arguments.tablealias & '.' & sField.Relation['local-table-join-field'])#")>
			<cfelse>
				<cfset ArrayAppend(sArgs.advsql.WHERE,"#escape(sField.Relation['table'] & '.' & sField.Relation['join-field-remote'])# = #escape(arguments.tablealias & '.' & sField.Relation['join-field-local'])#")>
			</cfif>
				<cfset ArrayAppend(sArgs.advsql.WHERE,"			AND		(")>
				<cfset ArrayAppend(sArgs.advsql.WHERE,"							1 = 0")>
				<cfloop index="temp" list="#in[sField.ColumnName]#">
					<cfset ArrayAppend(sArgs.advsql.WHERE,"					OR	#escape(sField.Relation['table'] & '.' & sField.Relation['field'])# = ")>
					<cfset ArrayAppend(sArgs.advsql.WHERE,sval(getField(sField.Relation["table"],sField.Relation["field"]),temp))>
				</cfloop>
				<cfset ArrayAppend(sArgs.advsql.WHERE,"					)")>
			
			<cfset ArrayAppend(aSQL,"AND	EXISTS (")>
				<cfset ArrayAppend(aSQL,getRecordsSQL(argumentCollection=sArgs))>
			<cfset ArrayAppend(aSQL,"		)")>
		</cfcase>
		<cfcase value="concat">
			<cfset ArrayAppend(aSQL,"AND	(")>
				<cfset ArrayAppend(aSQL,"#concat(sField.Relation['fields'],sField.Relation['delimiter'])#")>
			<cfset ArrayAppend(aSQL,")")>
			<cfset ArrayAppend(aSQL,"=")>
			<cfset ArrayAppend(aSQL,queryparam("CF_SQL_VARCHAR",in[sField.ColumnName]))>
		</cfcase>
		<cfcase value="avg,count,max,min,sum" delimiters=",">
			<cfset sArgs.tablename = sField.Relation["table"]>
			<cfset sArgs.fieldlist = sField.Relation["field"]>
			<cfset sArgs.advsql = StructNew()>
			<cfset sArgs.data = StructNew()>
			<cfset sArgs.join = StructNew()>
		
			<cfset sAdvSQL = StructNew()>
			<cfif StructKeyExists(sField.Relation,"join-table")>
				<cfset sArgs.join["table"] = sField.Relation["join-table"]>
				<cfset sArgs.join["onLeft"] = sField.Relation["remote-table-join-field"]>
				<cfset sArgs.join["onRight"] = sField.Relation["join-table-field-remote"]>
				<cfset sArgs.advsql["WHERE"] = "#escape(sField.Relation['join-table'] & '.' & sField.Relation['join-table-field-local'].ColumnName)# = #escape(arguments.tablealias & '.' & sField.Relation['local-table-join-field'])#">
			<cfelse>
				<cfset sArgs.advsql["WHERE"] = "#escape(sField.Relation['table'] & '.' & sField.Relation['join-field-remote'])# = #escape(arguments.tablealias & '.' & sField.Relation['join-field-local'])#">
			</cfif>
			<cfset sArgs["function"] = sField.Relation["type"]>
			<cfif arguments.tablename EQ sField.Relation["table"]>
				<cfset sArgs["tablealias"] = "datamgr_inner_table">
			</cfif>
			<cfset ArrayAppend(aSQL,"AND	(")>
				<cfset ArrayAppend(aSQL,getRecordsSQL(argumentCollection=sArgs))>
			<cfset ArrayAppend(aSQL,")")>
			<cfset ArrayAppend(aSQL,"=")>
			<cfset ArrayAppend(aSQL,Val(in[sField.ColumnName]))>
		</cfcase>
		<cfcase value="custom">
			<cfif StructKeyExists(sField.Relation,"sql") AND Len(sField.Relation.sql) AND StructKeyExists(sField.Relation,"CF_DataType")>
				<cfset ArrayAppend(aSQL,"AND	(")>
				<cfset ArrayAppend(aSQL,"#sField.Relation.sql#")>
				<cfset ArrayAppend(aSQL,")")>
				<cfset ArrayAppend(aSQL,"=")>
				<cfset ArrayAppend(aSQL,queryparam(cfsqltype=sField.Relation["CF_DataType"],value=in[sField.ColumnName]))>
			</cfif>
		</cfcase>
		</cfswitch>
	<cfelse>
		<cfset ArrayAppend(aSQL,escape(sField["ColumnName"]))>
	</cfif>
	
	<cfreturn "''">
</cffunction>

<cffunction name="getRecords" access="public" returntype="query" output="no" hint="I get a recordset based on the data given.">
	<cfargument name="tablename" type="string" required="yes" hint="The table from which to return a record.">
	<cfargument name="data" type="struct" required="no" hint="A structure with the data for the desired record. Each key/value indicates a value for the field matching that key.">
	<cfargument name="orderBy" type="string" default="">
	<cfargument name="maxrows" type="numeric" required="no">
	<cfargument name="fieldlist" type="string" default="" hint="A list of fields to return. If left blank, all fields will be returned.">
	<cfargument name="advsql" type="struct" hint="(Development Only) A structure of sqlarrays for each area of a query (SELECT,FROM,WHERE,ORDER BY).">
	
	<cfset var in = StructNew()><!--- holder for incoming data (just for readability) --->
	<cfset var i = 0><!--- Generic counter --->
	<cfset var colnum = 1>
	<cfset var sqlarray = ArrayNew(1)>
	<cfset var hasLists = false>
	<cfset var qRecords = 0>
	
	<cfif StructKeyExists(arguments,"data")>
		<cfset in = arguments.data>
	</cfif>
	
	<!--- Get records --->
	<cfset qRecords = runSQLArray(getRecordsSQL(argumentCollection=arguments))>
	
<!--- 	
	<cfquery name="qRecords" dbtype="query">
	SELECT	
		<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
			<cfif Len(arguments.fieldlist) eq 0 OR ListFindNoCase(arguments.fieldlist, pkfields[i].ColumnName)>
				<cfif colnum gt 1>,</cfif><cfset colnum = colnum + 1>
				#escape(pkfields[i].ColumnName)#
			</cfif>
		</cfloop>
		<!--- select updateable fields --->
		<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
			<cfif Len(arguments.fieldlist) eq 0 OR ListFindNoCase(arguments.fieldlist, fields[i].ColumnName)>
				<cfif colnum gt 1>,</cfif><cfset colnum = colnum + 1>
				#escape(fields[i].ColumnName)#
			</cfif>
		</cfloop>
	FROM	#arguments.tablealias#
	WHERE	1 = 1
	</cfquery>
 --->	
	<cfreturn qRecords>
</cffunction>

<cffunction name="insertRecord" access="public" returntype="string" output="no" hint="I insert a record into the given table with the provided data and do my best to return the primary key of the inserted record.">
	<cfargument name="tablename" type="string" required="yes" hint="The table in which to insert data.">
	<cfargument name="data" type="struct" required="yes" hint="A structure with the data for the desired record. Each key/value indicates a value for the field matching that key.">
	<cfargument name="OnExists" type="string" default="insert" hint="The action to take if a record with the given values exists. Possible values: insert (inserts another record), error (throws an error), update (updates the matching record), skip (performs no action), save (updates only for matching primary key)).">
	
	<cfset var fields = getUpdateableFields(arguments.tablename)>
	<cfset var OnExistsValues = "insert,error,update,skip"><!--- possible values for OnExists argument --->
	<cfset var i = 0><!--- generic counter --->
	<cfset var fieldcount = 0><!--- count of fields --->
	<cfset var pkfields = getPKFields(arguments.tablename)>
	<cfset var in = clean(arguments.data)><!--- holder for incoming data (just for readability) --->
	<cfset var inPK = StructNew()><!--- holder for incoming pk data (just for readability) --->
	<cfset var qGetRecords = QueryNew('none')>
	<cfset var result = ""><!--- will hold primary key --->
	<cfset var qCheckKey = 0><!--- Used to get primary key --->
	<cfset var bSetGuid = false><!--- Set GUID (SQL Server specific) --->
	<cfset var GuidVar = "GUID"><!--- var to create variable name for GUID (SQL Server specific) --->
	<cfset var inf = "">
	<cfset var sqlarray = ArrayNew(1)>
	
	<cfset in = getRelationValues(arguments.tablename,in)>
	
	<!--- Create GUID for insert SQL Server where the table has on primary key field and it is a GUID --->
	<cfif ArrayLen(pkfields) eq 1 AND pkfields[1].CF_Datatype eq "CF_SQL_IDSTAMP" AND getDatabase() eq "MS SQL" AND NOT StructKeyExists(in,pkfields[1].ColumnName)>
		<cfset bSetGuid = true>
	</cfif>
	
	<!--- Create variable to hold GUID for SQL Server GUID inserts --->
	<cfif bSetGuid>
		<cflock timeout="30" throwontimeout="No" name="DataMgr_GuidNum" type="EXCLUSIVE">
			<!--- %%I cant figure out a way to safely increment the variable to make it unique for a transaction w/0 the use of request scope --->
			<cfif isDefined("request.DataMgr_GuidNum")>
				<cfset request.DataMgr_GuidNum = Val(request.DataMgr_GuidNum) + 1>
			<cfelse>
				<cfset request.DataMgr_GuidNum = 1>
			</cfif>
			<cfset GuidVar = "GUID#request.DataMgr_GuidNum#">
		</cflock>
	</cfif>
	
	<!--- Check for existing records if an action other than insert should be take if one exists --->
	<cfif arguments.OnExists neq "insert">
		<cfif ArrayLen(pkfields)>
			<!--- Load up all primary key fields in temp structure --->
			<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
				<cfif StructKeyHasLen(in,pkfields[i].ColumnName)>
					<cfset inPK[pkfields[i].ColumnName] = in[pkfields[i].ColumnName]>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfif arguments.OnExists NEQ "save">
			<cfset qGetRecords = getRecords(tablename=arguments.tablename,data=in,fieldlist=StructKeyList(inPK))><!--- Try to get existing record with given data --->
		</cfif>
		
		<!--- If no matching records by all fields, Check for existing record by primary keys --->
		<cfif arguments.OnExists EQ "save" OR qGetRecords.RecordCount eq 0>
			<cfif ArrayLen(pkfields)>
				<!--- All all primary key fields exist, check for record --->
				<cfif StructCount(inPK) eq ArrayLen(pkfields)>
					<cfset qGetRecords = getRecord(tablename=arguments.tablename,data=inPK,fieldlist=StructKeyList(inPK))>
				</cfif>
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Check for existing records --->
	<cfif qGetRecords.RecordCount gt 0>
		<cfswitch expression="#arguments.OnExists#">
		<cfcase value="error">
			<cfthrow message="#arguments.tablename#: A record with these criteria already exists." type="DataMgr">
		</cfcase>
		<cfcase value="update,save">
			<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
				<cfset in[pkfields[i].ColumnName] = qGetRecords[pkfields[i].ColumnName][1]>
			</cfloop>
			<cfset result = updateRecord(arguments.tablename,in)>
			<cfreturn result>
		</cfcase>
		<cfcase value="skip">
			<cfreturn qGetRecords[pkfields[1].ColumnName][1]>
		</cfcase>
		</cfswitch>
	</cfif>
	
	<!--- Check for specials --->
	<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
		<cfif StructKeyExists(fields[i],"Special") AND Len(fields[i].Special) AND NOT StructKeyExists(in,fields[i].ColumnName)>
			<cfswitch expression="#fields[i].Special#">
			<cfcase value="CreationDate">
				<cfset in[fields[i].ColumnName] = now()>
			</cfcase>
			<cfcase value="LastUpdatedDate">
				<cfset in[fields[i].ColumnName] = now()>
			</cfcase>
			<cfcase value="Sorter">
				<cfset in[fields[i].ColumnName] = getNewSortNum(arguments.tablename,fields[i].ColumnName)>
			</cfcase>
			</cfswitch>
		</cfif>
	</cfloop>
	
	<!--- Insert record --->
	
	<cfset qDataset = variables.tabledata[arguments.tablename]>
	<cfif bSetGuid AND NOT StructKeyExists(in,pkfields[1].ColumnName)>
		<cfset in[pkfields[i].ColumnName] = CreateUUID()>
	</cfif>
	
	
	<cfset QueryAddRow(qDataset)>
	
	<!--- Loop through all updateable fields --->
	<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
		<cfif useField(in,fields[i]) OR (StructKeyExists(fields[i],"Default") AND Len(fields[i].Default) AND getDatabase() eq "Access")><!--- Include the field in SQL if it has appropriate data --->
			<cfset fieldcount = fieldcount + 1>
			<cfset QuerySetCell(qDataset,fields[i].ColumnName,in[fields[i].ColumnName])>
		</cfif>
	</cfloop>
	<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
		<cfif ( useField(in,pkfields[i]) AND NOT isIdentityField(pkfields[i]) ) OR ( pkfields[i].CF_Datatype eq "CF_SQL_IDSTAMP" AND bSetGuid )><!--- Include the field in SQL if it has appropriate data --->
			<cfset fieldcount = fieldcount + 1>
			<cfset QuerySetCell(qDataset,pkfields[i].ColumnName,in[pkfields[i].ColumnName])>
		<cfelseif isIdentityField(pkfields[i])>
			<cfset QuerySetCell(qDataset,pkfields[i].ColumnName,getNewSortNum(arguments.tablename,pkfields[i].ColumnName))>
		</cfif>
	</cfloop>
	<cfif fieldcount eq 0><cfsavecontent variable="inf"><cfdump var="#in#"></cfsavecontent><cfthrow message="You must pass in at least one field that can be inserted into the database. Fields: #inf#" type="DataMgr" errorcode="NeedInsertFields"></cfif>
	<cfset variables.WDDX_Data[arguments.tablename]["Dataset"] = qDataset>
	<cfset saveWDDXFile(arguments.tablename)>
	
	<!--- Get primary key --->
	<cfif Len(result) eq 0>
		<cfif ArrayLen(pkfields) AND StructKeyExists(pkfields[1],"Increment") AND isBoolean(pkfields[1].Increment) AND pkfields[1].Increment>
			<cfset result = getInsertedIdentity(arguments.tablename,pkfields[1].ColumnName)>
		<cfelse>
			<cftry>
				<cfset result = getPKFromData(arguments.tablename,in)>
				<cfcatch>
					<cfset result = "">
				</cfcatch>
			</cftry>
		</cfif>
	</cfif>
	
	<!--- set pkfield so that we can save relation data --->
	<cfif ArrayLen(pkfields)>
		<cfset in[pkfields[1].ColumnName] = result>
		<cfset saveRelations(arguments.tablename,in,pkfields[1],result)>
	</cfif>
	
	<!--- Log insert --->
	<cfif variables.doLogging AND NOT arguments.tablename eq variables.logtable>
		<cfinvoke method="logAction">
			<cfinvokeargument name="tablename" value="#arguments.tablename#">
			<cfif ArrayLen(pkfields) eq 1 AND StructKeyExists(in,pkfields[1].ColumnName)>
				<cfinvokeargument name="pkval" value="#in[pkfields[1].ColumnName]#">
			</cfif>
			<cfinvokeargument name="action" value="insert">
			<cfinvokeargument name="data" value="#in#">
			<cfinvokeargument name="sql" value="#sqlarray#">
		</cfinvoke>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="updateRecord" access="public" returntype="string" output="no" hint="I update a record in the given table with the provided data and return the primary key of the updated record.">
	<cfargument name="tablename" type="string" required="yes" hint="The table on which to update data.">
	<cfargument name="data" type="struct" required="yes" hint="A structure with the data for the desired record. Each key/value indicates a value for the field matching that key.">
	
	<cfset var fields = getUpdateableFields(arguments.tablename)>
	<cfset var i = 0><!--- generic counter --->
	<cfset var fieldcount = 0><!--- number of fields --->
	<cfset var pkfields = getPKFields(arguments.tablename)>
	<cfset var in = clean(arguments.data)><!--- holds incoming data for ease of use --->
	<cfset var qGetUpdateRecord = 0><!--- used to check for existing record --->
	<cfset var temp = "">
	<cfset var result = 0>
	<cfset var sqlarray = ArrayNew(1)>
	<cfset var inpk = StructNew()>
	<cfset var qDataset = getDataset(arguments.tablename)>
	<cfset var isMatch = false>
	
	<cfset in = getRelationValues(arguments.tablename,in)>
	
	<!--- This method is only to be used on fields with one pkfield --->
	<cfif NOT ArrayLen(pkfields)>
		<cfthrow message="This method can only be used on tables with at least one primary key field." type="DataMgr" errorcode="NeedPKField">
	</cfif>
	<!--- Throw exception on any attempt to update a table with no updateable fields --->
	<cfif NOT ArrayLen(fields)>
		<cfthrow errorcode="NoUpdateableFields" message="This table does not have any updateable fields." type="DataMgr">
	</cfif>
	<!--- Throw exception if any pkfields are missing from incoming data --->
	<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
		<cfif NOT StructKeyExists(in,pkfields[i].ColumnName)>
			<cfthrow errorcode="RequiresAllPkFields" message="All Primary Key fields must be used when updating a record." type="DataMgr">
		</cfif>
	</cfloop>
	
	<!--- Check for existing record --->
	<cfset sqlarray = ArrayNew(1)>
	<cfset ArrayAppend(sqlarray,"SELECT	#escape(pkfields[1].ColumnName)#")>
	<cfset ArrayAppend(sqlarray,"FROM	#escape(arguments.tablename)#")>
	<cfset ArrayAppend(sqlarray,"WHERE	1 = 1")>
	<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
		<cfset ArrayAppend(sqlarray,"AND	#escape(pkfields[i].ColumnName)# = ")>
		<cfset ArrayAppend(sqlarray,sval(pkfields[i],in))>
	</cfloop>
	<cfset qGetUpdateRecord = runSQLArray(sqlarray)>
	
	<!--- Make sure record exists to update --->
	<cfif qGetUpdateRecord.RecordCount EQ 1>
		<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
			<cfset inpk[pkfields[i].ColumnName] = qGetUpdateRecord[pkfields[i].ColumnName][1]>
			<cfset in[pkfields[i].ColumnName] = qGetUpdateRecord[pkfields[i].ColumnName][1]>
		</cfloop>
	<cfelse>
		<cfset temp = "">
		<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
			<cfset temp = ListAppend(temp,"#escape(pkfields[i].ColumnName)#=#in[pkfields[i].ColumnName]#")>
		</cfloop>
		<cfthrow errorcode="NoUpdateRecord" message="No record exists for update criteria (#temp#)." type="DataMgr">
	</cfif>
	
	<!--- Check for specials --->
	<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
		<cfif StructKeyExists(fields[i],"Special") AND Len(fields[i].Special) AND NOT StructKeyExists(in,fields[i].ColumnName)>
			<cfswitch expression="#fields[i].Special#">
			<cfcase value="LastUpdatedDate">
				<cfset in[fields[i].ColumnName] = now()>
			</cfcase>
			</cfswitch>
		</cfif>
	</cfloop>
	
	<cfoutput query="qDataset">
		<cfset isMatch = true>
		<cfloop index="i" from="1" to="#ArrayLen(pkfields)#" step="1">
			<cfif inpk[pkfields[i].ColumnName] NEQ qDataset[pkfields[i].ColumnName][CurrentRow]>
				<cfset isMatch = false>
			</cfif>
		</cfloop>
		<cfif isMatch>
			<cfloop index="i" from="1" to="#ArrayLen(fields)#" step="1">
				<cfif useField(in,fields[i])><!--- Include update if this is valid data --->
					<cfset checkLength(fields[i],in[fields[i].ColumnName])>
					<cfset fieldcount = fieldcount + 1>
					<cfset QuerySetCell(qDataset,fields[i].ColumnName,in[fields[i].ColumnName],CurrentRow)>
				<cfelseif isBlankValue(in,fields[i])><!--- Or if it is passed in as empty value and null are allowed --->
					<cfset fieldcount = fieldcount + 1>
					<cfset QuerySetCell(qDataset,fields[i].ColumnName,"",CurrentRow)>
				</cfif>
			</cfloop>
		</cfif>
	</cfoutput>
	
	<cfset variables.WDDX_Data[arguments.tablename]["Dataset"] = qDataset>
	<cfset saveWDDXFile(arguments.tablename)>
	
	<!--- Save any relations --->
	<cfset saveRelations(arguments.tablename,in,pkfields[1],result)>
	
	<!--- Log update --->
	<cfif variables.doLogging AND NOT arguments.tablename eq variables.logtable>
		<cfinvoke method="logAction">
			<cfinvokeargument name="tablename" value="#arguments.tablename#">
			<cfinvokeargument name="pkval" value="#result#">
			<cfinvokeargument name="action" value="update">
			<cfinvokeargument name="data" value="#in#">
			<cfinvokeargument name="sql" value="#sqlarray#">
		</cfinvoke>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="checkTable" access="private" returntype="boolean" output="no" hint="I check to see if the given table exists in the Datamgr.">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfif NOT StructKeyExists(variables.tables,arguments.tablename)>
		<cfset loadTable(arguments.tablename)>
	</cfif>
	
	<cfset variables.tabledata[arguments.tablename] = getDataset(arguments.tablename)>
	<cfset variables[arguments.tablename] = variables.tabledata[arguments.tablename]>
	
	<cfreturn true>
</cffunction>

<cffunction name="getCFDataType" access="public" returntype="string" output="no" hint="I return the cfqueryparam datatype from the database datatype.">
	<cfargument name="type" type="string" required="yes" hint="The database data type.">
	
	<cfset var result = "">
	
	<cfswitch expression="#arguments.type#">
		<cfcase value="bigint"><cfset result = "CF_SQL_BIGINT"></cfcase>
		<cfcase value="binary,image,sql_variant,sysname,varbinary"><cfset result = ""></cfcase>
		<cfcase value="bit"><cfset result = "CF_SQL_BIT"></cfcase>
		<cfcase value="char"><cfset result = "CF_SQL_CHAR"></cfcase>
		<cfcase value="datetime"><cfset result = "CF_SQL_DATE"></cfcase>
		<cfcase value="decimal"><cfset result = "CF_SQL_DECIMAL"></cfcase>
		<cfcase value="float"><cfset result = "CF_SQL_FLOAT"></cfcase>
		<cfcase value="int"><cfset result = "CF_SQL_INTEGER"></cfcase>
		<cfcase value="money"><cfset result = "CF_SQL_MONEY"></cfcase>
		<cfcase value="nchar"><cfset result = "CF_SQL_CHAR"></cfcase>
		<cfcase value="ntext"><cfset result = "CF_SQL_LONGVARCHAR"></cfcase>
		<cfcase value="numeric"><cfset result = "CF_SQL_NUMERIC"></cfcase>
		<cfcase value="nvarchar"><cfset result = "CF_SQL_VARCHAR"></cfcase>
		<cfcase value="real"><cfset result = "CF_SQL_REAL"></cfcase>
		<cfcase value="smalldatetime"><cfset result = "CF_SQL_DATE"></cfcase>
		<cfcase value="smallint"><cfset result = "CF_SQL_SMALLINT"></cfcase>
		<cfcase value="smallmoney"><cfset result = "CF_SQL_MONEY4"></cfcase>
		<cfcase value="text"><cfset result = "CF_SQL_LONGVARCHAR"></cfcase>
		<cfcase value="timestamp"><cfset result = "CF_SQL_TIMESTAMP"></cfcase>
		<cfcase value="tinyint"><cfset result = "CF_SQL_TINYINT"></cfcase>
		<cfcase value="uniqueidentifier"><cfset result = "CF_SQL_IDSTAMP"></cfcase>
		<cfcase value="varchar"><cfset result = "CF_SQL_VARCHAR"></cfcase>
		<cfdefaultcase><cfset result = ""></cfdefaultcase>
	</cfswitch>
	
	<cfreturn result>
</cffunction>

<cffunction name="getDBDataType" access="public" returntype="string" output="no" hint="I return the database datatype from the cfqueryparam datatype.">
	<cfargument name="CF_Datatype" type="string" required="yes">
	
	<cfset var result = "">
	
	<cfswitch expression="#arguments.CF_Datatype#">
		<cfcase value="CF_SQL_BIGINT"><cfset result = "BigInt"></cfcase>
		<cfcase value="CF_SQL_BIT"><cfset result = "Bit"></cfcase>
		<cfcase value="CF_SQL_CHAR"><cfset result = "VarChar"></cfcase>
		<cfcase value="CF_SQL_DATE"><cfset result = "Date"></cfcase>
		<cfcase value="CF_SQL_DECIMAL"><cfset result = "Decimal"></cfcase>
		<cfcase value="CF_SQL_DOUBLE"><cfset result = "Double"></cfcase>
		<cfcase value="CF_SQL_FLOAT"><cfset result = "Double"></cfcase>
		<cfcase value="CF_SQL_IDSTAMP"><cfset result = "VarChar"></cfcase>
		<cfcase value="CF_SQL_INTEGER"><cfset result = "Integer"></cfcase>
		<cfcase value="CF_SQL_LONGVARCHAR"><cfset result = "VarChar"></cfcase>
		<cfcase value="CF_SQL_MONEY"><cfset result = "Double"></cfcase>
		<cfcase value="CF_SQL_MONEY4"><cfset result = "Double"></cfcase>
		<cfcase value="CF_SQL_NUMERIC"><cfset result = "Double"></cfcase>
		<cfcase value="CF_SQL_REAL"><cfset result = "Double"></cfcase>
		<cfcase value="CF_SQL_SMALLINT"><cfset result = "Integer"></cfcase>
		<cfcase value="CF_SQL_TIMESTAMP"><cfset result = "Time"></cfcase>
		<cfcase value="CF_SQL_TINYINT"><cfset result = "Integer"></cfcase>
		<cfcase value="CF_SQL_VARCHAR"><cfset result = "VarChar"></cfcase>
		<cfdefaultcase><cfthrow message="DataMgr object cannot handle this data type." type="DataMgr" detail="DataMgr cannot handle data type '#arguments.CF_Datatype#'" errorcode="InvalidDataType"></cfdefaultcase>
	</cfswitch>
	
	<cfreturn result>
</cffunction>

<cffunction name="getWDDXInfo" access="private" returntype="struct" output="no">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var wTable = "">
	<cfset var sTable = 0>
	
	<cfif NOT StructKeyExists(variables,"WDDX_Data")>
		<cfset variables.WDDX_Data = StructNew()>
	</cfif>
	
	<cfif NOT StructKeyExists(variables.WDDX_Data,arguments.tablename)>
		<cffile action="READ" file="#variables.datasource##arguments.tablename#.wddx" variable="wTable">
		
		<cfwddx action="WDDX2CFML" input="#wTable#" output="sTable">
		
		<cfset variables.WDDX_Data[arguments.tablename] = sTable>
		<cfset getDataset(arguments.tablename)>
	</cfif>
	
	<cfreturn variables.WDDX_Data[arguments.tablename]>
</cffunction>

<cffunction name="getDataset1" access="private" returntype="query" output="no">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var sTable = getWDDXInfo(arguments.tablename)>
	<cfset var qRawData = sTable["Dataset"]>
	<cfset var qDataset = getDBTypeList(arguments.tablename)>
	<cfset var col ="">
	
	<cfreturn sTable["Dataset"]>
</cffunction>

<cffunction name="getDataset" access="private" returntype="query" output="no">
	<cfargument name="tablename" type="string" required="yes">
	
	<cfset var sTable = getWDDXInfo(arguments.tablename)>
	<cfset var qDataset = QueryNew(getDBFieldList2(arguments.tablename),getDBTypeList(arguments.tablename))>
	<cfset var qRawData = sTable["Dataset"]>
	<cfset var col ="">
	
	<cfoutput query="qRawData">
		<cfset QueryAddRow(qDataset)>
		<cfloop list="#qDataset.ColumnList#" index="col">
			<cftry>
				<cfset QuerySetCell(qDataset,col,qRawData[col][CurrentRow])>
				<cfcatch>
				</cfcatch>
			</cftry>
		</cfloop>
	</cfoutput>
	
	<cfreturn qDataset>
</cffunction>

<cffunction name="isStringType" access="private" returntype="boolean" output="no" hint="I indicate if the given datatype is valid for string data.">
	<cfargument name="type" type="string">

	<cfset var strtypes = "cf_sql_char,cf_sql_nchar,cf_sql_nvarchar,cf_sql_varchar">
	<cfset var result = false>
	<cfif ListFindNoCase(strtypes,arguments.type)>
		<cfset result = true>
	</cfif>
	
	<cfreturn result>
</cffunction>

<cffunction name="runSQL" access="public" returntype="any" output="no" hint="I run the given SQL.">
	<cfargument name="sql" type="string" required="yes">
	
	<cfset var qQuery = 0>
	<cfset var thisSQL = "">
	
	<cfquery name="qQuery" dbtype="query">#Trim(PreserveSingleQuotes(arguments.sql))#</cfquery>
	
	<cfif IsDefined("qQuery")>
		<cfreturn qQuery>
	</cfif>
	
</cffunction>

<cffunction name="runSQLArray" access="public" returntype="any" output="no" hint="I run the given array representing SQL code (structures in the array represent params).">
	<cfargument name="sqlarray" type="array" required="yes">
	
	<cfset var qQuery = 0>
	<cfset var i = 0>
	<cfset var temp = "">
	<cfset var aSQL = cleanSQLArray(arguments.sqlarray)>
	
	<cfquery name="qQuery" dbtype="query"><cfloop index="i" from="1" to="#ArrayLen(aSQL)#" step="1"><cfif IsSimpleValue(aSQL[i])><cfset temp = aSQL[i]>#Trim(PreserveSingleQuotes(temp))#<cfelseif IsStruct(aSQL[i])><cfset aSQL[i] = queryparam(argumentCollection=aSQL[i])><cfswitch expression="#aSQL[i].cfsqltype#"><cfcase value="CF_SQL_BIT"><cfif aSQL[i].value>1<cfelse>0</cfif></cfcase><cfcase value="CF_SQL_DATE">#CreateODBCDateTime(aSQL[i].value)#</cfcase><cfdefaultcase><cfif ListFindNoCase(variables.dectypes,aSQL[i].cfsqltype)>#Val(aSQL[i].value)#<cfelse><cfqueryparam value="#aSQL[i].value#" cfsqltype="#aSQL[i].cfsqltype#" maxlength="#aSQL[i].maxlength#" scale="#aSQL[i].scale#" null="#aSQL[i].null#" list="#aSQL[i].list#" separator="#aSQL[i].separator#"></cfif></cfdefaultcase></cfswitch></cfif> </cfloop></cfquery>
	
	<cfif IsDefined("qQuery")>
		<cfreturn qQuery>
	</cfif>
	
</cffunction>

<cffunction name="saveWDDXFile" access="private" returntype="void" output="no">
	<cfargument name="tablename" type="string" required="yes">
	<cfargument name="data" type="struct" default="#variables.WDDX_Data[arguments.tablename]#">
	
	<cfset var wData = 0>
	
	<cfwddx action="CFML2WDDX" input="#arguments.data#" output="wData" usetimezoneinfo="yes">
	<cffile action="write" file="#variables.datasource##arguments.tablename#.wddx" output="#wData#">
	
	<cfset StructDelete(variables.WDDX_Data,arguments.tablename)>
	<cfset StructDelete(variables,arguments.tablename)>
	<cfset getWDDXInfo(arguments.tablename)>
	<cfset checkTable(arguments.tablename)>
	
</cffunction>
<cfscript>
/**
 * Removes rows from a query.
 * Added var col = "";
 * No longer using Evaluate. Function is MUCH smaller now.
 * 
 * @param Query 	 Query to be modified 
 * @param Rows 	 Either a number or a list of numbers 
 * @return This function returns a query. 
 * @author Raymond Camden (ray@camdenfamily.com) 
 * @version 2, October 11, 2001 
 */
function QueryDeleteRows(Query,Rows) {
	var tmp = QueryNew(Query.ColumnList);
	var i = 1;
	var x = 1;

	for(i=1;i lte Query.recordCount; i=i+1) {
		if(not ListFind(Rows,i)) {
			QueryAddRow(tmp,1);
			for(x=1;x lte ListLen(tmp.ColumnList);x=x+1) {
				QuerySetCell(tmp, ListGetAt(tmp.ColumnList,x), query[ListGetAt(tmp.ColumnList,x)][i]);
			}
		}
	}
	return tmp;
}
</cfscript>

</cfcomponent>