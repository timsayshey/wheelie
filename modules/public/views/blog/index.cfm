<cfoutput>
	
	<cfset contentFor(siteTitle = getOption(qOptions,'seo_blog_title').label)>
	<cfset contentFor(siteDesc = getOption(qOptions,'seo_blog_description').label)>
	<cfset contentFor(siteKeywords = getOption(qOptions,'seo_blog_keywords').label)>
		
    <cfset blogTemplate = getThemeTemplate("blog-home")>
	
	<cfif len(blogTemplate)>
		<cfinclude template="#blogTemplate#">
	<cfelse>			
		<div class="blog-post">          
			<h1>Our Blog</h1>
			<cfif request.site.id eq 1>
				<br class="clear">
			</cfif>
			<br>
			
			<cfloop query="posts" startrow="#pagination.getStartRow()#" endrow="#pagination.getendrow()#">	
				<h2><a href="/blog/post/#posts.urlid#.html">#capitalize(posts.name)#</a></h2> 
				Added by #posts.zx_firstname# on #DateFormat(posts.createdAt,"MMMM D")#<br>  
					   
				<cfset postContent = left(removehtml(posts.content),500)>         
				#ListDeleteAt(postContent,listlen(postContent," ")," ")# ... <a href="/blog/post/#posts.urlid#.html">Read more</a>
				 
				<br><br>
			</cfloop>
			
			#paginator#
		</div>
	</cfif>	
</cfoutput>