<cfoutput>
	<cfparam name="gridActive">
	<cfparam name="currentId">
	<cfparam name="title">
	<cfparam name="tags">
	<cfparam name="description">
	<cfparam name="thumbPath" default="">
	<cfparam name="controllerName" default="">
	<cfparam name="appendBtns" default="">
	<cfparam name="prependBtns" default="">	
	<cfparam name="overlayImage" default="/assets/img/overlay.png">

	<cfset editPath = urlFor(							
		route		= "admin~Id",
		module		= "admin",
		controller	= controllerName,
		action		= "edit",
		id			= currentId
	)> 

	<cfparam name="href" default="href='#editPath#'">
	<!--- Grid Item --->		
	<cfif len(gridActive)>				
	
		<div class="listbox col-md-6" rel="#currentId#">
			<cfif checkPermission("user_save_others")>
				#checkboxtag(
					name	= 'deletelist', 
					class	= "itemselector",
					value	= currentId
				)#	
			</cfif>
			<div class="well bootsnipp-thumb">		
			
				<cfif len(thumbPath)>
				
					<a #href# class="filethumb col-md-3 col-sm-3 col-xs-4 roundy" style="		
															
						<cfif fileExists(expandPath(thumbPath))>
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
						<cfif isNull(params.rearrange)>
							#prependBtns#

							<cfif checkPermission("user_save_others")>
								#linkTo(
									text		= '<span class="elusive icon-edit"></span> Edit',
									class		= "btn btn-primary btn-xs",
									route		= "admin~Id",
									module		= "admin",
									controller	= controllerName,
									action		= "edit",
									id			= currentId
								)#		
								
								<cfset urlparams = "">
								<cfif !isNull(params.currentGroup)>
									<cfset urlparams = "currentGroup=#params.currentGroup#">
								</cfif>
																							
								#linkTo(
									text		= '<span class="elusive icon-trash"></span> Delete',
									class		= "btn btn-danger btn-xs confirmDelete",
									route		= "admin~Id",
									module		= "admin",
									controller	= controllerName,
									action		= "delete", 
									id			= currentId,								
									params		= urlparams
								)#
							</cfif>

							#appendBtns#

						<cfelse>	
							<span class='elusive icon-move'></span>
						</cfif>
					</div>					
					
					<cfif !isNull(params.currentGroup)> 
						<div class="userdetails">
                            <cfif len(trim(qUsers.jobtitle))>
							<span class="elusive icon-paper-clip-alt"></span> #qUsers.jobtitle#
                            <br>
							</cfif>
							<cfif len(trim(qUsers.email))>
                            <span class="elusive icon-envelope-alt"></span> #qUsers.email#
                            <br>
							</cfif>
							<cfif len(trim(qUsers.phone))>
                            <span class="elusive icon-phone-alt"></span> #qUsers.phone#
							</cfif>
						</div>
					</cfif>		
					
				</div>
				<br class="clear" />
			</div>
		</div>
		
	<!--- List Item --->		
	<cfelse>
		
		<div class="row listitem well">
			<cfif checkPermission("user_save_role_admin")>
				#checkboxtag(
					name	= 'deletelist', 
					class	= "itemselector",
					value	= currentId
				)#
			</cfif>
			
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
				
				<cfif checkPermission("user_save_role_admin")>
					<div class="col-sm-3 align-right">
						#linkTo(
							text		= '<span class="elusive icon-edit"></span> Edit',
							class		= "btn btn-primary btn-s",
							route		= "admin~Id",
							module	= "admin",
							controller	= controllerName,
							action		= "edit",
							id			= currentId
						)#				
																								
						#linkTo(
							text		= '<span class="elusive icon-trash"></span> Delete',
							class		= "btn btn-danger btn-s confirmDelete",
							route		= "admin~Id",
							module	= "admin",
							controller	= controllerName,
							action		= "delete", 
							id			= currentId
						)#	

						#appendBtns#
					</div>
				</cfif>
				
			</div>
		</div>		
	</cfif>		
	
	<!--- Reset href --->
	<cfset StructDelete(variables,"href")>
</cfoutput>