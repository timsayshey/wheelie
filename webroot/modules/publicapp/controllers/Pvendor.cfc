component extends="_main" output="false" 
{
	function init() 
	{
		super.init();
		filters(through="loggedOutOnly",except="login,loginPost,recovery,recoveryPost,signup,registerPost");
	}

	private function loggedOutOnly()
	{			
		if(StructKeyExists(session,"user"))
		{			
			redirectTo(route="public~itemsAction", action="index");	
		}	
	}
	
	function index()
	{
	}

	function signup()
	{
		user = model("User").new(colStruct("User"));
	}

	function registerPost()
	{				
		request.newRegistration = true;
	
		// Sync Unapproved Fields
		params.user.zx_firstname = params.user.firstname;				
		params.user.zx_lastname = params.user.lastname;
		params.user.zx_about = params.user.about;
		params.user.zx_company = params.user.company;

		transaction {

			// Save user
			user = model("User").new(params.user);			

			// Require company name and about
			var userResult = false;
			var usergroupJoinResult = false;

			if( !len(trim(params.user.company)) || !len(trim(params.user.about)) ) 
			{
				!len(trim(params.user.company)) ? user.addErrorToBase(message="Company name is required.") : false;
				!len(trim(params.user.about)) ? user.addErrorToBase(message="About company is required.") : false;				
			} else {
				userResult = user.save();

				// Add user to vendor group
				if(structKeyExists(user,"id")) {
					usergroupJoin = model("UsergroupJoin").new({ usergroupid = '5', userid = user.id});
					usergroupJoinResult = usergroupJoin.save();
				}
			}	

			// Insert or update user object with properties
			if (userResult && usergroupJoinResult)
			{			
				
				flashInsert(success="We sent you an email with a link to verify your email address. Check your spam.");

				var managers = model("user").findAll(
					where	= "siteid = '#request.site.id#' AND usergroupid = '2'",
					include = "UsergroupJoin(usergroup)"
				);

				for(var manager in managers) {
					mailgun( 
						mailTo	= manager.email,
						subject	= "New Vendor Signup: #params.user.company# - #params.user.firstname# #params.user.lastname#",
						html	= "User: #params.user.firstname# #params.user.lastname#<br><br>
									View profile:<br>
									http://#request.site.domain#/manager/profiles/profile/#user.id#"
					);
				}			
				
				userVerifyUrl = 'http://#request.site.domain#/#application.info.adminUrlPath#/users/verifyEmail?token=#passcrypt(password="#user.id#", type="encrypt")#';
				mailgun(
					mailTo	= user.email, 
					from	= application.wheels.adminFromEmail,
					subject	= "Verify your email address",
					html	= "Click the link below to verify your email address:<br>
							   <a href='#userVerifyUrl#'>#userVerifyUrl#</a>"
				);
				session.user.id = user.id;
				transaction action="commit";
				redirectTo(route="public~itemsAction", action="index");	
			} 
			else 
			{
				transaction action="rollback";
				errorMessagesName = "user";
				flashInsert(error="There was an error.");
				renderPage(route='public~pvendor', action='signup');		
			}	
		}
	}
}