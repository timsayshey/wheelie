<cfoutput>

	<cfparam name="videoid">
	<cfparam name="videofilename">
	<cfparam name="vidoefilepath">
	<cfparam name="youtubeid">
	<cfparam name="bytesize">
	
	<cfset thumbPath = "#info.uploadsPath#videos/thumbs/#ListFirst(videofilename,".")#.jpg">
	<cfset urlpath = "#vidoefilepath##videofilename#">	
	<cfset fullFilePath = ExpandPath(urlpath)>					
	
	<cfif len(qVideos.youtubeid)>
		<cfset isYoutube = true>
	<cfelse>
		<cfset isYoutube = false>
	</cfif>
	
	<!--- Details Modal --->
	<div class="modal primary" id="details_#videoid#" data-backdrop="static" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">#videofilename# Details</h4>
				</div>
				<div class="modal-body">								
				
					<cfif isYoutube>
					
						<object width="100%" height="315">
							<param name="movie" value="http://www.youtube.com/v/#youtubeid#?rel=0&amp;autoplay=0&amp;showinfo=0&amp;fs=1&amp;hl=en_US&amp;wmode=transparent">
							<param name="wmode" value="transparent">
							<embed src="http://www.youtube.com/v/#youtubeid#&amp;showinfo=0" type="application/x-shockwave-flash" wmode="transparent" width="100%" height="224">
						</object>
						Location: <a href="https://www.youtube.com/watch?v=#youtubeid#">https://www.youtube.com/watch?v=#youtubeid#</a><br />
						
					<cfelse>
					
						<div id="videoid_#videoid#">Loading the player...</div>
	
						<script type="text/javascript">
							jwplayer("videoid_#videoid#").setup({
								file: "#urlpath#",
								image: "#thumbPath#",
								width: "100%"
							});												
						</script>
						
						Location: <a href="http://#cgi.server_name##urlpath#">
						http://#cgi.server_name##urlpath#</a><br />
						Size: #bytesToMegabytes(qVideos.bytesize)# MB<br />
						
					</cfif>	
															
				</div>
			</div>
		</div>
	</div>

</cfoutput>