<cffunction name="mailgun">
	<cfargument name="mailTo" default="">
	<cfargument name="from" default="">
	<cfargument name="reply" default="">
	<cfargument name="bcc" default="">
	<cfargument name="subject" default="">
	<cfargument name="apiKey" default="xyz">
	<cfargument name="html" default=""> 
	<cfargument name="txt" default="">
		
	<!--- Try postmark
	<cfset pmCode = CreateObject("component","com.PostMarkAPI").sendMail(
		mailTo		= arguments.mailTo,
		mailFrom 	= arguments.From,
		mailReply 	= arguments.Reply,
		mailBcc 	= arguments.Bcc,
		mailSubject = arguments.Subject,            
		apiKey 		= arguments.apiKey,
		mailHTML 	= arguments.HTML,
		mailTxt 	= arguments.Txt
	)>
	
	<!--- If postmark fails --->
	<cfif !Find("200",pmCode)>
	
		<cfmail        
			type="html"
			from="error@churchinviter.org"  
			to="timsayshey@gmail.com"      
			subject="CI Postmark Error">        
			Code Length: #len(pmCode)# - Code: #pmCode#<br><br>
			
			<cfif isDefined("form")>
				<cfdump var="#form#"><br>                    
			</cfif>
			
			<cfif isDefined("cgi")>
				<cfdump var="#cgi#">                  
			</cfif>        
		</cfmail>
		
		<cfmail        
			type="html"
			from="Church Inviter <evite@churchinviter.org>" 
			replyto="#arguments.Reply#" 
			to="#arguments.mailTo#" 
			bcc="#arguments.Bcc#"        
			subject="#arguments.Subject#">   
				 
			#arguments.HTML#
			
		</cfmail>
	</cfif> --->
	
	<cfmail        
		type="html"
		from="#arguments.from#" 
		replyto="#arguments.reply#" 
		to="#arguments.mailTo#" 
		bcc="#arguments.bcc#"        
		subject="#arguments.subject#">   
			 
		#arguments.html#
		
	</cfmail>
</cffunction>