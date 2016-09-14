<cfoutput>
	
	<cfset contentFor(headerTitle	= '<span class="elusive icon-dashboard"></span> Dashboard')>

	<div class="jumbotron blue">
		<h1>Welcome to Wheelie</h1>
		<p>Watch your step.</p>
	</div>
	
	<div class="row">		
		<a class="icon-btn-lg col-md-3" href='#urlFor(route="admin~action", controller="pages", action="new")#'>
			<span class="large-icon elusive icon-file-new-alt"></span>
			<strong>Add page</strong>
		</a>
		
		<a class="icon-btn-lg col-md-3" href='#urlFor(route="admin~action", controller="videos", action="new")#'>
			<span class="large-icon elusive icon-video-alt"></span>
			<strong>Add video</strong>
		</a>
		
		<a class="icon-btn-lg col-md-3" href='#urlFor(route="admin~action", controller="users", action="index")#'>
			<span class="large-icon elusive icon-group-alt"></span>
			<strong>Users</strong>
		</a>
		
		<a class="icon-btn-lg col-md-3" href='#urlFor(route="admin~action", controller="options", action="index")#'>
			<span class="large-icon elusive icon-cog-alt"></span>
			<strong>Settings</strong>
		</a>
	</div>				
	
	<cfif checkPermission("log_read_others")>
	
		<cfset saveTypeButtons = {
			delete = "label-danger",
			update = "label-info",
			create = "label-success"
		}>
		
		<cfsavecontent variable="rightColumn">
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
							</cfloop>
																	
						</div>
					</div>
				</div>
			</div>
		</cfsavecontent>
		
		<cfset contentFor(rightColumn = rightColumn)>	
	
	</cfif>	
</cfoutput>