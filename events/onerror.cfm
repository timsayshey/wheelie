<cfheader statuscode="500" statustext="Internal Server Error">
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
<cfheader statuscode="301" statustext="Moved permanently">
<cfheader name="Location" value="/o/500">
<cfabort>	