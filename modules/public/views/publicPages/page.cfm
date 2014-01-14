<cfoutput>

<section class="page-wrapper">

	<cfif subMenuItems.recordcount>
		<nav class="page-nav">
		  <ul>
			
				<cfif activeMenuItem.parentid eq 0>
					<li><a href="#activeMenuItem.urlPath#" class="current">#activeMenuItem.name#</a></li>
				<cfelseif len(activeParent.urlPath)>
					<li><a href="#activeParent.urlPath#">#activeParent.name#</a></li>
				</cfif>		
				
				<cfloop query="subMenuItems">
					<li><a href="#subMenuItems.urlPath#"
							<cfif subMenuItems.id eq activeMenuItem.id>
								class="current"
							</cfif>
					>#subMenuItems.name#</a></li>
				</cfloop>
		  </ul>
		</nav>
	
		<article class="page-content">	
	<cfelse>
		<article class="page-content-full">
	</cfif>
		
		<h1>#capitalize(page.name)#</h1>
		
		<p>#page.content#</p>

	</article>

</section>

</cfoutput>