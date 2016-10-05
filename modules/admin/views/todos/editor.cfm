<cfparam name="todos">
<cfparam name="todo">
<cfparam name="todo.priority" default="medium">
<cfoutput> 
	
	<cfif !isNull(params.id)>
		#hiddenfieldtag(name='todo[id]', value=params.id)#	
	</cfif>
	
	#hiddenfieldtag(name="todo[todoid]", value="Primary")#		
	
	#btextfield(
		objectName 		= "todo",
		property 		= 'name', 
		label 			= 'Label',
		id 				= 'todoItemLabel',
		placeholder 	= "Coolest Todo Item Ever"
	)#	
	
	#bselecttag(
		label 		= 'Priority',
		name	 	= 'todo[priority]',
		selected	= todo.priority,
		options		= [
			{text="Low",value="low"},
			{text="Medium",value="medium"},
			{text="Urgent",value="urgent"}	
		]
	)#
	
	#btextarea(
		objectName 		= "todo",
		property 		= 'description', 
		label 			= 'Description',
		placeholder 	= "What am I?"
	)#	
	
	<label>Due</label><br>	
	#dateSelect(
		objectName 		= "todo",
		property 		= 'duedate',
		class="dateSelect"
	)#
	
	<br class="clear"><br>
	
	</cfoutput>