<cfscript>
	// [bootgrid cols="4" colsize="sm" type="row"][/bootgrid]
	function plugin_shortcode_bootgrid(attr,content) {
		param name="attr.colsize" value="md";
		param name="attr.cols" value="3";
		
		return "<div class='col-#attr.colsize#-#attr.cols#'>#processShortcodes(content)#</div>";
	}
</cfscript>