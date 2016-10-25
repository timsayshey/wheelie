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
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Add Form')>
	<cfelse>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Edit Form')>
	</cfif>
	
	<cfset contentFor(headerButtons = 
		'<li class="headertab">
			#linkTo(
				text		= "<span class=""elusive icon-arrow-left""></span> Go Back",
				route		= "public~Action", 
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
		
	#bcheckbox(
		objectName	= 'qform', 
		property	= "templated",
		class 		= "templated",
		label		= "Custom Template? "
	)#
	
	<div class="templateCode">
		#btextarea(
			objectName 	= 'qform', 
			property 	= 'template',
			label 		= "Template Code",
			id 			= "CodeMirror"
		)#
		<cfif !isNull(metafields) AND isQuery(metafields)>		
			<cfloop query="metafields">
				<span class="label label-primary">#type#: #identifier#</span>
			</cfloop>
		</cfif>
	</div>

	<script type="text/javascript">
		$(function() {
			checkTemplated();
			$("##qform-templated").change(function(){
		        checkTemplated();
		    });
		});

		function checkTemplated() {
			if($("##qform-templated").is(":checked")) {
	            $(".templateCode").show();	
	        } else {
	        	$(".templateCode").hide();	
	        }    
	    }		
	</script>

	#includePartial(partial="/_partials/codemirror")#
		 
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
				textField 		= "email"
			)#	
			
			#bselecttag(
				name			= "ccformusers",
				class			= "formuserselectize",
				multiple		= "true",
				label			= 'Email CC',
				options			= formusers,
				selected		= selectedccformusers,
				valueField 		= "id", 
				textField 		= "email"
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