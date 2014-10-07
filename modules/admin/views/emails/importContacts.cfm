<cfoutput>
    
    <h2>Import Emails</h2>
    
    <cfform enctype="multipart/form-data" method="post">
		
        <strong>CSV File [3 Columns: First Name, Last Name, Email]:</strong><br />
        <cfinput type="file" name="fileUpload" /><br />
        <br />
		<strong>Subscribe these emails to:</strong><br />
        <cfinput type="checkbox" name="sceniccheck" value="yes"> Newsletter
        <br />
        <cfinput name="submit" type="submit" value="Import">
    
    </cfform><br />
    <br />
    
	#expandPath('/temp/')#
	
    <cfif isDefined("fileUpload")>    	
    	
		
		
        <cffile action="upload" fileField="fileUpload" destination="##" nameconflict="overwrite">           
        
        <cffile action="read" file="D:\websites\webmaint\admin\newsletter\import\#cffile.CLIENTFILE#" variable="csvfile">
        
        <cfloop index="index" list="#csvfile#" delimiters="#chr(10)##chr(13)#">
        
			<cfif isValid("email", listgetAt('#index#',3, ','))>                
                
                <cfif isDefined("sceniccheck")>                  
                  
					<cfset data = { C_Email = listgetAt('#index#',3, ',') }>
                    <cfset check = Application.DataMgrLive.getRecord("newsletter",data)>
                    
                    <cfif len(check.C_Email) GT 0>
                    
						<cfset data = { 
                            C_FirstName = listgetAt('#index#',1, ','),
                            C_LastName = listgetAt('#index#',2, ','),
                            C_Email = listgetAt('#index#',3, ','),
							VisneticRights = 1  }>
                        <cfset Application.DataMgrLive.insertRecord("newsletter",data)> 
                               
                    <cfelse>     
                    
                    	Whoops! #listgetAt('#index#',3, ',')# has already been added to the Scenic View List.<br /><br />
                    
                    </cfif>
                  
                </cfif>
              
                <cfif isDefined("ehobbycheck")>                  
                  
					<cfset data = { C_Email = listgetAt('#index#',3, ',') }>
                    <cfset check = Application.DataMgrLive.getRecord("ehobbybrief",data)>
                    
                    <cfif len(check.C_Email) GT 0>
                    
						<cfset data = { 
                            C_FirstName = listgetAt('#index#',1, ','),
                            C_LastName = listgetAt('#index#',2, ','),
                            C_Email = listgetAt('#index#',3, ','),
							VisneticRights = 1  }>
                        <cfset Application.DataMgrLive.insertRecord("ehobbybrief",data)>        
                             
                    </cfif>
                  
                </cfif>
                
            <cfelse>
            
            	Aw snap! The following email address is invalid: #listgetAt('#index#',3, ',')#. Please try again. <br />
				<br />
               
            </cfif>        
        
        </cfloop>
        
    	<br /><strong>Your CSV has been processed.</strong>
        
    </cfif>
    
</cfoutput>