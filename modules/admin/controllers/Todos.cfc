<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
	}
	
	function importlistSubmit()
	{
		linebreak = Chr(13) & Chr(10);
		todoArray = ListToArray(params.importlist,linebreak);		
		
		for(todo in todoArray)
		{
			savetodo = model("Todo").new({ name = todo });
			saveResult = savetodo.save();
		}
		flashInsert(success="Todos imported successfully!");
		redirectTo(route="admin~Todo", action="rearrange", modelName="Todo");	
	}
	
	function sharedData()
	{
		//pages = model("Page").findAll(order="name ASC");
		//posts = model("Post").findAll(order="name ASC");
	}
	
	function emailreview()
	{
		todos = model("Todo").findAll(order="isDone DESC, sortOrder ASC, name ASC", select="id, name, parentid, sortOrder, description, priority, duedate, isdone", distinct=true);
		usesLayout("/layouts/layout.blank");
	}
	
	function emailreviewSend()
	{
		todos = model("Todo").findAll(order="isDone DESC, sortOrder ASC, name ASC", select="id, name, parentid, sortOrder, description, priority, duedate, isdone", distinct=true);
		
		savecontent variable="emailContent" { 
			include "../views/todos/emailreview.cfm" 
		}
		
		if(!isNull(params.emailto) AND Find("@",session.user.email))
		{
			emailto = params.emailto;
		} else {
			emailto = session.user.email;
		}
		mailgun(
			mailTo	= emailto,
			from	= application.wheels.adminFromEmail,
			subject	= "#session.user.fullname#'s Weekly Review",
			html	= emailContent
		);		
		writeOutput("Sent");
		abort;
	}
	
	function new()
	{					
		sharedData();
		
		todo = model("Todo").new(colStruct("Todo"));
		todos = model("Todo").findAll();
		sites = model("Site").findAll();
		renderPage(action="editor");
	}
	
	function markDone()
	{
		todo = model("todo").findByKey(params.id);
		todoresult = todo.update(isdone=now(),validate=false);
		if(todoresult) {
			json = SerializeJSON({response = "success"});	
		} else {
			json = SerializeJSON({response = "error"});
		}
		writeOutput(json); abort;	
	}
	
	function markNotDone()
	{	
		todo = model("todo").findByKey(params.id);
		todoresult = todo.update(isdone="");
		if(todoresult) {
			json = SerializeJSON({response = "success"});	
		} else {
			json = SerializeJSON({response = "error"});
		}
		writeOutput(json); abort;
	}
	
	function delete()
	{
		todo = model("Todo").findByKey(params.id);
		
		try {
			if(todo.delete())
			{
				writeOutput('{ "Message" : "", "Success" : true }');
			} else {
				writeOutput('{ "Message" : "", "Success" : false }');
			}
		} catch(any e) {
			writeOutput('{ "Message" : "", "Success" : false }');
		}
		abort;
	}
	
	function edit()
	{						
		sharedData();
		
		if(isDefined("params.id")) 
		{
			// Queries					
			todo = model("Todo").findAll(where="id = '#params.id#'#wherePermission("Todo","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(todo))
			{				
				todo = todo[1]; 
			}	
		}
		
		todos = model("Todo").findAll();
		sites = model("Site").findAll();
		renderPage(action="editor");		
	}
	
	function rearrange()
	{
		sharedData();
		
		todos = model("Todo").findAll(where=buildWhereStatement("Todo"), order="sortOrder ASC, name ASC", select="id, name, parentid, sortOrder, description, priority, duedate, isdone", distinct=true);
	}
	
	function print()
	{
		usesLayout("/layouts/layout.blank");
		
		sharedData();
		
		todos = model("Todo").findAll(where="isdone IS NULL#wherePermission("Todo","AND")#", order="sortOrder ASC, name ASC", select="id, name, parentid, sortOrder, description, priority, duedate, isdone", distinct=true);
	}
	
	function saveRearrange()
	{
		var loc = {};
		
		loc.newOrder = DeserializeJSON(params.todoOrder);
		
		for(i=1; i LTE arrayLen(loc.newOrder); i++)
		{
			loc.curr = loc.newOrder[i];
			
			if(!isNull(loc.curr.item_id))
			{
				if(isNull(loc.curr.parent_id) OR !IsNumeric(loc.curr.parent_id)) 
				{
					loc.curr.parent_id = 0;
				}
				
				todoCat = model("Todo").
				findByKey(loc.curr.item_id).
				update(
					parentid = loc.curr.parent_id,
					sortOrder = i
				);
			}
		}
		
		flashInsert(success="Updated successfully.");
		redirectTo(route="admin~Todo", action="rearrange", modelName="Todo");	
	}
	
	
	function save()
	{					
		// Save
		if(!isNull(params.todo.id) AND isNumeric(params.todo.id)) 
		{
			todo = model("Todo").findByKey(params.todo.id);
			saveResult = todo.update(params.todo);	
			
		} else {
			todo = model("Todo").new(params.todo);
			saveResult = todo.save();
		}
		
		// Redirect based on result
		if (saveResult)
		{			
			if(isNull(isAjaxRequest))
			{
				flashInsert(success="Saved successfully.");
				redirectTo(route="admin~Todo", action="index", modelName=params.modelName);	
			}
			else
			{
				json = SerializeJSON({
					response = "success",
					option = {
						value = todo.id,
						text = todo.name,
						description = todo.description,
						duedate = DateFormat(todo.duedate,"M/D/YYYY"),
						priority = todo.priority
					}
				});
				
				writeOutput(json); abort;
			}
			
					
		} else {	
		
			if(isNull(isAjaxRequest))
			{
				errorMessagesName = "Todo";
				flashInsert(error="There was an error.");
				redirectTo(route="admin~Todo", action="editor", modelName=params.modelName);					
			}
			else
			{
				json = SerializeJSON({
					response = "error",
					errors = 
					'<div class="alert alert-danger alert-dismissable fade in">
							<button class="close" data-dismiss="alert">&times;</button>
							#errorMessagesFor("todo")#
					</div>'
				});
				
				writeOutput(json); abort;
			}
		}		
	}
}
</cfscript>