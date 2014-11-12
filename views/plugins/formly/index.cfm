<cfscript>
	// [formly formid="11"]
	function plugin_shortcode_formly(attr,content) {
		param name="attr.formid" value="";
		return generateForm(formid=attr.formid);
	}
</cfscript>