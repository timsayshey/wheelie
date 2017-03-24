<cfoutput>
	
	<cfset contentFor(formy			= true)>
	<cfset contentFor(headerTitle	= '<span class="fa fa-user"></span> Register')>
	<cfset passwordLabel 			= "Password">
	<cfset passrequired 			= "required">		
		
	#startFormTag(route="admin~Action", module="admin", controller="users", action="registerPost", enctype="multipart/form-data", id="fileupload")#		
					
	<!--- Full name --->
	#btextfield(
		objectName	= 'user', 
		property	= 'Firstname', 
		label		= 'First name',
		placeholder	= "Ex: Matt",
		inlineField = true
	)#
	
	
	#btextfield(
		objectName	= 'user', 
		property	= 'Lastname', 
		label		= 'Last name',
		inlineField = true,
		placeholder	= "Ex: Chandler"
	)#

	#btextfield(
		objectName		= 'user', 
		property		= 'email', 
		label			= 'Email',
		inlineField 	= true,
		placeholder		= "Ex: matt.chandler@gmail.com",
		help 			= "This will be your login id"
	)#

	#btextfieldtag(
		label		= "Confirm Email", 
		name		= "user[emailConfirmation]",
		placeholder		= "Ex: matt.chandler@gmail.com",
		inlineField 	= true
	)#

	#bPasswordFieldTag(
		name			 = "user[password]",
		label			 = passwordLabel,
		inlineField 	 = true,
		placeholder		 = "Ex: Your super secret pass code"	
	)#

	<br>
	<br class="clear">
	<div class="form-horizontal form-group">
		<div class="col-sm-2">
		</div>
		<div class="col-sm-10">
			#bsubmittag(name="submit",value="Register", class="btn-lg btn-primary",inlineField 	= true)#
			<br class="clear">
		</div>
	</div>

	<br><br>
	<a class="lost-password" href='#urlFor(route="admin~Action", module="admin", controller="users", action="login")#'>Back to login</a>	
	
	#endFormTag()#	
</cfoutput>