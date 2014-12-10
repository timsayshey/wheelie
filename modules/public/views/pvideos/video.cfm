<cfoutput>

	<cfscript>
		//request.page.hideSidebar = true;
		request.page.noBgImage = true;
		contentFor(siteTitle = "#video.name# | #getOption(qOptions,'seo_videos_title').label#");
		contentFor(siteDescription = video.description);
	</cfscript>
	
	<h1>#video.name#</h1>
	<cfif request.site.id eq 1>
		<br class="clear">
	</cfif>
	#facebookLikeButton()#	
	<br>
	
	<style type="text/css">
	.videoWrapper {
		position: relative;
		padding-bottom: 56.25%; /* 16:9 */
		padding-top: 25px;
		height: 0;
	}
	.videoWrapper iframe {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
	}
	</style>

	<cfif len(video.password) AND isNull(session.videoaccess[video.id])>
		<cfif flashKeyExists("error")>
			<div class="alert alert-danger alert-dismissable fade in">
				<button class="close" data-dismiss="alert">&times;</button>
				<strong>#flash("error")#</strong> 
				<cfif !isNull(errorMessagesName)>												
					#errorMessagesFor(errorMessagesName)#
				</cfif>
			</div>
		</cfif>
			
		<strong>Password Required:</strong><br>
		<form action="/video/#video.id#" method="post">
			<input type="text" name="password" class="form-control"><br>
			<input type="submit" class="btn btn-warning btn-lg">
		</form>
	<cfelse>
	
		<cfif len(video.youtubeid)>
			<cfset videoUrl = "https://www.youtube.com/embed/#video.youtubeid#?rel=0&showinfo=0&fs=1&hl=en_US&wmode=opaque&autohide=1">
		<cfelseif len(video.vimeoid)>
			<cfset videoUrl = "https://player.vimeo.com/video/#video.vimeoid#">
		<cfelse>
			<cfset videoUrl = "">
		</cfif>
		
		<div class="videoWrapper">
			<iframe width="560" height="349" src="#videoUrl#" frameborder="0" allowfullscreen></iframe>
		</div>	
		<br>
		
		<strong>Description</strong><br>
		#video.description#
		
	</cfif>
	
</cfoutput>