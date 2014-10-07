<cfoutput>
	<cfparam name="pagetitle" default="">
	<cfparam name="pagesubtitle" default="">
	<cfparam name="pagecontent" default="">
	
	<h1>#pagetitle#</h1>
	<br class="clear"><br>
	<cfif len(trim(pagesubtitle))>
		<p class="intro text-center">#pagesubtitle#</p>
	</cfif>
	
	#pagecontent#
</cfoutput>