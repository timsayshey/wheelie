<cfoutput>
	<cfparam name="fieldclass" default="">
	<cfparam name="dataFields" type="query">
	
	<cfloop query="dataFields">
	
		<cfset fieldDivStart =  ''>
		<cfset fieldDivEnd =''>		
		<cfif IsBoolean(dataFields.divwrap) AND dataFields.divwrap>
			<cfset fieldDivStart = '<div class="#dataFields.divclass#">'>
			<cfset fieldDivEnd ='</div>'>		
		</cfif>
		
		<cfset selectTagValues = ListToArray(replaceLineBreaksWithCommas(dataFields.fieldvalues))>
		
		#dataFields.prepend#		
		#fieldDivStart#
		
		<cfif dataFields.type eq "text">			
			#btextfieldtag(
				name		= "fielddata[#id#]", 	
				label		= dataFields.labelplacement eq 'before' ? dataFields.name : "",	
				value		= !isNull(dataFields.fielddata) ? dataFields.fielddata : "",
				style		= dataFields.styleattribute,
				class		= "form-control #len(trim(dataFields.class)) ? dataFields.class : ''#",
				placeholder = dataFields.labelplacement eq "overlay" ? dataFields.name : ""
			)#
				
		<cfelseif dataFields.type eq "select">
			<cfset ArrayPrepend(selectTagValues,"")>			
			#bselecttag(
				name		= "fielddata[#id#]",
				label		= dataFields.labelplacement eq 'before' ? dataFields.name : "",
				selected	= !isNull(dataFields.fielddata) ? dataFields.fielddata : "",
				options		= selectTagValues,
				class		= "form-control #len(trim(dataFields.class)) ? dataFields.class : ''#",
				style		= dataFields.styleattribute		
			)#			
			
		<cfelseif dataFields.type eq "textarea">
			#btextareatag(
				name 		= "fielddata[#id#]", 
				label		= dataFields.labelplacement eq 'before' ? dataFields.name : "",						
				content		= !isNull(dataFields.fielddata) ? dataFields.fielddata : "",
				style		= "height:75px;#dataFields.styleattribute#",
				class		= dataFields.wysiwyg eq 1 ? "ckeditor" : "form-control",
				placeholder = dataFields.labelplacement eq "overlay" ? dataFields.name : ""			
			)#
			
		<cfelseif dataFields.type eq "checkbox">
			<cfset inputlabel = dataFields.labelplacement eq "none" ? "" : "<label>#dataFields.name#</label>">
			#dataFields.labelplacement eq "before" ? inputlabel : ""#
			#bcheckboxtag(
				name		= "fielddata[#id#]", 	
				checked		= !isNull(dataFields.fielddata) AND IsBoolean(dataFields.fielddata) AND dataFields.fielddata OR !isNull(dataFields.checked) AND dataFields.checked ? true : false,
				style		= dataFields.styleattribute,
				append		= ""
			)#	
			#dataFields.labelplacement eq "after" ? inputlabel : ""#
			
		<cfelseif dataFields.type eq "headline">
			<h3 class="formHeader">#dataFields.name#</h3>
			
		<cfelseif dataFields.type eq "label">
			<label class="#len(trim(dataFields.class)) ? dataFields.class : ''#">#dataFields.name#</label><br>
			
		<cfelseif dataFields.type eq "separator">
			#includePartial(partial="/_partials/formSeperator")#			 
			
		<cfelseif dataFields.type eq "submit">
			<button type="submit" class="#len(trim(dataFields.class)) ? dataFields.class : 'btn btn-sm btn-primary btn-block'#">#dataFields.name#</button>	
				
		<cfelseif dataFields.type eq "radio">			
			<label>#dataFields.name#</label><br>
			<cfloop array="#selectTagValues#" index="value">
				<cfset radioVal = !isNull(dataFields.fielddata) ? dataFields.fielddata : "">
				#radioButtonTag(
					name			= "fielddata[#id#]", 
					value			= value, 
					label			= dataFields.labelplacement eq 'none' ? "" : value,
					labelPlacement	= "after",
					checked			= radioVal eq value ? "true" : "false",
					style			= dataFields.styleattribute
				)#<br />
			</cfloop>
			<div class="separator"></div>
			
		<cfelseif dataFields.type eq "contentblock">
			#dataFields.contentblock#
			
		</cfif>
		
		#fieldDivEnd#
		#dataFields.append#
		
	</cfloop>

</cfoutput>