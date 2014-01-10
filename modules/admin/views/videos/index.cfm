<cfset javaScriptIncludeTag(sources="js/admin/video.js,vendor/jwplayer/jwplayer.js", head=true)>

<cfset contentFor(formy			= true)>
<cfset contentFor(headerTitle	= '<span class="elusive icon-video"></span> Videos')>
<cfset contentFor(headerButtons = 
			'<li class="headertab">
				#linkTo(
					text		= '<span class="elusive icon-plus"></span> Add Video',
					route		= "moduleAction",
					module	= "admin",
					controller	= "videos",
					action		= "new", 
					class		= "btn btn-default"
				)#		
			</li>')> 

<cfoutput>
	
	<div class="row-regular">
	
		#startFormTag(route="moduleAction", module="admin", controller="videos", action="deleteSelection", enctype="multipart/form-data")#	
		
			#includePartial(
				partial="/_partials/statusTabs", 
				controllerName	= "videos"
			)#
			
			<div class="col-md-10">
				<input type="checkbox" class="checkall" />				
				<button class="btn btn-primary btn-sm deleteselection confirmDelete" type="submit" value="deleteselection">Delete selection</button>
			</div>
			
			<cfif session.display eq "grid">
				<cfset gridActive = "active">
				<cfset listActive = "">
			<cfelse>
				<cfset gridActive = "">
				<cfset listActive = "active">
			</cfif>
			
			<div class="btn-group pull-right">
				<a href='#urlFor(route="moduleAction", module="admin", controller="videos", action="index")#?display=grid' class="btn btn-default #gridActive#"><span class="elusive icon-th-large"></span></a>
				<a href='#urlFor(route="moduleAction", module="admin", controller="videos", action="index")#?display=list' class="btn btn-default #listActive#"><span class="elusive icon-th-list"></span></a>
			</div>
			
			<br class="clear" /><br />
			
			<div id="video" class="col-md-12">
			
				<cfif !isNull(Video) and isObject(Video)>
					#errorMessagesFor("Video")#
					<br /><br />
				</cfif>
				
				<cfloop query="qVideos" startrow="#pagination.getStartRow()#" maxrows="#pagination.getMaxRows()#">		
					
					#includePartial(
						partial="/_partials/videoListing", 
						videoid			= qVideos.id, 
						videofilename	= qVideos.filename, 
						vidoefilepath	= qVideos.filepath, 
						youtubeid		= qVideos.youtubeid, 
						bytesize		= qVideos.bytesize
					)#
					
					<cfsavecontent variable="tags">
						<cfif status eq "youtubePending">
							<span class="elusive icon-upload color-danger" title="Uploading to Youtube"></span>
						<cfelseif status eq "youtubeFailed">
							<span class="elusive icon-error color-danger" title="Youtube Upload Failed"></span>
						<cfelseif isYoutube>									
							<span class="elusive icon-youtube color-danger" title="Hosted on Youtube"></span>
						</cfif>
						
						<cfif fileExists(fullFilePath)>
							<span class="elusive icon-hdd color-primary" title="Hosted on #cgi.SERVER_NAME#"></span>
						</cfif>
					</cfsavecontent>
					
					#includePartial(
						partial="/_partials/indexListItem", 
						currentid		= qVideos.id, 
						tags			= tags,
						gridActive		= gridActive,
						thumbPath		= thumbPath,
						title			= qVideos.name,
						description		= qVideos.description,
						controllerName	= "videos",
						overlayImage	= "/assets/images/videooverlay.png",
						href			= 'href="javascript:void(0)" data-toggle="modal" data-target="##details_#qVideos.id#"'
					)#
					
				</cfloop>
				
			</div>
		
		#endFormTag()#	
		
		<br class="clear" />
		
		#includePartial(
			partial="/_partials/indexPager", 
			currentController	= "videos"
		)#					
		
	</div>	
	
	<cfsavecontent variable="refiner">
	
		<div class="row">
			<article class="col-sm-12">
			
				<div class="data-block filter-bar">
					<section>
					
						<a href="javascript:void(0)" class="toggle">Filter results &raquo;</a>
						<div class="togglediv" <cfif len(rememberParams)>id="show"</cfif>>
							#startFormTag(route="moduleAction", module="admin", controller="videos", action="index", enctype="multipart/form-data", class="form-inline")#	
								<div class="row-regular">
																	
									<div class="col-md-2 col-sm-2">
										#bselecttag(
											name	 = 'sort',
											label	 = 'Sort by',
											options	 = [
												{text = "Name", value = "name"},
												{text = "Created", value = "createdat"},
												{text = "Last updated", value = "updatedat"}
											],
											selected = session.videos.sortby,
											class	 = "selectize",
											append	 = ""
										)#
									</div>
									<div class="col-md-2 col-sm-2">									
										#bselecttag(
											name	 = 'order',
											label	 = 'Order',
											options	 = [
												{text = "Ascending", value = "ASC"},
												{text = "Descending", value = "DESC"}
											],
											selected = session.videos.order,
											class	 = "selectize",
											append	 = ""
										)#
									</div>									
									<div class="col-md-2 col-sm-2">
										#bselecttag(
											name	 = 'hosted',
											label	 = 'Hosted on',
											options	 = [
												{text = "", value = ""},
												{text = "Youtube", value = "youtube"},
												{text = "#capitalize(cgi.SERVER_NAME)#", value = "local"}
											],
											selected = params.hosted,
											class	 = "selectize",
											append	 = ""
										)#
									</div>
									<div class="col-md-2 col-sm-2">
										#bselecttag(
											name			= "filtercategories",
											class			= "multiselectize",
											multiple		= "true",
											selected		= params.filtercategories,
											label			= "Categories",
											options			= videocategories,
											valueField 		= "id", 
											textField 		= "name"
										)#
									</div>
									<div class="col-md-2 col-sm-2">									
										#btextfieldtag(
											name			= 'search', 
											label			= 'Search',
											placeholder		= "Ex: green burrito",
											value			= params.search
										)#
									</div>
									<div class="col-md-1 col-sm-1">									
										<button class="btn btn-default btn-sm pull-right apply-btn" type="submit" title="Apply filter" name="filtertype" value="apply">
											<span class="elusive icon-ok"></span> Apply
										</button>
									</div>
									<div class="col-md-1 col-sm-1">		
										<button class="btn btn-default btn-sm pull-right apply-btn" type="submit" title="Clear filter" name="filtertype" value="clear">
											<span class="elusive icon-trash"></span> Clear
										</button>
									</div>
								</div>
								
							#endFormTag()#	
						</div>
					</section>
				</div>
			</article>
		</div>
	
	</cfsavecontent>
	
	<cfset contentFor(extraSection=refiner)>

</cfoutput>
		
