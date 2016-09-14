<cfoutput>
	
	<script src="/views/layouts/admin/assets/js/user.js" type="text/javascript"></script>
	<script src="/views/layouts/admin/assets/js/category.js" type="text/javascript"></script>
	
	<cfset contentFor(formy			= true)>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> #capitalize(usergroup.groupname)#')>
				
	<!--- For category.js --->
	#hiddenfieldtag(name="categoryController", id="categoryController", value="usertags")#	
	#hiddenfieldtag(name="categoryModel", id="categoryModel", value="usertag")#	
	#hiddenFieldTag(name="addCategoryType", id="addCategoryType", value="dropdown")#
	#hiddenFieldTag(name="currentGroup", value=params.currentGroup)#
	
	<cfset contentFor(formy = true)>
	
	<cfif !isNull(params.id)>
		<cfset isNew = false>
		<cfset currentStatus = user.status>
	<cfelse>
		<cfset isNew = true>
		<cfset currentStatus = "draft">
		<cfset user.securityApproval = 1>
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
	
	<cfif !isNull(user.approval_flag) AND user.approval_flag eq 1 AND user.showOnSite>
		<div class="alert alert-warning">
			<button type="button" class="close" data-dismiss="alert">&times;</button>
			Some changes are awaiting for approval by the admin before they show up publicly on the website.
		</div>
	</cfif>
					
	<!--- Email --->	
	<div class="col-sm-6 ">	
		#btextfield(
			objectName		= 'user', 
			property		= 'email', 
			label			= 'Email',
			placeholder		= "Ex: gmail@chucknorris.com"
		)#
	</div>

	<div class="col-md-6">
		#btextfield(
			objectName	= 'user', 
			property	= 'username', 
			label		= 'Display Name'
		)#<br>
	</div>
	
	<cfif checkPermission("user_save_role_admin")>	
		<cfset roles = ListToArray(application.rbs.roleslist)>			
		<div class="col-sm-6">	
			#bselect(
				includeBlank	= true,
				objectName		= 'user',
				property		= 'role',
				label			= 'Override Usergroup Role',
				options			= roles
			)#
		</div>							
	</cfif> 

	<cfset approvalToggle = "">
	<cfif checkPermission("user_save_others") OR user.showOnSite eq 0>	
		<cfset approvalToggle = "zx_">
		#hiddenFieldTag(name="user[approval_flag]", value="0")#
	<cfelse>
		#hiddenFieldTag(name="user[approval_flag]", value="1")#
	</cfif>
	
	#hiddenFieldTag(name="fromEditor", value="1")#
	
	<!--- Password --->
	<div class="col-sm-6 ">	
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
	<div class="col-sm-6 ">	
		#btextfield(
			objectName	= 'user', 
			property	= '#approvalToggle#firstname', 
			label		= 'First name*',
			placeholder	= "Ex: Chuck"
		)#
	</div>
	
	<div class="col-sm-6">	
		#btextfield(
			objectName	= 'user', 
			property	= '#approvalToggle#lastname', 
			label		= 'Last name*',
			placeholder	= "Ex: Norris"
		)#
	</div>

	<div class="col-sm-6 ">								
		#btextfield(
			objectName	= 'user', 
			property	= 'Phone', 
			label		= 'Phone*',
			placeholder	= "Ex: 555-555-3433"
		)#
	</div>
	
	<!--- <div class="col-sm-6">	
		#btextfield(
			objectName	= 'user', 
			property	= '#approvalToggle#designatory_letters', 
			label		= 'Credentials',
			placeholder	= "Ex: PhD, MSW, etc"
		)#
	</div>
	
	<div class="col-sm-6 ">	
		#btextfield(
			objectName	= 'user', 
			property	= '#approvalToggle#jobtitle', 
			label		= 'Job Title*',
			placeholder	= "Ex: Teacher"
		)#
	</div> --->
	
    <!--- <div class="col-sm-6 ">			
		#bselect(
			objectName	= 'user', 
			property	= 'title', 
			label		= 'Title',
			options		= [
				{text="",value=""},
				{text="Miss",value="Miss"},
				{text="Mr",value="Mr"},			
				{text="Mrs",value="Mrs"},
				{text="Ms",value="Ms"}
			]
		)#	
	</div>
	
	<div class="col-sm-6 ">			
		#bselect(
			objectName	= 'user', 
			property	= 'gender', 
			label		= 'Gender*',
			options		= [
				{text="",value="0"},
				{text="Male",value="1"},
				{text="Female",value="2"}
			]
		)#	
	</div>
	
	<div class="col-sm-6">
		<label>Job Start Date*</label><br>
		#dateSelect(
			objectName="user",
			property="start_date", 
			startYear="2000",
			includeBlank=true,
			class="dateSelect"
		)#
		<div class="separator"></div>
	</div>
	
	<div class="col-sm-6">
		<label>Birthday*</label><br>
		#dateSelect(
			objectName="user", 
			property="birthday", 
			order="month,day",
			includeBlank=true,
			class="dateSelect"
		)#
		<div class="separator"></div>
	</div> 
	
	
	 
		
	#includePartial(partial="/_partials/formSeperator")#	
						
	<div class="col-sm-6 ">
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
	
	<div class="col-sm-6 ">
		#btextfield(
			objectName	= 'user', 
			property	= 'city', 
			label		= 'City',
			placeholder	= "Ex: Awesome Town"
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
	
	<div class="col-sm-6 ">	  
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
	
	<h3 class="formHeader">Professional</h3>
	
	#btextarea(
		objectName 		= 'user', 
		property 		= '#approvalToggle#about',
		label 		 	= "Bio for Website*",
		style			= "height:150px"
	)#	 --->
	
	<!--- Get Custom Fields --->
	#includePartial(partial="/_partials/formFieldsRender")# 
	<br class="clear">
	
	<cfif checkPermission("user_save_others")>	
		#includePartial(partial="/_partials/formSeperator")#
			
		<div class="col-sm-6">
			<label>Show on Website?</label><br>
			#radioButton(objectName="user", property="showOnSite", tagValue="1", label="Yes ",labelPlacement="after")#<br />
			#radioButton(objectName="user", property="showOnSite", tagValue="0", label="No ",labelPlacement="after")#
			<div class="separator"></div>
		</div>
		
		<div class="col-sm-6">
			<label>Full Last Name on Website?</label><br>
			#radioButton(objectName="user", property="fullLastname", tagValue="1", label="Yes ",labelPlacement="after")#<br />
			#radioButton(objectName="user", property="fullLastname", tagValue="0", label="No ",labelPlacement="after")#
			<div class="separator"></div>
		</div>
		
		<div class="col-sm-6">
			<label>Email confirmed?</label><br>
			#radioButton(objectName="user", property="securityApproval", tagValue="1", label="Yes ",labelPlacement="after")#<br />
			#radioButton(objectName="user", property="securityApproval", tagValue="0", label="No ",labelPlacement="after")#
			<div class="separator"></div>
		</div>
		
		<div class="col-sm-6">
			<label>Multisite User?</label><br>
			#radioButton(objectName="user", property="globalized", tagValue="1", label="Yes ",labelPlacement="after")#<br />
			#radioButton(objectName="user", property="globalized", tagValue="0", label="No ",labelPlacement="after")#
			<div class="separator"></div>
		</div>
		
		<br class="clear">
		
	</cfif>
	
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

		<cfif checkPermission("user_save_others")>	
			<div class="data-block">
				<section>
					#bselecttag(
						name			= "usergroups",
						label			= 'Select Group',
						options			= usergroups,
						selected		= usergroup.id,
						valueField 		= "id", 
						textField 		= "groupname"
					)#
				</section>
			</div>	
		</cfif>
		
		<cfif checkPermission("user_save_others") OR user.showOnSite eq 0>	
			<div class="data-block">
				<section>
					<cfparam name="user.portrait" default="">
					#bImageUploadTag(
						name			= "portrait",
						value			= "", 	
						filepath		= "/assets/userpics/#user.id#.jpg",
						label			= 'Portrait'
					)#
				</section>
			</div> 	
		</cfif>
		
		</div>
		<div class="rightBottomBox  hidden-xs hidden-sm">
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="users", currentStatus=currentStatus, rightBottomClass="col-sm-3")#	
		</div>
	</cfsavecontent>
	<cfset contentFor(rightColumn = rightColumn)>
	<cfset contentFor(formWrapStart = startFormTag(route="admin~Action", module="admin", controller="users", action="save", enctype="multipart/form-data", id="fileupload"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>	
		
</cfoutput>