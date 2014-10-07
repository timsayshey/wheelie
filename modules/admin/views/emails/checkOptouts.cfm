<cfoutput>
    
	<cfset lineBreak = "#chr(10)##chr(13)#">
	
    <h2>Clean Subscriber List</h2>
	Removes opt-outs and returns a clean CSV<br><br>
    
    <cfform enctype="multipart/form-data" method="post" action="#cgi.path_info#">
		
        <strong>CSV File [3 Columns: First Name, Last Name, Email]:</strong><br />
        <cfinput type="file" name="fileUpload" /><br />
		<cfinput type="checkbox" name="includeOptins" value="true"> Include enquiry opt-ins<br /><br />
        <cfinput name="submit" type="submit" value="Check">
    
    </cfform><br />
    <br />	
	
	<!--- Parse Upload --->
    <cfif !isNull(form.fileUpload) AND FileExists(form.fileUpload)>  
		
		<!--- Read CSV --->
        <cffile action="upload" fileField="fileUpload" destination="#expandPath('./test.csv')#" nameconflict="overwrite">                
        <cffile action="read" file="#expandPath('./test.csv')#" variable="csvfile">
        
		<!--- Include Optins --->
		<cfif !isNull(form.includeOptins)>
			<cfset data = { optin = 1 }>
			<cfset optins = db.getRecords("enquiries",data)>
			
			<cfloop query="optins">
				<cfif listlen(optins.name," ") EQ 1>
					<cfset fname = listfirst(optins.name," ")>
					<cfset lname = " ">
				<cfelse>
					<cfset fname = listfirst(optins.name," ")>
					<cfset lname = listlast(optins.name," ")>
				</cfif>
				<cfset subscriberInfo = '"#fname#","#lname#","#optins.email#"'>
				<cfset csvfile = ListAppend(csvfile,subscriberInfo,"#lineBreak#")>
			</cfloop>
		</cfif>
		
		<cfset cleanList = '"First Name","Last Name","Email"'>
		
		<!--- Remove Opt-outs --->
        <cfloop index="index" list="#csvfile#" delimiters="#lineBreak#">
		
        	<cfset subscriber = { 
				firstname = Replace(listgetAt('#index#',1, ','),'"','','ALL'),
				lastname = Replace(listgetAt('#index#',2, ','),'"','','ALL'),
				email = Replace(listgetAt('#index#',3, ','),'"','','ALL')
			}>		                
			
			<cfset subscriber.email = ListFirst(subscriber.email,";")>
			<cfset subscriber.email = ListFirst(subscriber.email,",")>
			
			<cfif find("@",subscriber.email)>
			 
				<cfset data = { email = subscriber.email }>
				<cfset isOptout = db.getRecord("emailoptouts",data)>
				
				<cfif !isOptout.recordcount>				
					<cfset subscriberInfo = '"#subscriber.firstname#","#subscriber.lastname#","#subscriber.email#"'>
					<cfset cleanList = ListAppend(cleanList,subscriberInfo,"#lineBreak#")>
				<cfelse>
					BAD: #subscriber.email#<br>
				</cfif>
				
			</cfif>
			
        </cfloop>
		
		<!--- Return Clean CSV --->
		<cfset filePath = "/assets/private/153793751973957193715195731313/cleanList-#DateFormat(now(),'YYYY-MM-DD')#-#TimeFormat(now(),'SS')#.csv">
		<cffile action="write"
				file="#expandPath(filePath)#"
				output="#cleanList#">
		
		<h2>Download will start soon...</h2>
		<META http-equiv="refresh" content="3;URL=#filePath#">
		
    </cfif>
    
</cfoutput>