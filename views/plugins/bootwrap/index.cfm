<cfscript>
	// [bootwrap class="row"][/bootgrid]
	function plugin_shortcode_bootwrap(attr,content) {
		param name="attr.class" value="container";	
		
		return "<div class='#attr.class#'>#processShortcodes(content)#</div>";
	}
</cfscript>