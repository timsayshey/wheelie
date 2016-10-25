<cfoutput>
    <cfset request.breadcrumb = 'Checkout Complete'> 
    <cfset themeDir = "/views/themes/#request.site.theme#/shopfrog">

    <cfif arrayLen(vendorOrderResults)>
        <div class="content clearfix">
            <h1>Your order was placed successfully</h1>
        </div>
        <div class="content inner">
            <p class="lead">Thanks for you order!</p>
            <cfloop array="#vendorOrderResults#" index="result">
                <p class="lead">Your order number is: <strong>#result.orderid#</strong>.</p>   
            </cfloop>                        
            <p>We have emailed you a receipt of the transaction for you records.</p>
            <p>Thank you for shopping with us.</p>
        </div>
    </cfif>

    <cfif orderFail>
        <div class="content clearfix">
            <h1>There was an issue with your order</h1>
        </div>
        <div class="col-sm-12">
            <div class="content inner">
                <p class="lead">We're sorry, there was an issue with your order.</p>      
                <p>Please contact support.</p>
                <p>Errors:</p>
                <p>
                    <ul>
                        <cfloop array="#checkoutErrors#" index="error">
                            <li>#error#</li>
                        </cfloop>                        
                    </ul>
                </p>
            </div> 
        </div>
    </cfif>

</cfoutput>