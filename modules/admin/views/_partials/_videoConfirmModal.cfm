<cfoutput>

	<input id="baseOauthUrlFull" type="hidden" value="#baseOauthUrlFull#" />
		
	<div class="modal primary fade" id="youtubeconfirm" data-backdrop="static" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h3 class="modal-title" id="myModalLabel">Choose the account that you want to upload "#video.filename#" to:</h3>
				</div>
				<div class="modal-body">					
					<a href="/webpanel/index.cfm/m/admin/upload/toyoutube/?id=#videoFileID#&token=#token#" id="toYoutubeBtn" class="btn btn-danger btn-lg allowwrap btn-block"><strong>#oauthName# (#oauthEmail#)</strong></a> 
					
					<br />
					
					<!--- 
						Logout of google
						Use google logout hack described at:
						http://www.gethugames.in/blog/2012/04/authentication-and-authorization-for-google-apis-in-javascript-popup-window-tutorial.html
					--->
									
					<a 
						href="##" 
						class="btn btn-primary btn-lg btn-block" 
						target='googleLogoutFrame' 
						onclick="googleLogoutFrame.location='https://www.google.com/accounts/Logout'; redirectAfterGoogleLogout();return false;">
						Choose different account
						</a>   
						
					<iframe name='googleLogoutFrame' id="googleLogoutFrame" style='display:none'></iframe>		
					
					<div id="modal_loader"></div>
					
					<br />
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	
</cfoutput>