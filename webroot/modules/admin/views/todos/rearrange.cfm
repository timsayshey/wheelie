<cfoutput> 
	<script src="/views/layouts/admin/assets/js/sortTodos.js" type="text/javascript"></script>
	<script src="/views/layouts/admin/assets/js/todo.js" type="text/javascript"></script>
	
	#hiddenfieldtag(name="todoController", id="todoController", value="todos")#	
	#hiddenfieldtag(name="todoModel", id="todoModel", value="Todo")#	
	#hiddenFieldTag(name="addTodoType", id="addTodoType", value="sortlist")#
		
	<cfset contentFor(formy			= true)>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-move"></span> Todo')>
	<cfset contentFor(headerButtons = 
			'<li class="headertab">					
				<a href="javascript:void(0)" class="btn btn-default view-expanded"><span class="elusive icon-eye-open"></span> Expanded View</a>
				<a href="javascript:void(0)" class="btn btn-default view-simple"><span class="elusive icon-eye-close"></span> Simplified View</a>	
				<a href="javascript:void(0)" id="addnewtodo" class="btn btn-default"><span class="elusive icon-plus"></span> Add Todo</a>	
			</li>')> 
			
	<style type="text/css">
		hr {
			margin:5px 0;	
		}
		.ns-actions {
			width: 122px;
		}
		.ns-extra {
			min-height:11px;
			display:none;	
		}
		.view-simple {
			display:none;	
		}
	</style>

	<a href='#urlFor(route="admin~Action", controller="todos", action="emailreviewform")#' class="btn btn-sm btn-info">Get Email Review</a>	
	
	<a href='#urlFor(route="admin~Action", controller="todos", action="print")#' class="btn btn-sm btn-info">Print</a>
	
	<a href='#urlFor(route="admin~Action", controller="todos", action="importlist")#' class="btn btn-sm btn-info">Import Todos</a>
	<br><br>
	
	Drag the list to re-order.
	<br /><br />
	
	<ul id="nestable" class="sortable">
		#getNestable(todos,"todo")#
	</ul>
	
	<br class="clear" /><br />
	
	#hiddenFieldTag(name="todoOrder", id="serializedOutput")#
	
	<!--- 
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
		#includePartial(partial="/_partials/todoFormModal", modelName="Todo")#	
	</cfsavecontent>
	
	<cfset contentFor(rightColumn = rightColumn)> 	
	--->	
	#includePartial(partial="/_partials/todoFormModal", modelName="Todo")#	
	<cfset contentFor(formWrapStart = startFormTag(route="admin~todo", action="saveRearrange", modelName="Todo"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>
	
	<cfset todoQuery = queryNew(
		"id,name,parentid,description,duedate,priority,isdone","varchar,varchar,varchar,varchar,varchar,varchar,varchar",
		[{id:"<%=id%>", name:"<%=name%>", parentid:"<%=parentid%>", description:"<%=description%>", duedate:"<%=duedate%>", priority:"<%=priority%>", isdone:""}]
	)>	
	<script type="text/html" id="tmpl_todoListItem">
		#todoNestTemplate(
			query		 = todoQuery,
			name		 = "<%=name%>",
			id			 = "<%=id%>"
		)#	
	</script>
	
</cfoutput>