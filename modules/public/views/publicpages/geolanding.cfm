<cfif request.site.id neq 1><cfset redirectFullUrl("/p/404")></cfif>

<cfoutput>

<cfset contentFor(siteTitle = "Blah blah #locationName#")>
<cfset contentFor(siteDesc = "Blah blah from #locationName#")>
<cfset contentFor(siteKeywords = "Blah blah, #locationName#")>	

<cfset request.page.hideSidebar = true>

<cfset pic1 = '<div class="photo_sq pull-right"><img src="/assets/img/photo_sq.jpg" alt="Blah blah" /></div>'>

<cfif landingPage.templateid eq 1>
<!--- Template --->

<h1>Blah blah from #locationName#</h1>
<br class="clear">
#facebookLikeButton()#

#pic1#
Blah blah

</cfif>

<cfif !isNull(cities) AND cities.recordcount>
	<br class="clear">
	<h3>We also serve the following cities</h3>
	<div class="text-small">
		<cfloop query="cities">
		<a href='#urlFor(route="public~geolanding",state="#Replace(cities.state," ","-","ALL")#-#cities.state_acronym#",city=Replace(cities.city," ","-","ALL"))#'>#cities.city#, #cities.state_acronym#</a><cfif cities.recordcount neq cities.currentRow>, &nbsp;</cfif>
		</cfloop>
	</div>
</div>
</cfif>
	
</cfoutput>