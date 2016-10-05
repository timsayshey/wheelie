<cfscript>
	// Test Shortcode
	function plugin_shortcode_test(attr,content) {
		param name="attr" value="";
		param name="content" value="test";
		return "<div class='test'>#processShortcodes(content)#</div>";
	}
</cfscript>