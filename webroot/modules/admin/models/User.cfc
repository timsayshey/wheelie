<cfscript>	
	component extends="models.Model"
	{					
		function init()
		{			
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
		private function checkForCreatePermission()	
		{
			if(isNull(this.createdby))
			{
				this.createdby = 0;
			}
			checkForPermission(type="save", checkid=0 & "," & this.createdby); // Allow whoever created it or the owner to edit
		}
		
		private function checkForUpdatePermission()	
		{
			checkForPermission(type="save", checkid=this.id & "," & this.createdby);
		}
		
		private function checkForDeletePermission()
		{
			checkForPermission(type="delete", checkid=this.id & "," & this.createdby);
		}
	 	
		// Clean strings
		private function sanitize()
		{	
			var propsToSanitize = "firstname,lastname,address1,address2,state,zip,country,phone";
			for(var item in listToArray(propsToSanitize)) {
				if(!isNull(this[item])) this[item] = htmlEditFormat(this[item]);
			}
		}
		
		// Security
		private function checkAndSecurePassword()
		{
			if (StructKeyExists(this, "password") AND !len(this.password)) 
			{ 
				StructDelete(this,"password");
			}
			else if (StructKeyExists(this, "password") && !isEncryted(this.password)) 
			{ 
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
		
		private function preventRoleHacking()
		{
			if(StructKeyExists(this, "role") AND checkPermission("user_save_role"))
			{				
				if(!checkPermission("user_save_role_admin") AND ListFind("admin,editor",lcase(this.role)))
				{ 
					StructDelete(this,"role");
				}
				
			} 
			else 
			{
				StructDelete(this,"role");
			}
		}
	}
</cfscript>	