<cfsavecontent variable="UserList">
Bob	~	 Jim	~	bobjim@gmail.com
</cfsavecontent>

<cfoutput>
	<cfset cnt = 0>
	<cfloop list="#UserList#" delimiters="#chr(13)#" index="user">
	<cftry>
		<cfset fname = trim(ListGetAt(user,2,"~"))>
		<cfset lname = trim(ListGetAt(user,1,"~"))>
		<cfset email = trim(ListGetAt(user,3,"~"))>
		
		<cfscript>
			usercheck = model("User").findAll(where="email LIKE '#email#'",includeSoftDeletes=true);
			if(usercheck.recordcount eq 0)
			{	
				userinfo = {
					email = email,
					firstname = fname,
					lastname = lname,
					password = "changethis#cnt#",
					passwordConfirmation = "changethis#cnt#",
					zx_firstname = fname,			
					zx_lastname = lname
				};
				
				user = model("User").new(userinfo); 
				
				if (user.save())
				{			
					model("UsergroupJoin").create(usergroupid = 1, userid = user.id);
				}			
			}
			cnt++;
		</cfscript>
		<cfcatch></cfcatch>
	</cftry>
	</cfloop>
</cfoutput>