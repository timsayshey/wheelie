<cfoutput>

	<script src="/views/layouts/admin/assets/js/page.js" type="text/javascript"></script>
	
	<cfset contentFor(plupload		= true)>
	<cfset contentFor(formy			= true)>
	
	<cfif isNull(params.id)>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Add Section')>
	<cfelse>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Edit Section')>
	</cfif>
	
	<cfset contentFor(headerButtons = 
		'<li class="headertab">
			#linkTo(
				text		= "<span class=""elusive icon-arrow-left""></span> Go Back",
				route		= "admin~Id", 
				module		= "admin",
				controller	= "newsletterSections", 
				action		= "index", 
				id			= params.newsletterid,
				class		= "btn btn-default"
			)#	
		</li>')>
	
	<cfif !isNull(params.id)>
		<cfset isNew = false>
		<cfset currentStatus = newsletterSection.status>
	<cfelse>
		<cfset isNew = true>
		<cfset currentStatus = "draft">
	</cfif>
	
	#hiddenfieldtag(name="newsletterSection[newsletterid]",value="#params.newsletterid#")#
	
	<cfif !isNew>
		#hiddenfield(objectName='newsletterSection', property='id')#
		#hiddenFieldTag("id",params.id)#
	</cfif>			
													
	<!--- Title --->	
	#btextfield(
		objectName	= 'newsletterSection', 
		property	= 'title', 
		label		= 'Headline',
		placeholder	= "Ex: We Are Growing!"
	)#
								
	<!--- Description --->
	#btextarea(
		objectName 		= 'newsletterSection', 
		property 		= 'content', 	
		class			= "ckeditor",
		label 		 	= "Content"
	)#	
	
	<cfsavecontent variable="rightColumn">
		<div class="rightbarinner">			
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="newsletterSections", currentStatus=currentStatus)#					
		</div>
		</div>
	</cfsavecontent>
	<cfset contentFor(rightColumn = rightColumn)>
	<cfset contentFor(formWrapStart = startFormTag(route="admin~Action", module="admin", controller="newsletterSections", action="save", params="newsletterid=#params.newsletterid#"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>	
	
</cfoutput>