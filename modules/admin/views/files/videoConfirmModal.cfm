<cfoutput>
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
</cfoutput>