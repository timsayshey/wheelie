<cfoutput>
	<script src="/views/layouts/admin/assets/js/user.js" type="text/javascript"></script>
	<cfscript>
		// Get rearrange button and script if necessary
		initializeRearrange = includePartial(partial="/_partials/sortableScript", urlcontroller="users", reEndRow=qUsers.recordcount);		
		
		contentFor(formy = true);		
		if(len(capitalize(usergroup.groupname)))
		{
			titleName = capitalize(usergroup.groupname);
		} else {
			titleName = "User";
		}
		
		contentFor(headerTitle = '<span class="elusive icon-user"></span> #titleName#');
		
		if(checkPermission("user_save_others"))
		{
			contentFor(headerButtons = 
				'<li class="headertab">
					#initializeRearrange#
					#linkTo(
						text		= '<span class="elusive icon-plus"></span> Add #titleName#',
						route		= "admin~Action",
						module		= "admin",
						controller	= "users",
						action		= "new", 
						params		= "currentGroup=#capitalize(params.currentGroup)#",
						class		= "btn btn-default"
					)#		
				</li>');
		}
	</cfscript>
	
	<div class="row-regular">
	
		#startFormTag(route="admin~Action", module="admin", controller="users", action="deleteSelection", enctype="multipart/form-data", params="currentGroup=#params.currentGroup#")#	
		
			<cfif checkPermission("user_save_others")>
				<cfif isNull(params.rearrange)>
					#includePartial(
						partial			= "/_partials/statusTabs", 
						controllerName	= "users",
						statusUrl		= urlFor(route="admin~peopleTypes", currentGroup=params.currentGroup)
					)#
				</cfif>
				<div class="col-md-10">
					<input type="checkbox" class="checkall" />				
					<button class="btn btn-primary btn-sm deleteselection confirmDelete" type="submit" value="deleteselection">Delete selection</button>
				</div>
				<br class="clear" /><br /> 
			</cfif>
			
			<cfif session.display eq "grid">
				<cfset gridActive = "active">
				<cfset listActive = "">
			<cfelse>
				<cfset gridActive = "">
				<cfset listActive = "active">
			</cfif>
			
			<!--- 
			<div class="btn-group pull-right">				
				<a href='#urlFor(route="admin~peopleTypes", currentGroup=params.currentGroup)#?display=grid' class="btn btn-default #gridActive#"><span class="elusive icon-th-large"></span></a>
				<a href='#urlFor(route="admin~peopleTypes", currentGroup=params.currentGroup)#?display=list' class="btn btn-default #listActive#"><span class="elusive icon-th-list"></span></a>
			</div>
			 
			<br class="clear" /><br /> 
			--->
			
			<div id="user" class="col-md-12 sortable">
			
				<cfif !isNull(User) and isObject(User)>
					#errorMessagesFor("User")#
					<br /><br />
				</cfif>
				
				<cfloop query="qUsers" startrow="#request.reStartRow#" endrow="#request.reEndRow#">		
											
					<cfsavecontent variable="tags">
						<cfset roleIcons = {
							admin    = "icon-star-alt",
							editor   = "icon-unlock-alt",
							author   = "icon-pencil-alt",
							user     = "icon-lock-alt",
							guest    = "icon-lock-alt"
						}>
						<cfif StructKeyExists(roleIcons,qUsers.role)>
							<span class="elusive #roleIcons[qUsers.role]# color-danger" title="#capitalize(qUsers.role)#"></span>
						</cfif>
					</cfsavecontent> 
					
					#includePartial(
						partial			= "/_partials/indexListItem", 
						currentid		= qUsers.id, 
						tags			= tags,
						gridActive		= gridActive,
						thumbPath		= fileExists(expandPath("/assets/userpics/#qUsers.id#.jpg")) ? "/assets/userpics/#qUsers.id#.jpg" : '/assets/img/user_thumbholder.jpg',
						title			= capitalize(qUsers.zx_firstName) & " " & capitalize(qUsers.zx_lastName),
						description		= "",
						controllerName	= "users",
						href			= 'href="#urlFor(									
								route		= "admin~Id",
								module		= "admin",
								controller	= "profiles",
								action		= "profile",
								id			= qUsers.id
						)#"'
					)#
					
				</cfloop>
				
			</div>
		
		#endFormTag()#	
		
		<br class="clear" />
		
		<cfif isNull(params.rearrange)>
			#includePartial(
				partial="/_partials/indexPager", 
				currentController	= "users"
			)#	
		</cfif>				
		
	</div>	
	
	<cfif isNull(params.rearrange)>
		
		<cfsavecontent variable="refiner">
		
			<div class="row">
				<article class="col-sm-12">
				
					<div class="data-block filter-bar">
						<section>
						
							<a href="javascript:void(0)" class="toggle">Filter results &raquo;</a>
							<div class="togglediv" <cfif len(rememberParams)>id="show"</cfif>>
								#startFormTag(route="admin~peopleTypes", currentGroup=params.currentGroup, enctype="multipart/form-data", class="form-inline")#	
									<div class="row-regular">
																		
										<div class="col-md-2 col-sm-2">									
											#bselecttag(
												name	 = 'sort',
												label	 = 'Sort by',
												options	 = [
													{text = "First Name", value = "firstname"},
													{text = "Last Name", value = "lastname"},
													{text = "Created", value = "createdat"},
													{text = "Last updated", value = "updatedat"}
												],
												selected = session.users.sortby,
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
												selected = session.users.order,
												class	 = "selectize",
												append	 = ""
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
	
	</cfif>

</cfoutput>
		
