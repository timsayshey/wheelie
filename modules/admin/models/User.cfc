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
			// validatesPresenceOf(property="firstname", when="onCreate", message="First name can't be empty");
			// validatesPresenceOf(property="lastname", when="onCreate", message="Last name can't be empty");
			
			validatesFormatOf(property="email", type="email"); 	
			validatesUniquenessOf(property="email", scope="siteid"); 
			validatesUniquenessOf(property="username", scope="siteid"); 
			validatesLengthOf(property="username", within="4,65", message="Username length must be between 4 and 65 characters.");
			validatesLengthOf(property="password", within="4,65", message="Password length must be between 4 and 65 characters.");
			
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
			try {
				this.firstname 	= htmlEditFormat(this.firstname);
				this.lastname 	= htmlEditFormat(this.lastname);		
				this.address1 	= htmlEditFormat(this.address1);		
				this.address2	= htmlEditFormat(this.address2);		
				this.state 		= htmlEditFormat(this.state);		
				this.zip 		= htmlEditFormat(this.zip);
				this.country 	= htmlEditFormat(this.country);
				this.phone 		= htmlEditFormat(this.phone);
			} catch(any e) {}
		}
		
		// Security
		private function checkAndSecurePassword()
		{
			if (StructKeyExists(this, "password") AND !len(this.password)) 
			{ 
				StructDelete(this,"password");
			}
			else if (StructKeyExists(this, "password") AND StructKeyExists(this, "passwordConfirmation")) 
			{ 
				this.password = passcrypt(this.password, "encrypt");
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