<cfoutput>    
	<cfset javaScriptIncludeTag(sources="js/admin/sortMenu.js", head=true)>
	
	<cfset contentFor(formy			= true)>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-move"></span> Manage Menus')>	
	<cfset defaultMenus = "primary,secondary">
	
	<ul class="nav nav-tabs">		
		<cfloop list="#defaultMenus#,#getOption(qOptions,'menu_ids').content#" index="menuid">
			<li class="#params.id eq menuid ? 'active' : ''#"><a href='#urlFor(route="moduleId", module="admin", controller="menuitems", action="rearrange", id=menuid)#'>#capitalize(menuid)#</a></li>
		</cfloop>		
	</ul>
	
	<br />
	
	Drag the list to re-order, and click Update button to save the position. To add an item, use the form to the right.<br /><br />
	
	<cfif ListFind(defaultMenus, LCase(params.id))>
		<ul id="disnestable" class="sortable ui-sortable">
			<li id="menu-1" data-id="1" class="sortable">						
				<div class="ns-row">
					<div class="ns-title">Home</div>
				</div>	
			</li>
		</ul>
	</cfif>
	
	<ul id="nestable" class="sortable">
		#getNestable(menuitems)#
	</ul>
	
	<br class="clear" /><br />
	
	#hiddenFieldTag(name="categoryOrder", id="serializedOutput")#
	#hiddenFieldTag(name="menuid", value=params.id)#
	
	<cfsavecontent variable="rightColumn">
		<div class="rightbarinner">					
			<div class="data-block">
				<section>
					<button type="button" name="submit" value="save-continue" class="btn btn-primary submitBtn">Update menu</button>		
				</section>
			</div>		 
			
			<div class="panel-group" id="accordion">
				
				<!--- Add page menu item --->
				<div class="panel panel-default data-block">
					<header>
						<h4 class="panel-title">
						<a data-toggle="collapse" data-parent="##accordion" href="##collapse1">
							<span class="elusive icon-file"></span> Page Links
						</a>
						</h4>
					</header>
					<div id="collapse1" class="panel-collapse collapse in">
						<div class="panel-body">
							<section id="addItem" rel="page">
								#bselecttag(
									name			= "pages",
									id				= "itemid",	
									options			= pageOptions
								)#								
								<button id="submit" type="button" class="btn btn-primary" rel="page">Add to menu</button>	
							</section>
						</div>
					</div>
				</div>	
				
				<!--- Add custom links menu item --->
				<div class="panel panel-default data-block">
					<header>
						<h4 class="panel-title">
						<a data-toggle="collapse" data-parent="##accordion" href="##collapse2">
							<span class="elusive icon-edit"></span> Custom Links
						</a>
						</h4>
					</header>
					<div id="collapse2" class="panel-collapse collapse">
						<div class="panel-body">
							<section id="addTextItem" rel="videocategories">
								#btextFieldTag(name="customlabel", name="customlabel", label="Label", placeholder="My Page")#
								#btextFieldTag(name="customlink", name="customlink", label="URL Link", placeholder="http://")#								
								<button id="submit" type="button" class="btn btn-primary" rel="videocategories">Add to menu</button>								
							</section>
						</div>
					</div>
				</div>
				
				<!--- Add video category menu item --->
				<div class="panel panel-default data-block">
					<header>
						<h4 class="panel-title">
						<a data-toggle="collapse" data-parent="##accordion" href="##collapse3">
							<span class="elusive icon-tags"></span> Video Category Links
						</a>
						</h4>
					</header>
					<div id="collapse3" class="panel-collapse collapse">
						<div class="panel-body">
							<section id="addItem" rel="videocategories">
								#bselecttag(
									name			= "videocategories",
									id				= "itemid",		
									options			= videoCategoryOptions
								)#
								<button id="submit" type="button" class="btn btn-primary" rel="videocategories">Add to menu</button>
							</section>
						</div>
					</div>
				</div>
						
			</div>
			
			<br /><br /><br /><br /><br /><br />
			
			<!--- Add custom --->
		</div>
		
		</div>
		
		<!--- Edit Modal --->
		<div class="modal primary" id="editModal" data-backdrop="static" tabindex="-1" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title">Edit</h4>
					</div>
					<div class="modal-body" id="content">
						#btextfieldtag(
							name		= 'label', 
							label		= 'Label',
							id			= 'editLabel'
						)#	
						#btextfieldtag(
							name		= 'url', 
							label		= 'Link URL',
							id			= 'editUrl'
						)#
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
						<button type="button" class="btn btn-primary" id="saveEdits">Save</button>
					</div>
				</div>
			</div>
		</div>
		
		<div class="rightBottomBox  hidden-xs hidden-sm">
			<div class="col-sm-3 data-block">
				<section>
					<button type="button" name="submit" value="save-continue" class="btn btn-primary submitBtn">Update menu</button>		
				</section>
			</div>
		</div>
	</cfsavecontent>
	<cfset contentFor(rightColumn = rightColumn)>
	
	<cfset contentFor(formWrapStart = startFormTag(route="moduleAction", module="admin", controller="menuitems", id="form-menu", action="saveRearrange"))>		
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
				Name: <input type="text" class="itemname" name="itemname" value="<%=name%>" />
				URL: <input type="text" class="urlpath" name="urlpath" value="<%=id%>" />
				<input type="hidden" class="parentid" name="parentid" value="<%=parentid%>" />
				<input type="hidden" class="sortOrder" name="sortOrder" value="<%=sortOrder%>" />
			</div>
		</li>
	</script>		

</cfoutput>