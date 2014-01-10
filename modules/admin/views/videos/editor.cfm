<cfoutput>
	<cfset javaScriptIncludeTag(sources="
		js/admin/video.js,
		js/admin/category.js,
		vendor/jwplayer/jwplayer.js", 
	head=true)>
	
	<!--- For category.js --->
	#hiddenfieldtag(name="categoryController", id="categoryController", value="videoCategories")#	
	#hiddenfieldtag(name="categoryModel", id="categoryModel", value="videoCategory")#	
	#hiddenFieldTag(name="addCategoryType", id="addCategoryType", value="dropdown")#
	
	<cfset contentFor(plupload		= true)>
	<cfset contentFor(formy			= true)>
	
	<cfif isNull(params.id)>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-video"></span> Add Video')>
	<cfelse>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-video"></span> Edit Video')>
	</cfif>
	
	<cfif !isNull(params.id)>
		<cfset isNew = false>
		<cfset currentStatus = video.status>
	<cfelse>
		<cfset isNew = true>
		<cfset currentStatus = "draft">
	</cfif>
	
	<cfif !isNew>
		#hiddenfield(objectName='video', property='id', id="videoid")#
		#hiddenFieldTag("id",params.id)#
	</cfif>
					
	<!--- Title --->	
	#btextfield(
		objectName	= 'video', 
		property	= 'name', 
		label		= 'Title',
		placeholder	= "Ex: Coolest Video Ever",
		help		= 'Message inbox test'
	)#
	
	<!--- Video URL --->	
	#btextfield(
		prependedText	= '#cgi.server_name#/video/',
		label			= "Video URL",
		objectName		= 'video', 
		property		= 'urlid', 												
		placeholder	 	= "Coolest-Video-Ever",
		help 			= "This is name of the video's url address (Can't be changed in the future)",
		disabled 		= !isNew
	)#										
	
	<!--- Hide for now, use for multisites later --->
	<span style="display:none;">												
		#bselect(
			objectName 		= 'video', 
			property 		= 'siteid', 
			label 			= 'Site',
			class			= "selectize",
			isSelectize		= true,
			help			= "This determines which site that this video will show on",				
			options			= sites,
			valueField 		= "id", 
			textField 		= "name"
		)#
	</span>
	
	<!--- Is featured? --->								
	#bcheckbox(
		objectName	= 'video', 
		property	= "isFeatured",
		help		= "If featured, this video will show up on the homepage in the video spotlight",
		label		= "Featured?"
	)#
	
	#includePartial(partial="/_partials/formSeperator")#	
	
	<!--- Teaser --->
	#btextarea(
		objectName='video', 
		property='teaser', 	
		label 		 	= "Teaser",
		help     		= "Shows next to the video title and thumbnail on the video category page"
	)#
	
	<!--- Description --->
	#btextarea(
		objectName 		='video', 
		property 		='description', 	
		class			= "ckeditor",
		label 		 	= "Description",
		help 			= "Shows on the video page"
	)#	
							
	
	<!--- Right area --->
	<cfsavecontent variable="submitBox">
		<div class="{{class-here}} data-block">
			<section>
				<div class="btn-group dropdown">
					<button type="submit" name="submit" value="save-continue" class="btn btn-primary">Save & continue</button>
					<button class="btn btn-primary dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button> 
					<ul class="dropdown-menu dropdown-blue pull-right">
						<li><button type="submit" name="submit" value="save" class="btn-linky">Save & exit</button></li>					
						<cfif !isNew><li><a href='#urlFor(route="moduleId", module="admin", controller="videos", action="delete", id=params.id)#' class="btn-danger">Trash it</a></li></cfif>
						<li><a href='#urlFor(route="moduleAction", module="admin", controller="videos", action="index")#'>Back to users</a></li>
					</ul>
				</div>
			</section>
		</div>
	</cfsavecontent>
	
	<cfsavecontent variable="rightColumn">
		<div class="rightbarinner">
		
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="videos")#	
			
			<!--- Video Upload Section --->	
				
			<div class="data-block">
				<section>	
					#bselect(
						objectName 		= "video",
						property 		= "videofileid",
						label			= 'Select Video',
						help			= 'Select video that you want here',
						id				= "videoSelector",
						options			= videofiles,
						valueField 		= "id", 
						textField 		= "filename"
					)#
					
					<a href="javascript:void(0)" class="delete-video confirmDelete pull-right"><span class="elusive icon-trash"></span> Delete Selected</a>
					<a href="javascript:void(0)" class="upload-video" data-toggle="modal" data-target="##uploadVideo"><span class="elusive icon-plus"></span> Add New Video</a>
					<a href="javascript:void(0)" class="preview-video pull-right"><span class="elusive icon-youtube"></span> Preview Selected</a>
					<br class="clear" />
					#includePartial(partial="/_partials/videoSelectizer")#	
												
					#includePartial(partial="/_partials/videoModals",type="gallery")#	
					<input type="hidden" id="oauthWindowType" value="popup"> <!--- full or popup --->
				</section>
			</div>	
			
			<div class="data-block">
				<section>
					#bselecttag(
						name			= "videocategories",
						class			= "videocatselectize",
						multiple		= "true",
						selected		= selectedvideocategories,
						label			= 'Select Categories',
						help			= 'Select categories that you want this video to show up in',
						options			= videocategories,
						valueField 		= "id", 
						textField 		= "name"
					)#
					
					<script type="text/javascript">
						$(function() {
							window.$catselectize = $('.videocatselectize').selectize({
								maxItems: null
							});
						});
					</script>
					
					<a href="javascript:void(0)" id="addnewcategory">+ Add New Category</a>
					
					#includePartial(partial="/_partials/categoryFormModal", modelName="videocategory")#	
					
				</section>
			</div>			
		</div>
		
		</div>
		<div class="rightBottomBox  hidden-xs hidden-sm">
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="videos", rightBottomClass="col-sm-3")#	
		</div>
		
	</cfsavecontent>
	
	<cfset contentFor(rightColumn = rightColumn)>		
	<cfset contentFor(formWrapStart = startFormTag(route="moduleAction", module="admin", controller="videos", action="save", enctype="multipart/form-data", id = "fileupload"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>		
			
	<script type="text/html" id="tmpl_menuListItem">
		<li id="menu-<%=id%>" data-id="<%=id%>" class="sortable">						
			<div class="ns-row">
				<div class="ns-title"><%=name%></div>
				<div class="ns-actions">
					<a href="##" class="edit-menu" title="Edit"><span class="elusive icon-pencil"></span></a>
					<a href="##" class="delete-menu" title="Delete"><span class="elusive icon-trash"></span></a>							
				</div>
			</div>		
			<div class="ns-form">
				Name: <input type="text" name="itemname" value="<%=name%>" />
				URL: <input type="text" name="urlpath" value="<%=id%>" />
				<input type="hidden" class="parentid" name="parentid" value="<%=parentid%>" />
				<input type="hidden" class="sortOrder" name="sortOrder" value="<%=sortOrder%>" />
			</div>
		</li>
	</script>
	
</cfoutput>





