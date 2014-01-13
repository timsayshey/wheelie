<cfoutput>
	
	<cfset contentFor(formy			= true)>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> Register')>
	<cfset passwordLabel 			= "Password">
	<cfset passrequired 			= "required">		
		
	#startFormTag(route="moduleAction", module="admin", controller="users", action="registerPost", enctype="multipart/form-data", id="fileupload")#		
					
	<!--- Email --->	
	<div class="col-sm-6 clearleft">	
		#btextfield(
			objectName		= 'user', 
			property		= 'email', 
			label			= 'Email',
			placeholder		= "Ex: gmail@chucknorris.com"
		)#
	</div>
	
	<div class="col-sm-6">	
		<cfparam name="user.portrait" default="">
		#bImageUploadTag(
			name			= "portrait",
			value			= user.portrait, 	
			filepath		= user.portrait,
			label			= 'Portrait'
		)#
	</div>

	<!--- Password 
	,"#passrequired#" = "" --->
	<div class="col-sm-6 clearleft">	
		#bPasswordFieldTag(
			name			 = "user[password]",
			label			 = passwordLabel,
			placeholder		 = "Password"			
		)#
	</div>
	
	<div class="col-sm-6">	
		#bPasswordFieldTag(
			label		= "Confirm Password", 
			placeholder	= "Confirm Password",
			name		= "user[passwordConfirmation]"
		)#
	</div>	
				
	<!--- Full name --->
	<div class="col-sm-6 clearleft">	
		#btextfield(
			objectName	= 'user', 
			property	= 'Firstname', 
			label		= 'First name',
			placeholder	= "Ex: Chuck"
		)#
	</div>
	
	<div class="col-sm-6">	
		#btextfield(
			objectName	= 'user', 
			property	= 'Lastname', 
			label		= 'Last name',
			placeholder	= "Ex: Norris"
		)#
	</div>
	
	<br class="clear">
	
	#bsubmittag(name="submit",value="Register", class="btn-lg btn-primary")#
	<a class="lost-password pull-right" href='#urlFor(route="moduleAction", module="admin", controller="users", action="login")#'>Back to login</a>	
	
	#endFormTag()#	
		
</cfoutput>