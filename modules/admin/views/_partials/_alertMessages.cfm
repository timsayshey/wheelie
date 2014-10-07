<cfoutput>

	<cfif NOT flashIsEmpty()>
				
		<cfif flashKeyExists("error")>
			<div class="alert alert-danger alert-dismissable fade in">
				<button class="close" data-dismiss="alert">&times;</button>
				<strong>#flash("error")#</strong> 
				<cfif !isNull(errorMessagesName)>												
					#errorMessagesFor(errorMessagesName)#
				</cfif>
			</div>
		</cfif>
		
		<cfif flashKeyExists("success")>
			<div class="alert alert-success">
				<button type="button" class="close" data-dismiss="alert">&times;</button>
				<strong>#flash("success")#</strong>
			</div>
		</cfif>
			
	</cfif>	
	
</cfoutput>