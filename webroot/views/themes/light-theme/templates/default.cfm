<cfoutput>
	<cfparam name="pagetitle" default="">
	<cfparam name="pagecontent" default="">
			
	<h1 class="content-title">#capitalize(pagetitle)#</h1>
	
	<div class="content-wrapped">#pagecontent#</div>
</cfoutput>