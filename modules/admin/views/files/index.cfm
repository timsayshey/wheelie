<cfset contentFor(headerTitle	= '<span class="elusive icon-video"></span> Video Files')>
<cfset contentFor(headerButtons = 
			'<li class="headertab">
				<a href="javascript:void(0)"
					class="upload-video btn btn-large btn-primary pull-right"
					data-toggle="modal"
					data-target="##uploadVideo"
				><span class="elusive icon-plus"></span> Add Video</a>
			</li>')>


<script type="text/javascript" src="/assets/vendor/jwplayer/jwplayer.js"></script>

<cfoutput> 

	<div class="container">
		<div class="row-regular">
		
			<cfif !isNull(Video) and isObject(Video)>
				#errorMessagesFor("Video")#
			</cfif>	
			
			<div id="video">
					
				<cfloop query="qVideos">
					<cfset thumbPath = "#info.uploadsPath#videos/thumbs/#ListFirst(qVideos.filename,".")#.jpg">
					<cfset urlpath = "#qVideos.filepath##qVideos.filename#">	
					<cfset fullFilePath = ExpandPath(urlpath)>							
					
					<cfif len(qVideos.youtubeid)>
						<cfset isYoutube = true>
					<cfelse>
						<cfset isYoutube = false>
					</cfif>
					
					<!--- Video Listing --->						
					<div class="video col-sm-12 col-xs-12 col-md-3 col-lg-3">
						<div class="thumbnail bootsnipp-thumb">	
						
							<a href="javascript:void(0)" class="boxtitle" data-toggle="modal" data-target="##details_#qVideos.id#">
								#filename#			
							</a>	
							
							<a href="javascript:void(0)" data-toggle="modal" data-target="##details_#qVideos.id#" class="filethumb" style="
							background-image:url(
								
								<cfif fileExists(thumbPath)>
									#thumbPath#
								</cfif>
							);
							">
								<img src="/assets/images/videooverlay.png">
							</a>
							<div class="caption">
							
								<cfif status eq "youtubePending">
									<span class="label label-danger">Uploading</span>
								<cfelseif status eq "youtubeFailed">
									<span class="label label-danger">Youtube Fail</span>
								<cfelseif isYoutube>									
									<span class="label label-danger" style="margin-left:5px;">Youtube</span>
								</cfif>
								
								<cfif fileExists(fullFilePath)>
									<span class="label label-info">Hosted</span>
								</cfif>
								
								<div class="btn-group pull-right">								
								
									<a href="javascript:void(0)" class="btn btn-primary btn-xs" data-toggle="modal" data-target="##details_#qVideos.id#" title="Watch"><span class="elusive icon-search"></span> </a>
									
									<cfif !isYoutube><a href="javascript:void(0)" class="btn btn-primary btn-xs" title="Download"><span class="elusive icon-download-alt"></span></a></cfif>	
																											
									#linkTo(
										text='<span class="elusive icon-trash"></span>',
										class="btn btn-primary btn-xs confirmDelete",
										route="moduleId",
										title="Delete",
										module="admin",
										controller="files",
										action="delete", 
										id=qVideos.id
									)#	
									
								</div>		
								
								<br class="clear" />
								
							</div>
						</div>
					</div>
					
					<!--- Details Modal --->
					<div class="modal primary" id="details_#qVideos.id#" data-backdrop="static" tabindex="-1" role="dialog">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
									<h4 class="modal-title" id="myModalLabel">#qVideos.filename# Details</h4>
								</div>
								<div class="modal-body">								
								
									<cfif isYoutube>
									
										<iframe width="100%" height="315" src="//www.youtube.com/embed/#qVideos.youtubeid#?rel=0" frameborder="0" allowfullscreen></iframe>
										Location: <a href="https://www.youtube.com/watch?v=#qVideos.youtubeid#">https://www.youtube.com/watch?v=#qVideos.youtubeid#</a><br />
										
									<cfelse>
									
										<div id="videoid_#qVideos.id#">Loading the player...</div>

										<script type="text/javascript">
											jwplayer("videoid_#qVideos.id#").setup({
												file: "#urlpath#",
												image: "#thumbPath#",
												width: "100%"
											});												
										</script>
										
										Location: <a href="http://#cgi.server_name##urlpath#">
										http://#cgi.server_name##urlpath#</a><br />
										Size: #bytesToMegabytes(qVideos.bytesize)# MB<br />
									</cfif>	
									
									Added #timeAgoInWords(qVideos.createdAt)# ago
																			
								</div>
							</div>
						</div>
					</div>
					
				</cfloop>		
					
			</div>			
			
		</div>
	</div>
		
	#includePartial(partial="/_partials/videoModals")#	
	<input type="hidden" id="oauthWindowType" value="full"> <!--- full or popup --->

</div>

</cfoutput>
		
