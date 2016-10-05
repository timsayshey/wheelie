<cfoutput>
	
	<cfset contentFor(formy			= true)>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> Register')>
	<cfset passwordLabel 			= "Password">
	<cfset passrequired 			= "required">		
		
	#startFormTag(route="admin~Action", module="admin", controller="users", action="registerPost", enctype="multipart/form-data", id="fileupload")#		
					
	<!--- Full name --->
	<div class="col-sm-6">	
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

	<!--- 
	<div class="col-sm-6">	
		#btextfield(
			objectName	= 'user', 
			property	= 'jobtitle', 
			label		= 'Job Title*',
			placeholder	= "Ex: Teacher"
		)#
	</div>	
	
	<div class="col-sm-6">	
		#btextfield(
			objectName	= 'user', 
			property	= 'designatory_letters', 
			label		= 'Credentials*',
			placeholder	= "Ex: PhD MDA BS"
		)#
	</div>	 --->
	
	<!--- Password 
	,"#passrequired#" = "" --->

	<div class="col-sm-6">	
		#btextfield(
			objectName		= 'user', 
			property		= 'username', 
			label			= 'Username *',
			placeholder		= "Ex: chucknorris"
		)#
	</div>	

	<div class="col-sm-6">	
		#bPasswordFieldTag(
			name			 = "user[password]",
			label			 = passwordLabel,
			placeholder		 = "Password *"			
		)#
	</div>

	<div class="col-sm-6">	
		#btextfield(
			objectName		= 'user', 
			property		= 'email', 
			label			= 'Email *',
			placeholder		= "Ex: chucknorris@gmail.com"
		)#
	</div>
	
	<div class="col-sm-6">	
		#btextfieldtag(
			label		= "Confirm Email *", 
			name		= "user[emailConfirmation]"
		)#
	</div>	

	<br>
	
	<!--- Email --->
	
	
	<div class="col-sm-6">	
		<cfparam name="user.portrait" default="">
		#bImageUploadTag(
			name			= "portrait",
			value			= user.portrait, 	
			filepath		= user.portrait,
			label			= 'Portrait'
		)#
	</div>	

	<!--- 
	<div class="col-sm-12">	
		#btextarea(
			objectName	= 'user', 
			property	= 'about', 
			label		= 'Bio',
			placeholder	= "",
			style		= "min-height:120px;"
		)#
	</div>--->	
	
		
	<br class="clear">
	
	#bsubmittag(name="submit",value="Register", class="btn-lg btn-primary")#<br><br>
	<a class="lost-password" href='#urlFor(route="admin~Action", module="admin", controller="users", action="login")#'>Back to login</a>	
	
	#endFormTag()#	

		
</cfoutput>