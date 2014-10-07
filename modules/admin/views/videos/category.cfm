<cfset contentFor(formy			= true)>
<cfset contentFor(headerTitle	= '<span class="elusive icon-video"></span> Videos')>

<cfoutput>
	<cfif isNull(qVideos)>
		<h2>Sorry, couldn't find that category. Please try again.</h2>
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
							overlayImage	= "/assets/images/videooverlay.png",
							href			= "href='#urlFor(route="admin~id",controller="videos",action="video",id=qVideos.id)#'"
						)#					
					</cfloop>
				
				</div>
			</cfif>
			
			<br class="clear" />
			
		</div>	
	
	</cfif>

</cfoutput>
		
