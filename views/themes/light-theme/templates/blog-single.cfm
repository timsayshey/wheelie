<cfoutput>
	<h1>#capitalize(post.name)#</h1>
	
	<cfif post.zx_firstname eq "Calo">
		<cfset userLastname = "">
	<cfelseif post.fullLastname eq 1>
		<cfset userLastname = post.zx_lastname>
	<cfelseif len(post.zx_lastname)>
		<cfset userLastname = left(post.zx_lastname,1) & ".">
	<cfelse>
		<cfset userLastname = "">
	</cfif>
	
	By <a href='##viewProfile'>#post.zx_firstname# #userLastname#</a> | Added #DateFormat(post.createdAt,"MMMM D")#
	#facebookLikeButton(style="width:100px; height:20px; display:inline-block; margin-left:10px;")#
	
	<cfif request.site.id neq 1>
	<br>
	</cfif>
	
	<br> 
	<cfset showSocial = 1>
	
	#post.content#  
	
	<cfif isNull(showSocial)>
		<br><br>
	<cfelse>
		<cfset endodedDomain = URLEncodedFormat('http://#request.site.domain#')>
		<cfset encodedUrl = URLEncodedFormat(currentPageUrl)>
		<div>
		#facebookLikeButton()#
		
		<!--- <iframe allowtransparency="true" frameborder="0" scrolling="no" src="https://platform.twitter.com/widgets/tweet_button.html?url=#encodedUrl#&via=caloteens&counturl=#endodedDomain#" style="width:100px; height:20px; float:left; margin-right:10px;"></iframe>
		
		<iframe src="https://plusone.google.com/_/+1/fastbutton?bsv&amp;size=medium&amp;hl=en-US&amp;url=#encodedUrl#&amp;parent=#endodedDomain#" allowtransparency="true" frameborder="0" scrolling="no" title="+1" style="width:100px; height:20px; float:left; margin-right:10px;"></iframe> --->
		</div>
		<br><br>              
	</cfif>
</cfoutput>