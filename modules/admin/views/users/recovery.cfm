<cfoutput>

	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> Recovery')>
	
	#startFormTag(route="admin~Action", module="admin", controller="users", action="recoveryPost")#
	
		<p>Please enter your email address you used to set up your account.</p>
		<div class="form-group">
			<label>Email address</label>
			<input class="form-control" type="email" placeholder="Enter your email" name="email">
		</div>
		<button class="btn btn-primary" type="submit">Submit</button>
		<a class="lost-password pull-right" href='#urlFor(route="admin~Action", module="admin", controller="users", action="login")#'>Back to login</a>
		
	#endFormTag()#
	
</cfoutput>