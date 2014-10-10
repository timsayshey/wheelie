<cffile action="read" file="./export.json" variable="importData">
<!--- 
1	
string	ID
2	
string	URL
3	
string	YoutubeId
4	
string	quoteImg
--->

<cfset importData = DeserializeJSON(importData)>

<cfloop array="#importData.data#" index="row">

    <cfscript>		
		data = {
			urlId = trim(row[2])
		};
		post = db.getRecords("posts",data);
	</cfscript>	
	
	<cfloop query="post">
		<cfscript>		
			thisRow = {
				id = post.id,
				youtubeid = row[10],
				quoteImg = row[11]
			};		
			test = db.updateRecord("posts",thisRow);
			writeDump(thisRow);
			writeDump(test);
		</cfscript>
	</cfloop>
	
	
	
</cfloop>
