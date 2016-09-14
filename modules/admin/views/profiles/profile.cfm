<cftry>
	<cfoutput>
	
		<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> #capitalize(user.firstName)# #capitalize(user.lastName)#')>
		<cfsavecontent variable="topBtns">
			<li class="headertab">
			
				<cfif params.id eq session.user.id OR checkPermission("user_save_others")>
					#linkTo(
						text		= "<span class=""elusive icon-edit""></span> Edit",							
						route		= "admin~Id",
						module		= "admin",
						controller	= "users",
						action		= "edit",
						id			= params.id,
						class		= "btn btn-default"
					)#		
				</cfif>
				
				#linkTo(
					text		= "<span class=""elusive icon-arrow-left""></span> Go Back",
					route		= "admin~peopleTypes", 
					currentGroup= user.usergroupid,
					class		= "btn btn-default"  
				)#	
			</li>
		</cfsavecontent>
		<cfset contentFor(headerButtons = topBtns)>
				
		<div id="about" style="margin:0 auto; text-align:center; max-width:500px">
		
			<cfset thumbpath = fileExists(expandPath("/assets/userpics/#user.id#.jpg")) ? "/assets/userpics/#user.id#.jpg" : '/assets/img/user_thumbholder.jpg'>
			
			<cfset thumbpathfull = fileExists(expandPath("/assets/userpics_full/#user.id#.jpg")) ? "/assets/userpics_full/#user.id#.jpg" : '/assets/img/user_thumbholder.jpg'>
			
			<a data-lightbox="image-1" href='#thumbpathfull#' class="filethumb col-md-3 col-sm-3 col-xs-4 roundy" style="												
				<cfif fileExists(expandPath(thumbPath))>
					background-image:url('#thumbPath#');
				</cfif>
			">
				<img src="/assets/img/overlay.png">
			</a>
			
			<h3 class="media-heading">#capitalize(user.firstName)# #capitalize(user.lastName)# #user.designatory_letters#</h3>
			#user.jobtitle#<br><br>
			
			<br class="clear"><br>
			
			<div style="text-align:left;">
				
				<cfif len(user.start_date)>
					<span><strong>Start Date: </strong></span>
					#DateFormat(user.start_date,"MMMM D, YYYY")#<hr>
				</cfif>	
				
				<cfif len(user.birthday)>
					<span><strong>Birthday: </strong></span>
					#DateFormat(user.birthday,"MMMM D")#<hr>
				</cfif>
				
				<cfif len(user.email)>
					<span><strong>Email: </strong></span>
					#user.email#<hr>
				</cfif>
				
				<cfif len(user.phone)>
					<span><strong>Phone: </strong></span>
					#user.phone#<hr>
				</cfif>
				
				<cfif len(user.about)>
					<span><strong>About: </strong></span>
					#user.about#<hr>
				</cfif>
				
				<!--- Get Custom Fields --->
				#includePartial(partial="/_partials/presentFieldData")#
				
			</div>
			
		</div>
		
		<br class="clear">
		
	</cfoutput>
	<cfcatch>
		<cfdump var="#cfcatch#">
	</cfcatch>
</cftry>