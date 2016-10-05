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
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Add Site')>
	<cfelse>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Edit Site')>
	</cfif>
	
	<cfset contentFor(headerButtons = 
		'<li class="headertab">
			#linkTo(
				text		= "<span class=""elusive icon-arrow-left""></span> Go Back",
				route		= "admin~Action", 
				module		= "admin",
				controller	= "sites", 
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
		#hiddenfield(objectName='site', property='id', id="siteid")#
		#hiddenFieldTag("id",params.id)#
	</cfif>		
		
	<div class="col-sm-6 ">		
		#btextfield(
			objectName	= 'site', 
			property	= 'name', 
			label		= 'Site Name',
			placeholder	= "Ex: Coolest Site Ever"
		)#
	</div>
	
	<div class="col-sm-6 ">		
		#btextfield(
			objectName	= 'site', 
			property	= 'urlid', 
			label		= 'Site Domain',
			placeholder	= "Ex: mydomain.com"
		)#
	</div>
	
	<cfdirectory action="list" directory="#expandPath('/views/themes/')#" name="themeFolders">
	
	<cfset themeOptions = []>
	<cfloop query="themeFolders">
		<cfif type eq "Dir">
			<cfset ArrayAppend(themeOptions, {text=name,value=name})>
		</cfif>
	</cfloop>
	
	<div class="col-sm-6 ">
		#bselect(
			objectName 	= 'site', 
			label		= 'Theme',
			property 	= 'theme', 
			options		= themeOptions
		)#
	</div>
	
	<div class="col-sm-6 ">		
		#btextfield(
			objectName	= 'site', 
			property	= 'emailMatchOtherDomains', 
			label		= 'Alternative Domains for Email Match',
			placeholder	= "Ex: mydomain.com, otherdomain.com"
		)#
	</div>
	
	<div class="col-sm-6 ">		
		#btextfield(
			objectName	= 'site', 
			property	= 'urlExtension', 
			label		= 'Url Extension',
			placeholder	= "Ex: html"
		)#
	</div>	
	
	<br class="clear">
	
	<div class="col-sm-6">
		<label>SSL Enabled</label><br>
		#radioButton(objectName="site", property="sslenabled", tagValue="1", label="Yes ",labelPlacement="after")#<br />
		#radioButton(objectName="site", property="sslenabled", tagValue="0", label="No ",labelPlacement="after")#
		<div class="separator"></div>
	</div>
	
	<div class="col-sm-6">
		<label>Disable Registration</label><br>
		#radioButton(objectName="site", property="registrationDisabled", tagValue="1", label="Yes ",labelPlacement="after")#<br />
		#radioButton(objectName="site", property="registrationDisabled", tagValue="0", label="No ",labelPlacement="after")#
		<div class="separator"></div>
	</div>
	
	<div class="col-sm-6">
		<label>Require User's Email Match Domain</label><br>
		#radioButton(objectName="site", property="emailMatchDomainRequired", tagValue="1", label="Yes ",labelPlacement="after")#<br />
		#radioButton(objectName="site", property="emailMatchDomainRequired", tagValue="0", label="No ",labelPlacement="after")#
		<div class="separator"></div>
	</div>
	
	<div class="col-sm-6">
		<label>Enable Admin Theme</label><br>
		#radioButton(objectName="site", property="enableAdminTheme", tagValue="1", label="Yes ",labelPlacement="after")#<br />
		#radioButton(objectName="site", property="enableAdminTheme", tagValue="0", label="No ",labelPlacement="after")#
		<div class="separator"></div>
	</div>
		
	<br class="clear">
	
	<div id="siteOptions">							
		#bLabel(label="Site options",help="Set various aspects of the site here")#
		<br class="clear" />
		
		#includePartial(partial="/_partials/bulkOptionsForm",qOptions=siteOptions)#								
	</div>
	
	<br class="clear" />
	
	<cfsavecontent variable="rightColumn">
		<div class="rightbarinner">			
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="sites", currentStatus="")#					
		</div>
		</div>
	</cfsavecontent>
	<cfset contentFor(rightColumn = rightColumn)>
	<cfset contentFor(formWrapStart = startFormTag(route="admin~Action", module="admin", controller="sites", action="save"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>	
	
</cfoutput>