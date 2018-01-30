<cfscript>
component extends="_main" output="false"
{
	function init()
	{
		super.init();
	}

	function index()
	{
		if(!isNull(params.id)) {
			@lcaseSingular@fields = model("@ucaseSingular@Field").findAll(where="@lcaseSingular@id = #params.id#", order="sortorder ASC");
		}
	}

	function updateOrder()
	{
		orderValues = DeserializeJSON(params.orderValues);

		for(i=1; i LTE ArrayLen(orderValues); i = i + 1) {
			fieldValue = orderValues[i];

			@ucaseSingular@Field = model("@ucaseSingular@Field").findOne(where="id = #fieldValue.fieldId#");

			if(isObject(@ucaseSingular@Field)) {
				@ucaseSingular@Field.update(sortorder=fieldValue.newIndex,validate=false);
			}
		}
		abort;
	}

	function toggleRecord()
	{
		var loc = {};
		@lcaseSingular@fields = model("@ucaseSingular@Field").findByKey(params.id);
		if(@lcaseSingular@fields[params.col] eq 1) {
			loc.toggleValue = 0;
		} else {
			loc.toggleValue = 1;
		}

		loc.newInsert = StructNew();
		StructInsert(loc.newInsert,params.col,loc.toggleValue);
		@lcaseSingular@fields.update(loc.newInsert);

		flashInsert(success="@ucaseSingular@ fields updated successfully.");
		redirectTo(route="admin~Index", controller="@lcaseSingular@s");
	}

	function new()
	{
		// Queries
		@lcaseSingular@field = model("@ucaseSingular@Field").new(colStruct("@ucaseSingular@Field"));

		// If not allowed redirect
		wherePermission("@ucaseSingular@");

		// Show @lcaseSingular@
		renderPage(action="editor");
	}

	function edit()
	{
		if(isDefined("params.id")) {
			// Queries
			@lcaseSingular@field = model("@ucaseSingular@Field").findAll(where="id = '#params.id#'#wherePermission("@ucaseSingular@","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(@lcaseSingular@field)) {
				@lcaseSingular@field = @lcaseSingular@field[1];
			}

			// @ucaseSingular@ not found?
			if (!IsObject(@lcaseSingular@field)) {
				flashInsert(error="Not found");
				redirectTo(route="admin~id", module="admin", controller="@ucaseSingular@Fields", action="index", id=params.@lcaseSingular@id);
			}
		}

		renderPage(action="editor");
	}

	function save()
	{
		// Get @lcaseSingular@ object
		if(!isNull(params.@lcaseSingular@field.id)) {
			@lcaseSingular@field = model("@ucaseSingular@Field").findByKey(params.@lcaseSingular@field.id);
			saveResult = @lcaseSingular@field.update(params.@lcaseSingular@field);
		} else {
			@lcaseSingular@field = model("@ucaseSingular@Field").new(params.@lcaseSingular@field);
			saveResult = @lcaseSingular@field.save();
			isNew@ucaseSingular@field = true;
		}

		// Insert or update @lcaseSingular@ object with @lcasePlural@
		if (saveResult) {
			flashInsert(success='Field saved.');
			redirectTo(route="admin~Id", module="admin", controller="@lcaseSingular@fields", action="edit", id=@lcaseSingular@field.id, params="@lcaseSingular@id=#@lcaseSingular@field.@lcaseSingular@id#");
		} else {

			errorMessagesName = "@lcaseSingular@field";
			param name="@lcaseSingular@field.id" default="0";

			flashInsert(error="There was an error.");
			renderPage(route="admin~Action", module="admin", controller="@ucaseSingular@Fields", action="editor");
		}
	}

	function delete()
	{
		@lcaseSingular@s = model("@ucaseSingular@Field").findByKey(params.id);

		if(@lcaseSingular@s.delete()) {
			flashInsert(success="The field was deleted successfully.");
		} else
		{
			flashInsert(error="The field could not be found.");
		}

		redirectTo(route="admin~id", module="admin", controller="@ucaseSingular@Fields", action="index", id=params.@lcaseSingular@id);
	}
}
</cfscript>
