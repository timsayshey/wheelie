<cfscript>
	// Your custom routes
	
	adminUrlPath = application.info.adminUrlPath; // default "/manager"
	
	addRoute( 
        name="public~pageapps", 
		pattern="/y/[action]",
        controller="pageapps"
    );
	
    addRoute( 
        name="public~itemPage", 
        pattern="/i/[urlid]/[locationid]",
        action="item",
        controller="pitems"
    );

    addRoute( 
        name="public~itemRss", 
        pattern="/rss/latest/20",
        action="rss",
        controller="pitems"
    );

	addRoute( 
        name="public~itemsId", 
		pattern="/ad/[action]/[id]",
        controller="pitems"
    );

    addRoute( 
        name="public~ownerid", 
		pattern="/profile/[ownerid]",
		action="index",
        controller="pitems"
    );
	
	addRoute( 
        name="public~itemsAction", 
		pattern="/shop/[action]",
        controller="pitems"
    );
	
	addRoute( 
        name="public~itemsIndex", 
		pattern="/shop",
        controller="pitems",
		action="index"
    );
	
	addRoute( 
        name="public~cartId", 
		pattern="/cart/[action]/[id]",
        controller="pcart"
    );
	
	addRoute( 
        name="public~cartAction", 
		pattern="/cart/[action]",
        controller="pcart"
    );
	
	addRoute( 
        name="public~cartIndex", 
		pattern="/cart",
        controller="pcart",
		action="index"
    );

	addRoute( 
        name="public~checkoutAction", 
		pattern="/checkout/[action]",
        controller="pcheckout"
    );

    addRoute( 
        name="public~checkoutIndex", 
		pattern="/checkout",
        controller="pcheckout",
		action="index"
    );
	
</cfscript>