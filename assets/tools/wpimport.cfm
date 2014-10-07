<cffile action="read" file="./wpexport2.json" variable="importData">
<cfset importData = DeserializeJSON(importData)>
<cfset importData = importData.data.posts>
<cfabort>

<!--- <cffile action="read" file="./wpexport.xml" variable="importData">
<cfset importData = XMLParse(importData)>
<cfdump var="#importData#" abort> --->

<cfset newData = []>

<cfloop array="#importData#" index="row">
    <cfscript>	
		thisRow = {
			postType = "post",
			urlid = row["slug"],
			name = row["Title"],
			content = REReplace(row["html"],"[^0-9A-Za-z -_~!@##$%^&*()+'`]","","all"),
			metagenerated = 1,
			metatitle = row["Title"],
			metakeywords = row["Title"],
			metadescription = row["Title"],
			status = "published",
			createdat = row["created_at"],
			createdby = 1,
			siteid = 1,
			authorName = "Alex"
		};
		db.insertRecord("posts",thisRow);		
	</cfscript>
</cfloop>
<cfdump var="#newData#">