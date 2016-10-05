<cfset contentFor(formy			= true)>
<cfset contentFor(headerTitle	= '<span class="elusive icon-video"></span> Training')>

<cfoutput>
	<cfif isNull(qVideos)>
		<h4>Oops! You haven't set the default admin video category yet.</h4>
		<strong>To fix this:</strong>
		<ul>
			<li>Go to the admin menu > content > videos > categories.</li>
			<li>Add a root training category and checkmark "Default Admin Category".</li>
			<li>Then save.</li>
			<li>You're done! Now add sub categories and videos to the categories.</li>
		</ul>
	<cfelse>
	
		<div class="row-regular">	
			<cfif videoCategories.recordcount>
				<strong>Categories</strong><br><br>
				<cfloop query="videoCategories">
					#linkTo(text=videoCategories.name,route="admin~id",controller="videos",action="category",id=videoCategories.urlid,class="btn btn-default btn-sm")#
				</cfloop>
				<br class="clear" /><br />
			</cfif>			
			
			<cfif qVideos.recordcount>
				<strong>Videos</strong><br><br>
				<div id="video" class="col-md-12">
				
					<cfloop query="qVideos">
						
						#includePartial(
							partial="/_partials/indexListItem", 
							currentid		= qVideos.id, 
							tags			= "",
							gridActive		= false,
							thumbPath		= "#info.videoThumbPath##qVideos.id#.jpg",
							title			= qVideos.name,
							description		= qVideos.description,
							controllerName	= "videos",
							overlayImage	= "/assets/img/videooverlay.png",
							href			= "href='#urlFor(route="admin~id",controller="videos",action="video",id=qVideos.id)#'"
						)#					
					</cfloop>
				
				</div>
			</cfif>
			
			<br class="clear" />
			
		</div>	
	
	</cfif>

</cfoutput>
		
