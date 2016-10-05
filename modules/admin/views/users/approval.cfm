<cfoutput>
	<cfif !checkPermission("user_noApprovalNeeded")>	
		Access Denied
		<cfabort>
	</cfif>

	<cftry>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-user"></span> Pending Staff Changes')>
	
		<cfloop query="users">
			<div class="well">
			<h1>#users.firstname# #users.lastname#</h1>
			
			#startFormTag(route="admin~Action", module="admin", controller="users", action="save")#	
				#hiddenFieldTag(name="user[approval_flag]", value="0")#
				
				<cfif users.zx_firstname neq users.firstname>
				#btextfieldtag( 
					label = "First Name", 
					name  = "user[zx_firstname]",
					value = users.firstname
				)#
				Currently: #users.zx_firstname#<br><br>

				</cfif>
				
				<cfif users.zx_lastname neq users.lastname>
				#btextfieldtag(
					label = "Last Name",
					name  = "user[zx_lastname]",
					value = users.lastname,
					help  = 'Currently: #users.zx_lastname#'					
				)#
				Currently: #users.zx_lastname#<br><br>
				</cfif>
				
				<cfif users.zx_designatory_letters neq users.designatory_letters>
				#btextfieldtag(
					label = "Designatory Letters",
					name  = "user[zx_designatory_letters]",
					value = users.designatory_letters,
					help  = 'Currently: #users.zx_designatory_letters#'					
				)#
				Currently: #users.zx_designatory_letters#<br><br>
				</cfif>
				
				<cfif users.zx_jobtitle neq users.jobtitle>
				#btextfieldtag(
					label = "Job Title",
					name  = "user[zx_jobtitle]",
					value = users.jobtitle,
					help  = 'Currently: #users.zx_jobtitle#'					
				)#
				Currently: #users.zx_jobtitle#<br><br>
				</cfif>
				
				<cfif users.zx_about neq users.about>
				#btextareatag( 
					label = "About",
					name  = "user[zx_about]",
					content = users.about,		
					class = "ckeditor",
					help  = 'Currently: #users.zx_about#'
				)#
				Currently: #users.zx_about#<br><br>
				</cfif>
				
				<cfset photoPath = "/assets/userpics_pending/#users.id#.jpg">
				<cfif FileExists(expandPath(photoPath))>
					<div class="row">
						<div class="col-sm-2">
							<img src="/assets/userpics/#users.id#.jpg" style="width:100px;">
							<br>
							Current Photo
						</div>
						<div class="col-sm-2">
							<img src="#photoPath#" style="width:100px;"><br>
							New Photo<br>
							<input type="radio" name="handlePortrait" value="live"> Make Portrait live<br>							
							<input type="radio" name="handlePortrait" value="delete"> Delete Portrait<br>
							<input type="radio" name="handlePortrait" value="notlive"> Do nothing<br><br>
						</div>
					</div>
					<br class="clear">
				</cfif>
				
				<input type="hidden" name="user[id]" value="#users.id#">
				<button type="submit" name="submit" value="published" class="btn btn-primary btn-lrg">Approve #users.firstname# #users.lastname#</button>
			#endFormTag()#
			</div>
			
			<br><br>

		</cfloop>
		
	
	<cfcatch><cfdump var="#cfcatch#"></cfcatch>
	</cftry>
</cfoutput>
		
