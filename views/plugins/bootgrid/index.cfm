<cfscript>
	// [bootgrid cols="4" colsize="sm" type="row"][/bootgrid]
	function plugin_shortcode_bootgrid(attr,content) {
		param name="attr.colsize" value="md";
		param name="attr.cols" value="3";
		param name="attr.type" value="col";		
		
		if(attr.type eq "container-start")
		{
			return "<div class='container'>";
		} 
		else if(attr.type eq "row-start") 
		{
			return "<div class='row'>";
		} 
		else if(attr.type eq "tag-end") 
		{
			return "</div>";
		}
		else if(attr.type eq "col") 
		{
			return "<div class='col-#attr.colsize#-#attr.cols#'>#content#</div>";
		}
	}
</cfscript>