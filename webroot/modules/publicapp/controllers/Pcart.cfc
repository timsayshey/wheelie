<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
		filters(through="checkCartExists");
	}
	
	function index()
	{
		qCart = getCartItems();
	}
	
	function additem()
	{		
		if(!isNull(params.id) AND !isNull(params.itemqty))
		{
			flashInsert(success=session.cart.items.containsKey(params.id) ? "Item updated!" : "Item added!");
			session.cart.items[params.id] = ReReplaceNoCase(params.itemqty,"[^0-9]","","ALL");
		}
		redirectTo(route="public~cartIndex");
	}

	function removeitem()
	{		
		if(session.cart.items.containsKey(params.id)) {
			structDelete(session.cart.items,params.id);
			flashInsert(success="Item removed!");	
		}
		redirectTo(route="public~cartIndex");
	}
	
	function checkCartExists()
	{
		if(isNull(session.cart.items))
		{
			session.cart.items = {};
		}
	}
}
</cfscript>