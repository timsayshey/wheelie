<cfoutput>
	<cfparam name="pagetitle" default="">
	<cfparam name="pagecontent" default="">

	<section class="page-wrapper">

		<article class="page-content-full">

			<h1 class="content-title">#capitalize(pagetitle)#</h1>

			<div class="content-wrapped">#pagecontent#</div>

		</article>

	</section>
</cfoutput>
