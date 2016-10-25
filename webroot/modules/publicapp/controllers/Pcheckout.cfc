<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
		filters(through="loggedOutOnly",except="login,loginPost,registerPost");
		filters(through="loggedInExcept",only="login,loginPost,registerPost");
		filters(through="checkCartExists");
	}

	function index()
	{
		qCart = getCartItems();
	}

	function login()
	{
		user = model("User").new(colStruct("User"));
		qCart = getCartItems();
	}

	function complete()
	{
		checkoutErrors = [];
		orderFail = false;
		var orderItemsResult = false;
		var userCart = session.cart.items;
		var qCart = getCartItems();
		vendorOrderResults = [];
		var customer = {};
		var market = {
			stripe_user_id = application.wheels.stripeKey
		};

		if(isBoolean(qCart) && qCart == false) {
			orderFail = true; 
		} else {			
			transaction {	
				//////////////////////////////////////////////////////////////////////
				// Get total for each vendor
				query name="qVendors" dbtype="query" {
					echo("SELECT DISTINCT ownerid FROM qCart");
				}
				var vendorsCartTotals = {};
				for(vendor in qVendors) {					
					query name="qVendorCartItems" dbtype="query" {
						echo("SELECT id, price FROM qCart WHERE ownerid = '#vendor.ownerid#'");
					}

					var vendorCartTotal = 0;
					for(vendorCartItem in qVendorCartItems) {
						vendorCartTotal += vendorCartItem.price * userCart[vendorCartItem.id];
					}
					vendorsCartTotals[vendor.ownerid] = vendorCartTotal; 
				}

				//////////////////////////////////////////////////////////////////////
				// Check that vendor's stripeids are active otherwise update db
				for(ownerid in vendorsCartTotals) {
					try {
						vendor = model('user').findOne(where="id = '#ownerid#'");
						isStripeActive = stripe.getAccount(vendor.stripe_user_id);

						if(isStripeActive.status_code neq 200) {
							saveVendor = vendor.update({
								'stripe_vendor_active' = 0
							});
						}
					} catch(e) {
						writeDump(vendor);
						writeDump(e); abort;
					}
				}

				//////////////////////////////////////////////////////////////////////
				// Create or get customer
				var user = model("User").findByKey(session.user.id);
				
				var customerData = {
					'description' = '#params.fname# #params.lname#',
					'email' = session.user.email,
					'source' = params.stripeToken
				};

				// Update stripe customer
				if(findNoCase("cus_",user.stripe_customer_id)) {
					customerData.id = user.stripe_customer_id;
					var customer = stripe.updateCustomer(argumentCollection=customerData);
				}

				// Create stripe customer
				if(!customer.containsKey('status_code') || (customer.containsKey('status_code') && customer.status_code neq 200)){
					var customer = stripe.createCustomer(argumentCollection=customerData);
				}

				// Update db customer stripe id
				if(customer.containsKey('id')) {
					saveUser = user.update({
						'stripe_customer_id' = customer.id
					});
				}

				var appPercent = 5; // 5%
				var marketPercent = 10;

				//////////////////////////////////////////////////////////////////////
				// Create order for each vendor
				for(ownerid in vendorsCartTotals) {

					//////////////////////////////////////////////////////////////////////
					// Save order
					order = model("Order").new({
						customerid = session.user.id,
						eventid = params.eventid
					});
					orderResult = order.save(transaction="none");
					
					//////////////////////////////////////////////////////////////////////
					// Charge customer for vendor order
					var vendor = model('user').findAll(where="id = '#ownerid#'");
					
					if(vendor.stripe_vendor_active) {
						var cartTotal = vendorsCartTotals[ownerid];
						var customerToken = stripe.createCardToken(
							'stripeAccount' = vendor.stripe_user_id, 
							'customer' = user.stripe_customer_id
						);

						var appFee = appPercent / 100 * cartTotal;
						var amountToCharge = cartTotal - appFee;

						// Stripe API Charge
						stripeCharge = stripe.createCharge(
							'amount' = amountToCharge, 
							'source' = customerToken.id, 
							'stripeAccount' = vendor.stripe_user_id,
							'application_fee' = appFee
						);

						// Save to DB
						orderTransaction = model("OrderTransaction").new({
							'orderid' = order.id,
							'ownerid' = ownerid,
							'ordertotal' = cartTotal,
							'totalafterfee' = amountToCharge,
							'appfee' = appFee,
							'gateway' = 'stripe',							
							'status' = stripeCharge.containsKey("status") ? stripeCharge.status : 'failed',
							'stripe_response' = serializeJSON(stripeCharge)
						});
						orderTransactionResult = orderTransaction.save();

						//////////////////////////////////////////////////////////////////////
						// Save order items
						query name="qVendorCartItems" dbtype="query" {
							echo("SELECT * FROM qCart WHERE ownerid = '#ownerid#'");
						}
						for(var cartItem in qVendorCartItems) {
							orderItem = model("OrderItem").new({
								orderid = order.id,
								ownerid = cartItem.ownerid,
								itemid = cartItem.id,
								itemname = cartItem.name,
								itemprice = cartItem.price,
								itemquantity = userCart[cartItem.id],
								status = 'pending'
							});
							orderItemsResult = orderItem.save(transaction="none");
							if(!orderItemsResult) { break; }

							// Delete item from cart once paid and saved
							if(!isNull(session.cart.items) AND session.cart.items.containsKey(cartItem.id)) { structDelete(session.cart.items,cartItem.id); }							
						}
					} else {
						arrayAppend(checkoutErrors,"Sorry, #vendor.company#'s account is not active.");
						orderTransactionResult = false;
					}

					//////////////////////////////////////////////////////////////////////
					// If fail, rollback and show error page
					if (!orderResult || !orderItemsResult || !orderTransactionResult || orderFail || arrayLen(checkoutErrors)) {
						//transaction action="rollback"; -- disabling for now, don't want to lose strip transaction data
						orderFail = true;
					} else {
						// Delete cart
						structDelete(session,"cart");

						// Send emails
						mailgun(
							mailTo	= session.user.email,
							bcc		= application.wheels.adminEmail,
							from	= application.wheels.adminFromEmail,
							subject	= 'Order Success: #order.id#',
							html	= "<div style='font-family:Arial'>Login to FreshCartApp.com to see order details!</div>"
						);
					}

					arrayAppend(vendorOrderResults, {success=!orderFail, orderid=order.id});
				}

			}
		}
	}
	private function loggedOutOnly()
	{			
		// Authenticate
		if(!StructKeyExists(session,"user"))
		{			
			redirectTo(route="public~checkoutAction", action="login");
		}	
	}
	
	private function loggedInExcept()
	{	
		// Authenticate
		if(StructKeyExists(session,"user"))
		{			
			redirectTo(route="public~checkoutAction", action="index");
		}	
	}
	
	function loginUser(id)
	{
		var user = model("UserGroupJoin").findAll(where="userid = '#arguments.id#'", include="User,UserGroup");

		session.user = {
			id 			= user.userid,
			fullname 	= user.firstname & " " & user.lastname,
			firstname 	= user.firstname,
			lastname 	= user.lastname,
			role		= user.usergrouprole,
			email 		= user.email,
			siteid		= user.siteid,
			globalized	= user.globalized
		};
		
		if(len(trim(user.role)))
		{
			session.user.role = user.role;
		}
	}	

	function loginPost()
	{
		var user = model("User").findAll(where="email = '#params.email#' AND password = '#passcrypt(params.pass, "encrypt")#' AND #siteIdEqualsCheck()#");
			
		if(user.recordcount) {
			loginUser(user.id);
			redirectTo(route="public~checkoutAction", action="index");
		} else {
			errorMessagesName = "user";
			flashInsert(error="There was an error with your login.");
			redirectTo(route="public~checkoutAction", action="login");		
		}
	}

	function registerPost()
	{
		request.newRegistration = true;

		// Save user
		user = model("User").new(params.user);
		saveResult = user.save(); 
		
		// Insert or update user object with properties
		if (saveResult)
		{
			defaultUsergroup = model("Usergroup").findOne(where="defaultgroup = 1#wherePermission("Usergroup","AND")#"); // wherePermission for siteid
			model("UsergroupJoin").create(usergroupid = defaultUsergroup.id, userid = user.id);
			flashInsert(success="You signed up, you can now continue with checkout!");
			loginUser(user.id);
			redirectTo(route="public~checkoutAction", action="index");
		} else {
			errorMessagesName = "user";
			flashInsert(error="There was an error with your registration.");
			renderPage(route="public~checkoutAction", action="login");		
		}
	}

	function checkCartExists()
	{
		if(isNull(session.cart.items))
		{
			session.cart.items = {};
		}
	}
	numeric function amountToCents(required numeric amount) {
		local.amount = arguments.amount * 100; // convert amount to cents for Stripe
		return local.amount;
	}
	
	numeric function centsToAmount(required numeric cents) {
		local.amount = arguments.cents / 100; // convert cents to dollars
		return local.amount;
	}
}
</cfscript>