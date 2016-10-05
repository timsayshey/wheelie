<cfoutput>
	<cfif form.containsKey("to")>
		<cfmail        
			type="html"
			from="#form.from#" 
			to="#form.to#" 
			subject="TEST EMAIL FROM testemail.cfm">   
				 
			THIS IS A TEST.
			
		</cfmail> 
	<cfelse>
		<form action="testemail.cfm" method="post">
			TO: <input name="to" value="me@test.com"><br>
			FROM: <input name="from" value="me@test.com"><br>
			<input type=submit>
		</form>
	</cfif>
</cfoutput>