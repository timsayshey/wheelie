<cfoutput>
	<cfset request.templateActive = true>

	<cfparam name="pagetitle" default="">
	<cfparam name="subtitle" default="">
	<cfparam name="pagesubtitle" default="">
	<cfparam name="pagecontent" default="">

    <div class="ltc-container container">
		#pagecontent#
	</div>

</cfoutput>
