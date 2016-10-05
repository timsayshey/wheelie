component extends="_main" output="false" 
{
	function init() 
	{
		super.init();			
	}
	
	function index() 
	{
	}

	function switchuser(){
		if (params.containsKey("id") AND isNumeric(params.id) AND checkPermission("superadmin")) {
			session.user.id = params.id;
			location("/"); 
			abort;
		} else {
			writeOutput("fail."); abort;
		}
	}

	function enableVendor(){
		toggleVendor(params.id,1);
	}

	function disableVendor(){
		toggleVendor(params.id,0);
	}

	function toggleVendor(ownerid,enable){
		user = model("User").findOne(where="id = '#ownerid#'");

		if(isObject(user))
		{
			enabledOrDisabled = arguments.enable ? 'enabled' : 'disabled';
			user.update(market_enabled=arguments.enable,callbacks=false,validate=false);
			// Send email
			mailgun(
				mailTo	= user.email,
				from	= application.wheels.adminFromEmail,
				reply	= session.user.email,
				subject	= 'Your account has been #enabledOrDisabled#',
				html	= "
				<div style='font-family:Arial'>
					The market manager, #session.user.firstname# #session.user.lastname#, has #enabledOrDisabled# your account.<br><br>
					If you believe this was done in error, please contact #session.user.firstname# at #session.user.email#
				</div>"
			);
		} else {
			throw("ToggleVendor error!")
		}
		flashInsert(success="User has been updated successfully");
		redirectTo(route="admin~peopleTypes", currentGroup=3);
	}
} 