<cfoutput>
	
	<cfset contentFor(siteTitle = "Newsletter sign up")>
	
	<cfset request.page.hideSidebar = true>	
	<cfset request.page.hideFooterCallToAction = true>	
	<cfset contentFor(formy			= true)>    
	<cfset lineBreak = "#chr(10)##chr(13)#">
    
	<div class="well"> 
	   #startFormTag(action="http://#site.request.domain#/p/newsletterSubmit",method="post")#
		<h2>Newsletter Sign-up</h2>
		
		The email newsletter is the best way to stay informed about upcoming events, special announcements and new website content. Also don't forget to like our page to get live updates in your Facebook feed.<br><br>
		
		<div class="input-group text-center">
			#textfieldtag(
				name			= 'email', 
				placeholder		= 'Your Email',
				class			= 'form-control input-lg'
			)#
			<span class="input-group-btn">#submitTag(class="btn btn-lg btn-primary",value="OK")#</span>
		</div>
	  #endFormTag()#
	</div>
	
</cfoutput>