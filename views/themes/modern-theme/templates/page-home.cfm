<cfoutput>
	<cfset request.templateActive = true>
	<cfparam name="pagetitle" default="">
	<cfparam name="pagesubtitle" default="">
	<cfparam name="pagecontent" default="">

	<section class="page-wrapper">

		<cfif subMenuItems.recordcount>
			<nav class="page-nav">
			  <ul>

					<!--- <cfif activeMenuItem.parentid eq 0>
						<li>#menuitemLink()#</li>
					<cfelseif len(activeParent.urlPath)>
						<li>#menuitemLink()#</li>
					</cfif>	 --->

					<cfloop query="subMenuItems">
						<cfset menuItem = subMenuItems>
						<li>#menuitemLink()#</li>
					</cfloop>
			  </ul>
			</nav>

			<article class="page-content">
		<cfelse>
			<article class="page-content-full">
		</cfif>

			<h1 class="content-title">#capitalize(pagetitle)#</h1>

			<div class="content-wrapped">#pagecontent#</div>

		</article>

	</section>
</cfoutput>
