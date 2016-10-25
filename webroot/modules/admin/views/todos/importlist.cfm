<cfoutput>
	
	<cfset isnew = true>
	
	<cfset contentFor(headerTitle	= '<span class="elusive icon-move"></span> Import List of Todos')>
	
	#btextareatag(
		name			= 'importlist',	
		label 		 	= 'List of Todos to Import',
		help			= 'One todo per line',
		style			= 'height:300px;'
	)#	
	
	<!--- Right area --->	
	<cfsavecontent variable="rightColumn">
		
		<div class="rightbarinner">		
			<div class="data-block">
				<section>
					#submitTag(value="Submit", class="btn btn-sm btn-primary")#	
				</section>
			</div>				
		</div>	
			
		</div>
		
	</cfsavecontent>
	
	<cfset contentFor(rightColumn = rightColumn)>		
	<cfset contentFor(formWrapStart = startFormTag(route="admin~action", controller="todos", action="importlistSubmit"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>	
	
</cfoutput>





