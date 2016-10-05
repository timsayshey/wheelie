<cfoutput>
	<cfif photos.recordCount>
	
		<ul class="sortable ui-sortable">

		    <cfloop query="#photos#">
				<li id="#fileid#">
					<img src="/assets/uploads/properties/#fileid#-thumb.jpg">
					<div class="pic-options">
						<a href="##captionModal" data-toggle="modal" class="captionMedia" data-id="#id#" title="#len(trim(name)) ? name : "Add caption"#"><span class="elusive icon-tag"></span></a>
						<a href="javascript:void(0)" class="deleteMedia pull-right" title="Remove" data-fileid="#fileid#"><span class="elusive icon-remove"></span></a>
					</div>
				</li>
			</cfloop>

	    </ul>
	    <br class="clear"><br>
    </cfif>
</cfoutput>