<cfoutput>	
	
	<cfif !isNull(type) and type eq "gallery">
		<input type="hidden" id="uploadType" value="gallery" />
	<cfelse>
		<input type="hidden" id="uploadType" value="file" />
	</cfif>
	
	<cfset contentFor(plupload=true)>
	<cfset contentFor(formy=true)>
	
	<cfset oauthService = "http://oauth.outerplex.com/google?redir=http://#cgi.server_name#">
	<cfset baseOauthUrl = "#oauthService#/m/admin/files/">
	<cfset baseOauthUrlPopup = "#oauthService#/m/admin/upload/oauth/">
	<input id="baseOauthUrl" type="hidden" value="#baseOauthUrl#" />	
	<input id="baseOauthUrlPopup" type="hidden" value="#baseOauthUrlPopup#" />
	
	<div class="modal primary fade" id="uploadVideo" data-backdrop="static" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">Upload Video</h4>
				</div>
				<div class="modal-body">
				
					#hiddenfieldtag(
						name		= "selectType",
						id			= "selectType",
						value		= "yt-u"
					)#
					
					#hiddenfieldtag(
						name		= 'typeId', 	
						class		= 'typeId',
						id			= 'typeId',
						value		= ''
					)#
					
					<!--- Youtube file - Already uploaded --->
					<span class="type-wrap" data-type="yt" style="display:none;">					
							
						#btextfieldtag(
							name='youtubeurl', 
							value='', 
							class="youtubeurl form-control",
							label='Youtube URL',
							id="youtubeURLInput",
							placeholder	 = "Paste youtube video or playlist link here",
							help='Enter the url of the video or playlist from youtube'
						)#
						
						#hiddenfieldtag(
							name	= 'video[youtubeId]', 
							id		= "youtubeIDInput",
							class	= "youtubeId"
						)#
						
						<div class="form-group">
							<div class="wiz_block yt_thumb_chooser"></div>
						</div>						
					
						<a href="javascript:void(0)" id="youtubelink" rel="loc-u">Back to video uploader</a>
						
						<button type="button" class="btn btn-primary pull-right" id="submitYoutubeURL">Submit</button>
						
						<br class="clear" />
						<br />						
						
					</span>
					
					<!--- Local file - Upload now --->
					<span class="type-wrap" data-type="loc-u">					
						<div class="form-group">								
							#bLabel(label="Upload Video File",help="Select the video file from your computer that you want to upload to the local server. (Valid filetypes: flv)")#
							<div class="controls">
								<div id="uploader">											
									<div id="container">
										<a id="uploadvideo" rel="loc-u" class="btn btn-success" href="javascript:void(0)">Upload to Server</a>
										<a id="uploadyoutube" rel="yt-u" class="btn btn-danger" href="javascript:void(0)">Upload to Youtube</a>
										<br /><br />
										<div id="filelist"></div>
										<div id="progress" class="progress progress-success">
											<div class="progress-bar bar"></div>
										</div>
										<a href="javascript:void(0)" id="youtubelink" rel="yt">Already on YouTube?</a>
									</div>											
								</div>										
							</div>
							
						</div>								
					</span>
					
				</div>
			</div>
		</div>
	</div>

	<cfif !isNull(params.token)>
	
		#includePartial(
			partial="/_partials/videoConfirmModal",
			baseOauthUrlFull	= "#baseOauthUrl#%3Fid=#params.id#",	
			videoFileID 		= params.id,	
			token 				= params.token,	
			oauthName 			= params.name,	
			oauthEmail			= params.email
		)#	
		
		<script type="text/javascript">
			$(function() {
				$('##youtubeconfirm').modal({
					show: true
				});
			});
		</script> 
		
	</cfif>
	
	<div id="oauthConfirmModal"></div>

</cfoutput>