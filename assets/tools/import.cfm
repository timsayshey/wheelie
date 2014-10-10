<cffile action="read" file="./NVW.json" variable="importData">
<!--- 
1	
string	ID
2	
string	URL
3	
string	ORIGURL
4	
string	TITLE
5	
string	BODY
6	
string	TYPE
7	
string	METADESCRIPTION
8	
string	METAKEYWORDS
9	
string	METATITLE 


--->

<cfset importData = DeserializeJSON(importData)>
<cfdump var="#importData#">
<cfabort>
<cfset newData = []>

<cfloop array="#importData.data#" index="row">
    <cfscript>	
		thisRow = {
			postType = "post",
			urlid = row[2],
			name = row[4],
			content = REReplace(row[5],"[^0-9A-Za-z -_~!@##$%^&*()+'`]","","all"),
			metagenerated = 1,
			metatitle = row[4],
			metakeywords = row[4],
			metadescription = row[4],
			status = "published",
			createdat = row[10],
			createdby = 1,
			siteid = 3,
			authorName = row[11],
			oldUrl = row[3]
		};
		db.insertRecord("posts",thisRow);

/*2 URL
3 ORIGURL
4 TITLE
5 BODY
6 TYPE
7 METADESCRIPTION
8 METAKEYWORDS
9 METATITLE
10 CREATEDAT
11 AUTHOR*/

		
		
		
	</cfscript>
</cfloop>
<cfdump var="#newData#">