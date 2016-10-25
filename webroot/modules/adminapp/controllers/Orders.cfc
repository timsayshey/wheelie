component extends="_main" output="false" 
{
	function init() 
	{
		super.init();			
	}
	
	function index() 
	{
		solditems = model('order').findAll(
			order = "createdAt DESC",
			include = "ordertransaction(user(UsergroupJoin(usergroup)))",
			where = "ownerid = '#session.user.id#'"
		);

		purchaseditems = model('order').findAll(
			order = "createdAt DESC",
			include = "ordertransaction(user(UsergroupJoin(usergroup)))",
			where = "customerid = '#session.user.id#'"
		);

		contentFor(headerTitle	= '<span class="elusive icon-shopping-cart"></span> My Orders');	
	}

	function customers() 
	{
		orders = model('order').findAll(
			where="ownerid = '#session.user.id#'",
			order="createdAt DESC",
			include = "ordertransaction(user(UsergroupJoin(usergroup)))"
		);

		contentFor(headerTitle	= '<span class="elusive icon-shopping-cart"></span> Customer Orders');	
	}

	function details() 
	{
		orderitems = model('order').findAll(
			where="id = '#params.id#'",
			order="createdAt DESC",
			include = "orderitems"
		);

		ordertransaction = model('order').findAll(
			where="id = '#params.id#'",
			order="createdAt DESC",
			include = "ordertransaction"
		);

		try {
			stripeResponse = deserializeJSON(ordertransaction.stripe_response).source;

			if(stripeResponse.containsKey("last4") && 
				stripeResponse.containsKey("brand") &&
				stripeResponse.containsKey("exp_month") &&
				stripeResponse.containsKey("exp_year") ) {
				stripeCard = stripeResponse;
			}
		} catch(e) { }

		contentFor(headerTitle	= '<span class="elusive icon-shopping-cart"></span> Order');	
	}
}