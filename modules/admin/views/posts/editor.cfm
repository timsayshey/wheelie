<cfoutput>

	<script src="/views/layouts/admin/assets/js/page.js" type="text/javascript"></script>
	
	<cfset contentFor(plupload		= true)>
	<cfset contentFor(formy			= true)>
	
	<cfif isNull(params.id)>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Add Post')>
	<cfelse>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Edit Post')>
	</cfif>
	
	<cfif !isNull(params.id)>
		<cfset isNew = false>
		<cfset currentStatus = post.status>
	<cfelse>
		<cfset isNew = true>
		<cfset currentStatus = "draft">
	</cfif>
	
	<cfif !isNew>
		#hiddenfield(objectName='post', property='id', id="postid")#
		#hiddenFieldTag("id",params.id)#
	</cfif>			
													
	<!--- Title --->	
	#btextfield(
		objectName	= 'post', 
		property	= 'name', 
		label		= 'Title',
		placeholder	= "Ex: Coolest Post Ever",
		help		= 'Message inbox test'
	)#
	
	<!--- Post URL --->	
	#btextfield(
		prependedText	= '#cgi.http_host#/post/',
		label			= "Post URL",
		objectName		= 'post', 
		property		= 'urlid', 												
		placeholder	 	= "Coolest-Post-Ever",
		help 			= "This is name of the post's url address (Can't be changed in the future)"
	)#	
								
	<!--- Description --->
	#btextarea(
		objectName 		= 'post', 
		property 		= 'content', 	
		class			= "ckeditor",
		label 		 	= "Content",
		help 			= "Shows on the post"
	)#	
	
	<cfif !isNew>
		<!--- Set Author --->
		<cfset users = model("User").findAll(order="email ASC")>
		#bselecttag(
			name			= "post[createdBy]",
			selected		= post.createdBy,
			label			= 'Author',
			options			= users,
			valueField 		= "id", 
			textField 		= "email"
		)#
	</cfif>
	
	#includePartial(partial="/_partials/formSeperator")#	
	
	<!--- Generate SEO Automatically --->
	<cfif isNew>
		<cfset post.metagenerated = 1>
	</cfif>
								
	#bcheckbox(
		objectName	= 'post', 
		property	= 'metagenerated', 
		label		= 'Auto generate meta',
		help		= 'Automatically generate meta tags for seo. Better meta means better search engine ranks.',
		id			= 'metagenerated'
	)#	
	
	<div id="metaOptions">		
						
		#bLabel(label="Homepost options",help="Set various aspects of homepost here")#
		<br class="clear" />
		
		#btextfield(
			label			= 'Title',
			objectName		= 'post', 
			property		= 'metatitle',
			placeholder		= 'Meta title'
		)#	
		#btextfield(
			label			= 'Description',
			objectName		= 'post', 
			property		= 'metadescription',
			placeholder		= 'Meta description'
		)#	
		#btextfield(
			label			= 'Keywords',
			objectName		= 'post', 
			property		= 'metakeywords',
			placeholder		= 'Meta keywords'
		)#	
		<br />
	</div>
	
	<br class="clear" />
	
	<cfsavecontent variable="rightColumn">
		<div class="rightbarinner">			
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="posts", currentStatus=currentStatus)#					
		</div>
		</div>
		<div class="rightBottomBox  hidden-xs hidden-sm">
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="posts", currentStatus=currentStatus, rightBottomClass="col-sm-3")#	
		</div>
	</cfsavecontent>
	<cfset contentFor(rightColumn = rightColumn)>
	<cfset contentFor(formWrapStart = startFormTag(route="admin~Action", module="admin", controller="posts", action="save", enctype="multipart/form-data", id = "fileupload"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>	
	
</cfoutput>