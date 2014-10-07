<cfoutput>

	<cfset contentFor(clearLayout = true)>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-dashboard"></span> Dashboard')>
	 
	<div class="hero data-block todo-block">
		<section>
		<h2>Welcome to the management area</h2>
		</section>
	</div>
    
	<cfif checkPermission("log_read_others")>
	
	<br class="clear">
	<div class="col-md-12">
		<h1>Admin Info</h1>
		
		<cftry>
		
			<cfset saveTypeButtons = {
				delete = "label-danger",
				update = "label-info",
				create = "label-success"
			}>
		
			<div class="data-block todo-block">
				<header>
					<h2><span class="elusive icon-align-justify"></span> Recent activity</h2>
				</header>
				<section>
					<cfloop query="qLog">
						<strong>#firstname# #lastname#</strong> performed <span class="label #saveTypeButtons[savetype]#">#savetype#</span> to the "#modelid#" record in the #model# model via #controller#' #action# #timeAgoInWords(createdAt)# ago.
						<br /><hr  />
					</cfloop>
					<a data-toggle="modal" href="##myModal" class="btn btn-primary" >See all</a>
				</section>
			</div>
			
			
				<!--- Modal --->
				<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
								<h4 class="modal-title" id="myModalLabel">All user activity</h4>
							</div>
							<div class="modal-body">								
							
								<cfloop query="qLogFull">
									<strong>#firstname# #lastname#</strong> performed <span class="label #saveTypeButtons[savetype]#">#savetype#</span> to the "#modelid#" record in the #model# model via #controller#' #action# #timeAgoInWords(createdAt)# ago.
									<br /><hr  />
									<cfif qLogFull.currentRow eq 100>
										<cfbreak>
									</cfif>
								</cfloop>
																		
							</div>
						</div>
					</div>
				</div>
				<cfcatch>
					<cfdump var="#cfcatch#">
				</cfcatch>
			</cftry>	
	</div>
	
	</cfif>	
</cfoutput>
