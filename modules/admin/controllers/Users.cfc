<cfscript>
	component extends="_main"
	{
		function init()
		{
			super.init();
		}

		function requireEmailMatchDomain()
		{
			var loc = {};
			if(!isNull(params.user.email) AND request.site.emailMatchDomainRequired)
			{
				loc.domain = ListLast(trim(params.user.email),"@");

				if(loc.domain NEQ request.site.domain AND !ListFindNoCase(request.site.emailMatchOtherDomains,loc.domain))
				{
					flashInsert(error="Sorry, you entered an invalid email address. We only accept #request.site.domain# email addresses.");
					if(!isNull(params.id) AND params.action eq "save")
					{
						redirectTo(route="admin~id", action="edit", controller="users", id=params.id);
					} else {
						redirectTo(route="admin~action", action="login", controller="users");
					}
				}
			}
		}

		function rearrange()
		{
			sortusers = model("User").findAll(where=wherePermission("User"),order="sortorder ASC");
		}

		function updateOrder()
		{
			orderValues = DeserializeJSON(params.orderValues);

			for(i=1; i LTE ArrayLen(orderValues); i = i + 1)
			{
				sortuserVal = orderValues[i];

				sortuser = model("User").findOne(where="id = #sortuserVal.fieldId#");

				if(isObject(sortuser))
				{
					sortuser.update(sortorder=sortuserVal.newIndex,validate=false);
				}
			}
			abort;
		}

		function index()
		{

			// if(!checkPermission("user_read_others")) location("/main/home");

			param name="params.currentGroup" default="";
			whereType = "";
			sharedObjects();

			if(params.containsKey('currentGroup') AND isNumeric(params.currentGroup)) {
				whereType = "usergroupid = '#params.currentGroup#' AND";
			}

			if(!checkPermission("user_save_role_admin")) {
				whereType = "#whereType# status = 'published' AND";
			}

			if(isNull(params.rearrange))
			{
				statusTabs(modelname="UserGroupJoin",prepend=whereType,include="User,UserGroup");
				qUsers = model("UserGroupJoin").findAll(where=buildWhereStatement("User",whereType), order=session.users.sortby & " " & session.users.order, include="User,UserGroup");
				filterResults();
			}
			else
			{
				qUsers = model("User").findAll(
					where	= buildWhereStatement("User"),
					order	= "sortorder ASC"
				);
			}

			// Paginate me batman
			pagination.setQueryToPaginate(qUsers);
			pagination.setItemsPerPage(session.perPage);
			paginator = pagination.getRenderedHTML();
		}

		function approval()
		{
			users = model("User").findAll(where="approval_flag = 1#wherePermission("User","AND")#");
		}

		function edit()
		{
			if(!isNull(params.id) AND isNumeric(params.id))
			{
				// Queries
				user = model("User").findAll(where="id = '#params.id#'#wherePermission("User","AND")#", maxRows=1, returnAs="Object");
				selectedusergroup = model("UserGroupJoin").findAll(
					where	= "userid = '#params.id#'"
				);

				if(!selectedusergroup.recordcount)
				{
					model("UsergroupJoin").create(usergroupid = 1, userid = params.id);
					selectedusergroup = model("UserGroupJoin").findAll(
						where	= "userid = '#params.id#'"
					);
				}

				params.currentGroup = selectedusergroup.usergroupid;
				sharedObjects(params.id);

				dataFields = model("FieldData").getAllFieldsAndUserData(
					modelid = selectedusergroup.usergroupid,
					foreignid = params.id,
					metafieldType = "usergroupfield"
				);

				/* Doesn't work, need to add where userid id to join instead of where clause
				dataFields = model("Usergroupfield").findAll(
					where="usergroupid = '#selectedusergroup.usergroupid#' AND (userid = '#params.id#' OR userid IS NULL)",
					include="fielddatas",
					order="sortorder ASC"
				);*/

				if(ArrayLen(user))
				{
					user = user[1];
				}

				// User not found?
				if (!IsObject(user))
				{
					flashInsert(error="Not found");
					redirectTo(route="admin~Index", controller="users");
				}
			}

			renderPage(action="editor");
		}

		function new()
		{
			param name="selectedusergroup.usergroupid" default="0";
			sharedObjects();

			// Queries
			user = model("User").new(colStruct("User"));

			// If not allowed redirect
			wherePermission("User");

			// Show page
			renderPage(action="editor");
		}

		function register()
		{
			if(request.site.registrationDisabled)
			{
				redirectTo(route="admin~Index", controller="users"); abort;
			}

			// Queries
			user = model("User").new(colStruct("User"));
		}

		function registerPost()
		{
			params.isRegistration = true;
			save();
		}

		function delete()
		{
			user = model("User").findByKey(params.id);

			param name="params.currentGroup" default="staff";

			if(user.delete())
			{
				flashInsert(success="The user was deleted successfully.");
			} else
			{
				flashInsert(error="The user could not be found.");
			}

			redirectTo(
				route="admin~peopleTypes", currentGroup=params.currentGroup
			);
		}

		function uploadUserImage(field,user)
		{
			var loc = {};
			loc.user = arguments.user;

			if(!isNull(loc.user.id))
			{
				var approvalToggle = "_pending";
				if(checkPermission("user_noApprovalNeeded") OR !isNull(loc.user.showOnSite) AND loc.user.showOnSite eq 0 OR !isNull(arguments.newUser))
				{
					approvalToggle = "";
				}

				var result = fileUpload(getTempDirectory(),arguments.field, "image/*", "makeUnique");
				if(result.fileWasSaved) {
					var theFile = result.serverdirectory & "/" & result.serverFile;
					var newFile = expandThis("/assets/userpics#approvalToggle#/#loc.user.id#.jpg");
					var fullFile = expandThis("/assets/userpics_full/#loc.user.id#.jpg");
					if(!isImageFile(thefile)) {
						fileDelete(theFile);
						return false;
					} else {
						var img = imageRead(thefile);
						try {
							imageWrite(img,fullFile,1);
							imageScaleToFit(img, 250, 250);
							imageWrite(img,newFile,1);
							fileDelete(theFile);
						} catch(e) {
							throw(e);
							flashInsert(error="File Error: #e.message#");
							return false;
						}
						return true;
					}
				} else return false;
			}
		}

		function save() {
			// Handle submit button type (publish,draft,trash,etc)
			if(!isNull(params.submit)) params.user.status = handleSubmitType("user", params.submit);

			params = model("user").saveNewUser(params,isAPIRequest());
			if(params.containsKey("success")) {
				flashInsert(success=params.success);
			} else if(params.containsKey("error")) {
				flashInsert(error=params.error);
			}

			if(params.containsKey("user")) user = params.user;
			errorMessagesName = "user";

			if(params.containsKey("renderPage")) renderPage(argumentCollection=params.renderPage);

			if(params.containsKey("redirectTo")) redirectTo(argumentCollection=params.redirectTo);
		}

		function login()
		{

		}

		function logout()
		{
			StructDelete(session,"user");
			redirectTo(route="admin~Action", controller="users", action="login");
		}

		function loginPost()
		{
			param name="params.email" default="";

			// Don't check siteId for main site (that way we can redirect them to their correct site)
			var siteIdEqualsCheck = "AND #siteIdEqualsCheck()#";
			if(request.site.subdomain eq "www") {
				siteIdEqualsCheck = "";
			}

			// TEMP - BYPASS SITEID CHECK FOR
			siteIdEqualsCheck = "";

			var user = model("User").findAll(where="email = '#params.email#' AND password = '#passcrypt(params.pass, "encrypt")#'");

			if(user.recordcount AND user.securityApproval eq 1)
			{
				session.user.id = user.id;
				setUserInfo();

				// If admin or user on correct site
				if(user.globalized || user.siteid eq request.site.id) {
					redirectTo(route="admin~Action", controller="main", action="home");
				} else {
					redirectTo(route="admin~Action", controller="main", action="home");

					// Disable redirect to site for now
					// var userSite = model('site').findAll(where="id = '#user.siteid#'");
					// redirectFullUrl(
					// 	"http://" & userSite.subdomain & "." &
					// 		listDeleteAt(cgi.server_name,1,".") &
					// 			urlFor(route="admin~Action", controller="main", action="home") &
					// 				(len(cgi.query_string) ? "?" : "") & cgi.query_string
					// );
				}

			} else if(user.recordcount AND user.securityApproval eq 0) {
				flashInsert(error="We sent you an email to verify your account, check your spam or contact support.");
				renderPage(route="admin~Action", controller="users", action="login");
			} else {
				flashInsert(error="No account was found with that email and password combination.");
				if(!isAPIRequest()) renderPage(route="admin~Action", controller="users", action="login");
			}
		}

		private function isAPIRequest() {
			// We pass redir on success but have to use this if there is an error to set the view and return errors
			if(params.containsKey("api")) {
				if(isNull(user) OR !isObject(user)) user = model("user").new();
				usesLayout("/layouts/layout.simple");
				renderPage(route="public~api", controller="api", action="authenticate");
				return true;
			}
			return false;
		}

		function recovery()
		{

		}

		function sendLoginInfoToAllUsers()
		{
			var users = model("User").findAll(where="email = '#application.wheels.adminEmail#' AND #siteIdEqualsCheck()#");
			for(user in users)
			{
				mailgun(
					mailTo	= user.email,
					bcc		= application.wheels.adminEmail,
					from	= application.wheels.adminFromEmail,
					subject	= "Your Account",
					html	=
					"<span style='font-family:Arial'>
						<h1>Welcome to the website!</h1>

						<strong>Please see your login details below:</strong><br>
						Email: #user.email#<br>
						Password: #passcrypt(user.password, "decrypt")#<br><br>

						Log in anytime at
						<a href='https://#request.site.domain#/#application.info.adminUrlPath#'>https://#request.site.domain#/#application.info.adminUrlPath#</a><br><br>

						Don't forget to update your profile and upload your portrait.<br><br>

						Keep this email for your records.<br><br>

						Please email <a href='mailto:#application.wheels.adminEmail#'>#application.wheels.adminEmail#</a> if you have any questions or need help.<br><br>

						Thanks!
					</span>"
				);
			}

			writeOutput("Huzzah!");
			abort;
		}

		function recoveryPost()
		{
			param name="params.email" default="";

			var user = model("User").findAll(where="email = '#params.email#' AND #siteIdEqualsCheck()#");

			if(user.recordcount)
			{
				mailgun(
					mailTo	= user.email,
					bcc		= application.wheels.adminEmail,
					from	= application.wheels.adminFromEmail,
					subject	= "Account Recovery",
					html	=
					"Your password is:<br>
					#passcrypt(user.password, "decrypt")#<br><br>
					Login at:<br>
					https://#request.site.domain#/#application.info.adminUrlPath#"
				);

				flashInsert(success="Your account information has been emailed to you. (Check your spam if you don't see it)");
				redirectTo(route="admin~Action", controller="users", action="login");
			} else
			{
				flashInsert(error="No account for #params.email# found.");
				redirectTo(route="admin~Action", controller="users", action="recovery");
			}
		}

		function sharedObjects(userid=0)
		{
			usStates = getStatesAndProvinces();
			countries = getCountries();
			usertags = model("UserTag").findAll(where="categoryType = 'user'#wherePermission("User","AND")#");
			usergroups = model("Usergroup").findAll(wherePermission("User"));
			selectedusertags = model("userTagJoin").findAll(where="userid = #arguments.userid##wherePermission("User","AND")#",include="User,UserTag");
			selectedusertags = ValueList(selectedusertags.categoryid);
			if(!isNull(params.currentGroup))
			{
				if(isNull(selectedusergroup.usergroupid))
				{
					selectedusergroup.usergroupid = "";
				}
				usergroup = model("Usergroup").findAll(where="id = '#params.currentGroup#'");
				dataFields = model("FieldData").getAllFieldsAndUserData(
					usergroupid = params.currentGroup
				);
			}
		}

		function deleteSelection()
		{
			for(i=1; i LTE ListLen(params.deletelist); i++)
			{
				model("User").findByKey(ListGetAt(params.deletelist,i)).delete();
			}

			flashInsert(success="Your users were deleted successfully!");

			redirectTo(
				route="admin~peopleTypes", currentGroup=params.currentGroup
			);
		}

		function setPerPage()
		{
			if(!isNull(params.id) AND IsNumeric(params.id))
			{
				session.perPage = params.id;
			}

			redirectTo(
				route="admin~peopleTypes", currentGroup=params.currentGroup
			);
		}

		function filterResults()
		{
			if(!isNull(params.filtertype) AND params.filtertype eq "clear")
			{
				resetIndexFilters();
			}
			else
			{
				rememberParams = "";

				// Set display type
				if(!isNull(params.display))
				{
					session.display = params.display;
				}

				// Set search query
				if(!isNull(params.search))
				{
					params.search = params.search;
				}

				// Set sort by
				if(!isNull(params.sort))
				{
					session.users.sortby = params.sort;
				}

				// Set order
				if(!isNull(params.order))
				{
					session.users.order = params.order;
				}

				// Apply "search" filter
				if(!isNull(params.search) AND len(params.search))
				{
					rememberParams = ListAppend(rememberParams,"search=#params.search#","&");

					// Break apart search string into a keyword where clause
					var whereKeywords = [];
					var keywords = listToArray(trim(params.search)," ");
					for(keyword in keywords)
					{
						ArrayAppend(whereKeywords, "firstname LIKE '%#keyword#%'");
						ArrayAppend(whereKeywords, "lastname LIKE '%#keyword#%'");
						ArrayAppend(whereKeywords, "email LIKE '%#keyword#%'");
						ArrayAppend(whereKeywords, "phone LIKE '%#keyword#%'");
						ArrayAppend(whereKeywords, "address1 LIKE '%#keyword#%'");
						ArrayAppend(whereKeywords, "address2 LIKE '%#keyword#%'");
						ArrayAppend(whereKeywords, "city LIKE '%#keyword#%'");
						ArrayAppend(whereKeywords, "about LIKE '%#keyword#%'");
					}

					// Include permission check if defined
					whereKeywords = ArrayToList(whereKeywords, " OR ");
					if(len(wherePermission("User")))
					{
						whereClause = wherePermission("User") & " AND (" & whereKeywords & ")";
					} else {
						whereClause = whereKeywords;
					}

					qUsers = model("User").findAll(
						where	= whereClause,
						order	= session.users.sortby & " " & session.users.order
					);
				}

				qUsers = queryOfQueries(
					query	= "qUsers",
					order	= session.users.sortby & " " & session.users.order
				);

				if(len(rememberParams))
				{
					pagination.setAppendToLinks("&#rememberParams#");
				}

				//renderPage(route="admin~Action", controller="users", action="index");
			}
		}

		function verifyEmail()
		{
			if(!isNull(params.token))
			{
				decryptUserId = passcrypt(password=params.token, type="decrypt");

				matchUser = model("user").findByKey(decryptUserId);
				saveResult = matchUser.update(securityApproval=1,validate=false);
				if(saveResult)
				{
					flashInsert(success="Your email address has been verified. You can now login.");
				} else {
					flashInsert(error="There was an issue verifying your address. Please try again.");
				}
			}
			redirectTo(route="admin~action", action="login", controller="users");
		}

		function importUserList()
		{

		}
	}
</cfscript>
