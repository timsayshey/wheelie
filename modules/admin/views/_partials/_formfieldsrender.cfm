<cfoutput>
	<cfparam name="fieldclass" default="">
	<cfparam name="dataFields" type="query">
	
	<cfloop query="dataFields">
	
		<cfset selectTagValues = ListToArray(replaceLineBreaksWithCommas(dataFields.fieldvalues))>
		<cfif dataFields.type eq "text">
			<div class="#fieldclass#">
				#btextfieldtag(
					name		= "fielddata[#id#]", 	
					label		= dataFields.name,	
					value		= !isNull(dataFields.fielddata) ? dataFields.fielddata : ""
				)#
			</div>
		<cfelseif dataFields.type eq "select">
			<cfset ArrayPrepend(selectTagValues,"")>
			<div class="#fieldclass#">
				#bselecttag(
					name		= "fielddata[#id#]",
					label		= dataFields.name,
					selected	= !isNull(dataFields.fielddata) ? dataFields.fielddata : "",
					options		= selectTagValues					
				)#
			</div>
		<cfelseif dataFields.type eq "textarea">
			#btextareatag(
				name 		= "fielddata[#id#]", 
				label		= dataFields.name,						
				content		= !isNull(dataFields.fielddata) ? dataFields.fielddata : "",
				style		= "height:75px",
				class		= dataFields.wysiwyg eq 1 ? "ckeditor" : "form-control"				
			)#
		<cfelseif dataFields.type eq "headline">
			<h3 class="formHeader">#dataFields.name#</h3>
		<cfelseif dataFields.type eq "separator">
			#includePartial(partial="/_partials/formSeperator")#
		<cfelseif dataFields.type eq "radio">
			<div class="#fieldclass#">
				<label>#dataFields.name#</label><br>
				<cfloop array="#selectTagValues#" index="value">
					<cfset radioVal = !isNull(dataFields.fielddata) ? dataFields.fielddata : "">
					#radioButtonTag(
						name			= "fielddata[#id#]", 
						value			= value, 
						label			= value,
						labelPlacement	= "after",
						checked			= radioVal eq value ? "true" : "false"
					)#<br />
				</cfloop>
				<div class="separator"></div>			
			</div>
		<cfelseif dataFields.type eq "contentblock">
			#dataFields.contentblock#
		</cfif>
	</cfloop>

</cfoutput>