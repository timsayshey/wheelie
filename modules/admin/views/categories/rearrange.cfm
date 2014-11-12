<cfoutput>    
	<input type="hidden" name="maxLevel" class="maxLevel" value="#isNull(params.maxlevel) ? 0 : params.maxlevel#" />
	<script src="/views/layouts/admin/assets/js/sortCategories.js" type="text/javascript"></script>
	<script src="/views/layouts/admin/assets/js/category.js" type="text/javascript"></script>
	<script src="/views/layouts/admin/assets/js/video.js" type="text/javascript"></script>
	
	#hiddenfieldtag(name="categoryController", id="categoryController", value="categories")#	
	#hiddenfieldtag(name="categoryModel", id="categoryModel", value=params.modelName)#	
	#hiddenFieldTag(name="addCategoryType", id="addCategoryType", value="sortlist")#
		
	<cfset contentFor(formy			= true)>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-move"></span> #categoryInfo.plural#')>
	<cfset contentFor(headerButtons = 
			'<li class="headertab">
				<a href="javascript:void(0)" id="addnewcategory" class="btn btn-default"><span class="elusive icon-plus"></span> Add #categoryInfo.singular#</a>			
			</li>')> 
			
	Drag the list to re-order, and click update button to save the position. To add an item, use the form to the right.<br /><br />
	
	<ul id="nestable" class="sortable">
		#getNestable(categories,"category")#
	</ul>
	
	<br class="clear" /><br />
	
	#hiddenFieldTag(name="categoryOrder", id="serializedOutput")#
	
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
		#includePartial(partial="/_partials/categoryFormModal", modelName=params.modelName)#	
	</cfsavecontent>
	
	<cfset contentFor(rightColumn = rightColumn)>	
	<cfset contentFor(formWrapStart = startFormTag(route="admin~Category", action="saveRearrange", modelName=params.modelName))>		
	<cfset contentFor(formWrapEnd = endFormTag())>
	
	<script type="text/html" id="tmpl_categoryListItem">
		<li id="menu-<%=id%>" data-id="<%=id%>" class="sortable">						
			<div class="ns-row">
				<div class="ns-title"><%=name%></div>
				<div class="ns-actions">
					<a href="javascript:void(0)" data-id="<%=id%>" id="editcategory" class="edit-menu" title="Edit"><span class="elusive icon-pencil"></span></a>
					<a href="javascript:void(0)" data-id="<%=id%>" id="deletecategory" class="delete-menu confirmDelete" title="Delete"><span class="elusive icon-trash"></span></a>							
				</div>
			</div>	
		</li>
	</script>
	
</cfoutput>