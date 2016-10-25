<cfscript>
	// [formly formid="11"]
	function plugin_shortcode_formly(attr,content) {
		param name="attr.formid" value="";
		param name="attr.formwrap" value="true";		
		param name="attr.formclass" value="true";
		
		return generateForm(formid=attr.formid,formwrap=attr.formwrap,formclass=attr.formclass);
	}
</cfscript>