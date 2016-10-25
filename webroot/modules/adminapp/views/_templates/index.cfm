<cfoutput>
	
	<cfscript>
		// Get rearrange button and script if necessary
		initializeRearrange = includePartial(partial="/_partials/sortableScript", urlcontroller="@lcasePlural@", reEndRow=q@ucasePlural@.recordcount);
		
		contentFor(formy = true);
		contentFor(headerTitle	= '<span class="elusive icon-@lcaseSingular@"></span> @ucasePlural@');		
		contentFor(headerButtons = 
			"<li class='headertab'>
				#initializeRearrange#
				#linkTo(
					text		= '<span class=''elusive icon-plus''></span> Add @ucaseSingular@',
					route		= 'admin~action',
					controller	= '@lcasePlural@',
					action		= 'new', 
					class		= 'btn btn-default'
				)#
				#linkTo(
					text		= '<span class=''elusive icon-plus''></span> Edit Fields',
					href		= '/m/admin/fields/index/@lcaseSingular@field?modelid=3',
					class		= 'btn btn-default'
				)#	
			</li>"
		);
	</cfscript>
	
	<div class="row-regular">
	
		#startFormTag(route="moduleAction", module="admin", controller="@lcasePlural@", action="deleteSelection", enctype="multipart/form-data")#	
			
			<cfif checkPermission("@lcaseSingular@_delete_others")>
                <div class="col-md-10">
                    <input type="checkbox" class="checkall" />				
                    <button class="btn btn-primary btn-sm deleteselection confirmDelete" type="submit" value="deleteselection">Delete selection</button>
                </div>
			</cfif>
            
			<cfif session.display eq "grid">
				<cfset gridActive = "active">
				<cfset listActive = "">
			<cfelse>
				<cfset gridActive = "">
				<cfset listActive = "active">
			</cfif>
			
			<div class="btn-group pull-right">
				<a href='#urlFor(route="moduleAction", module="admin", controller="@lcasePlural@", action="index")#?display=grid' class="btn btn-default #gridActive#"><span class="elusive icon-th-large"></span></a>
				<a href='#urlFor(route="moduleAction", module="admin", controller="@lcasePlural@", action="index")#?display=list' class="btn btn-default #listActive#"><span class="elusive icon-th-list"></span></a>
			</div>
			
			<br class="clear" /><br />
			
			<div id="@lcaseSingular@" class="sortable col-md-12">
			
				<cfif !isDefined("@ucaseSingular@") and isObject(variables.@ucaseSingular@)>
					#errorMessagesFor("@ucaseSingular@")#
					<br /><br />
				</cfif>
				<cfif !q@ucasePlural@.recordcount>
					<div class="well text-center">
						<h3>Whoops! You haven't added any @ucasePlural@ yet.</h3>
						#linkTo(
							text		= 'Click here to get started',
							route		= 'admin~action',
							controller	= '@lcasePlural@',
							action		= 'new', 
							class		= 'btn btn-primary'
						)#
					</div>	
				</cfif>
				<cfset info.@lcaseSingular@ThumbPath = isNull(info.@lcaseSingular@ThumbPath) ? "" : info.@lcaseSingular@ThumbPath>
				<cfloop query="q@ucasePlural@" startrow="#request.reStartRow#" endrow="#request.reEndRow#">		
					<cfset @lcaseSingular@thumbpath = "#info.@lcaseSingular@ThumbPath#sm/#q@ucasePlural@.id#.jpg">
					#includePartial(
						partial="/_partials/indexListItem", 
						currentid		= q@ucasePlural@.id, 
						tags			= "",
						gridActive		= gridActive,
						thumbPath		= fileExists(expandPath(@lcaseSingular@thumbpath)) ? @lcaseSingular@thumbpath : '/assets/img/@lcaseSingular@_thumbholder.jpg',
						title			= q@ucasePlural@.name,
						description		= q@ucasePlural@.description,
						controllerName	= "@lcasePlural@",
						href			= "href='#urlFor(
							route		= "admin~Id",
							module		= "admin",
							controller	= "@lcasePlural@",
							action		= "edit",
							id			= q@ucasePlural@.id
						)#'"	
					)#
					
				</cfloop>
				
			</div>
		
		#endFormTag()#	
		
		<br class="clear" />
		
		<cfif isNull(params.rearrange)>
			#includePartial(
				partial="/_partials/indexPager", 
				currentController	= "@lcasePlural@"
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
								#startFormTag(route="moduleAction", module="admin", controller="@lcasePlural@", action="index", enctype="multipart/form-data", class="form-inline")#	
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
												selected = session.@lcasePlural@.sortby,
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
												selected = session.@lcasePlural@.order,
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
												options			= @lcaseSingular@categories,
												valueField 		= "id", 
												textField 		= "name"
											)#
										</div> --->
										<div class="col-md-2 col-sm-2">									
											#btextfieldtag(
												name			= 'search', 
												label			= 'Search',
												placeholder		= "Ex: Keyword",
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