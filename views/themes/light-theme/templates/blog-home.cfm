<cfoutput>
	<div class="blog-post">          
		<h1>Our Blog</h1>
		
		<cfloop query="posts" startrow="#pagination.getStartRow()#" endrow="#pagination.getendrow()#">	
			<h2><a href="/blog/post/#posts.urlid#.html">#capitalize(posts.name)#</a></h2> 
			Added by #posts.zx_firstname# on #DateFormat(posts.createdAt,"MMMM D")#<br>  
				   
			<cfset postContent = left(removehtml(posts.content),500)>         
			#ListDeleteAt(postContent,listlen(postContent," ")," ")# ... <a href="/blog/post/#posts.urlid#.html">Read more</a>
			 
			<br><br>
		</cfloop>
		
		#paginator#
	</div>
</cfoutput>