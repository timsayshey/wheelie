<cfset setSiteInfo()>

<cfinclude template="/models/services/global/settings.cfm">

<cfif isNull(session.referer) AND !Find("#request.site.domain#",lcase(cgi.http_referer)) AND len(trim(cgi.http_referer))>
	<cfset session.referer = cgi.http_referer>
</cfif>

<cfif isNull(session.entryPage)>
	<cfset session.entryPage = cgi.path_info>
</cfif>

<cfinclude template="/models/services/global/global.cfm">

<cfset redirects()>

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

<!--- Share session across subsomains --->
<cfcookie name="cfid" domain="#request.site.domain#" value="#session.cfid#">
<cfcookie name="cftoken" domain="#request.site.domain#" value="#session.cftoken#">

<cfset application.wheels.errorEmailAddress=application.wheels.adminFromEmail>


