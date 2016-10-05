<cfoutput>
	
	<cfset isnew = true>
	
	<cfset contentFor(headerTitle	= '<span class="elusive icon-move"></span> Import List of Metafields')>
	
	#btextareatag(
		name			= 'importlist',	
		label 		 	= 'List of metafields to Import',
		help			= 'One metafield per line',
		style			= 'height:300px;'
	)#

	<br><br>
	Legend (precede with):<br>
	/ Checkbox<br>
	- Headline<br>
	+ Radio options (ie +Pick an Option%Option 1,Option 2,Option 3)<br>
	* Checkbox options (ie *Pick an Option%Option 1,Option 2,Option 3)<br>
	
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
	<cfset contentFor(formWrapStart = startFormTag(route="admin~Field", controller="metafields", modelName="propertyfield", params="modelid=#params.modelid#", action="importlistSubmit"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>	
	
</cfoutput>





