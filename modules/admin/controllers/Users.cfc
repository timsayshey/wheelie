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
			param name="params.currentGroup" default="0";
			whereType = "";
			sharedObjects();
			
			whereType = "usergroupid = '#params.currentGroup#' AND";
			
			if(!checkPermission("user_save_role_admin"))
			{
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
					redirectTo(route="admin~Index", module="admin", controller="users");
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
				redirectTo(route="admin~Index", module="admin", controller="users"); abort;
			}
			
			// Queries
			user = model("User").new(colStruct("User"));
		}
		
		function registerPost()
		{				
			requireEmailMatchDomain();
			
			request.newRegistration = true;
			
			// Sync Unapproved Fields
			// params.user.zx_firstname = params.user.firstname;				
			// params.user.zx_lastname = params.user.lastname;
			// params.user.zx_about = params.user.about;
			// params.user.zx_designatory_letters = params.user.designatory_letters;
			// params.user.zx_jobtitle = params.user.jobtitle;
			
			params.user.password = passcrypt(params.user.password, "encrypt");

			// Save user
			user = model("User").new(params.user);
			saveResult = user.save(); 
			
			// Insert or update user object with properties
			if (saveResult)
			{			
				// Save Portrait
				if(!isNull(form.portrait) AND len(form.portrait) AND FileExists(form.portrait))
				{								
					if(uploadUserImage(field="portrait",user=user,newUser=true))
					{
						user.portrait = "";
					}
				}
				
				// Default usergroup to staff ("1")
				defaultUsergroup = model("Usergroup").findOne(where="defaultgroup = 1#wherePermission("Usergroup","AND")#");
				model("UsergroupJoin").create(usergroupid = defaultUsergroup.id, userid = user.id);
				// flashInsert(success="We sent you an email with a link to verify your email address. Check your spam.");
				
				// userVerifyUrl = 'http://#request.site.domain#/#application.info.adminUrlPath#/users/verifyEmail?token=#passcrypt(password="#user.id#", type="encrypt")#';
				// mailgun(
				// 	mailTo	= user.email, 
				// 	from	= application.wheels.adminFromEmail,
				// 	subject	= "Verify your email address",
				// 	html	= "Click the link below to verify your email address:<br>
				// 			   <a href='#userVerifyUrl#'>#userVerifyUrl#</a>"
				// );
				flashInsert(success="Your account was created");
				session.user.id = user.id;
				redirectTo(route="admin~Action", module="admin", controller="users", action="login");									
			} 
			else 
			{
				errorMessagesName = "user";
				flashInsert(error="There was an error.");
				renderPage(route="admin~Action", module="admin", controller="users", action="register");		
			}		
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
					var newFile = expandPath("/assets/userpics#approvalToggle#/#loc.user.id#.jpg");
					var fullFile = expandPath("/assets/userpics_full/#loc.user.id#.jpg");
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
							flashInsert(error="File Error: #e.message#");
							return false;
						}
						return true;
					}
				} else return false;			
			}
		}
		
		function save()
		{							
			requireEmailMatchDomain();
			
			param name="params.usertags" default="";		
			param name="params.usergroups" default="";		
			
					
			// Handle submit button type (publish,draft,trash,etc)
			if(!isNull(params.submit))
			{
				params.user.status = handleSubmitType("user", params.submit);	
			}
			
			if(!isNull(params.user.approval_flag) AND params.user.approval_flag eq 1)
			{
				mailgun(
					mailTo	= '#application.wheels.adminEmail#,#!isNull(request.hrEmails) AND len(trim(request.hrEmails)) ? ",#request.hrEmails#" : ""#',
					from	= application.wheels.adminFromEmail,
					subject	= "User Changes Pending",
					html	= "User: #params.user.firstname# #params.user.lastname#<br>
								<br>
								Click the link below to approve:<br>
								http://#request.site.domain#/connect/users/approval"
				);
			}
			
			syncApprovedFields();
			
			// Get user object
			if(!isNull(params.user.id)) 
			{
				user = model("User").findByKey(params.user.id);
				saveResult = user.update(params.user);
			} else {
				user = model("User").new(params.user);
				saveResult = user.save();
			}			
			
			// Insert or update user object with properties
			if (saveResult)   
			{				
				// Approve Portrait
				pendingPortraitPath = expandPath("/assets/userpics_pending/#user.id#.jpg");
				if(!isNull(params.handlePortrait) AND fileExists(pendingPortraitPath))
				{
					if(params.handlePortrait eq "live")
					{					
						FileMove(
							pendingPortraitPath,
							expandPath("/assets/userpics/#user.id#.jpg")
						);
					}
					else if(params.handlePortrait eq "delete")
					{
						FileDelete(pendingPortraitPath);
					}
				}
				
				// Delete Portrait
				if(!isNull(params.portrait_delete))
				{
					deleteThisFile("/assets/userpics/#user.id#.jpg");
					deleteThisFile("/assets/userpics_full/#user.id#.jpg");
					deleteThisFile("/assets/userpics_pending/#user.id#.jpg");
				}
				
				// Save Portrait
				if(!isNull(form.portrait) AND len(form.portrait) AND FileExists(form.portrait))
				{								
					if(uploadUserImage("portrait",user))
					{
						params.user.portrait = "";
					}
				}
				
				if(StructKeyExists(params,"isHome"))
				{  
					option = model("Option").findByKey("home_id");
					option.update(content=user.id);
				}				
				
				// Clear existing user category associations
				if(!isNull(params.fromEditor))
				{
					model("userTagJoin").deleteAll(where="userid = #user.id#");	
				}
								
				if(len(params.usertags))
				{		
					// Insert new user category associations	
					for(id in ListToArray(params.usertags))
					{				
						model("userTagJoin").create(categoryid = id, userid = user.id);				
					}
				}
				
				if(checkPermission("user_save_others")) {
					// Clear existing usergroups associations
					if(!isNull(params.fromEditor))
					{
						model("UsergroupJoin").deleteAll(where="userid = #user.id#");	
					}
					
					if(len(params.usergroups))
					{		
						// Insert usergroups associations	
						for(id in ListToArray(params.usergroups))
						{				
							model("UsergroupJoin").create(usergroupid = id, userid = user.id);			
						}
					}
				}
				
				// Save custom metafeild data
				if(!isNull(params.fielddata))
				{ 
					model("FieldData").saveFielddata(
						fields		= params.fielddata,
						foreignid	= user.id
					);
				}
				
				flashInsert(success="User saved.");
				redirectTo(route="admin~Id", module="admin", controller="users", action="edit", id=user.id);			
						
			} else {						
				
				errorMessagesName = "user";
				param name="user.id" default="0";
				sharedObjects(user.id);
				
				flashInsert(error="There was an error.");
				renderPage(route="admin~Action", module="admin", controller="users", action="editor");		
			}	
			
		}
		
		function login()
		{
			
		}
		
		function logout()
		{
			StructDelete(session,"user");
			redirectTo(route="admin~Action", module="admin", controller="users", action="login");
		}
		
		function loginPost()
		{
			param name="params.email" default="";

			// Don't check siteId for main site (that way we can redirect them to their correct site)
			var siteIdEqualsCheck = "AND #siteIdEqualsCheck()#";
			if(request.site.subdomain eq "www") {
				siteIdEqualsCheck = "";
			}
			
			var user = model("User").findAll(where="email = '#params.email#' AND password = '#passcrypt(params.pass, "encrypt")#'");
			
			if(user.recordcount AND user.securityApproval eq 1)
			{
				session.user.id = user.id;
				setUserInfo();

				// If admin or user on correct site
				if(user.globalized || user.siteid eq request.site.id) {
					redirectTo(route="admin~Action", controller="main", action="home");
				} else {
					var userSite = model('site').findAll(where="id = '#user.siteid#'");
					redirectFullUrl(
						"http://" & userSite.subdomain & "." & 
							listDeleteAt(cgi.server_name,1,".") & 
								urlFor(route="admin~Action", controller="main", action="home") & 
									(len(cgi.query_string) ? "?" : "") & cgi.query_string
					);
				}
					
			} else if(user.recordcount AND user.securityApproval eq 0) {	
				flashInsert(error="We sent you an email to verify your account, check your spam or contact support.");	
				renderPage(route="admin~Action", controller="users", action="login");	
			} else {			
				flashInsert(error="No account was found with that email and password combination.");	
				renderPage(route="admin~Action", controller="users", action="login");		
			}
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
						<a href='http://#request.site.domain#/#application.info.adminUrlPath#'>http://#request.site.domain#/#application.info.adminUrlPath#</a><br><br>
						
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
					http://#request.site.domain#/#application.info.adminUrlPath#"
				);
				
				flashInsert(success="Your account information has been emailed to you. (Check your spam if you don't see it)");		
				redirectTo(route="admin~Action", module="admin", controller="users", action="login");	
			} else
			{
				flashInsert(error="No account for #params.email# found.");		
				redirectTo(route="admin~Action", module="admin", controller="users", action="recovery");	
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
		
		function syncApprovedFields()
		{
			if(!isNull(params.user.approval_flag) AND params.user.approval_flag neq 1)
			{			
				//abort;
				if(!isNull(params.user.zx_firstname))
				{
					params.user.firstname = params.user.zx_firstname;
				}
				if(!isNull(params.user.zx_lastname))
				{
					params.user.lastname = params.user.zx_lastname;
				}
				if(!isNull(params.user.zx_jobtitle))
				{
					params.user.jobtitle = params.user.zx_jobtitle;
				}
				if(!isNull(params.user.zx_designatory_letters))
				{
					params.user.designatory_letters = params.user.zx_designatory_letters;
				}
				if(!isNull(params.user.zx_about))
				{
					params.user.about = params.user.zx_about;
				}					
			}
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
				
				//renderPage(route="admin~Action", module="admin", controller="users", action="index");		
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