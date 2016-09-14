<cfif !isNull(session.user)>
	<cfoutput>
		<link href="/assets/vendor/css/font/icons.css" media="all" rel="stylesheet" type="text/css"/>
		<script src="/views/layouts/admin/assets/vendor/multimenu/multimenu.js" type="text/javascript"></script>
		<link href="/views/layouts/admin/assets/vendor/multimenu/multimenu.css" rel="stylesheet">
		
		<div id="adminmenu-wrap">
			<ul id="adminmenu">
				#includePartial(partial="/_partials/adminMenu")#
			</ul>
		</div>
	</cfoutput>
</cfif>