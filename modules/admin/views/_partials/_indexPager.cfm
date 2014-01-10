<cfoutput>

	<cfparam name="currentController">
	
	<div class="row-regular">				
		<div class="col-md-2">
			#bselecttag(
				name	= 'sort',
				options	= [
					{text="1 Per Page",value="1"},
					{text="2 Per Page",value="2"},
					{text="3 Per Page",value="3"},
					{text="10 Per Page",value="10"},
					{text="50 Per Page",value="50"},
					{text="100 Per Page",value="100"},
					{text="Show All",value="9999999"}
				],
				selected= session.perPage,
				class	= "selectize perPage",
				append	= ""
			)#
			#hiddenFieldTag(
				id		= "perPagePath",
				name	= "perPagePath",
				value	= "#urlFor(route="moduleAction", module="admin", controller="#currentController#", action="setPerPage")#"
			)#
		</div>
		<div class="col-md-5 pull-right align-right">
			#paginator#
		</div>
	</div>
	
</cfoutput>