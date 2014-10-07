<cfscript>
component extends="_main" output="false" 
{
	function show()
	{			
		qform = model("form").findAll(where="id = '#params.id#'");
		dataFields = model("FormField").findAll(where="metafieldType = 'formfield' AND modelid = '#params.id#'",order="sortorder ASC");
	}	
	
	function formsubmissionSave()
	{		
		qform = model("Form").findByKey(params.id);
	}
}
</cfscript>