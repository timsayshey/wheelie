<cfoutput>
	
	<script type="text/javascript">
		$(function() {
			$("table").responsiveTable();
		});
	</script>
	
	<script src="/views/layouts/admin/assets/js/page.js" type="text/javascript"></script>
	
	<cfset contentFor(plupload		= true)>
	<cfset contentFor(formy			= true)>
	
	<cfif isNull(params.id)>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Add Usergroup')>
	<cfelse>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Edit Usergroup')>
	</cfif>
	
	<cfset contentFor(headerButtons = 
		'<li class="headertab">
			#linkTo(
				text		= "<span class=""elusive icon-arrow-left""></span> Go Back",
				route		= "admin~Action", 
				module		= "admin",
				controller	= "usergroups", 
				action		= "index", 
				class		= "btn btn-default"
			)#	
		</li>')>
	
	<cfif !isNull(params.id)>
		<cfset isNew = false>
	<cfelse>
		<cfset isNew = true>
	</cfif>
	
	<cfif !isNew>
		#hiddenfield(objectName='usergroup', property='id', id="usergroupid")#
		#hiddenFieldTag("id",params.id)#
	</cfif>		
		
	<div class="col-sm-6 ">		
		#btextfield(
			objectName	= 'usergroup', 
			property	= 'groupname', 
			label		= 'Usergroup Name',
			placeholder	= "Ex: Coolest Usergroup Ever"
		)#
	</div>
	
	<div class="col-sm-6 ">		
		<label>Default group for new registrations?</label><br>
		#radioButton(objectName="usergroup", property="defaultgroup", tagValue="1", label="Yes ",labelPlacement="after")#<br />
		#radioButton(objectName="usergroup", property="defaultgroup", tagValue="0", label="No ",labelPlacement="after")#
	</div>
	
	<cfif checkPermission("superadmin")>
		#includePartial(partial="/_partials/formSeperator")#		
		<h3 class="formHeader">Super Admin Options</h3>
		<div class="col-sm-6 ">		
			<label>Available to all sites?</label><br>
			#radioButton(objectName="usergroup", property="globalized", tagValue="1", label="Yes ",labelPlacement="after")#<br />
			#radioButton(objectName="usergroup", property="globalized", tagValue="0", label="No ",labelPlacement="after")#
		</div>
        
		<cfset roles = ListToArray(application.rbs.roleslist)>	
        
        <div class="col-sm-6">	
            #bselect(
                includeBlank	= true,
				objectName		= 'usergroup',
                property		= 'role',
                label			= 'Role',
                options			= roles
            )#
        </div>
            
	</cfif>
	
	<br class="clear">
	
	<cfsavecontent variable="rightColumn">
		<div class="rightbarinner">			
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="usergroups", currentStatus="")#					
		</div>
		</div>
	</cfsavecontent>
	<cfset contentFor(rightColumn = rightColumn)>
	<cfset contentFor(formWrapStart = startFormTag(route="admin~Action", module="admin", controller="usergroups", action="save"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>	
	
</cfoutput>