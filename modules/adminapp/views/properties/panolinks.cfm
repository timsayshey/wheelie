<cfoutput>
	<div class="row">
		<cfif arrayLen(settings)>
		    <cfloop array="#settings#" index="panorama">
		    	<div class="col-md-3">
					<img src="/assets/uploads/properties/#panorama.data.fileid#-sm.jpg" style="width:100%"><br>
					<input class="caption" id="#panorama.data.id#" value="#panorama.caption#" placeholder="Caption">
					<a href="javascript:void(0)" class="saveCaption btn btn-success btn-xs" data-uuid="#panorama.uuid#">Save</a> 
					<a href="javascript:void(0)" class="delete btn btn-danger btn-xs pull-right" data-uuid="#panorama.uuid#" style="margin-top:6px">&times;</a>
				</div>
			</cfloop>
	    </cfif>
    </div>
</cfoutput>