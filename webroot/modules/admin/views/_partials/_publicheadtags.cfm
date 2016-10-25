<cfoutput>

	<script src="/assets/vendor/jquery-1.10.1.min.js"></script>
	<script src="/assets/vendor/jquery-migrate-1.2.1.min.js"></script>
	<script src="/assets/vendor/js/libs/modernizr.js" type="text/javascript"></script>
	<script src="/assets/vendor/js/bootstrap/bootstrap.min.js" type="text/javascript"></script>
	<!--- <script src="/views/layouts/admin/assets/js/adminmenu.js" type="text/javascript"></script> --->
	
	<link href="/assets/css/shared.css" rel="stylesheet" type="text/css"/>
	
	<cfparam name="adminHeadColor" default="54a5de">
	<cfif findNoCase("admin",params.route) AND !(request.containsKey("bypassAdminBody") AND request.bypassAdminBody)>
		<style type="text/css">
			body {
				background: none !important;
			}
			.hero {
				background: ###adminHeadColor# !important;
			}
			.data-block header {
				background: ###adminHeadColor# !important;
			}
			.topnav, .navbar {
				z-index:120 !important;	
			}
		</style>		
	</cfif>
</cfoutput>