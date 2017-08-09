<cfoutput>
	<h1 class="content-title">#capitalize(post.name)#</h1>
	<div class="content-wrapped">
		<cfif post.fullLastname eq 1>
			<cfset userLastname = post.lastname>
		<cfelseif len(post.lastname)>
			<cfset userLastname = left(post.lastname,1) & ".">
		<cfelse>
			<cfset userLastname = "">
		</cfif>

		By <a href='##viewProfile'>#post.firstname# #userLastname#</a> | Added #DateFormat(post.createdAt,"MMMM D")#
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
			<cfset endodedDomain = URLEncodedFormat('https://#request.site.domain#')>
			<cfset encodedUrl = URLEncodedFormat(currentPageUrl)>
			<div>
				#facebookLikeButton()#
			</div>
			<br><br>
		</cfif>
	</div>
</cfoutput>
