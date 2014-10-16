<cfoutput>

	<section class="page-wrapper">
		
		<cfif subMenuItems.recordcount>
			<nav class="page-nav">
				#generateSubmenu()#
			</nav>
			<article class="page-content">    
		<cfelse>
			<article class="normal-page">
		</cfif>	
				 
		<cfif IsStruct(users)>
            <h1>#users.name#</h1>
            #users.content#
        <cfelse>
            
            <h1>#userTag.name#</h1>            
            <cfif len(trim(userTag.description))>                    
                #userTag.description#<br><br>
            </cfif>
            
			<div class="row">
            <cfloop query="users">
                <cfscript>
				user = model("UserGroupJoin").findAll(where="userid = '#users.id#'", include="User,UserGroup");
				dataFields = model("FieldData").getAllFieldsAndUserData(
					modelid = user.usergroupid,
					foreignid = user.userid,
					metafieldType = "usergroupfield"
				);
				</cfscript>	
                
                <cfquery dbtype="query" name="qQuery">
                    SELECT * FROM dataFields
                    WHERE name = 'Spouse''s Name'
                </cfquery>                
				<cfset spouse_name = qQuery.fielddata>
                
				<cfquery dbtype="query" name="qQuery">
                    SELECT * FROM dataFields
                    WHERE name = 'Website'
                </cfquery>                
				<cfset website = qQuery.fielddata>
				   
                <div class="col-sm-4" style="min-height:250px;">
					<cfset imagePath = ExpandPath("/assets/userpics/#users.id#.jpg")>
	                    
					<cfif FileExists(imagePath)>
						<img src="/assets/userpics/#users.id#.jpg" class="img-responsive" />
					<cfelse>
						<img src="/assets/img/user_thumbholder.jpg" height="143" width="207" />
					</cfif>
					<h4>#users.firstname#
					<cfif len(spouse_name)>& #spouse_name#</cfif>
					#users.lastname#</h4>
                    
					<cfif len(trim(users.title))><h5>#users.title#</h5></cfif> 
					<cfif len(trim(website))><h5><a href="#website#">Website</a></h5></cfif> 
                </div>
				
            </cfloop>
			</div>
                
        </cfif>
		
		</article>

	</section>
    
</cfoutput>