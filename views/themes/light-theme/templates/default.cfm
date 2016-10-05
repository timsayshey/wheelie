<cfoutput>
	<cfparam name="pagetitle" default="">
	<cfparam name="pagecontent" default="">
	
	<section class="page-wrapper">	

		<article class="page-content-full">
			
			<h1>#capitalize(pagetitle)#</h1>
			
			<p>#pagecontent#</p>
	
		</article>
	
	</section>
</cfoutput>