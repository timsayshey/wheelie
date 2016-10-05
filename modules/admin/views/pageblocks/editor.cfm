<cfoutput>

	<cfset contentFor(plupload		= true)>
	<cfset contentFor(formy			= true)>
	
	<cfif isNull(params.id)>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-file-new"></span> Add PageBlock')>
	<cfelse>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-file-new"></span> Edit PageBlock')>
	</cfif>
	
	<cfif !isNull(params.id)>
		<cfset isNew = false>
		<cfset currentStatus = pageblock.status>
	<cfelse>
		<cfset isNew = true>
		<cfset currentStatus = "draft">
	</cfif>
	
	<cfif !isNew>
		#hiddenfield(objectName='pageblock', property='id', id="pageblockid")#
		#hiddenFieldTag("id",params.id)#
	</cfif>			
													
	<!--- Title --->	
	#btextfield(
		objectName	= 'pageblock', 
		property	= 'name', 
		label		= 'Title',
		placeholder	= "Ex: Coolest PageBlock Ever",
		help		= 'Message inbox test'
	)#
								
	<!--- Description --->
	#btextarea(
		objectName 		= 'pageblock', 
		property 		= 'content', 	
		class			= "ckeditor",
		label 		 	= "Content",
		help 			= "Shows on the pageblock"
	)#	
	<br class="clear" />

	</div>
	
	#includePartial(partial="/_partials/editorSubmitBox", controllerName="pageblocks", currentStatus=currentStatus, rightBottomClass="col-sm-12")#	
	

	<cfset contentFor(formWrapStart = startFormTag(route="admin~Action", module="admin", controller="pageblocks", action="save", enctype="multipart/form-data", id = "fileupload"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>	
	
</cfoutput>