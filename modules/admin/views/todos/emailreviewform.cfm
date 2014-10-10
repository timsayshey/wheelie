<cfoutput>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> To-dos Email Review')>
	
	<h2>Preview Review Email</h2>
	<form action='#urlFor(route="admin~Action", controller="todos", action="emailreview")#' method="post">
		Start Date<br>
		#dateSelectTags(
			name='startDate',
			class="dateSelect"
		)#<br><br>
		
		End Date<br>
		#dateSelectTags(
			name='endDate',
			class="dateSelect"
		)#<br><br>
		
		<button type="submit" name="submit" value="preview" class="btn btn-primary">Preview Review</button><br><br>
	</form>
	
	<h2>Send Review Email</h2>
	<form action='#urlFor(route="admin~Action", controller="todos", action="emailreviewSend")#' method="post">	
		Start Date<br>
		#dateSelectTags(
			name='startDate',
			class="dateSelect"
		)#<br><br>
		
		End Date<br>
		#dateSelectTags(
			name='endDate',
			class="dateSelect"
		)#<br><br>
		
		Recipient's Email<br>
		<input type="text" value="#session.user.email#" name="emailto"><br><br>
		
		<button type="submit" name="submit" value="emailto" class="btn btn-primary">Email Review</button>
	</form>
</cfoutput>