<cfscript>
	setSiteInfo();

	include "/models/services/global/settings.cfm";
	
	thisSiteUrl = "http://#request.site.domain#";
	
	if(
		isNull(session.referer) AND len(trim(cgi.http_referer)) AND 
		(len(cgi.http_referer) GTE thisSiteUrl AND Left(cgi.http_referer,len(thisSiteUrl)) NEQ thisSiteUrl OR len(cgi.http_referer) LT thisSiteUrl)
	)
	{
		session.referer = cgi.http_referer;
	}
	
	if(isNull(session.entryPage))
	{
		session.entryPage = cgi.path_info;
	}
	
	include "/models/services/global/global.cfm";
	
	redirects();
</cfscript>

<!--- Remove beginning/ending whitespace from params --->
<cfif StructCount(form)>
    <cfloop collection="#form#" item="key">
		<cfif IsSimpleValue(form[key])>
        	<cfset form[key] = Trim(form[key])>
		</cfif>
    </cfloop>
</cfif>
<cfif StructCount(url)>
    <cfloop collection="#url#" item="key">
        <cfset url[key] = Trim(url[key])>
    </cfloop>
</cfif>

<!--- Share session across subsomains
<cfcookie name="cfid" domain="#request.site.domain#" value="#session.cfid#">
<cfcookie name="cftoken" domain="#request.site.domain#" value="#session.cftoken#"> --->

<cfset application.wheels.errorEmailAddress=application.wheels.adminFromEmail>


