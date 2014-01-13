<cfscript>
	component extends="_main" 
	{
		function init() 
		{
			super.init();
		}
		
		function index()
		{			
			statusTabs("user");
			
			qUsers = model("User").findAll(where=buildWhereStatement("User"), order=session.users.sortby & " " & session.users.order);			
			filterResults();
			
			// Paginate me batman
			pagination.setQueryToPaginate(qUsers);	
			pagination.setItemsPerPage(session.perPage);		
			paginator = pagination.getRenderedHTML();
		}
		
		function edit()
		{						
			if(isDefined("params.id")) 
			{
				// Queries
				sharedObjects(params.id);
				user = model("User").findAll(where="id = '#params.id#'#wherePermission("User","AND")#", maxRows=1, returnAs="Object");
				
				if(ArrayLen(user))
				{				
					user = user[1];
				}
				
				// User not found?
				if (!IsObject(user))
				{
					flashInsert(error="Not found");
					redirectTo(route="moduleIndex", module="admin", controller="users");
				}			
			}
			
			renderView(action="editor");		
		}
		
		function new()
		{
			// Queries
			sharedObjects(0);
			user = model("User").new(colStruct("User"));	
				
			// If not allowed redirect
			wherePermission("User");
			
			// Show page
			renderView(action="editor");
		}
		
		function register()
		{
			usesLayout("/layouts/layout.admin.misc");
			
			// Queries
			sharedObjects(0);
			user = model("User").new(colStruct("User"));
		}
		
		function registerPost()
		{				
			usesLayout("/layouts/layout.admin.misc");
			
			request.newRegistration = true;
			
			// Save Portrait
			if(len(form.portrait) AND FileExists(form.portrait))
			{				
				uploadResult = fileMgr.uploadFile(FieldName="portrait", NameConflict="MakeUnique");	
				
				if(StructKeyExists(uploadResult,"filewassaved") AND uploadResult.filewassaved)
				{
					params.user.portrait = fileMgr.getFileURL(uploadResult.serverfile);
				}
			}
			
			// Save user
			user = model("User").new(params.user);
			saveResult = user.save();
			
			// Insert or update user object with properties
			if (saveResult)
			{			
				flashInsert(success="You have registered successfully!");
				redirectTo(route="moduleAction", module="admin", controller="users", action="login");									
			} 
			else 
			{
				errorMessagesName = "user";
				flashInsert(error="There was an error.");
				renderView(route="moduleAction", module="admin", controller="users", action="register");		
			}		
		}
		
		function delete()
		{
			user = model("User").findByKey(params.id);
			
			if(user.delete())
			{
				flashInsert(success="The user was deleted successfully.");							
			} else 
			{
				flashInsert(error="The user could not be found.");
			}
			
			redirectTo(
				route="moduleIndex",
				module="admin",
				controller="users"
			);
		}
	
		function save()
		{				
			param name="params.usertags" default="";			
			
			// Handle submit button type (publish,draft,trash,etc)
			if(!isNull(params.submit))
			{
				params.user.status = handleSubmitType("user", params.submit);	
			}
			
			// Save Portrait
			if(len(form.portrait) AND FileExists(form.portrait))
			{				
				uploadResult = fileMgr.uploadFile(FieldName="portrait", NameConflict="MakeUnique");	
				
				if(StructKeyExists(uploadResult,"filewassaved") AND uploadResult.filewassaved)
				{
					params.user.portrait = fileMgr.getFileURL(uploadResult.serverfile);
				}
			}
			
			// Get user object
			if(!isNull(params.user.id)) 
			{
				user = model("User").findByKey(params.user.id);
				saveResult = user.update(params.user);
				
				// Clear existing video category associations
				model("userTagJoin").deleteAll(where="userid = #params.user.id#");
			} else {
				user = model("User").new(params.user);
				saveResult = user.save();
			}
			
			// Insert or update user object with properties
			if (saveResult)
			{				
				if(StructKeyExists(params,"isHome"))
				{
					option = model("Option").findByKey("home_id");
					option.update(content=user.id);
				}			
				
				// Insert new user category associations			
				for(id in ListToArray(params.usertags))
				{				
					model("userTagJoin").create(categoryid = id, userid = user.id);				
				}
				
				flashInsert(success="User saved.");
				redirectTo(route="moduleId", module="admin", controller="users", action="edit", id=user.id);			
						
			} else {						
				
				errorMessagesName = "user";
				param name="user.id" default="0";
				sharedObjects(user.id);
				
				flashInsert(error="There was an error.");
				renderView(route="moduleAction", module="admin", controller="users", action="editor");		
			}		
		}
		
		function login()
		{
			usesLayout("/layouts/layout.admin.login");
		}
		
		function logout()
		{
			StructDelete(session,"user");
			redirectTo(route="moduleAction", module="admin", controller="users", action="login");
		}
		
		function loginPost()
		{
			param name="params.email" default="";
			
			var user = model("User").findAll(where="email = '#params.email#' AND password = '#passcrypt(params.pass, "encrypt")#'");
			
			if(user.recordcount)
			{
				session.user.id = user.id;
				setUserInfo();
				redirectTo(route="moduleAction", module="admin", controller="main", action="home");					
				
			} else {			
				flashInsert(error="No account was found with that email and password combination.");		
				redirectTo(route="moduleAction", module="admin", controller="users", action="login");	
			}
		}
		
		function recovery()
		{
			usesLayout("/layouts/layout.admin.misc");
		}
		
		function recoveryPost()
		{
			param name="params.email" default="";
			
			var user = model("User").findAll(where="email = '#params.email#'");
			
			if(user.recordcount)
			{
				mailgun(
					mailTo	= user.email,
					from	= application.wheels.errorEmailAddress,
					subject	= "Account Recovery",
					html	= "Your password is #passcrypt(user.password, "decrypt")#"
				);
				
				flashInsert(success="Your account information has been emailed to you. (Check your spam if you don't see it)");		
				redirectTo(route="moduleAction", module="admin", controller="users", action="login");	
			} else
			{
				flashInsert(error="No account for #params.email# found.");		
				redirectTo(route="moduleAction", module="admin", controller="users", action="recovery");	
			}		
		}
		
		// Override the parent function here, because we also need to check to see if it's the owner's id
		function wherePermission(modelName="", prepend="")
		{
			if(checkPermission("#arguments.modelName#_read_others"))
			{
				return "";
			} else if (checkPermission("#arguments.modelName#_read") OR (!isNull(params.id) AND params.id eq session.user.id)) 
			{
				return " #arguments.prepend# (id = '#session.user.id#' OR createdby = '#session.user.id#')";
			} else 
			{
				flashInsert(error="Sorry, you don't have permission to do that.213");
				redirectTo(route="moduleAction", module="admin", controller="main", action="home");
			}
		}
		
		function sharedObjects(userid)
		{					
			usStates = getStatesAndProvinces();
			countries = getCountries();	
			usertags = model("UserTag").findAll();
			selectedusertags = model("userTagJoin").findAll(where="userid = #arguments.userid#",include="User,UserTag");
			selectedusertags = ValueList(selectedusertags.categoryid);
		}	
		
		function deleteSelection()
		{
			for(i=1; i LTE ListLen(params.deletelist); i++)
			{
				model("User").findByKey(ListGetAt(params.deletelist,i)).delete();
			}
			
			flashInsert(success="Your users were deleted successfully!");			
			
			redirectTo(
				route="moduleIndex",
				module="admin",
				controller="users"
			);
		}
		
		function setPerPage()
		{
			if(!isNull(params.id) AND IsNumeric(params.id))
			{
				session.perPage = params.id;
			}
			
			redirectTo(
				route="moduleIndex",
				module="admin",
				controller="users"
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
				
				// Clear out the duplicates
				qUsers = queryOfQueries(
					query	= "qUsers",
					order	= session.users.sortby & " " & session.users.order
				);
				
				if(len(rememberParams))
				{
					pagination.setAppendToLinks("&#rememberParams#");
				}
				
				//renderView(route="moduleAction", module="admin", controller="users", action="index");		
			}
		}
			
	}
</cfscript>