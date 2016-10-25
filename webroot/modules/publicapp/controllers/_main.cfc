<cfscript>
component output="false" extends="modules.public.controllers._main"  
{	
	function init()
	{
		super.init();
	}

	// function getCartItems() {
	// 	buildWhere = "";		
	// 	currentRow = 0;
		
	// 	for (itemid in session.cart.items) 
	// 	{
	// 		currentRow++;
	// 		buildWhere = buildWhere & "Items.id = #itemid#";			
	// 		if(currentRow NEQ StructCount(session.cart.items))
	// 		{
	// 			buildWhere = buildWhere & " OR ";
	// 		}
	// 	}
		
	// 	return model("item").findAll(
	// 		where	= buildWhere,
	// 		include = "User(UsergroupJoin(usergroup))"
	// 	);
	// }

	function getCartItems(cart=session.cart.items) {
		var buildWhere = "";
		var itemCount = 1;
		var whereString = "";
		var itemids = listToArray(structKeyList(arguments.cart));

		for(var itemid in itemids) {
			whereString = "id = '#itemid#'";
			buildWhere &= (itemCount == 1) ? whereString : " OR " & whereString;
			itemCount++;
		}
		
		var cartQuery = model('Item').findAll(where=buildWhere);

		if(arrayLen(itemids) != cartQuery.recordcount OR !cartQuery.recordcount) { return false; }

		return cartQuery;
	}
}
</cfscript>