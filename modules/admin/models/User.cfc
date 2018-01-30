component extends="models.Model"
{
	function init() {
		// Before after save
		beforeSave("sanitize,checkAndSecurePassword,preventRoleHacking");

		// Validations
		validatesConfirmationOf(properties="email", message="The email addresses that you entered do not match");
		validatesPresenceOf("email");

		//validatesPresenceOf(property="about", when="onCreate", message="Bio can't be empty");
		//validatesPresenceOf(property="jobtitle", when="onCreate", message="Job title can't be empty");
		validatesPresenceOf(property="firstname", when="onCreate", message="First name can't be empty");
		validatesPresenceOf(property="password", when="onCreate", message="Password can't be empty");
		//validatesPresenceOf(property="lastname", when="onCreate", message="Last name can't be empty");

		// validatesFormatOf(property="email", type="email");
		validatesUniquenessOf(property="email");
		// validatesUniquenessOf(property="username", scope="siteid");
		// validatesLengthOf(property="username", within="4,65", message="Username length must be between 4 and 65 characters.");
		validatesLengthOf(property="password", minimum="6", maximum="150");

		// Relations
		hasMany(name="Logs");
		hasMany(name="UserTagJoins");
		belongsTo(name="UserTagJoin",foreignKey="id",joinkey="userid");

		belongsTo(name="Log");
		belongsTo(name="Post",foreignKey="createdBy");
		belongsTo(name="Itdevice",foreignKey="userid");

		belongsTo(name="UsergroupJoin", foreignKey="id", joinKey="userid", joinType="outer");

		super.init();

		// Permission check override
		beforeDelete('checkForDeletePermission');
		beforeCreate('checkForCreatePermission');
		beforeUpdate('checkForUpdatePermission');
	}

	// Permission Checks
	private function checkForCreatePermission() {
		if(isNull(this.createdby)) {
			this.createdby = 0;
		}
		checkForPermission(type="save", checkid=0 & "," & this.createdby); // Allow whoever created it or the owner to edit
	}

	private function checkForUpdatePermission() {
		checkForPermission(type="save", checkid=this.id & "," & this.createdby);
	}

	private function checkForDeletePermission() {
		checkForPermission(type="delete", checkid=this.id & "," & this.createdby);
	}

	// Clean strings
	private function sanitize() {
		var propsToSanitize = "firstname,lastname,address1,address2,state,zip,country,phone";
		for(var item in listToArray(propsToSanitize)) {
			if(!isNull(this[item])) this[item] = htmlEditFormat(this[item]);
		}
	}

	// Security
	private function checkAndSecurePassword() {
		if (StructKeyExists(this, "password") AND !len(this.password)) {
			StructDelete(this,"password");
		}
		else if (StructKeyExists(this, "password") && !isEncryted(this.password)) {
			this.password = passcrypt(this.password, "encrypt");
		}
	}

	private function isEncryted(hash) {
		try {
			passcrypt(arguments.hash, "decrypt");
			return true;
		} catch(any e) {
			return false;
		}
	}

	private function preventRoleHacking() {
		if(StructKeyExists(this, "role") AND checkPermission("user_save_role")) {
			if(!checkPermission("user_save_role_admin") AND ListFind("admin,editor",lcase(this.role))) {
				StructDelete(this,"role");
			}

		} else {
			StructDelete(this,"role");
		}
	}
	public function saveNewUser(params) {
		params.isAPI = params.containsKey('isAPI') && params.isAPI ? true : false;
		var domainMatchResult = requireEmailMatchDomain(params);
		if(domainMatchResult.containsKey("error")) {
			return domainMatchResult;
		}

		param name="params.usertags" default="";
		param name="params.usergroups" default="";

		if(!isNull(params.user.approval_flag) AND params.user.approval_flag eq 1) {
			mailgun(
				mailTo	= '#application.wheels.adminEmail#,#!isNull(request.hrEmails) AND len(trim(request.hrEmails)) ? ",#request.hrEmails#" : ""#',
				from	= application.wheels.adminFromEmail,
				subject	= "User Changes Pending",
				html	= "User: #params.user.firstname# #params.user.lastname#<br>
							<br>
							Click the link below to approve:<br>
							https://#request.site.domain#/connect/users/approval"
			);
		}

		// Get user object
		if(!isNull(params.user.id)) {
			params.user = model("User").findByKey(params.user.id);
			var saveResult = params.user.update(params.user);
		} else {
			params.user = model("User").new(params.user);
			var saveResult = params.user.save();
		}

		// Insert or update user object with properties
		if (saveResult) {
			// Approve Portrait
			var pendingPortraitPath = expandThis("/assets/userpics_pending/#params.user.id#.jpg");
			if(!isNull(params.handlePortrait) AND fileExists(pendingPortraitPath)) {
				if(params.handlePortrait eq "live") {
					FileMove(
						pendingPortraitPath,
						expandThis("/assets/userpics/#params.user.id#.jpg")
					);
				}
				else if(params.handlePortrait eq "delete") {
					FileDelete(pendingPortraitPath);
				}
			}

			// Delete Portrait
			if(!isNull(params.portrait_delete)) {
				deleteThisFile("/assets/userpics/#params.user.id#.jpg");
				deleteThisFile("/assets/userpics_full/#params.user.id#.jpg");
				deleteThisFile("/assets/userpics_pending/#params.user.id#.jpg");
			}

			// Save Portrait
			if(!isNull(form.portrait) AND len(form.portrait) AND FileExists(form.portrait)) {
				if(uploadUserImage("portrait",user)) {
					params.user.portrait = "";
				}
			}

			if(StructKeyExists(params,"isHome")) {
				var option = model("Option").findByKey("home_id");
				option.update(content=params.user.id);
			}

			// Clear existing user category associations
			if(!isNull(params.fromEditor)) {
				model("userTagJoin").deleteAll(where="userid = #params.user.id#");
			}

			if(len(params.usertags)) {
				// Insert new user category associations
				for(id in ListToArray(params.usertags)) {
					model("userTagJoin").create(categoryid = id, userid = params.user.id);
				}
			}

			if(checkPermission("user_save_others")) {
				// Clear existing usergroups associations
				if(!isNull(params.fromEditor)) {
					model("UsergroupJoin").deleteAll(where="userid = #params.user.id#");
				}

				if(len(params.usergroups)) {
					// Insert usergroups associations
					for(id in ListToArray(params.usergroups))
					{
						model("UsergroupJoin").create(usergroupid = id, userid = params.user.id);
					}
				}
			}

			// Save custom metafeild data
			if(!isNull(params.fielddata)) {
				model("FieldData").saveFielddata(
					fields		= params.fielddata,
					foreignid	= params.user.id
				);
			}
		}

		var isRegistration = params.containsKey("isRegistration") AND params.isRegistration;

		if(saveResult AND isRegistration) {
			if(!isNull(form.portrait) AND len(form.portrait) AND FileExists(form.portrait)) {
				if(uploadUserImage(field="portrait",user=params.user,newUser=true)) {
					params.user.portrait = "";
				}
			}

			// Default usergroup to staff ("1")
			var defaultUsergroup = model("Usergroup").findOne(where="defaultgroup = 1#wherePermission("Usergroup","AND")#");
			model("UsergroupJoin").create(usergroupid = defaultUsergroup.id, userid = params.user.id);

			params.success = "Your account was created";

			session.user.id = params.user.id;

			var sitename = capitalize(request.site.name & "." & request.site.domainExt);
			mailgun(
				mailTo	= params.user.email,
				from	= "#request.site.domain# <#application.wheels.noReplyEmail#>",
				subject	= "Registration Info",
				html	= "Hi #params.user.firstname#,<br>
					<br>
					You have successfully registered at #sitename#<br>
					<br>
					Below is your login information:<br>
					Email: #params.user.email#<br>
					Password: The password you chose during sign up.<br>
					<br>
					We hope you enjoy using #sitename#. Thanks!<br>
					<br>
					--The #sitename# Team<br>
					http://#sitename#"
			);
			params.redirectTo = {route="admin~Action", controller="users", action="login"};

		} else if(!saveResult AND isRegistration) {
			errorMessagesName = "user";
			params.error="There was an error.";
			if(!params.isAPI) {
				params.renderPage = {route="admin~action", controller="users", action="register"};
			}
		} else if(saveResult) {
			params.success="User saved.";
			params.redirectTo = {route="admin~Id", controller="users", action="edit", id=params.user.id};
		} else {
			errorMessagesName = "user";
			param name="params.user.id" default="0";
			sharedObjects(params.user.id);

			params.error="There was an error.";
			params.renderPage = {route="admin~Action", controller="users", action="editor"};
		}
		params.saveResult = saveResult;
		return params;
	}

	function requireEmailMatchDomain(params) {
		var loc = {};
		var result = {};
		if(!isNull(params.user.email) AND request.site.emailMatchDomainRequired) {
			loc.domain = ListLast(trim(params.user.email),"@");

			if(loc.domain NEQ request.site.domain AND !ListFindNoCase(request.site.emailMatchOtherDomains,loc.domain)) {
				params.error="Sorry, you entered an invalid email address. We only accept #request.site.domain# email addresses.";
				if(!isNull(params.id) AND params.action eq "save") {
					params.redirectTo = {route="admin~id", action="edit", controller="users", id=params.id};
				} else {
					params.redirectTo = {route="admin~action", action="login", controller="users"};
				}
			}
		}
		return result;
	}
}
