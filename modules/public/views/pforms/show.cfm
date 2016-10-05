<cfoutput>
	
	<cfset request.page.hideSidebar = true>
	<cfset request.page.noBgImage = true>
	<cfset request.page.hideFooterCallToAction = true>	
	<cfset contentFor(siteTitle = "#qform.name#")>
	
	<!--- Get Custom Fields --->
	#generateForm(formid=params.id)#
	<br class="clear"><br>
	
</cfoutput>