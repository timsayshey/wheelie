<cfinclude template="/models/services/global/global.cfm">

<!--- Remove beginning/ending whitespace from params --->
<cfif StructCount(form)>
    <cfloop collection="#form#" item="key">
        <cfset form[key] = Trim(form[key])>
    </cfloop>
</cfif>
<cfif StructCount(url)>
    <cfloop collection="#url#" item="key">
        <cfset url[key] = Trim(url[key])>
    </cfloop>
</cfif>