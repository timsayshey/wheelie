<cfscript>
	// [get val="11"]
	function plugin_shortcode_get(attr,content) {
		param name="attr.val" value="";
		param name="attr.fieldid" value="";

		if(isNumeric(attr.fieldid) AND params.containsKey("fielddata")) {
			return params.fielddata.containsKey(attr.fieldid) ? params.fielddata[attr.fieldid] : "";
		} else {
			return params.containsKey(attr.val) ? params[attr.val] : "";
		}		
	}
</cfscript>