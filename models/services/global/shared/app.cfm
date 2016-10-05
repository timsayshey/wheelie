<cfscript>
	// App specific functions go here

	function getPageBlock(required id) {
		return model("PageBlock").findAll(where="id = '#id#'").content;
	}
</cfscript>