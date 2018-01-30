<cfscript>
component output="false" extends="controllers.Controller"
{
	function init() {
		super.init();

		secureActions = "mailUs,jobapp,jobappSubmit,newsletter,newsletterSubmit,footerbar";
		//forceHttps(only=secureActions);
		//forceHttp(except=secureActions);

		filters(through="customPublicAppFilters",except=secureActions);

		filters(through="preHandler");
		filters(through="loggedOutOnly",except="login,loginPost,recovery,recoveryPost,register,registerPost");

	}

	private function customPublicAppFilters() {
		include "/modules/publicapp/publicfilters.cfm";
	}

	private function loggedOutOnly() {
		// Authenticate
		if(!StructKeyExists(session,"user") && listfirst(cgi.server_name,".") != 'www' && request.site.subdomain != '') {
			redirectTo(route="admin~action", controller="users", action="login");
		}
	}

	function preHandler() {
		homeid = getOption(qOptions,'home_id').content;

		if(!isNull(params.format)) {
			if(params.format eq "modal") {
				usesLayout("/layouts/layout.modal");
			} else {
				usesLayout("/themes/#request.site.theme#/layout");
			}
		} else {
			usesLayout("/themes/#request.site.theme#/layout");
		}

		if(params.action eq "testerror") {
			request.testthis = "/themes/#request.site.theme#/layout";
		}

		if(!isNull(params.ajax)) {
			isAjaxRequest = 1;
			usesLayout("/layouts/layout.blank");
		}

		if(request.containsKey("usesLayout")) {
			usesLayout(request.usesLayout);
		}
	}

}
</cfscript>
