<cfparam name="field" default="">
<cfset extraFieldArgs = !isNull(extraFieldArgs) ? extraFieldArgs : {}>
<cfset params.fielddata = !isNull(params.fielddata) ? params.fielddata : {}>
<cfoutput>

	<cfset fieldDivStart =  ''>
	<cfset fieldDivEnd = ''>		
	<cfif IsBoolean(field.divwrap) AND field.divwrap>
		<cfset fieldDivStart = '<div class="#field.divclass#">'>
		<cfset fieldDivEnd ='</div>'>		
	</cfif>
	
	<cfset selectTagValues = ListToArray(replaceLineBreaksWithCommas(field.fieldvalues))>
	
	#field.prepend#		
	#fieldDivStart#
	
	<cfif field.type eq "text">
		<cfset fieldArgs = {
			name		= "fielddata[#field.id#]", 	
			label		= field.labelplacement eq 'before' ? field.name : "",	
			value		= !isNull(field.fielddata) ? field.fielddata : "",
			style		= field.styleattribute,
			class		= "form-control #len(trim(field.class)) ? field.class : ''#",			
			placeholder = field.labelplacement eq "overlay" ? field.name : ""
		}>
		<cfset structAppend(fieldArgs,extraFieldArgs,true)>
		#btextfieldtag(argumentcollection=fieldArgs)#
			
	<cfelseif field.type eq "select">
		<cfset ArrayPrepend(selectTagValues,"")>			
		<cfset fieldArgs = {
			name		= "fielddata[#field.id#]",
			label		= field.labelplacement eq 'before' ? field.name : "",
			selected	= !isNull(field.fielddata) ? field.fielddata : "",
			options		= selectTagValues,
			class		= "form-control #len(trim(field.class)) ? field.class : ''#",
			style		= field.styleattribute		
		}>
		<cfset structAppend(fieldArgs,extraFieldArgs,true)>
		#bselecttag(argumentcollection=fieldArgs)#
		
	<cfelseif field.type eq "textarea">
		<cfset fieldArgs = {
			name 		= "fielddata[#field.id#]", 
			label		= field.labelplacement eq 'before' ? field.name : "",						
			content		= !isNull(field.fielddata) ? field.fielddata : "",
			style		= "height:75px;#field.styleattribute#",
			class		= field.wysiwyg eq 1 ? "ckeditor" : "form-control",
			placeholder = field.labelplacement eq "overlay" ? field.name : ""	
		}>
		<cfset structAppend(fieldArgs,extraFieldArgs,true)>
		#btextareatag(argumentcollection=fieldArgs)#
		
	<cfelseif field.type eq "checkbox">
		<cfset inputlabel = field.labelplacement eq "none" ? "" : "<label for='fielddata[#field.id#]'>#field.name#</label>">
		
		<cfset isChecked = !isNull(field.fielddata) AND IsBoolean(field.fielddata) AND field.fielddata OR !isNull(field.checked) AND field.checked ? true : false>
		<cfset isChecked = params.fielddata.containsKey(field.id) ? true : isChecked>

		<cfset fieldArgs = {
			name		= "fielddata[#field.id#]", 
			id 			= "fielddata[#field.id#]", 	
			checked		= isChecked,
			style		= field.styleattribute,
			append		= ""
		}>		
		<cfset structAppend(fieldArgs,extraFieldArgs,true)>		

		#field.labelplacement eq "before" ? inputlabel : ""#
		#bcheckboxtag(argumentcollection=fieldArgs)#
		<input name="#fieldArgs.name#($checkbox)" type="hidden" value="0">
		#field.labelplacement eq "after" ? inputlabel : ""#

	<cfelseif field.type eq "checkbox-options">
		<label class="label-title">#field.name#</label><br>
		<cfloop array="#selectTagValues#" index="value">
			#field.wrapoptions ? "<div class='col-sm-6 option'>" : ""#
			<cfset selectedValues = !isNull(field.fielddata) ? field.fielddata : "">
			<cfset fieldArgs = {
				name			= "fielddata[#field.id#]", 
				value			= value, 
				label			= value,
				labelPlacement	= field.labelplacement,
				checked			= listFindNoCase(selectedValues, value) ? "true" : "false",
				style			= field.styleattribute
			}>
			<cfset structAppend(fieldArgs,extraFieldArgs,true)>
			#checkboxtag(argumentcollection=fieldArgs)#
			#field.wrapoptions ? "</div>" : "<br />"#
		</cfloop>
		<div class="separator"></div>

	<cfelseif field.type eq "headline">
		<h3 class="formHeader">#field.name#</h3>
		
	<cfelseif field.type eq "label">
		<label class="#len(trim(field.class)) ? field.class : ''#">#field.name#</label><br>
		
	<cfelseif field.type eq "separator">
		#includePartial(partial="/_partials/formSeperator")#			 
		
	<cfelseif field.type eq "submit">
		<cfset btnClass = len(trim(field.class)) ? field.class : 'btn btn-sm btn-primary btn-block'>
		<cfset btnClass = extraFieldArgs.containsKey("class") ? extraFieldArgs.class : btnClass>
		<cfset btnId = extraFieldArgs.containsKey("id") ? extraFieldArgs.id : ''>
		<input type="submit" class="#btnClass#" id="#btnId#" value="#field.name#">

	<cfelseif field.type eq "radio">		
		<label class="label-title">#field.name#</label><br>
		<cfloop array="#selectTagValues#" index="value">
			#field.wrapoptions ? "<div class='col-sm-6 option'>" : ""#
			<cfset radioVal = !isNull(field.fielddata) ? field.fielddata : "">
			<cfset fieldArgs = {
				name			= "fielddata[#field.id#]", 
				value			= value, 
				label			= field.labelplacement eq 'none' ? "" : value,
				labelPlacement	= "after",
				checked			= radioVal eq value ? "true" : "false",
				style			= field.styleattribute
			}>
			<cfset structAppend(fieldArgs,extraFieldArgs,true)>
			#radioButtonTag(argumentcollection=fieldArgs)#
			#field.wrapoptions ? "</div>" : "<br />"#
		</cfloop>
		<div class="separator"></div>
		
	<cfelseif field.type eq "contentblock">
		#field.contentblock#

	<cfelseif field.type eq "codeblock">
		#field.codeblock#
			
	</cfif>
	
	#fieldDivEnd#
	#field.append#

</cfoutput>