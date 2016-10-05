<cfoutput>

	<script src="/views/layouts/admin/assets/js/page.js" type="text/javascript"></script>
	
	<cfset contentFor(plupload		= true)>
	<cfset contentFor(formy			= true)>
	
	<cfif isNull(params.id)>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Add Newsletter')>
	<cfelse>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Edit Newsletter')>
	</cfif>
	
	<cfset contentFor(headerButtons = 
		'<li class="headertab">
			#linkTo(
				text		= "<span class=""elusive icon-arrow-left""></span> Go Back",
				route		= "admin~Action", 
				module		= "admin",
				controller	= "newsletters", 
				action		= "index", 
				class		= "btn btn-default"
			)#	
		</li>')>
	
	<cfif !isNull(params.id)>
		<cfset isNew = false>
		<cfset currentStatus = newsletter.status>
	<cfelse>
		<cfset isNew = true>
		<cfset currentStatus = "draft">
	</cfif>
	
	<cfif !isNew>
		#hiddenfield(objectName='newsletter', property='id', id="newsletterid")#
		#hiddenFieldTag("id",params.id)#
	</cfif>			
													
	<!--- Title --->	
	#btextfield(
		objectName	= 'newsletter', 
		property	= 'subject', 
		label		= 'Email Subject',
		placeholder	= "Ex: Coolest Newsletter Ever"
	)#
								
	<!--- Description
	#btextarea(
		objectName 		= 'newsletter', 
		property 		= 'content', 	
		class			= "ckeditor",
		label 		 	= "Content",
		help 			= "Shows on the newsletter"
	)#	 --->
	
	<cfsavecontent variable="rightColumn">
		<div class="rightbarinner">			
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="newsletters", currentStatus=currentStatus)#					
		</div>
		</div>
	</cfsavecontent>
	<cfset contentFor(rightColumn = rightColumn)>
	<cfset contentFor(formWrapStart = startFormTag(route="admin~Action", module="admin", controller="newsletters", action="save"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>	
	
</cfoutput>