<cfoutput>

	<cfparam name="showPrependedText" default=false>
					
	<ul class="nav nav-pills nav-stacked col-sm-3">
		<cfloop query="qOptions">
			<cfif editContent OR editLabel OR editAttachment>			
				<!--- <cfset optionName = showPrependedText ? qOptions.id : ListDeleteAt(qOptions.id,1,"_")> --->
				<cfset optionName = qOptions.id>
				<li class="#currentRow eq 1 ? 'active' : ''#"><a href="###cleanseFilename(qOptions.id)#" data-toggle="tab">#formatOptionName(optionName)#</a></li>
			</cfif>
		</cfloop>
	</ul>
	
	<!-- Tab panes -->
	<div class="tab-content col-sm-9">		
		<cfset count = 1>							
		<cfloop query="qOptions">	
			<cfset option = qOptions>
			<cfif editContent OR editLabel OR editAttachment>			
				<div class="tab-pane #count eq 1 ? 'active' : ''#" id="#cleanseFilename(option.id)#">
					
					<cfif option.editLabel>						
						<div class="col-sm-6">		
							#btextfieldtag(
								name			= "options[" & option.id & "[label]]",
								value			= option.label, 			
								label			= "Label"
							)#	
						</div>
					</cfif>
					
					<cfif option.editContent>
						<cfif option.inputtype eq "text">
							<div class="col-sm-6">									
								#btextfieldtag(
									name			= "options[" & option.id & "[content]]",
									value			= option.content, 	
									label			= '#len(option.inputlabel) ? option.inputlabel : "Content"#'
								)#
							</div>
						<cfelseif option.inputtype eq "textarea">
							<br class="clear" />
							#btextareatag(
								name			= "options[" & option.id & "[content]]",
								content			= option.content, 	
								label			= '#len(option.inputlabel) ? option.inputlabel : "Content"#',
								class			= 'ckeditor'
							)#	
						</cfif>	
					</cfif>	
					
					<cfif option.editAttachment>
						<div class="col-sm-6">									
							#bImageUploadTag(
								name			= "options[" & option.id & "[attachment]]",
								value			= option.attachment, 	
								filepath		= option.attachment,
								label			= 'Thumbnail'
							)#
						</div>
					</cfif>								
				</div>
				<cfset count++>
			</cfif>
		</cfloop>
	</div>

</cfoutput>