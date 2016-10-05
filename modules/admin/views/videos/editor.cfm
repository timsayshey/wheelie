<cfoutput>
	<script src="/views/layouts/admin/assets/js/newvideo.js" type="text/javascript"></script>
	<script src="/views/layouts/admin/assets/js/category.js" type="text/javascript"></script>
	
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
	<cfelse>
		<cfset isNew = true>
	</cfif>
	
	<div class="col-sm-12">	
		
		<cfif !isNew>
			#hiddenfield(objectName='video', property='id', id="videoid")#
			#hiddenFieldTag("id",params.id)#
		</cfif>
		
		<!--- Youtube id --->
		<div class="videoExists well">
			<label>Current Video and Thumbnail</label>
			<br class="clear">
			<div class="col-md-5">
				<cfif len(video.youtubeid)>
					<cfset videoUrl = "https://www.youtube.com/embed/#video.youtubeid#?rel=0&showinfo=0&fs=1&hl=en_US&wmode=opaque">
				<cfelseif len(video.vimeoid)>
					<cfset videoUrl = "https://player.vimeo.com/video/#video.vimeoid#">
				<cfelse>
					<cfset videoUrl = "">
				</cfif>
				<iframe src="#videoUrl#" width="100%" height="390" style="max-width:200px;max-height:150px;" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
				
			</div>
			<!--- <cfif FileExists("#info.fileVideoThumbs##video.id#.jpg")>
				<div class="col-md-4">
					<img src="#info.videoThumbPath##video.id#.jpg" width="100" style="float:left">
				</div>
			</cfif>	 --->	
			<br class="clear">
			
			<a href="##" class="replaceVideo btn btn-default">Change Video</a>
		</div>
		
		<div class="videoNotExists well">
			#btextfieldtag(
				name='videoUrl', 
				value='', 
				class="videoUrl form-control",
				label='Vimeo or Youtube Video URL',
				placeholder	 = "Paste video video or playlist link here",
				help='Enter the url of the video'
			)#
			#hiddenfield(
				objectName	= 'video', 
				property	= 'youtubeid',
				id			= "youtubeIDInput",
				class		= "youtubeid"
			)#	
			#hiddenfield(
				objectName	= 'video', 
				property	= 'vimeoid',
				id			= "vimeoIDInput",
				class		= "vimeoid"
			)#				
			#hiddenfieldtag(
				name		= 'video[isPlaylist]',
				id			= "isPlaylist",
				value		= "0"
			)#	
			<div class="form-group">
				<div class="yt_thumb_chooser"></div>
			</div>
			<cfif len(video.youtubeid)>
				<a href="##" class="replaceVideoCancel btn btn-default">Cancel</a>
			</cfif>
		</div>	
		
		<!--- <div class="videoFile well">
			Upload file to /assets/private/videos/ then select from the list below:<br>
			<cfdirectory action="list" filter="*.flv" directory="#expandPath('/assets/private/videos/')#" name="userpics">
			#bselecttag(
				name	= 'sort',
				options	= [
					{text="6 Per Page",value="6"},
					{text="10 Per Page",value="10"},
					{text="50 Per Page",value="50"},
					{text="100 Per Page",value="100"},
					{text="Show All",value="9999999"}
				],
				selected= session.perPage,
				class	= "selectize perPage",
				append	= ""
			)#
		</div> --->
					
		<!--- Title --->	
		#btextfield(
			objectName	= 'video', 
			property	= 'name', 
			label		= 'Title',
			placeholder	= "Ex: Coolest Video Ever"
		)#
		
		<!--- Video URL --->	
		#btextfield(
			prependedText	= '#siteUrl#/video/',
			label			= "Video URL",
			objectName		= 'video', 
			property		= 'urlid', 												
			placeholder	 	= "Coolest-Video-Ever",
			help 			= "This is name of the video's url address (Can't be changed in the future)",
			disabled 		= !isNew
		)#
		
		#btextfield(
			objectName	= 'video', 
			property	= 'password', 
			label		= 'Password',
			help 		= "Leave blank for no password",
			placeholder	= "Ex: Pass123"
		)#	
	
	</div>
	
	<!--- Show on Website? --->								
	<div class="col-sm-6 ">	
	#bcheckbox(
		objectName	= 'video', 
		property	= "onSite",
		help		= "If checked, this video will show on the website",
		label		= "Show on Website?"
	)#
	</div>
	
	<!--- Is featured? --->								
	<div class="col-sm-6 ">	
	#bcheckbox(
		objectName	= 'video', 
		property	= "isFeatured",
		help		= "If checked, this video will show up in the featured section",
		label		= "Featured?"
	)#	
	</div>
	
	#includePartial(partial="/_partials/formSeperator")#	
	
	#btextarea(
		objectName 		='video', 
		property 		='teaser', 	
		label 		 	= "Teaser",
		help 			= "Shows on the video page"
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
					
					<a href="##" id="addnewcategory">+ Add New Category</a>
					
					#includePartial(partial="/_partials/categoryFormModal", modelName="videocategory")#	
					
				</section>
			</div>			
		</div>
		
		<div class="data-block">
			<section>
				<cfparam name="video.videothumb" default="">
				#bImageUploadTag(
					name			= "videothumb",
					value			= "",
					filepath		= "#info.uploadsPath#videos/thumbs/#video.id#.jpg",
					label			= "Thumbnail"
				)#<br>
				#bcheckbox(
					objectName	= 'video', 
					property	= "customThumb",
					help		= "This will overwrite your current thumbnail",
					label		= "Disable Youtube Thumb Fetcher"
				)#
			</section>
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





