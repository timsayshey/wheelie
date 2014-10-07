<cfoutput>
	
	<script type="text/javascript">
		$(function() {
			$("table").responsiveTable();
		});
	</script>
	
	<cfset javaScriptIncludeTag(sources="js/admin/page.js", head=true)>
	
	<cfset contentFor(plupload		= true)>
	<cfset contentFor(formy			= true)>
	
	<cfif isNull(params.id)>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Add Form')>
	<cfelse>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Edit Form')>
	</cfif>
	
	<cfset contentFor(headerButtons = 
		'<li class="headertab">
			#linkTo(
				text		= "<span class=""elusive icon-arrow-left""></span> Go Back",
				route		= "admin~Action", 
				module		= "admin",
				controller	= "forms", 
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
		#hiddenfield(objectName='qform', property='id', id="formid")#
		#hiddenFieldTag("id",params.id)#
	</cfif>		
		
	#btextfield(
		objectName	= 'qform', 
		property	= 'name', 
		label		= 'Form Name',
		placeholder	= "Ex: Coolest form Ever"
	)#
		 
	#includePartial(partial="/_partials/formSeperator")#
	
	#btextarea(
		objectName 	= 'qform', 
		property 	= 'successcontent',
		label 		= "Success Content",
		class 		= 'ckeditor'
	)#
	
	#btextarea(
		objectName 	= 'qform', 
		property 	= 'successembed',
		label 		= "Success Embed Codes"
	)#
	
	#btextarea(
		objectName 	= 'qform', 
		property 	= 'failcontent',
		label 		= "Fail Content",
		class 		= 'ckeditor'
	)#
	
	#btextarea(
		objectName 	= 'qform', 
		property 	= 'failembed',
		label 		= "Fail Embed Codes"
	)#

	
	<br class="clear">
	 
	<cfsavecontent variable="rightColumn">
		<div class="data-block">
			<section>
			#bselecttag(
				name			= "formusers",
				class			= "formuserselectize",
				multiple		= "true",
				label			= 'Email To',
				options			= formusers,
				selected		= selectedformusers,
				valueField 		= "id", 
				textField 		= "lastname"
			)#	
			
			#bselecttag(
				name			= "ccformusers",
				class			= "formuserselectize",
				multiple		= "true",
				label			= 'Email CC',
				options			= formusers,
				selected		= selectedccformusers,
				valueField 		= "id", 
				textField 		= "lastname"
			)#	
			<script type="text/javascript">
				$(function() {
					window.$catselectize = $('.formuserselectize').selectize({
						maxItems: null
					});
				});
			</script>
			</section>
		</div>
		
		<div class="rightbarinner">			
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="forms", currentStatus="")#					
		</div>
		</div>
	</cfsavecontent>
	<cfset contentFor(rightColumn = rightColumn)>
	<cfset contentFor(formWrapStart = startFormTag(route="admin~Action", module="admin", controller="forms", action="save"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>	
	
</cfoutput>