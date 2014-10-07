<cfoutput>
	
	<cfset request.page.hideSidebar = true>
	<cfset request.page.noBgImage = true>
	<cfset request.page.hideFooterCallToAction = true>	
	<cfset contentFor(siteTitle = "#qform.name#")>
	
	<!--- Get Custom Fields --->
	<form action='#trim(getHttpsDomain())##urlFor(route="admin~Action", controller="forms", action="formsubmissionSave")#' enctype="multipart/form-data" method="post">
	
		#hiddenfield(objectName='qform', property='id')#
		#includePartial(partial="/_partials/formFieldsRender")#
		#submitTag(value="Submit",class="btn btn-lg btn-warning")#
		
	</form>
	<br class="clear">
	
</cfoutput>