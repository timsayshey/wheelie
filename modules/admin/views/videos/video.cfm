<cfoutput>
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
	
	<cfset contentFor(headerTitle	= '<span class="elusive icon-video"></span> #video.name#')>	
	<cfset contentFor(headerButtons = 
		'<li class="headertab">
			#linkTo(
				text		= "<span class=""elusive icon-arrow-left""></span> Go Back",
				href		= "#cgi.HTTP_REFERER#", 
				class		= "btn btn-default"
			)#
		</li>')>
		
	<cfif len(video.youtubeid)>
		<cfset videoUrl = "https://www.youtube.com/embed/#video.youtubeid#?rel=0&showinfo=0&fs=1&hl=en_US&wmode=opaque&autohide=1">
	<cfelseif len(video.vimeoid)>
		<cfset videoUrl = "https://player.vimeo.com/video/#video.vimeoid#">
	<cfelse>
		<cfset videoUrl = "">
	</cfif>
	
	<div class="videoWrapper">
		<iframe type="text/html" width="640" height="360" src="#videoUrl#" frameborder="0"></iframe>
	</div>	
</cfoutput>