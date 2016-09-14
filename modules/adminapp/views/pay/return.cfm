<cfset stripeSecretKey = 'sk_test_twS6XfB68E9DHlZdLnnDAI1k'>

<cfhttp
    method="post"
    url="https://connect.stripe.com/oauth/token"
    userAgent="FreshCart">
    <cfhttpparam type="Formfield" name="client_secret" value="#stripeSecretKey#">
    <cfhttpparam type="Formfield" name="code" value="#params.code#">
    <cfhttpparam type="Formfield" name="grant_type" value="authorization_code">
</cfhttp>

<cfset response = deserializeJSON(cfhttp.filecontent)>

<cfif response.containsKey('stripe_user_id')>
	<cfset user = model("User").findByKey(session.user.id)>
	<cfset saveResult = user.update({
		stripe_token_type 		= response.token_type,
		stripe_publishable_key 	= response.stripe_publishable_key,
		stripe_scope 			= response.scope,
		stripe_livemode 		= response.livemode eq 'false' ? 0 : 1,
		stripe_user_id 			= response.stripe_user_id,
		stripe_refresh_token 	= response.refresh_token,
		stripe_access_token 	= response.access_token,
		stripe_vendor_active	= 1
	})>

	<cfif saveResult>
		Success! Your Stripe account has been authenticated.
	</cfif>
<cfelse>
	Sorry, there was an error authenticating your Stripe account. Please try again.
</cfif>