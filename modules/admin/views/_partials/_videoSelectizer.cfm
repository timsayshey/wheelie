<cfoutput>
	<cfset selectedFile = "">	
	<cfset selectOptions = "">	
	
	<cfloop query="videofiles">	
		
		<cfset thumbPath = "#info.uploadsPath#videos/thumbs/#ListFirst(videofiles.filename,".")#.jpg">
		
		<cfif !fileExists(expandPath(thumbPath))>
			<cfset thumbPath = "/assets/uploads/videos/thumbs/_thumbnotfound.jpg">
		</cfif>
		
		<cfset selectOptions = ListAppend(selectOptions,"{thumb: '#thumbPath#', name: '#videofiles.filename#', id: #videofiles.id#, youtube: #len(videofiles.youtubeid)#}")>
				
		<cfif video.videofileid EQ videofiles.id>
			<cfset selectedFile = videofiles.id>
		</cfif>
		
		<!--- Set modals --->
		<cfif len(videofiles.youtubeid)>
			<cfset isYoutube = true>
		<cfelse>
			<cfset isYoutube = false>
		</cfif>
		
		<cfset urlpath = "#filepath##filename#">	
		
		<div class="modal primary" id="details_#id#" data-backdrop="static" tabindex="-1" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="myModalLabel">#filename# Details</h4>
					</div>
					<div class="modal-body">								
					
						<cfif isYoutube>
						
							<iframe width="100%" height="315" src="//www.youtube.com/embed/#youtubeid#?rel=0" frameborder="0" allowfullscreen></iframe>
							Location: <a href="https://www.youtube.com/watch?v=#youtubeid#">https://www.youtube.com/watch?v=#youtubeid#</a><br />
							
						<cfelse>
						
							<div id="videoid_#id#">Loading the player...</div>
		
							<script type="text/javascript">
								jwplayer("videoid_#id#").setup({
									file: "#urlpath#",
									image: "#thumbPath#",
									width: "100%"
								});												
							</script>
							
							Location: <a href="http://#cgi.server_name##urlpath#">
							http://#cgi.server_name##urlpath#</a><br />
							Size: #bytesToMegabytes(bytesize)# MB<br />
							
						</cfif>	
																
					</div>
				</div>
			</div>
		</div>
		
	</cfloop>	
	
	<script>
		$(function() {
			window.$videoSelector = $('##videoSelector').selectize({
				persist: false,
				maxItems: 1,
				valueField: 'id',
				labelField: 'thumb',
				searchField: ['name', 'thumb'],
				options: [
					#selectOptions#
				],
				render: {
					item: function(item, escape) {
						return  '<div>' +
									'<div class="filethumb col-md-3 col-sm-3 col-xs-3 roundy" style="background-image:url(' + escape(item.thumb) + ');">' +
										'<img src="/assets/images/videooverlay.png">' +
									'</div>' +
									'<div class="col-md-9 col-sm-9 col-xs-9">' +
										'<span class="boxtitle">' + escape(item.name) + '</span>' +
										(item.youtube > 0 ? '<span class="elusive icon-youtube color-danger" title="Hosted on Youtube"></span>' : '') +
										'<span class="elusive icon-hdd color-primary" title="Hosted on #cgi.SERVER_NAME#"></span>' +
									'</div>' +
									'<br class="clear">' +
								'</div>'
					},
					option: function(item, escape) {
						var label = item.name || item.thumb;
						var caption = item.name ? item.thumb : null;
						return '<div>' +
									'<div class="filethumb col-md-3 col-sm-3 col-xs-3 roundy" style="background-image:url(' + escape(item.thumb) + ');">' +
										'<img src="/assets/images/videooverlay.png">' +
									'</div>' +
									'<div class="col-md-9 col-sm-9 col-xs-9">' +
										'<span class="boxtitle">' + escape(item.name) + '</span>' +
										(item.youtube > 0 ? '<span class="elusive icon-youtube color-danger" title="Hosted on Youtube"></span>' : '') +
										'<span class="elusive icon-hdd color-primary" title="Hosted on #cgi.SERVER_NAME#"></span>' +
									'</div>' +
									'<br class="clear">' +
								'</div>'
					}
				}
			});
			window.$videoSelector = window.$videoSelector[0].selectize;
			window.$videoSelector.addItem("#selectedFile#");
			window.$videoSelector.refreshOptions(false);
		});
	</script>	
</cfoutput>