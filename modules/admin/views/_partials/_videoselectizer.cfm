<cfoutput>
	<cfset selectedFile = "">	
	<cfset selectOptions = "">	
	
	<cfloop query="videofiles">	
		
		<cfset thumbPath = "http://#siteUrl##info.videoThumbPath##ListFirst(videofiles.filename,".")#.jpg">
		
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
		
		<cfset urlpath = "#info.filevideos##filename#">	
		
	</cfloop>
		
	<div class="modal primary" id="videoPreview" data-backdrop="static" tabindex="-1" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">Preview</h4>
				</div>
				<div class="modal-body">								
				
												
				</div>
			</div>
		</div>
	</div>
	
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
										'<img src="/assets/img/videooverlay.png">' +
									'</div>' +
									'<div class="col-md-9 col-sm-9 col-xs-9">' +
										'<span class="boxtitle">' + escape(item.name) + '</span>' +
										(item.youtube > 0 ? '<span class="elusive icon-youtube color-danger" title="Hosted on Youtube"></span>' : '') +
										(item.youtube == 0 ? '<span class="elusive icon-hdd color-primary" title="Hosted on #siteUrl#"></span>' : '') +
									'</div>' +
									'<br class="clear">' +
								'</div>'
					},
					option: function(item, escape) {
						var label = item.name || item.thumb;
						var caption = item.name ? item.thumb : null;
						return '<div>' +
									'<div class="filethumb col-md-3 col-sm-3 col-xs-3 roundy" style="background-image:url(' + escape(item.thumb) + ');">' +
										'<img src="/assets/img/videooverlay.png">' +
									'</div>' +
									'<div class="col-md-9 col-sm-9 col-xs-9">' +
										'<span class="boxtitle">' + escape(item.name) + '</span>' +
										(item.youtube > 0 ? '<span class="elusive icon-youtube color-danger" title="Hosted on Youtube"></span>' : '') +
										(item.youtube == 0 ? '<span class="elusive icon-hdd color-primary" title="Hosted on #siteUrl#"></span>' : '') +
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