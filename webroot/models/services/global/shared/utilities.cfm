<cfoutput>
	<cffunction name="cleanNumber" output="no">
		<cfargument name="dirtystring">
		<cfargument name="nospaces" default="false">
		
		<cfscript>
			cleanstring = removehtml(dirtystring);
			cleanstring = REReplace(cleanstring,"[^0-9_ .]","","all");
			if(arguments.nospaces) cleanstring = REReplace(cleanstring,"[^0-9.]","","all");
		</cfscript>
		
		<cfreturn trim(cleanstring)>
	</cffunction>    
	<cffunction name="deleteThisFile" output="no">
		<cfargument name="filepath">
		<cfscript>
			var loc = {};
			loc.thisfile = expandThis(arguments.filepath);
			if(FileExists(loc.thisfile))
			{
				fileDelete(loc.thisfile);
			}
		</cfscript>
	</cffunction>
	<cffunction name="getQuoteUrlId" output="no">
		<cfargument name="pageQuoteUrl" type="string" default="">
		<cfparam name="quoteformurl" default="quote">

		<cfif len(trim(arguments.pageQuoteUrl))>
			<cfset quoteformurl = listDeleteAt(arguments.pageQuoteUrl,listLen(arguments.pageQuoteUrl,"."),".")>
		</cfif>

		<cfif len(trim(request.site.urlExtension))>
			<cfset quoteformurl = "/" & quoteformurl & "." & request.site.urlExtension>
		</cfif>

		<cfreturn quoteformurl>
	</cffunction>
	<cffunction name="generateForm" output="no">
		<cfargument name="formid" default="">
		<cfargument name="formwrap" default="true">
		<cfargument name="formclass" default="">

		<cfset metaform = model("Form").findAll(where="id = '#arguments.formid#'")>
		<cfset dataFields = model("FormField").findAll(where="metafieldType = 'formfield' AND modelid = '#arguments.formid#'",order="sortorder ASC")>

		<cfif isBoolean(metaform.templated) AND metaform.templated>
			<cfset formContent =  '				
				#hiddenfieldtag(name="qform[id]", value="#arguments.formid#")#
				#processShortcodes(metaform.template)#
			'>		
		<cfelse>
			<cfset formContent =  '				
				#hiddenfieldtag(name="qform[id]", value="#arguments.formid#")#
				#includePartial(partial="/_partials/formFieldsRender")#'>
		</cfif>
		
		<cfif isBoolean(formwrap) AND formwrap>
			<cfset formContent =  '
			<form enctype="multipart/form-data" method="post" class="#formclass#"
				action="#urlFor(route="admin~Action", controller="forms", action="formsubmissionSave")#?formid=#arguments.formid#">				
				#formContent#		
			</form>'>
		</cfif>

		<cfreturn formContent>
		
	</cffunction>
	
	<cffunction name="siteIdEqualsCheck" output="no">
		<cfargument name="allowAllSiteRecords" default="true">
		
		<cfif !arguments.allowAllSiteRecords>
			<cfreturn "siteid = #getSiteId()#">
		</cfif>
		<cfreturn "(siteid=#getSiteId()# OR globalized = 1)">
	</cffunction>
	
	<cffunction name="getAdminTemplate">
		<cfargument name="templateId" default="">		
		<cfset themeTemplatePath = "/views/layouts/admin/templates/#templateId#.cfm">
		<cfset themeTemplatePathFull = expandPath(themeTemplatePath)>
		<cfif FileExists(themeTemplatePathFull)>
			<cfreturn themeTemplatePath>
		<cfelse>
			<cfreturn ""> 
		</cfif>
	</cffunction>
	
	<cffunction name="getThemeTemplate" output="no">
		<cfargument name="templateId" default="">

		<cfset themePageTemplatePath = "/views/themes/#request.site.theme#/pagetemplates/#templateId#.cfm">
		<cfset themeTemplatePath = "/views/themes/#request.site.theme#/templates/#templateId#.cfm">

		<cfif FileExists(expandPath(themePageTemplatePath))>
			<cfreturn themePageTemplatePath>
		<cfelseif FileExists(expandPath(themeTemplatePath))>
			<cfreturn themeTemplatePath>
		<cfelse>
			<cfreturn ""> 
		</cfif>
	</cffunction>
    
    <cffunction name="getAllUserFieldData" output="no">
    	<cfargument name="userid">
    	<cfscript>
			var loc = {};
			loc.user = model("UserGroupJoin").findAll(where="userid = '#arguments.userid#'", include="User,UserGroup");
			return model("FieldData").getAllFieldsAndUserData(
				modelid 	  = loc.user.usergroupid,
				foreignid	  = loc.user.userid,
				metafieldType = "usergroupfield"
			);
		</cfscript> 
    </cffunction>
    
    <!--- 
		<cfset qUserfieldData = getAllUserFieldData(session.user.id)>
		#getDatafieldVal(identifier="my-hairs-color",qData=qUserfieldData)#
		#getDatafieldVal(identifier="my-hairs-color",userid=session.user.id)#
	--->
    <cffunction name="getDatafieldVal" output="no">
		<cfargument name="identifier">
        <cfargument name="qData" default="">
        <cfargument name="userid" default="">
        
        <cfif isNumeric(arguments.userid)>
			<cfset arguments.qData = getAllUserFieldData(arguments.userid)>        
        </cfif>
        
        <cfif IsQuery(arguments.qData)>
            <cfquery dbtype="query" name="qQuery">
                SELECT * FROM arguments.qData
                WHERE identifier = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.identifier#">
            </cfquery>                
            <cfreturn qQuery.fielddata>
        </cfif>
	</cffunction>  
    <cffunction returntype="String" name="getDataField" output="false">
	    <cfargument name="field">
	    <cfif dataFieldsMap.containsKey(field) AND listLen(dataFieldsMap[field])>
	        <cfreturn replace(dataFieldsMap[field],",",", ","ALL")>
	    <cfelse>
	        <cfreturn "">
	    </cfif>
	</cffunction>
	<cffunction name="dataFieldHtml">
	    <cfargument name="label">
	    <cfargument name="field">
	    <cfargument name="groupLimit">
	    <cfif dataFieldsMap.containsKey(field) AND listLen(dataFieldsMap[field])>
	        <div class="col-md-6 feature-boxes">
	            <h4>#label#</h4>
	            #dataFieldListHtml(field,groupLimit)#
	        </div>
	    </cfif> 
	</cffunction>
	<cffunction name="dataFieldListHtml">
	    <cfargument name="field">
	    <cfargument name="groupLimit" default="2">
	    <cfset var count = 0>
	    <cfset var totalCount = 0>

	    <cfif dataFieldsMap.containsKey(field)>
	        <cfset var list = dataFieldsMap[field]>
	        <cfloop list="#list#" index="item">
	            <cfset count++>
	            <cfset totalCount++>
	            <cfif count eq 1><ul></cfif>
	            <li>#item#</li>
	            <cfif totalCount GTE listLen(list) OR count GTE groupLimit>
	                </ul>
	                <cfset count = 0>
	            </cfif>        
	        </cfloop> 
	    </cfif>
	</cffunction>
	<cffunction name="dataListItemHtml">
	    <cfargument name="field">
	    <cfargument name="label">
	    <cfif len(property[field])><li>#label#: #property[field]#</li></cfif>
	</cffunction>
	<cffunction name="dataFieldListItemHtml">
	    <cfargument name="field">
	    <cfargument name="label">
	    <cfset var fieldData = getDataField(field)>
	    <cfif len(trim(fieldData))><li>#label#: #fieldData#</li></cfif>
	</cffunction>
	<cffunction name="xssCleaner" access="private" returntype="string" output="Yes" hint="Possible Malicious html code from a given string">
		<cfargument name="str"    type="string" required="yes" hint="String">
		<cfargument name="action" type="string" required="no" default="cleanup" hint="If [cleanup], this will clean up the string and output new string, if [find], this will output a value or zero">
		<cfset arguments.str = replaceNoCase(arguments.str, '&lt;', '<')>
		<cfset arguments.str = replaceNoCase(arguments.str, '&gt;', '>')>
		<!--- **************************************************************************** --->
		<!--- Remove string between <script> <object><iframe><style><meta> and <link> tags --->
		<!--- @param str     String to clean up. (Required)                                --->
		<!--- @param action    Replace and Clean up or Find                                --->
		<!--- @author         Saman W Jayasekara (sam @ cflove . org)                     --->
		<!--- @version 1.1    May 22, 2010                                                 --->
		<!--- **************************************************************************** --->
		<cfswitch expression="#arguments.action#">
		<cfcase value="cleanup">
		<cfset local.str = ReReplaceNoCase(arguments.str,"<script.*?</*.script*.>|<applet.*?</*.applet*.>|<embed.*?</*.embed*.>|<ilayer.*?</*.ilayer*.>|<frame.*?</*.frame*.>|<object.*?</*.object*.>|<iframe.*?</*.iframe*.>|<style.*?</*.style*.>|<meta([^>]*[^/])>|<link([^>]*[^/])>|<script([^>]*[^/])>", "", "ALL")>
		<cfset local.str = local.str.ReplaceAll("<\w+[^>]*\son\w+=.*[ /]*>|<script.*/*>|</*.script>|<[^>]*(javascript:)[^>]*>|<[^>]*(onClick:)[^>]*>|<[^>]*(onDblClick:)[^>]*>|<[^>]*(onMouseDown:)[^>]*>|<[^>]*(onMouseOut:)[^>]*>|<[^>]*(onMouseUp:)[^>]*>|<[^>]*(onMouseOver:)[^>]*>|<[^>]*(onBlur:)[^>]*>|<[^>]*(onFocus:)[^>]*>|<[^>]*(onSelect:)[^>]*>","") >
		<cfset local.str = reReplaceNoCase(local.str, "</?(script|applet|embed|ilayer|frame|iframe|frameset|style|link)[^>]*>","","all")>
		</cfcase>
		<cfdefaultcase>
		<cfset local.str = REFindNoCase("<script.*?</script*.>|<applet.*?</applet*.>|<embed.*?</embed*.>|<ilayer.*?</ilayer*.>|<frame.*?</frame*.>|<object.*?</object*.>|<iframe.*?</iframe*.>|<style.*?</style*.>|<meta([^>]*[^/])>|<link([^>]*[^/])>|<\w+[^>]*\son\w+=.*[ /]*>|<[^>]*(javascript:)[^>]*>|<[^>]*(onClick:)[^>]*>|<[^>]*(onDblClick:)[^>]*>|<[^>]*(onMouseDown:)[^>]*>|<[^>]*(onMouseOut:)[^>]*>|<[^>]*(onMouseUp:)[^>]*>|<[^>]*(onMouseOver:)[^>]*>|<[^>]*(onBlur:)[^>]*>|<[^>]*(onFocus:)[^>]*>|<[^>]*(onSelect:)[^>]*>",arguments.str)>
		</cfdefaultcase>
		</cfswitch>
		<cfreturn local.str>
	</cffunction>
	
    <cfscript>
	/**
	* Sorts an array of structures based on a key in the structures.
	* 
	* @param aofS      Array of structures. (Required)
	* @param key      Key to sort by. (Required)
	* @param sortOrder      Order to sort by, asc or desc. (Optional)
	* @param sortType      Text, textnocase, or numeric. (Optional)
	* @param delim      Delimiter used for temporary data storage. Must not exist in data. Defaults to a period. (Optional)
	* @return Returns a sorted array. 
	* @author Nathan Dintenfass (nathan@changemedia.com) 
	* @version 1, April 4, 2013 
	*/
	function arrayOfStructsSort(aOfS,key){
		//by default we'll use an ascending sort
		var sortOrder = "asc";        
		//by default, we'll use a textnocase sort
		var sortType = "textnocase";
		//by default, use ascii character 30 as the delim
		var delim = ".";
		//make an array to hold the sort stuff
		var sortArray = arraynew(1);
		//make an array to return
		var returnArray = arraynew(1);
		//grab the number of elements in the array (used in the loops)
		var count = arrayLen(aOfS);
		//make a variable to use in the loop
		var ii = 1;
		//if there is a 3rd argument, set the sortOrder
		if(arraylen(arguments) GT 2)
			sortOrder = arguments[3];
		//if there is a 4th argument, set the sortType
		if(arraylen(arguments) GT 3)
			sortType = arguments[4];
		//if there is a 5th argument, set the delim
		if(arraylen(arguments) GT 4)
			delim = arguments[5];
		//loop over the array of structs, building the sortArray
		for(ii = 1; ii lte count; ii = ii + 1)
			sortArray[ii] = aOfS[ii][key] & delim & ii;
		//now sort the array
		arraySort(sortArray,sortType,sortOrder);
		//now build the return array
		for(ii = 1; ii lte count; ii = ii + 1)
			returnArray[ii] = aOfS[listLast(sortArray[ii],delim)];
		//return the array
		return returnArray;
	}
	function arrayOfStructsDeduplicate(required aOfS,required fieldName){
		var cleanArray = [];
		for(var arrayItem in aOfS){
	 
			var arrayItemExists = false;

			for(cleanArrayItem in cleanArray){
				if( cleanArrayItem[fieldName] == arrayItem[fieldName] ){
					arrayItemExists = true;
					break;
				}
			}	 

			!arrayItemExists ? arrayAppend(cleanArray,arrayItem) : false;
		}
		return cleanArray;
	}
	function expandThis(required string path) {

		if(application.containsKey("s3")) {
			var s3path = "s3://" & application.s3.accessKeyId & ":" & application.s3.awsSecretKey & "@" & application.s3.host & "/" & application.s3info.defaultBucket & arguments.path;
			return s3path;
		} else {
			return expandPath(arguments.path);
		}		
	}
	function assetUrlPrefix() {
		if(application.containsKey("s3")) {
			return "https://#application.s3info.defaultBucket#.s3.amazonaws.com";
		} else {
			return "";
		}		
	}
	function cacheThis(type,name,data) {
		if(!session.containsKey("cacheThis")) {
			session.cacheThis = {};
		}
		if(arguments.type eq "check") {
			return session.cacheThis.containsKey("name");
		} else if(arguments.type eq "get" AND session.cacheThis.containsKey("name")){
			return session.cacheThis[name];
		} else if(arguments.type eq "add"){
			session.cacheThis[name] = data;
			return true;
		}
	}
	function jsonToQuery(arrayOfObjects) {
		var columns = structKeyList(arrayOfObjects[1]);
		var columnTypes = [];
		for(var column in columns) arrayAppend(columnTypes, "varchar");
		var query = queryNew(columns,arrayToList(columnTypes), []);
		for(var item in arrayOfObjects) {
			var insert = {};
			for(var column in columns) {
				insert[column] = !isNull(item[column]) ? item[column] : "";
			}
			queryAddRow(query, insert);
		}
		return query;
	}
	function makeSubdomainUnique(subdomain) {
		var mySubdomain = rereplacenocase(arguments.subdomain, '[^a-z0-9]', '', 'all');

		var SQL = "SELECT subdomain FROM sites WHERE subdomain = :subdomain";
		var q = new Query(sql=sql,datasource=application.wheels.dataSourceName);
		q.addParam( name="subdomain", cfsqltype="cf_sql_varchar", value=mySubdomain );
		var qSiteCheck = q.execute().getResult();

		if(qSiteCheck.recordcount) {
			return makeSubdomainUnique(mySubdomain & RandRange(1, 999, "SHA1PRNG"));
		} else {
			return mySubdomain;
		}
	}
	</cfscript> 
</cfoutput>