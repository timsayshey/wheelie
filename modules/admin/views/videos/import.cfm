<!--- <cfoutput>
	<cffeed
		source	= "https://gdata.youtube.com/feeds/api/users/youtubeid/uploads?max-results=50&start-index=1"
		name	= "youtubeFeed"
		query	= "youtubeFeed">
	
	<cfset video = youtubeFeed.entry[10]>
	<cfset title = video.title.value>
	<cfset urlid = lcase(cleanUrlId(title))>
	<cfset urlid = removehtml(urlid)>
	
	<cfset insertData = {
		urlid = urlid,
		description = video.content[1].value,
		teaser = video.content[1].value,
		name = title,
		youtubeid = ListLast(video.id,"/")
	}>
	
	<cfdump var="#insertData#" abort>
	
	<cfset insertThis = model("Video").new(
		insertData
	)>
	<cfset saveResult = insertThis.save()>	
	
	<cfset model("Video").saveYoutubeThumb(
		filename	= insertThis.youtubeId,
		imgUrl		= "http://i1.ytimg.com/vi/#insertThis.youtubeId#/hqdefault.jpg",
		videoid		= insertThis.id
	)>
	
	<cfdump var="#saveResult#">

</cfoutput>

<cfset videos = model('Video').findall()>

<cfloop query="videos">
	
</cfloop> --->