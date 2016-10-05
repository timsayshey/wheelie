<cfoutput>
	<script src="/views/layouts/admin/assets/js/post.js" type="text/javascript"></script>
	<cfset javaScriptIncludeTag(sources="vendor/jwplayer/jwplayer.js", head=true)>
	
	<cfset contentFor(formy			= true)>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Posts')>
	<cfset contentFor(headerButtons = 
				'<li class="headertab">
					#linkTo(
						text		= '<span class="elusive icon-pencil"></span> Add Post',
						route		= "admin~Action",
						module		= "admin",
						controller	= "posts",
						action		= "new", 
						class		= "btn btn-default"
					)#		
				</li>')>
				
	<div class="row-regular">
	
		#startFormTag(route="admin~Action", module="admin", controller="posts", action="deleteSelection", enctype="multipart/form-data")#	
		
			#includePartial(
				partial="/_partials/statusTabs", 
				controllerName	= "posts"
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
				<a href='#urlFor(route="admin~Action", module="admin", controller="posts", action="index")#?display=grid' class="btn btn-default #gridActive#"><span class="elusive icon-th-large"></span></a>
				<a href='#urlFor(route="admin~Action", module="admin", controller="posts", action="index")#?display=list' class="btn btn-default #listActive#"><span class="elusive icon-th-list"></span></a>
			</div>
			
			<br class="clear" /><br />
			
			<div id="post" class="col-md-12">
			
				<cfif !isNull(Post) and isObject(Post)>
					#errorMessagesFor("Post")#
					<br /><br />
				</cfif>
				
				<cfset homeid = getOption(qOptions,'home_id').content>
				
				<cfloop query="qPosts" startrow="#pagination.getStartRow()#" endrow="#pagination.getendrow()#">		
											
					<cfsavecontent variable="tags">
						<cfif qPosts.id eq homeid><span class="elusive icon-home color-danger" title="Homepost"></span></cfif>						
						<cfif qPosts.status eq "published">
							<span class="elusive icon-eye-open color-info" title="Published"></span>
						<cfelse>						
							<span class="elusive icon-eye-close color-danger" title="#capitalize(qPosts.status)#"></span>
						</cfif>
					</cfsavecontent> 
					
					#includePartial(
						partial="/_partials/indexListItem", 
						currentid		= qPosts.id, 
						tags			= tags,
						gridActive		= gridActive,
						title			= qPosts.name,
						description		= "",
						controllerName	= "posts"
					)#
					
				</cfloop>
				
			</div>
		
		#endFormTag()#	
		
		<br class="clear" />
		
		#includePartial(
			partial				= "/_partials/indexPager", 
			currentController	= "posts"
		)#					
		
	</div>	
	
	<cfsavecontent variable="refiner">
	
		<div class="row">
			<article class="col-sm-12">
			
				<div class="data-block filter-bar">
					<section>
					
						<a href="javascript:void(0)" class="toggle">Filter results &raquo;</a>
						<div class="togglediv" <cfif len(rememberParams)>id="show"</cfif>>
							#startFormTag(route="admin~Action", module="admin", controller="posts", action="index", enctype="multipart/form-data", class="form-inline")#	
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
											selected = session.posts.sortby,
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
											selected = session.posts.order,
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

</cfoutput>
		
