<cfoutput>

	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> #qform.name# Submission')>
	<cfset contentFor(headerButtons = 
		'<li class="headertab">
			#linkTo(
				text		= "<span class=""elusive icon-arrow-left""></span> Go Back",
				route		= "admin~id",
				controller	= "forms",
				action		= "formsubmissions",
				id			= qform.id,
				class		= "btn btn-default" 
			)#
		</li>')>
	<strong>Time of Submission:</strong> #DateFormat(formsubmission.createdAt,"MMMM D, YYYY")# at #TimeFormat(formsubmission.createdAt, "short")#<br>
<br>
	
	<!--- Get Custom Fields --->
	#includePartial(partial="/_partials/presentFieldData")#
	<br class="clear">
	
</cfoutput>