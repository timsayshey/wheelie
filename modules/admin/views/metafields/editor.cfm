<cfoutput>
	
	<script type="text/javascript">
		function handleFieldtypeChange(currVal)
		{
			$(".fieldvalues,.contentblock,.wysiwygtoggle").hide();	
			if( $(".fieldvalues").hasClass( currVal ) )
			{
				$(".fieldvalues").show();
			}
			else if ( $(".contentblock").hasClass( currVal ) )
			{
				$(".contentblock").show();
			}
			else if (currVal == 'textarea')
			{
				$(".wysiwygtoggle").show();
			}
		}
		
		$(function() {
			$("table").responsiveTable();
			
			handleFieldtypeChange($(".fieldtype").val());
			$(".fieldtype").change(function() {
				handleFieldtypeChange($(this).val());
			});
		});
	</script>
	
	<script src="/views/layouts/admin/assets/js/page.js" type="text/javascript"></script>
	
	<cfset contentFor(plupload		= true)>
	<cfset contentFor(formy			= true)>
	
	<cfif isNull(params.id)>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Add Field')>
	<cfelse>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-pencil"></span> Edit Field')>
	</cfif>
	 
	<cfset contentFor(headerButtons = 
		'<li class="headertab">
			#linkTo(
				text		= "<span class=""elusive icon-arrow-left""></span> Go Back",
				route		= "admin~Field",
				controller	= "metafields",
				action		= "index",
				modelName	= params.modelname,
				class		= "btn btn-default",
				params		= buttonParams
			)#	
		</li>')>
	
	<cfif !isNull(params.id)>
		<cfset isNew = false>
	<cfelse>
		<cfset isNew = true>
	</cfif>
	
	<cfif !isNew>
		#hiddenfield(objectName='metafield', property='id', id="metafieldid")#
		#hiddenFieldTag("id",params.id)#
	</cfif>		
	
	#hiddenfieldtag(name='metafield[modelid]', value=params.modelid)#		
	
	<div class="col-sm-6 ">		
		#btextfield(
			objectName	= 'metafield', 
			property	= 'name', 
			label		= 'Field Name',
			placeholder	= "Ex: Coolest Field Ever"
		)#
	</div>
    
    <div class="col-sm-6 ">		
		#btextfield(
			objectName	= 'metafield', 
			property	= 'identifier', 
			label		= 'Identifier',
			placeholder	= "Ex: coolest-field-ever"
		)#
	</div>
	
	<div class="col-sm-6 ">	
		#bselecttag(
			label	= 'Field Type',
			name	= 'metafield[type]',
			options	= [
				{text="Text",value="text"},
				{text="Textarea",value="textarea"},
				{text="Dropdown Options",value="select"},
				{text="Radio Options",value="radio"},
				{text="Headline",value="headline"},
				{text="Separator",value="separator"},
				{text="Content",value="contentblock"}
			],
			selected= metafield.type,
			class	= "selectize fieldtype",
			append	= ""
		)#
	</div>
	
	<br class="clear">
	
	<div class="col-sm-6 fieldvalues radio select">		
		#btextarea(
			objectName	= 'metafield', 
			property	= 'fieldvalues', 
			label		= 'Field Values'
		)#
	</div>
	
	<div class="col-sm-12 contentblock">		
		#btextarea(
			objectName	= 'metafield', 
			property	= 'contentblock', 
			label		= 'Content',
			class		= 'ckeditor'
		)#
	</div>
	<div class="col-sm-6 wysiwygtoggle">
		<label>Enable Visual Text Editor?</label><br>
		<cfif !isNumeric(metafield.wysiwyg)>
			<cfset metafield.wysiwyg = 0>
		</cfif>
		#radioButton(objectName="metafield", property="wysiwyg", tagValue="1", label="Yes ",labelPlacement="after")#<br />
		#radioButton(objectName="metafield", property="wysiwyg", tagValue="0", label="No ",labelPlacement="after")#
		<div class="separator"></div>
	</div>
	<br class="clear">
	
	<cfsavecontent variable="rightColumn">
		<div class="rightbarinner">			
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="metafields", currentStatus="")#					
		</div>
		</div>
	</cfsavecontent>
	<cfset contentFor(rightColumn = rightColumn)>
	<cfset contentFor(formWrapStart = startFormTag(
		route		= "admin~Field",
		controller	= "metafields",
		modelName	= params.modelname, 
		action		= "save",
		params		= buttonParams
	))>		
	<cfset contentFor(formWrapEnd = endFormTag())>	
	
</cfoutput>