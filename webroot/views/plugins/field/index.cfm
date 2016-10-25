<cfscript>
	// [field for="identifier"]
	function plugin_shortcode_field(attr,content) {
		param name="attr.for" value="never match anything kthxbye";
		extraFieldArgs = Duplicate(attr);
		structDelete(extraFieldArgs,"for");
		
		field = model("FormField").findAll(where="identifier = '#attr.for#' AND metafieldType = 'formfield'",order="sortorder ASC");
		if(field.recordcount) {
			return includePartial("/_partials/formfield");
		} else {
			return "";
		}		
	}
</cfscript>