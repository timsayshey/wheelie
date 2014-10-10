<cfoutput>

	<cfparam name="currentController">
	
	<div class="row-regular">				
		<div class="col-md-2">
			#bselecttag(
				name	= 'sort',
				options	= [
					{text="6 Per Page",value="6"},
					{text="10 Per Page",value="10"},
					{text="50 Per Page",value="50"},
					{text="100 Per Page",value="100"},
					{text="Show All",value="9999999"}
				],
				selected= session.perPage,
				class	= "selectize perPage",
				append	= ""
			)#
			
			<cfparam name="params.currentGroup" default="">
			#hiddenFieldTag(
				id		= "perPagePath",
				name	= "perPagePath",
				value	= urlFor(route="admin~Action", module="admin", controller="#currentController#", action="setPerPage", params="currentGroup=#params.currentGroup#") 
			)#
			
		</div>
		<div class="col-md-5 pull-right align-right">
			#paginator#
		</div>
	</div>
	
</cfoutput>