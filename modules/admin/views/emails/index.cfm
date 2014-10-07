<cftry>
<cfoutput>	

	<cfset contentFor(formy			= true)>
	<cfset contentFor(headerTitle	= '<span class="elusive icon-cog"></span> Emails')>
	
	<h2>Subscriber Stats</h2>
	
	<strong>Emails:</strong> #qEmails.recordcount#<br />
	<strong>Opt-outs</strong>: #qOptouts.recordcount#<br /><br />
	
	<h2>Add subscribers</h2>
		
	<form enctype="multipart/form-data" method="post">
		
        <strong>CSV File [3 Columns: First Name, Last Name, Email]:</strong><br />
        <input type="file" name="fileUpload" /><br />
        <br />
        <input name="submit" type="submit" value="Import">
    
    </form>
	
	<h2>Download subscribers</h2>
	
	<a href="#urlFor(route='admin~action',controller='emails',action='download')#">Click here</a>
	
	<cfif isDefined("fileUpload")>  
		  	
		<cfset tempPath = "C:\home\">	
		<cffile action="upload" fileField="fileUpload" destination="#tempPath#" nameconflict="overwrite">          
	    <cffile action="read" file="#tempPath##cffile.CLIENTFILE#" variable="csvfile">
		
		<cfloop index="index" list="#csvfile#" delimiters="#chr(10)##chr(13)#">
	        <cftry>
				<cfset currEmail = listgetAt(index,3, ',')>
				<cfset currEmail = trim(ListFirst(currEmail))> 
				<cfset currEmail = ListFirst(currEmail," ")>
				<cfset currEmail = ListFirst(currEmail,";")>
				<cfset currEmail = Replace(currEmail,'"','','ALL')>
				
				<cfif listlen(currEmail,'@') eq 2> 
				
					<cfset check = model("Email").findAll(where="email LIKE '%#currEmail#%'")>
					
					<cfif !check.recordcount>
					
						<cfset data = { 
							firstName = Replace(listgetAt('#index#',1, ','),'"','','ALL'),
							lastName = Replace(listgetAt('#index#',2, ','),'"','','ALL'),
							email = currEmail
						}>
						<cfset db.insertRecord("emails",data)> 
							   
					<cfelse>     
					
						Whoops! #currEmail# has already been added.<br /><br />				
					</cfif>
						
				<cfelse>
				
					Aw snap! The following email address is invalid: #currEmail#. Please try again. <br />
					<br />
				   
				</cfif> 
				<cfcatch></cfcatch>       
			</cftry>
		</cfloop>
		
		<br /><strong>Your CSV has been processed.</strong>
	
	</cfif>

</cfoutput>
		<cfcatch>
			<cfdump var="#cfcatch#">
		</cfcatch>
 
</cftry>