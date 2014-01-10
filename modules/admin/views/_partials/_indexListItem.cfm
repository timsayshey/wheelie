<cfoutput>
	<cfparam name="gridActive">
	<cfparam name="currentId">
	<cfparam name="title">
	<cfparam name="tags">
	<cfparam name="description">
	<cfparam name="thumbPath" default="">
	<cfparam name="controllerName" default="">
	<cfparam name="overlayImage" default="/assets/images/overlay.png">
	<cfset editPath = urlFor(							
						route		= "moduleId",
						module	= "admin",
						controller	= controllerName,
						action		= "edit",
						id			= currentId)> 
	<cfparam name="href" default="href='#editPath#'">
	
	<!--- Grid Item --->		
	<cfif len(gridActive)>				
	
		<div class="listbox col-sm-6 col-xs-12 col-md-6 col-lg-4">
			#checkboxtag(
				name	= 'deletelist', 
				class	= "itemselector",
				value	= currentId
			)#	
			<div class="well bootsnipp-thumb">								
				
				<cfif len(thumbPath)>
					<a #href# class="filethumb col-md-3 col-sm-3 col-xs-4 roundy" style="												
						<cfif fileExists(thumbPath)>
							background-image:url('#thumbPath#');
						</cfif>
					">
						<img src="#overlayImage#">
					</a>
					<div class="col-md-9 col-sm-9 col-xs-8">
				<cfelse>
					<div class="col-md-12 col-sm-12 col-xs-12">
				</cfif>
				
					<a #href# class="boxtitle">#title#</a>								
					<br class="clear" />
					
					#tags#
					
					<div class="pull-right">								
						
						#linkTo(
							text		= '<span class="elusive icon-edit"></span> Edit',
							class		= "btn btn-primary btn-xs",
							route		= "moduleId",
							module	= "admin",
							controller	= controllerName,
							action		= "edit",
							id			= currentId
						)#				
																								
						#linkTo(
							text		= '<span class="elusive icon-trash"></span> Delete',
							class		= "btn btn-danger btn-xs confirmDelete",
							route		= "moduleId",
							module	= "admin",
							controller	= controllerName,
							action		= "delete", 
							id			= currentId
						)#	
						
					</div>		
					
				</div>
				<br class="clear" />
			</div>
		</div>
		
	<!--- List Item --->		
	<cfelse>
		
		<div class="row listitem well">
		
			#checkboxtag(
				name	= 'deletelist', 
				class	= "itemselector",
				value	= currentId
			)#
			
			<cfif len(thumbPath)>
				<div class="col-sm-2">
					<a href="javascript:void(0)" data-toggle="modal" data-target="##details_#currentId#" class="filethumb roundy" style="							
						<cfif fileExists(thumbPath)>
							background-image:url('#thumbPath#');
						</cfif>
					">
						<img src="#overlayImage#">
					</a>
				</div>
				<div class="col-sm-10">
			<cfelse>
				<div class="col-sm-12 leftpadding">
			</cfif>
			
				<div class="col-sm-9">
					<h3>#title#</h3>	
					<cfif len(sanitize(description))>
						<p>#sanitize(description)#</p>
					</cfif>
					
					<span class="tags">#tags#</span>
				</div>
				<div class="col-sm-3 align-right">
					#linkTo(
						text		= '<span class="elusive icon-edit"></span> Edit',
						class		= "btn btn-primary btn-s",
						route		= "moduleId",
						module	= "admin",
						controller	= controllerName,
						action		= "edit",
						id			= currentId
					)#				
																							
					#linkTo(
						text		= '<span class="elusive icon-trash"></span> Delete',
						class		= "btn btn-danger btn-s confirmDelete",
						route		= "moduleId",
						module	= "admin",
						controller	= controllerName,
						action		= "delete", 
						id			= currentId
					)#	
				</div>
			</div>
		</div>		
	</cfif>		
	
	<!--- Reset href --->
	<cfset StructDelete(variables,"href")>
</cfoutput>