<cfoutput>
	
	<cfset videos = model("Video").findAll()>
	
	<cfloop query="videos">
		<cfif len(youtubeid) GT 4><a href="https://youtube.com/watch?v=#youtubeid#"></cfif>#name#<cfif len(youtubeid) GT 4></a></cfif><br>
	</cfloop>
</cfoutput>