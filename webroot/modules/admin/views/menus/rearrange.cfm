<cfoutput>    

	<script src="/views/layouts/admin/assets/js/sortMenus.js" type="text/javascript"></script>
	<script src="/views/layouts/admin/assets/js/menu.js" type="text/javascript"></script>
	<script src="/views/layouts/admin/assets/js/video.js" type="text/javascript"></script>
		
	#hiddenfieldtag(name="menuController", id="menuController", value="menus")#	
	#hiddenfieldtag(name="menuModel", id="menuModel", value="Menu")#	
	#hiddenFieldTag(name="addMenuType", id="addMenuType", value="sortlist")#
		
	<cfset contentFor(formy			= true)>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-move"></span> Menu')>
	<cfset contentFor(headerButtons = 
			'<li class="headertab">
				<a href="javascript:void(0)" id="addnewmenu" class="btn btn-default"><span class="elusive icon-plus"></span> Add Menu Item</a>			
			</li>')> 
			
	Drag the list to re-order, and click update button to save the position. To add an item, use the form to the right.<br /><br />
	
	<ul id="nestable" class="sortable">
		#getNestable(menus,"menu")#
	</ul>
	
	<br class="clear" /><br />
	
	#hiddenFieldTag(name="menuOrder", id="serializedOutput")#
	
	<cfsavecontent variable="rightColumn">
		<div class="rightbarinner">					
			<div class="data-block">
				<section>
					<button type="submit" name="submit" value="save-continue" class="btn btn-primary submitBtn">Update order</button>		
				</section>
			</div>
		</div>		 
		
		</div>
		<div class="rightBottomBox  hidden-xs hidden-sm">
			<div class="col-sm-3 data-block">
				<section>
					<button type="submit" name="submit" value="save-continue" class="btn btn-primary submitBtn">Update order</button>		
				</section>
			</div>
		</div>
		#includePartial(partial="/_partials/menuFormModal", modelName="Menu")#	
	</cfsavecontent>
	
	<cfset contentFor(rightColumn = rightColumn)>	
	<cfset contentFor(formWrapStart = startFormTag(route="admin~Menu", action="saveRearrange", modelName="Menu"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>
	
	<script type="text/html" id="tmpl_menuListItem">
		<li id="menu-<%=id%>" data-id="<%=id%>" class="sortable">						
			<div class="ns-row">
				<div class="ns-title"><%=name%></div>
				<div class="ns-actions">
					<a href="javascript:void(0)" data-id="<%=id%>" id="editmenu" class="edit-menu" title="Edit"><span class="elusive icon-pencil"></span></a>
					<a href="javascript:void(0)" data-id="<%=id%>" id="deletemenu" class="delete-menu confirmDelete" title="Delete"><span class="elusive icon-trash"></span></a>							
				</div>
			</div>	
		</li>
	</script>
	
</cfoutput>