<cfoutput>

	<!--- Nestable --->
	<cffunction name="getNestable">
		<cfargument name="query">
		<cfargument name="templateType" default="menu">		
		
		<cfsavecontent variable="returnNest">	
			<cfloop query="arguments.query">
				<cfif parentid eq 0 OR !len(parentid)>
					<cfif arguments.templateType eq "category">
						#categoryNestTemplate(
							query		 = arguments.query,
							name		 = name,
							id			 = id
						)#	
					<cfelseif arguments.templateType eq "menu">
						#menuNestTemplate(
							query		 = arguments.query,
							name		 = name,
							id			 = id,
							url			 = urlPath,
							parentid	 = parentid,
							sortOrder	 = sortOrder
						)#	
					</cfif>					
				</cfif>
			</cfloop>		
		</cfsavecontent>
		
		<cfreturn returnNest>
	</cffunction>
	
	<cffunction name="getNestableChildren">
		<cfargument name="query">
		<cfargument name="templateType" default="menu">	
		<cfargument name="parentsid">
		
		<cfsavecontent variable="returnChildren">
			<cfloop query="arguments.query">				
				<cfif parentid eq arguments.parentsid>
					<cfif arguments.templateType eq "category">
						#categoryNestTemplate(
							query		 = arguments.query,
							name		 = name,
							id			 = id
						)#	
					<cfelseif arguments.templateType eq "menu">
						#menuNestTemplate(
							query		 = arguments.query,
							name		 = name,
							id			 = id,
							url			 = urlPath,
							parentid	 = parentid,
							sortOrder	 = sortOrder
						)#	
					</cfif>						
				</cfif>
			</cfloop>
		</cfsavecontent>
		
		<cfset returnChildren = trim(returnChildren)>
		
		<cfif len(returnChildren)>
			<cfreturn '<ul>#returnChildren#</ul>'>
		</cfif>
	</cffunction>
	
	<cffunction name="categoryNestTemplate">
		<cfargument name="query">	
		<cfargument name="name">	
		<cfargument name="id">	
			
		<li id="menu-#arguments.id#" data-id="#arguments.id#" class="sortable">						
			<div class="ns-row">
				<div class="ns-title">#arguments.name#</div>
				<div class="ns-actions">
					<a href="javascript:void(0)" data-id="#arguments.id#" id="editcategory" class="edit-menu" title="Edit"><span class="elusive icon-pencil"></span></a>
					<a href="javascript:void(0)" data-id="#arguments.id#" id="deletecategory" class="delete-menu confirmDelete" title="Delete"><span class="elusive icon-trash"></span></a>							
				</div>
			</div>		
			#getNestableChildren(
				query		 = arguments.query,
				parentsid	 = arguments.id,
				templateType = "category"
			)#	
		</li>
	</cffunction>
	
	<cffunction name="menuNestTemplate">
		<cfargument name="query">	
		<cfargument name="name">	
		<cfargument name="id">	
		<cfargument name="url">	
		<cfargument name="parentid">	
		<cfargument name="sortOrder">	
		<li id="menu-#arguments.id#" data-id="#arguments.id#" class="sortable">						
			<div class="ns-row">
				<div class="ns-title">#arguments.name#</div>
				<div class="ns-actions">
					<a href="javascript:void(0)" class="edit-menu" title="Edit"><span class="elusive icon-pencil"></span></a>
					<a href="javascript:void(0)" class="delete-menu" title="Delete"><span class="elusive icon-trash"></span></a>
				</div>
			</div>		
			<div class="ns-form">
				Name: <input type="text" class="itemname" name="itemname" value="#arguments.name#" />
				URL: <input type="text" class="urlpath" name="urlpath" value="#arguments.url#" />
				<input type="hidden" class="parentid" name="parentid" value="#arguments.parentid#" />
				<input type="hidden" class="sortOrder" name="sortOrder" value="#arguments.sortOrder#" />
			</div>		
			#getNestableChildren(
				query		= arguments.query,
				parentsid	= arguments.id,
				templateType = "menu"
			)#	
		</li>
	</cffunction>	

</cfoutput>