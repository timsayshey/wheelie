<cftry>

<cfoutput>
	
	<cfscript>
		// Get rearrange button and script if necessary
		initializeRearrange = includePartial(partial="/_partials/sortableScript", urlcontroller="videos", reEndRow=qVideos.recordcount);
		
		contentFor(formy = true);
		contentFor(headerTitle	= '<span class="elusive icon-video"></span> Videos');		
		contentFor(headerButtons = 
			"<li class='headertab'>
				#initializeRearrange#
				#linkTo(
					text		= '<span class=''elusive icon-plus''></span> Add Video',
					route		= 'admin~action',
					controller	= 'videos',
					action		= 'new', 
					class		= 'btn btn-default'
				)#		
			</li>"
		);
	</cfscript>
	
	<div class="row-regular">
	
		#startFormTag(route="moduleAction", module="admin", controller="videos", action="deleteSelection", enctype="multipart/form-data")#	
			
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
			
			<div id="video" class="sortable col-md-12">
			
				<cfif !isNull(Video) and isObject(Video)>
					#errorMessagesFor("Video")#
					<br /><br />
				</cfif>
				
				<cfloop query="qVideos" startrow="#request.reStartRow#" endrow="#request.reEndRow#">		
					
					<cfsavecontent variable="tags">
					
					</cfsavecontent>
					
					#includePartial(
						partial="/_partials/indexListItem", 
						currentid		= qVideos.id, 
						tags			= tags,
						gridActive		= gridActive,
						thumbPath		= "#info.videoThumbPath##qVideos.id#.jpg",
						title			= qVideos.name,
						description		= qVideos.description,
						controllerName	= "videos",
						overlayImage	= "/assets/img/videooverlay.png",
						href			= "href='#urlFor(
							route		= "admin~Id",
							module		= "admin",
							controller	= "videos",
							action		= "edit",
							id			= qVideos.id
						)#'"	
					)#
					
				</cfloop>
				
			</div>
		
		#endFormTag()#	
		
		<br class="clear" />
		
		<cfif isNull(params.rearrange)>
			#includePartial(
				partial="/_partials/indexPager", 
				currentController	= "videos"
			)#	
		</cfif>				
		
	</div>	
	
	<cfif isNull(params.rearrange)>
		
		<cfsavecontent variable="refiner">
		
			<div class="row">
				<article class="col-sm-12">
				
					<div class="data-block filter-bar">
						<section>
						
							<a href="##" class="toggle">Filter results &raquo;</a>
							<div class="togglediv" <cfif len(rememberParams)>id="show"</cfif>>
								#startFormTag(route="moduleAction", module="admin", controller="videos", action="index", enctype="multipart/form-data", class="form-inline")#	
									<div class="row-regular">
																		
										<div class="col-md-2 col-sm-2">
											#bselecttag(
												name	 = 'sort',
												label	 = 'Sort by',
												options	 = [
													{text = "Default", value = "sortorder"},
													{text = "Name", value = "name"},
													{text = "Created", value = "id"}
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
										<!--- <div class="col-md-2 col-sm-2">
											#bselecttag(
												name	 = 'hosted',
												label	 = 'Hosted on',
												options	 = [
													{text = "", value = ""},
													{text = "Youtube", value = "youtube"},
													{text = "#capitalize(siteUrl)#", value = "local"}
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
										</div> --->
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
	</cfif>	
	
</cfoutput>
		
<cfcatch>
	<cfdump var="#cfcatch#">
</cfcatch>
</cftry>