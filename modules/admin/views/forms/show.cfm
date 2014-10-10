<cfoutput>

	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> #qform.name#')>
	
	<!--- Get Custom Fields --->
	#startFormTag(route="admin~Action", controller="forms", action="formsubmissionSave", enctype="multipart/form-data", params="adminLayout=1")#
	
		#hiddenfield(objectName='qform', property='id')#
		#includePartial(partial="/_partials/formFieldsRender")#
		#submitTag(value="Submit",class="btn btn-lg btn-primary")#
		
	#endFormTag()#
	<br class="clear">
	
</cfoutput>