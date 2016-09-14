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
	<cffunction name="deleteThisFile">
		<cfargument name="filepath">
		<cfscript>
			var loc = {};
			loc.thisfile = expandPath(arguments.filepath);
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
	<cffunction name="generateForm">
		<cfargument name="formid" default="">
		<cfargument name="formwrap" default="true">
		<cfargument name="formclass" default="">

		<cfset metaform = model("Form").findAll(where="id = '#arguments.formid#'")>
		<cfset dataFields = model("FormField").findAll(where="metafieldType = 'formfield' AND modelid = '#arguments.formid#'",order="sortorder ASC")>

		<cfif metaform.templated>
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
	
	<cffunction name="siteIdEqualsCheck">
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
	
	<cffunction name="getThemeTemplate">
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
    
    <cffunction name="getAllUserFieldData">
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
    <cffunction name="getDatafieldVal">
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
		for(arrayItem in aOfS){
	 
			arrayItemExists = false;

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
	</cfscript> 
	
</cfoutput>