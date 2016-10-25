<cfoutput>	

	<cfset contentFor(formy			= true)>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-cog"></span> Settings')>
	
	<div id="options">
		#includePartial(partial="/_partials/bulkOptionsForm",qOptions=qOptions,showPrependedText=true)#
	</div>
	<br class="clear" />
	
	<cfsavecontent variable="rightColumn">
		<div class="rightbarinner">					
			<div class="data-block">
				<section>
					<button type="submit" name="submit" value="save-continue" class="btn btn-primary">Save settings</button>		
				</section>
			</div>
		</div> 
		</div>
		<div class="rightBottomBox  hidden-xs hidden-sm">
			<div class="col-sm-3 data-block">
				<section>
					<button type="submit" name="submit" value="save-continue" class="btn btn-primary">Save settings</button>		
				</section>
			</div>
		</div>
	</cfsavecontent>
	<cfset contentFor(rightColumn = rightColumn)>
	<cfset contentFor(formWrapStart = startFormTag(route="admin~Action", module="admin", controller="options", action="save", enctype="multipart/form-data"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>	

</cfoutput>
		
