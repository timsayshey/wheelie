<cfoutput>	
	
	<cfif !isNull(type) and type eq "gallery">
		<input type="hidden" id="uploadType" value="gallery" />
	<cfelse>
		<input type="hidden" id="uploadType" value="file" />
	</cfif>
	
	<cfset contentFor(plupload=true)>
	<cfset contentFor(formy=true)>
	
	<cfparam name="panelUrl" default="">
	
	<cfset oauthService = "http://oauth.outerplex.com/google?redir=http://#panelUrl#">
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
					
					<!--- Youtube file - Already uploaded --->
					<span class="type-wrap" data-type="yt">					
							
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
					
						<a href="##" id="youtubelink" rel="loc-u">Back to video uploader</a>
						
						<button type="button" class="btn btn-primary pull-right" id="submitYoutubeURL">Submit</button>
						
						<br class="clear" />
						<br />						
						
					</span>
					
					<!--- Local file - Upload now --->
					<span class="type-wrap" data-type="loc-u" style="display:none;">					
						<div class="form-group">								
							#bLabel(label="Upload Video File",help="Select the video file from your computer that you want to upload to the local server. (Valid filetypes: flv)")#
							<div class="controls">
								<div id="uploader">											
									<div id="container">
									
										<div class="btnWrap" style="display:inline;">
											<div class="btn-group" data-toggle-name="typeId" data-toggle="buttons-radio">
												<button type="button" value="yt" data-toggle="button" class="btn btn-info active">Youtube</button>
												<button type="button" value="loc" data-toggle="button" class="btn btn-info">Local Server</button>											
											</div>										
											<input type="hidden" id="typeId" class="typeId" name="typeId" value="yt">																					
										</div>
										<a id="uploadvideobtn" class="btn btn-success" href="##">Select Video and Upload</a>
										
										<br /><br />
										<div id="filelist"></div>
										<div id="progress" class="progress progress-success">
											<div class="progress-bar bar"></div>
										</div>
										<a href="##" id="youtubelink" rel="yt">Already on YouTube?</a>
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