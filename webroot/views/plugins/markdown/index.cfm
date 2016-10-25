<cfscript>
	// [markdown][/markdown]
	function plugin_shortcode_markdown(attr,content) {
		param name="attr.class" value="container";		
		
		return "#markdown.markdownToHtml(content)#";
	}
</cfscript>