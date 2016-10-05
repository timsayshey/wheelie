404<cfset log404()>

<cfheader statuscode="404" statustext="Not Found">
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
<cfheader name="Location" value="/o/404">
<cfabort>	