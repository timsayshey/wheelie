<cfoutput>

	<cfset javaScriptIncludeTag(sources="
		js/admin/user.js,
		js/admin/category.js", 
	head=true)>
	
	<cfset contentFor(formy			= true)>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> User')>
				
	<!--- For category.js --->
	#hiddenfieldtag(name="categoryController", id="categoryController", value="usertags")#	
	#hiddenfieldtag(name="categoryModel", id="categoryModel", value="usertag")#	
	#hiddenFieldTag(name="addCategoryType", id="addCategoryType", value="dropdown")#
	
	<cfset contentFor(formy = true)>
	
	<cfif !isNull(params.id)>
		<cfset isNew = false>
		<cfset currentStatus = user.status>
	<cfelse>
		<cfset isNew = true>
		<cfset currentStatus = "draft">
	</cfif>
	 
	<cfif !isNull(params.id)>
		<cfset isNew = false>
	<cfelse>
		<cfset isNew = true>
	</cfif>
	
	<cfif !isNew>
		#hiddenfield(objectName='user', property='id', id="userid")#
		#hiddenFieldTag("id",params.id)#
		<cfset passwordLabel = "Change Password">
		<cfset passrequired = "">
	<cfelse>
		<cfset passwordLabel = "Password">
		<cfset passrequired = "required">
	</cfif>				
					
	<!--- Email --->	
	<div class="col-sm-6 clearleft">	
		#btextfield(
			objectName		= 'user', 
			property		= 'email', 
			label			= 'Email',
			placeholder		= "Ex: gmail@chucknorris.com"
		)#
	</div>
	
	<cfif checkPermission("user_save_role")>	
		<cfset roles = ["author","user","guest"]>		
		<cfif checkPermission("user_save_role_admin")>	
			<cfset ArrayPrepend(roles,"editor")>
			<cfset ArrayPrepend(roles,"admin")>			
		</cfif>				
		<cfif !isNull(user.role) AND !ArrayFind(roles,user.role)>
			<cfset ArrayPrepend(roles,user.role)>
		</cfif>
		<div class="col-sm-6">	
			#bselect(
				objectName		= 'user',
				property		= 'role',
				label			= 'Role',
				options			= roles
			)#
		</div>
	<cfelse>
		<br class="clear" />							
	</cfif>

	<!--- Password --->
	<div class="col-sm-6 clearleft">	
		#bPasswordFieldTag(
			name			 = "user[password]",
			label			 = passwordLabel,
			placeholder		 = "Password",									
			colclass		 = passrequired
		)#
	</div>
	
	<div class="col-sm-6">	
		#bPasswordFieldTag(
			label		= "Confirm Password", 
			placeholder	= "Confirm Password",
			name		= "user[passwordConfirmation]",
			colclass	= passrequired
		)#
	</div>
	
	#includePartial(partial="/_partials/formSeperator")#				
				
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
    
    <div class="col-sm-6 clearleft">	
		#btextfield(
			objectName	= 'user', 
			property	= 'title', 
			label		= 'Title',
			placeholder	= "Ex: Sensei"
		)#
	</div>
	
	<div class="col-sm-6">	
		#btextfield(
			objectName	= 'user', 
			property	= 'spouse_firstname', 
			label		= 'Spouse''s Name'
		)#
	</div>
	
	<div class="col-sm-6 clearleft">								
		#btextfield(
			objectName	= 'user', 
			property	= 'Phone', 
			label		= 'Phone',
			placeholder	= "Ex: 573-434-3433"
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
	
	#includePartial(partial="/_partials/formSeperator")#	
						
	<div class="col-sm-6 clearleft">
		#btextfield(
			objectName	= 'user', 
			property	= 'address1', 
			label		= 'Address Line 1',
			placeholder	= "Ex: 123 Cool Rd."
		)#
	</div>
	
	<div class="col-sm-6">
		#btextfield(
			objectName	= 'user', 
			property	= 'address2', 
			label		= 'Address Line 2',
			placeholder	= "Ex: Suite 4"
		)#
	</div>
	
	<div class="col-sm-6 clearleft">
		#btextfield(
			objectName	= 'user', 
			property	= 'city', 
			label		= 'City',
			placeholder	= "Ex: Lake City"
		)#
	</div>
	
	<div class="col-sm-6">
		#bselect(
			objectName	= 'user', 
			property	= 'state', 
			label		= 'State', 
			options		= usStates, 
			valueField	= "abbreviation", 
			textField	= "name"
		)#
	</div>
	
	<div class="col-sm-6 clearleft">	  
		#bselect(
			objectName	= 'user', 
			property	= 'country', 
			label		= 'Country', 
			options		= countries, 
			valueField	= "abbreviation", 
			textField	= "name"
		)#
	</div>
	
	<div class="col-sm-6">
		#btextfield(
			objectName	= 'user', 
			property	= 'zip', 
			label		= 'Zipcode',
			placeholder	= '65049'
		)#
	</div>
	
	#includePartial(partial="/_partials/formSeperator")#	
	
	#btextarea(
		objectName 		= 'user', 
		property 		= 'about', 	
		class			= "ckeditor",
		label 		 	= "About"
	)#
	
	<!--- Right area --->		
	<cfsavecontent variable="rightColumn">
		<div class="rightbarinner">			
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="users", currentStatus=currentStatus)#					
		</div>
		<div class="data-block">
			<section>
				#bselecttag(
					name			= "usertags",
					class			= "usertagselectize",
					multiple		= "true",
					label			= 'Select Tags',
					help			= 'Select tags that you want to associate with this user',
					options			= usertags,
					selected		= selectedusertags,
					valueField 		= "id", 
					textField 		= "name"
				)#
				
				<script type="text/javascript">
					$(function() {
						window.$catselectize = $('.usertagselectize').selectize({
							maxItems: null
						});
					});
				</script>
				
				<a href="javascript:void(0)" id="addnewcategory">+ Add New Tag</a>
				
				#includePartial(partial="/_partials/categoryFormModal", modelName="usertag", modalTitle="Tag")#	
				
			</section>
		</div>			
		</div>
		<div class="rightBottomBox  hidden-xs hidden-sm">
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="users", currentStatus=currentStatus, rightBottomClass="col-sm-3")#	
		</div>
	</cfsavecontent>
	<cfset contentFor(rightColumn = rightColumn)>
	<cfset contentFor(formWrapStart = startFormTag(route="moduleAction", module="admin", controller="users", action="save", enctype="multipart/form-data", id="fileupload"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>	
		
</cfoutput>