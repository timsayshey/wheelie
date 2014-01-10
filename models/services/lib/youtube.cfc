<cfcomponent displayName="YouTube CFC" output="false">
	
	<cfset variables.authtoken="">
	<cfset variables.username="default">
	<cfset variables.devkey="">
	
	<cfset variables.standardurl = "http://gdata.youtube.com/feeds/api/standardfeeds/">
	
	<cffunction name="init" access="public" returnType="youtube" output="false">
	  <cfargument name="devkey" type="string" required="true">
		<cfset variables.devkey = arguments.devkey>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="setToken" access="public">
		<cfargument name="token" required="yes">
		<cfset variables.authtoken=arguments.token>
	</cffunction>
	
	<cffunction name="addFavoriteVideoForUser" access="public" returntype="any" output="false" hint="Adds a Favorites Video of the user">
		<cfargument name="videoId" type="string" required="true"> 
		<cfset var theurl = "http://gdata.youtube.com/feeds/api/users/default/favorites">
		<cfset var result = "">
		<cfset var meta = "">
		
	<cfsavecontent variable="meta">
	<cfoutput>
	<?xml version="1.0" encoding="UTF-8"?>
	<entry xmlns="http://www.w3.org/2005/Atom">
	<id>#arguments.videoid#</id>
	</entry>
	</cfoutput>
	</cfsavecontent>
	
		<cfset meta = trim(meta)>
	
		<cfhttp url="#theurl#" method="post" result="result">
			<cfhttpparam type="header" name="Host" value="gdata.youtube.com">	
			<cfhttpparam type="header" name="Content-Type" value="application/atom+xml">
			<cfhttpparam type="header" name="Content-Length" value="#len(meta)#">
			<cfhttpparam type="header" name="Authorization" value="ClientLogin auth=#variables.authtoken#">
			<cfhttpparam type="header" name="X-GData-Client" value="youtubecfc">
			<cfhttpparam type="header" name="X-GData-Key" value="key=#variables.devkey#">
			<cfhttpparam type="header" name="GData-Version" value="2">
			<cfhttpparam type="body" value="#meta#">
		</cfhttp>
	</cffunction>	
	
	
	<!--- Note - this method was begun but ran into issues. Leaving it out for now. 
	<cffunction name="addPlaylist" access="public" returntype="any" output="false"	hint="Adds a playlist for a user.">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
	
		<cfset var theurl = "http://gdata.youtube.com/feeds/api/users/default/playlists">
		<cfset var result = "">
		<cfset var meta = "">
		<cfset var tmpFile = expandPath("./#replace(createUUID(),'-','_','all')#")>
		<cfset var resxml = "">
	  
	<cfsavecontent variable="meta">
	<cfoutput>
	<?xml version="1.0" encoding="UTF-8"?>
	<entry xmlns="http://www.w3.org/2005/Atom" xmlns:yt="http://gdata.youtube.com/schemas/2007">
	<title type="text">#xmlFormat(arguments.title)#</title>
	<summary>#XMLFormat(arguments.description)#</summary>
	</entry>
	</cfoutput>
	</cfsavecontent>
	
		<cfset meta = trim(meta)>
		<cffile action="write" file="#tmpfile#" output="#meta#">
	
		<cfhttp url="#theurl#" method="post" result="result">
			<cfhttpparam type="header" name="Host" value="gdata.youtube.com">	
			<cfhttpparam type="header" name="Content-Type" value="application/atom+xml">
			<cfhttpparam type="header" name="Content-Length" value="#len(meta)#">
			<cfhttpparam type="header" name="Authorization" value="GoogleLogin auth=#variables.authtoken#">		
			<cfhttpparam type="header" name="X-GData-Client" value="youtubecfc">
			<cfhttpparam type="header" name="X-GData-Key" value="key=#variables.devkey#">
			<cfhttpparam type="file" name="API_XML_Request" file="#tmpfile#" mimetype="application/atom+xml; charset=UTF-8 ">		
		</cfhttp>
		<cffile action="delete" file="#tmpfile#">
	</cfoutput>
	<cfdump var="#result#"><cfabort>
	</cffunction>
	--->
	
	<cffunction name="addVideoToPlaylist" access="public" returnType="any" output="false" hint="Adds a vide to a playlist.">
		<cfargument name="playlistId" type="string" required="true">
		<cfargument name="videoId" type="string" required="true">
	
		<cfset var resxml = "">
		<cfset var theurl = "http://gdata.youtube.com/feeds/api/playlists/#arguments.playlistid#">
	
		<cfset var meta = "">
	<!--- defaults to position 1 for now --->	
	<cfsavecontent variable="meta">
	<cfoutput>
	<?xml version="1.0" encoding="UTF-8"?>
	<entry xmlns="http://www.w3.org/2005/Atom"
		xmlns:yt="http://gdata.youtube.com/schemas/2007">
	<id>#arguments.videoid#</id>
	  <yt:position>1</yt:position>
	</entry>
	</cfoutput>
	</cfsavecontent>
	
		<cfset meta = trim(meta)>
	
		<cfhttp url="#theurl#" method="post" result="result">
			<cfhttpparam type="header" name="Host" value="gdata.youtube.com">
			<cfhttpparam type="header" name="Content-Type" value="application/atom+xml">
			<cfhttpparam type="header" name="Authorization" value="GoogleLogin auth=#variables.authtoken#">
			<cfhttpparam type="header" name="X-GData-Client" value="youtubecfc">
			<cfhttpparam type="header" name="X-GData-Key" value="key=#variables.devkey#">
			<cfhttpparam type="body" value="#meta#">
		</cfhttp>
	
		<cfif result.responseheader.explanation is "Created">
			<cfreturn true>
		<cfelse>
			<cfif isXml(result.filecontent)>
				<cfset resxml = xmlParse(result.fileContent)>
				<cfthrow message="YouTubeCFC Upload Error: Domain=#resxml.errors.error.domain.xmlText#, Code=#resxml.errors.error.code.xmlText#">
			<cfelse>
				<cfthrow message="YouTubeCFC Upload Error: Status: #result.responseheader.status_code# / Explanation: #result.responseheader.explanation#">
			</cfif>	
		</cfif>		
	</cffunction>
		
	<cffunction name="delete" access="public" returnType="any" output="false" hint="I update a video.">
		<cfargument name="videoId" type="string" required="true">
		
		<cfset var theurl = "http://uploads.gdata.youtube.com/feeds/api/users/#variables.username#/uploads/">
		<cfset var result = "">
		<cfset var resxml = "">
	
		<!--- Video ID may include the URL, strip it --->
		<cfset arguments.videoid = replace(arguments.videoid, "http://gdata.youtube.com/feeds/api/videos/","")>
		<cfset arguments.videoid = listFirst(arguments.videoid, "&")>	
	
		<cfset theurl &=  arguments.videoId />
		
		<cfhttp url="#theurl#" method="delete" result="result">
			<cfhttpparam type="header" name="Host" value="gdata.youtube.com">
			<cfhttpparam type="header" name="Content-Type" value="application/atom+xml">
			<cfhttpparam type="header" name="Authorization" value="GoogleLogin auth=#variables.authtoken#">
			<cfhttpparam type="header" name="X-GData-Client" value="youtubecfc">
			<cfhttpparam type="header" name="X-GData-Key" value="key=#variables.devkey#">
		</cfhttp>
		<cfif result.responseheader.explanation is "OK">
			<cfreturn "Video successfully removed.">
		<cfelse>
			<cfif isXml(result.filecontent)>
				<cfset resxml = xmlParse(result.fileContent)>
				<cfthrow message="YouTubeCFC Upload Error: Domain=#resxml.errors.error.domain.xmlText#, Code=#resxml.errors.error.code.xmlText#">
			<cfelse>
				<cfthrow message="YouTubeCFC Upload Error: Status: #result.responseheader.status_code# / Explanation: #result.responseheader.explanation#">
			</cfif>	
		</cfif>
	</cffunction>	
	
	<cffunction name="deleteFavoriteVideoForUser" access="public" returntype="any" output="false" hint="Deletes a Favorites Video of the user">
		<cfargument name="videoId" type="string" required="true"> 
		<cfset var theurl = "http://gdata.youtube.com/feeds/api/users/#variables.username#/favorites/#arguments.videoid#">
		<cfset var result = "">
	
		<cfhttp url="#theurl#" method="delete" result="result">
			<cfhttpparam type="header" name="Authorization" value="GoogleLogin auth=#variables.authtoken#">
			<cfhttpparam type="header" name="X-GData-Client" value="youtubecfc">
			<cfhttpparam type="header" name="X-GData-Key" value="key=#variables.devkey#">
		</cfhttp>
	
	</cffunction>	
	
	<!---
	YT has some FUNKY rules for the keyword string you sent them. Much too funky for the average user. This function
	was built to help correct user input so that YT will be happy. From their docs:
	
	The <media:keywords> tag contains a comma-separated list of words associated with a video. You must provide at least one keyword for 
	each video in your feed. This field has a maximum length of 120 characters, including commas, and may contain all valid 
	UTF-8 characters except < and <. In addition, each keyword must be at least two characters long and may not be longer than 25 characters.
	
	Please note that individual keywords may not contain spaces. However, you can use spaces after the commas that separate keywords. 
	For example, crazy,surfing,stunts and crazy, surfing, stunts are both valid values for this tag. However, crazy, surfing stunts 
	is not valid. (The invalid value does not contain a comma between "surfing" and "stunts".)
	--->
	<cffunction name="fixKeywords" access="private" returnType="string" output="false">
		<cfargument name="s" type="string" required="true">
		
		<!--- split by words --->
		<cfset var words = reMatch("[[:word:]]+", arguments.s)>
		<cfset var result = "">
		<cfset var w = "">
			
		<cfloop index="w" array="#words#">
			<cfif len(w) gte 2>
				<cfif len(w) gt 25>
					<cfset w = left(w,25)>
				</cfif>
			</cfif>
			<!--- only add if we won't go over 120 --->
			<cfif len(listAppend(result,w)) gt 120>
				<!--- leave now! --->
				<cfreturn result>
			</cfif>
			<cfset result = listAppend(result,w)>
		</cfloop>
	
		<cfreturn result>
		<!---
		This was attempt 1, which I got rid of - but I'm keeping the code for now.
		<!--- first reduce to 120 chars --->
		<cfset arguments.s = left(arguments.s, 120)>
		<!--- remove < and > --->
		<cfset arguments.s = rereplace(arguments.s, "[<>]", "", "all")>
		<!--- get words, if < 2 chars, remove it, if more > 25, trim it --->
		<cfset arguments.s = rereplace(arguments.s, "\w{", "\1, \2", "all")>
	
		<!--- replace any (noncomma)(space)(noncomma) with (noncomma),(space)(noncomma) --->
		<cfset arguments.s = rereplace(arguments.s, "([[:alnum:]])[[:space:]]+([[:alnum:]])", "\1, \2", "all")>
		<cfreturn arguments.s>
		--->
	</cffunction>
	
	<cffunction name="getCategories" access="public" returnType="array" output="false"
				hint="Gets the valid categories for YouTube.">
		<cfset var curl = "http://gdata.youtube.com/schemas/2007/categories.cat">
		<cfset var results = arrayNew(1)>
		<cfset var result = "">
		<cfset var x = "">
		
		<cfhttp url="#curl#" result="result">
		<cfset result = xmlparse(result.filecontent)>
		<!--- Note, we use just the term, not the label. --->
		<cfloop index="x" from="1" to="#arrayLen(result["app:categories"]["atom:category"])#">
			<cfset arrayAppend(results, result["app:categories"]["atom:category"][x].xmlAttributes.term)>
		</cfloop>
	
		<cfreturn results>
	</cffunction>
	
	<cffunction name="getChannels" access="public" returntype="query" output="false" hint="Gets Channels List by search.">
		<cfargument name="search" type="string" required="true">
		<cfargument name="start" type="numeric" required="false">
		<cfargument name="max" type="numeric" required="false" hint="Defaults to 25 in API, max is 50">
		<cfargument name="strict" type="string" required="false" default="true" hint="Instruct API to ignore Invalid requests">
	
		<cfset var baseurl = "http://gdata.youtube.com/feeds/api/channels">
		<cfset var result = "">
		<cfset var results = queryNew("id,updated,title,summary,url,videocount,link,author,authorurl,total")>
		<cfset var x = "">
		<cfset var total = "">
		<cfset var entry = "">
		
		<cfset baseurl &= "?v=2&q=#urlEncodedFormat(arguments.search)#">
	
		<cfif structKeyExists(arguments, "start")>
			<cfset baseurl &= "&start-index=#arguments.start#">
		</cfif>
		<cfif structKeyExists(arguments, "max")>
			<cfset baseurl &= "&max-results=#arguments.max#">
		</cfif>
		<cfif structKeyExists(arguments, "strict")>
			<cfset baseurl &= "&strict=#arguments.strict#">
		</cfif>
	
		<cfhttp url="#baseurl#" result="result">
		<cfset result = xmlParse(result.filecontent)>
	
		<cfif not structKeyExists(result, "feed") or not structKeyExists(result.feed, "entry") or arrayLen(result.feed.entry) is 0>
			<cfreturn results>
		</cfif>
		
		<cfset total = result.feed["openSearch:totalResults"].xmlText>
		<cfloop index="x" from="1" to="#arrayLen(result.feed.entry)#">
			<cfset entry = result.feed.entry[x]>
			<cfset queryAddRow(results)>
			<cfset querySetCell(results, "id", entry.id.xmlText)>
			<cfset querySetCell(results, "updated", handleDate(entry.updated.xmlText))>
			<cfset querySetCell(results, "title", entry.title.xmlText)>
			<cfif structKeyExists(entry, "summary")>
				<cfset querySetCell(results, "summary", entry.summary.xmlText)>
			<cfelse>
				<cfset querySetCell(results, "summary", "")>
			</cfif>
			<cfset querySetCell(results, "url", entry["gd:feedLink"].xmlAttributes.href)>
			<cfif structKeyExists(entry["gd:feedLink"].xmlAttributes, "countHint")>
				<cfset querySetCell(results, "videocount", entry["gd:feedLink"].xmlAttributes.countHint)>
			</cfif>
			<cfset querySetCell(results, "link", entry.link[2].xmlattributes.href)>
			<cfset querySetCell(results, "author", entry.author.name.xmlText)>
			<cfset querySetCell(results, "authorurl", entry.author.uri.xmlText)>
			<cfset querySetCell(results, "total", total)>		
		</cfloop>
		<cfreturn results>
	</cffunction>
	
	<cffunction name="getComments" access="public" returnType="query" output="false"
				hint="Gets all the comments for a video.">
		<cfargument name="videoid" type="string" required="true">
		<cfset var commentsurl = "http://gdata.youtube.com/feeds/api/videos/#arguments.videoid#/comments">
		<cfset var result = "">
		<cfset var comments = queryNew("total,published,title,content,author,authorurl")>
		<cfset var total = "">
		<cfset var x = "">
		<cfset var comment = "">
		
	
		<cfhttp url="#commentsurl#" result="result">
		<cfif not isXml(result.fileContent)>
			<cfthrow message="#result.fileContent#">
		</cfif>
		<cfset result = xmlParse(result.fileContent)>
		
		<cfset total = result.feed["openSearch:totalResults"].xmlText>
		
		<cfif not total>
			<cfreturn comments>
		</cfif>
		
		<cfloop index="x" from="1" to="#arrayLen(result.feed["entry"])#">
			<cfset comment = result.feed["entry"][x]>
			<cfset queryAddRow(comments)>
			<cfset querySetCell(comments, "total", total)>
			<cfset querySetCell(comments, "published", handleDate(comment.published.xmltext))>
			<cfset querySetCell(comments, "title", comment.title.xmltext)>
			<cfset querySetCell(comments, "content", comment.content.xmltext)>
			<cfset querySetCell(comments, "author", comment.author.name.xmltext)>
			<cfset querySetCell(comments, "authorurl", comment.author.uri.xmltext)>
		</cfloop>
	
		<cfreturn comments>
	</cffunction>
	
	<cffunction name="getEmbedCode" access="public" returnType="string" output="false" hint="Utility function to return embed html">
		<cfargument name="videoid" type="string" required="true">
		<!--- Video ID may include the URL, strip it --->
		<cfset arguments.videoid = replace(arguments.videoid, "http://gdata.youtube.com/feeds/api/videos/","")>
		<cfset arguments.videoid = listFirst(arguments.videoid, "&")>	
		<cfreturn '<object width="425" height="355"><param name="movie" value="http://www.youtube.com/v/#arguments.videoid#&hl=en"></param><param name="wmode" value="transparent"></param><embed src="http://www.youtube.com/v/#arguments.videoid#&hl=en" type="application/x-shockwave-flash" wmode="transparent" width="425" height="355"></embed></object>'>
	</cffunction>
	
	<cffunction name="getFavoriteVideosForUser" access="public" returntype="any" output="false" hint="Get Favorites Video of the user">
		<cfset var theurl = "http://gdata.youtube.com/feeds/api/users/default/favorites">
		<cfreturn getVideos(myurl=theurl,secure=true)>
	</cffunction>
		
	<cffunction name="getPlaylist" access="public" returnType="query" output="false"
				hint="Gets a playlist.">
		<cfargument name="plurl" type="string" required="true">
		<cfargument name="start" type="numeric" required="false" default="1">
		<cfargument name="max" type="numeric" required="false" default="50">
	
		<cfif not find("?", arguments.plurl)>
			<cfset arguments.plurl &= "?">
		</cfif>
		
		<cfif structKeyExists(arguments, "start")>
			<cfset arguments.plurl &= "&start-index=#arguments.start#">
		</cfif>
		<cfif structKeyExists(arguments, "max")>
			<cfset arguments.plurl &= "&max-results=#arguments.max#">
		</cfif>
		<cfreturn getVideos(arguments.plurl)>
	</cffunction>
	
	<cffunction name="getPlaylists" access="public" returnType="query" output="false"
				hint="Gets playlists for a user.">
		<cfargument name="user" type="string" required="true">
		<cfargument name="startindex" type="numeric" required="true" default="1">
		<cfargument name="max" type="numeric" required="true" default="25">
	
		<cfset var baseurl = "http://gdata.youtube.com/feeds/api/users/#arguments.user#/playlists">
		<cfset var result = "">
		<cfset var results = queryNew("total,url,published,updated,title,content,author,authorurl,videocount,playlistid")>
		<cfset var x = "">
		<cfset var total = "">
		<cfset var entry = "">
	
		<cfset baseurl &= "?start-index=#arguments.startindex#&max-results=#arguments.max#">
		
		<cfhttp url="#baseurl#" result="result">
		<cfset result = xmlParse(result.filecontent)>
		<cfif not structKeyExists(result.feed, "entry")>
			<cfreturn results>
		</cfif>
	
		<cfset total = result.feed["openSearch:totalResults"].xmlText>
			
		<cfloop index="x" from="1" to="#arrayLen(result.feed.entry)#">
			<cfset entry = result.feed.entry[x]>
			<cfset queryAddRow(results)>
			<cfset querySetCell(results, "total", total)>
			<cfset querySetCell(results, "url", entry["gd:feedLink"].xmlAttributes.href)>
			<cfset querySetCell(results, "published", handleDate(entry.published.xmlText))>
			<cfset querySetCell(results, "updated", handleDate(entry.updated.xmlText))>
			<cfset querySetCell(results, "title", entry.title.xmlText)>
			<cfset querySetCell(results, "content", entry.content.xmlText)>
			<cfset querySetCell(results, "author", entry.author.name.xmlText)>
			<cfset querySetCell(results, "authorurl", entry.author.uri.xmlText)>
			<cfset querySetCell(results, "videocount", entry["gd:feedLink"].xmlAttributes.countHint)>
			<cfset querySetCell(results, "playlistID", entry["yt:playlistId"].xmlText)>
		</cfloop>
		<cfreturn results>
	</cffunction>
	
	<cffunction name="getVideo" access="public" returnType="struct" output="false"
				hint="Get one video.">
		<cfargument name="myid" type="string" requied="true" hint="You can supply JUST the id, or the full URL">
		<cfset var result = "">
		<cfset var packet = "">
		<cfset var entry = "">
		<cfset var resulttext = "">
		
		<!--- see if we provided a full url --->		
		<cfif not find("/", arguments.myid)>
			<cfset arguments.myid = "http://gdata.youtube.com/feeds/api/videos/#arguments.myid#">
		</cfif>
			
		<cfhttp url="#arguments.myid#" result="result">	
		<cfset resulttext = result.filecontent>
		<cfif resulttext is "Invalid id" OR result.statuscode EQ "403 Forbidden">
			<cfthrow message="YouTubeCFC: Invalid id">
		</cfif>
		<cfset packet = xmlParse(resulttext)>
		<cfset entry = packet.entry>
		<cfreturn parseEntry(entry)>
		
	</cffunction>
	
	<cffunction name="getVideos" access="private" returnType="any" output="false"
				hint="Wrapper for video listing functions.">
		<cfargument name="myurl" type="string" required="true">
		<cfargument name="metaresult" type="boolean" required="false" default="false" hint="Used for getting complex data back from the results. Right now only used by search.">
		<cfargument name="secure" type="boolean" required="false" default="false" hint="Only used for secure downloads. Calls will fail if not properly authenticated.">
		
		<cfset var result = "">
		<cfset var packet = "">
		<cfset var results = queryNew(
		"videostatus,total,id,published,updated,categories,keywords,title,content,author,authorurl,link,description,duration,thumbnail_url,thumbnail_width,thumbnail_height,viewcount,favoritecount,averagerating,numratings,commentsurl,numcomments",
		"varchar,integer,varchar,date,date,varchar,varchar,varchar,varchar,varchar,varchar,varchar,varchar,integer,varchar,integer,integer,integer,integer,integer,integer,varchar,integer")>
		<cfset var x = "">
		<cfset var entry = "">
		<cfset var totalentries = "">
		<cfset var pentry = "">
		<cfset var key = "">
		<cfset var meta = structNew()>
		<cfset var links = "">
		
		<cfif arguments.secure>
			<cfhttp url="#arguments.myurl#" method="get" result="result">
				<cfhttpparam type="header" name="Authorization" value="GoogleLogin auth=#variables.authtoken#">
				<cfhttpparam type="header" name="X-GData-Client" value="youtubecfc">
				<cfhttpparam type="header" name="X-GData-Key" value="key=#variables.devkey#">
			</cfhttp>
		<cfelse>
			<cfhttp url="#arguments.myurl#" result="result">	
		</cfif>
		
		<cfset result = result.filecontent>
		<cfset packet = xmlParse(result)>
		<cfset totalentries = packet.feed["openSearch:totalResults"].xmlText>
	
		<cfif structKeyExists(packet.feed, "entry")>
			<cfloop index="x" from="1" to="#arrayLen(packet.feed.entry)#">
				<cfset entry = packet.feed.entry[x]>
				<cfset pentry = parseEntry(entry)>
				<cfset queryAddRow(results)>
				<cfset querySetCell(results, "total", totalentries)>
				<cfloop item="key" collection="#pentry#">
					<cfset querySetCell(results, key, pentry[key])>
				</cfloop>
	
				<!--- keywords is in a meta key now --->
				<cfif structKeyExists(entry, "media:keywords")>
					<cfset querySetCell(results, "keywords", entry["media:keywords"].xmlText)>
				</cfif>
			</cfloop>
		</cfif>
			
		<cfif not arguments.metaresult>
			<cfreturn results>
		<cfelse>
			<cfset meta.results = results>
			<!--- We will now put other info in the struct. For now its just spelling suggestions. --->
			<cfset links = xmlSearch(packet, "//:link[@rel='http://schemas.google.com/g/2006##spellcorrection']")>
			<cfif arrayLen(links)>
				<cfset meta.suggestion = links[1].xmlAttributes.title>
			</cfif>
			<cfreturn meta>
		</cfif>
	</cffunction>
	
	<cffunction name="getMobileVideos" access="public" returnType="query" output="false"
				hint="Gets mobile videos.">
		<cfargument name="start" type="numeric" required="false">
		<cfargument name="max" type="numeric" required="false" hint="Defaults to 25 in API, max is 50">
		<cfset var baseurl = variables.standardurl & "watch_on_mobile?">
		<cfif structKeyExists(arguments, "start")>
			<cfset baseurl &= "&start-index=#arguments.start#">
		</cfif>
		<cfif structKeyExists(arguments, "max")>
			<cfset baseurl &= "&max-results=#arguments.max#">
		</cfif>
		<cfreturn getVideos(baseurl)>
	</cffunction>
	
	<cffunction name="getMostDiscussedVideos" access="public" returnType="query" output="false"
				hint="Gets the most discussed videos.">
		<cfargument name="time" type="string" default="" hint="Restrict to: today,this_week,this_month,all_time">	
		<cfargument name="start" type="numeric" required="false">
		<cfargument name="max" type="numeric" required="false" hint="Defaults to 25 in API, max is 50">
		<cfset var baseurl = variables.standardurl & "most_discussed?">
		<cfif len(arguments.time)>
			<cfset baseurl = baseurl & "&time=#arguments.time#">
		</cfif>
		<cfif structKeyExists(arguments, "start")>
			<cfset baseurl &= "&start-index=#arguments.start#">
		</cfif>
		<cfif structKeyExists(arguments, "max")>
			<cfset baseurl &= "&max-results=#arguments.max#">
		</cfif>
		
		<cfreturn getVideos(baseurl)>
	</cffunction>
	
	<cffunction name="getMostRecentVideos" access="public" returnType="query" output="false"
				hint="Gets the most recent videos.">
		<cfargument name="start" type="numeric" required="false">
		<cfargument name="max" type="numeric" required="false" hint="Defaults to 25 in API, max is 50">
		<cfset var baseurl = variables.standardurl & "most_recent?">
		<cfif structKeyExists(arguments, "start")>
			<cfset baseurl &= "&start-index=#arguments.start#">
		</cfif>
		<cfif structKeyExists(arguments, "max")>
			<cfset baseurl &= "&max-results=#arguments.max#">
		</cfif>
		<cfreturn getVideos(baseurl)>
	</cffunction>
	
	<cffunction name="getMostRespondedVideos" access="public" returnType="query" output="false"
				hint="Gets the videos with the most responses.">
		<cfargument name="time" type="string" default="" hint="Restrict to: today,this_week,this_month,all_time">								
		<cfargument name="start" type="numeric" required="false">
		<cfargument name="max" type="numeric" required="false" hint="Defaults to 25 in API, max is 50">
		<cfset var baseurl = variables.standardurl & "most_responded?">
		<cfif len(arguments.time)>
			<cfset baseurl = baseurl & "&time=#arguments.time#">
		</cfif>	
		<cfif structKeyExists(arguments, "start")>
			<cfset baseurl &= "&start-index=#arguments.start#">
	
		</cfif>
		<cfif structKeyExists(arguments, "max")>
			<cfset baseurl &= "&max-results=#arguments.max#">
		</cfif>
		<cfreturn getVideos(baseurl)>
	</cffunction>
	
	<cffunction name="getMostViewedVideos" access="public" returnType="query" output="false"
				hint="Gets most viewed videos.">
		<cfargument name="time" type="string" default="" hint="Restrict to: today,this_week,this_month,all_time">				
		<cfargument name="start" type="numeric" required="false">
		<cfargument name="max" type="numeric" required="false" hint="Defaults to 25 in API, max is 50">
		<cfset var baseurl = variables.standardurl & "most_viewed?">
		<cfif len(arguments.time)>
			<cfset baseurl = baseurl & "&time=#arguments.time#">
		</cfif>
		<cfif structKeyExists(arguments, "start")>
			<cfset baseurl &= "&start-index=#arguments.start#">
		</cfif>
		<cfif structKeyExists(arguments, "max")>
			<cfset baseurl &= "&max-results=#arguments.max#">
		</cfif>
		<cfreturn getVideos(baseurl)>
	</cffunction>
	
	<cffunction name="getRecentlyFeaturedVideos" access="public" returnType="query" output="false"
				hint="Gets the recently featured videos.">
		<cfargument name="start" type="numeric" required="false">
		<cfargument name="max" type="numeric" required="false" hint="Defaults to 25 in API, max is 50">
		<cfset var baseurl = variables.standardurl & "recently_featured?">
		<cfif structKeyExists(arguments, "start")>
			<cfset baseurl &= "&start-index=#arguments.start#">
		</cfif>
		<cfif structKeyExists(arguments, "max")>
			<cfset baseurl &= "&max-results=#arguments.max#">
		</cfif>
		<cfreturn getVideos(baseurl)>
	</cffunction>
	
	<cffunction name="getTopFavoritesVideos" access="public" returnType="query" output="false"
				hint="Gets the most favorited videos.">
		<cfargument name="time" type="string" default="" hint="Restrict to: today,this_week,this_month,all_time">
		<cfargument name="start" type="numeric" required="false">
		<cfargument name="max" type="numeric" required="false" hint="Defaults to 25 in API, max is 50">
		<cfset var baseurl = variables.standardurl & "top_favorites?">
		<cfif len(arguments.time)>
			<cfset baseurl = baseurl & "&time=#arguments.time#">
		</cfif>
		<cfif structKeyExists(arguments, "start")>
			<cfset baseurl &= "&start-index=#arguments.start#">
		</cfif>
		<cfif structKeyExists(arguments, "max")>
			<cfset baseurl &= "&max-results=#arguments.max#">
		</cfif>
	
		<cfreturn getVideos(baseurl)>
	</cffunction>
	
	<cffunction name="getTopRatedVideos" access="public" returnType="query" output="false"
				hint="Gets the top rated videos.">
		<cfargument name="time" type="string" default="" hint="Restrict to: today,this_week,this_month,all_time">
		<cfargument name="start" type="numeric" required="false">
		<cfargument name="max" type="numeric" required="false" hint="Defaults to 25 in API, max is 50">
	
		<cfset var baseurl = variables.standardurl & "top_rated?">
		<cfif len(arguments.time)>
			<cfset baseurl = baseurl & "&time=#arguments.time#">
		</cfif>
		<cfif structKeyExists(arguments, "start")>
			<cfset baseurl &= "&start-index=#arguments.start#">
		</cfif>
		<cfif structKeyExists(arguments, "max")>
			<cfset baseurl &= "&max-results=#arguments.max#">
		</cfif>
		<cfreturn getVideos(baseurl)>
	</cffunction>
	
	<cffunction name="getUploadToken" access="public" returnType="xml" output="false" hint="I create a token to upload a video from the browser.">
		   <cfargument name="title" type="string" required="true">
		   <cfargument name="description" type="string" required="true">
		   <cfargument name="categories" type="string" required="true">
		   <cfargument name="keywords" type="string" required="true">
		   <cfargument name="isPrivate" type="boolean" default="false">
	
		   <cfset var theurl = "http://gdata.youtube.com/action/GetUploadToken">
		   <cfset var result = "">
		   <cfset var meta = "">
		   <cfset var resxml = "">
	
		   <!--- todo, validate the categories --->
		   <cfsavecontent variable="meta">
		   <cfoutput>
	<?xml version="1.0"?>
	<entry xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007">
	<media:group>
		   <media:title type="plain">#xmlFormat(arguments.title)#</media:title>
		   <media:description type="plain">#xmlFormat(arguments.description)#</media:description>
		   <media:category scheme="http://gdata.youtube.com/schemas/2007/categories.cat">#arguments.categories#</media:category>
		   <media:keywords>#xmlFormat(fixKeywords(arguments.keywords))#</media:keywords>
		   <cfif arguments.isPrivate>
				   <yt:private />
		   </cfif>
	</media:group>
	</entry>
		   </cfoutput>
		   </cfsavecontent>
		   <cfset meta = trim(meta)>
	
		   <cfhttp url="#theurl#" method="post" result="result">
				   <cfhttpparam type="header" name="Authorization" value="GoogleLogin auth=#variables.authtoken#">
				   <cfhttpparam type="header" name="Content-Type" value="application/atom+xml">
				   <cfhttpparam type="header" name="X-GData-Client" value="youtubecfc">
				   <cfhttpparam type="header" name="X-GData-Key" value="key=#variables.devkey#">
				   <cfhttpparam type="body" value="#meta#">
		   </cfhttp>
	
		   <cfif result.responseheader.explanation is "OK">
				   <cfset resxml = xmlParse(result.fileContent).response>
				   <cfreturn resxml>
		   <cfelse>
				   <cfthrow message="YouTubeCFC Upload Error: Status: #result.responseheader.status_code# / Explanation: #result.responseheader.explanation#">
		   </cfif>
	
	</cffunction>
	
	<cffunction name="getVideosByCategoriesKeywords" access="public" returnType="query" output="false"
				hint="Gets videos for a category or keyword.">
		<cfargument name="categories" type="string" required="false">
		<cfargument name="keywords" type="string" required="false">
		<cfset var baseurl = "http://gdata.youtube.com/feeds/api/videos/-">
		
		<cfif not structKeyExists(arguments, "categories") and not structKeyExists(arguments, "keywords")>
			<cfthrow message="YouTubeCFC Error: Must supply either a category or keyword to getVideosByCategoriesKeywords">
		</cfif>
		
	
		<cfif structKeyExists(arguments, "categories")>
			<cfset arguments.categories = listChangeDelims(arguments.categories, "%7C")>
			<cfset baseurl &= "/" & arguments.categories>
		</cfif>
		<cfif structKeyExists(arguments, "keywords")>
			<cfset arguments.keywords = listChangeDelims(arguments.keywords, "/")>
			<cfset baseurl &= "/" & arguments.keywords>
		</cfif>
	
		<cfreturn getVideos(baseurl)>
	</cffunction>
	
	<cffunction name="getVideosBySearch" access="public" returnType="query" output="false"
				hint="Gets videos by a search.">
		<cfargument name="search" type="string" required="true">
		<cfargument name="orderby" type="string" required="false" hint="Valid values are: relevance,published,viewcount,rating, or relevance_lang_X">
		<cfargument name="start" type="numeric" required="false">
		<cfargument name="max" type="numeric" required="false" hint="Defaults to 25 in API, max is 50">
		<cfargument name="author" type="string" required="false">
		<cfargument name="lang" type="string" required="false" hint="Two-character language code to restrict results.">
		<cfargument name="racy" type="boolean" required="false" hint="YouTube defaults to NOT-racy. How boring.">
		<cfargument name="time" type="string" required="false" hint="all_time(default),today,this_week,this_month">
		<cfargument name="autosearch" type="boolean" required="false" hint="If true, and results are 0 and suggestion != blank, will return a search for suggestion">
	
		<cfset var baseurl = "http://gdata.youtube.com/feeds/api/videos">
		<cfset var result = "">
		<cfset var newargs = "">
		
		<cfset baseurl &= "?v=2&q=#urlEncodedFormat(arguments.search)#">
		
		<cfif structKeyExists(arguments, "orderby")>
			<cfset baseurl &= "&orderby=#arguments.orderby#">
		</cfif>
		<cfif structKeyExists(arguments, "start")>
			<cfset baseurl &= "&start-index=#arguments.start#">
		</cfif>
		<cfif structKeyExists(arguments, "max")>
			<cfset baseurl &= "&max-results=#arguments.max#">
		</cfif>
		<cfif structKeyExists(arguments, "author")>
			<cfset baseurl &= "&author=#arguments.author#">
		</cfif>
		<cfif structKeyExists(arguments, "lang")>
			<cfset baseurl &= "&lr=#arguments.lang#">
		</cfif>
		<cfif structKeyExists(arguments, "racy")>
			<cfif arguments.racy>
				<cfset baseurl &= "&racy=include">
			<cfelse>
				<cfset baseurl &= "&race=exclude">
			</cfif>
		</cfif>
		<cfif structKeyExists(arguments, "time")>
			<cfset baseurl &= "&time=#arguments.time#">
		</cfif>
	
		<cfset result = getVideos(baseurl,true)>
	
		<!--- add suggestions column --->
		<cfset queryAddColumn(result.results,"suggestion", "varchar", arrayNew(1))>
		<cfif result.results.recordCount>
			<cfif structKeyExists(result, "suggestion")>
				<cfloop query="result.results">
					<cfset querySetCell(result.results, "suggestion", result.suggestion, currentRow)>
				</cfloop>
			</cfif>
			<cfreturn result.results>
		<cfelseif structKeyExists(result, "suggestion")>
			<cfset newArgs = duplicate(arguments)>
			<cfset newArgs.autosearch = false>
			<cfset newArgs.search = result.suggestion>
			<cfreturn getVideosBySearch(argumentCollection=newArgs)>
		<cfelse>
			<cfreturn result.results>
		</cfif>
		
	</cffunction>
	
	<cffunction name="getVideosByUser" access="public" returnType="query" output="false"
				hint="Gets videos for a user.">
		<cfargument name="username" type="string" required="true">
		<cfset var baseurl = "http://gdata.youtube.com/feeds/api/users/#arguments.username#/uploads">
		<cfreturn getVideos(baseurl)>
	</cffunction>
	
	<cffunction name="handleDate" access="public" returnType="date" output="false" hint="Utility function for dates.">
		<cfargument name="datestr" type="string" required="true">
		<cfset var date = listFirst(arguments.datestr,"T")>
		<cfset var time = listLast(arguments.datestr,"T")>
	
		<!--- remove the Z from time - probably a bit dangerous --->
		<cfset time = replace(time, "Z", "")>
		
		<cfset date = dateFormat(date,"short")>
		<cfset time = timeFormat(listFirst(time,"-"),"short")>	
		<cfreturn date & " " & time>	
	</cffunction>
		
	<cffunction name="login" access="public" returnType="void" output="false"
				hint="I authenticate a user and set the authtoken/username.">
		<cfargument name="email" type="string" required="true" hint="Username, normally an email address.">
		<cfargument name="password" type="string" required="true">
		<cfset var theurl = "https://www.google.com/accounts/ClientLogin">
		<cfset var result = "">
		<cfset var lines = "">
		
		<cfhttp url="#theurl#" method="post" result="result">
			<cfhttpparam type="header" name="GData-Version" value="2.1">
			<cfhttpparam type="formfield" name="Email" value="#arguments.email#">
			<cfhttpparam type="formfield" name="Passwd" value="#arguments.password#">
			<cfhttpparam type="formfield" name="service" value="youtube">	
			<cfhttpparam type="formfield" name="source" value="youtubecfc">	
		</cfhttp>
	
		<cfset result = result.filecontent>
		<cfset lines = listToArray(result, chr(10))>
		
		<cfif ArrayLen(lines) neq 3>
			<cfthrow message="YouTubeCFC Login Error: #result#">
		</cfif>
	
		<cfset variables.authtoken = listRest(lines[3],"=")>
	
	</cffunction>
	
	<cffunction name="parseEntry" access="private" returnType="struct" output="false" hint="I'm a utility function to parse Entry XML">
		<cfargument name="entry" type="any" required="true">
		<cfset var s = structNew()>
		<cfset var y = "">
		<cfset var keywordlist = "">
		<cfset var categorylist = "">
		
		<cfset s.id = arguments.entry.id.xmlText>
		<cfset s.published = "">
		<cfif structKeyExists(arguments.entry, "published")>
			<cfset s.published = handleDate(arguments.entry.published.xmlText)>
		</cfif>
		<cfset s.updated = handleDate(arguments.entry.updated.xmlText)>
	
		<cfloop index="y" from="1" to="#arrayLen(arguments.entry.category)#">
			<cfif arguments.entry.category[y].xmlAttributes.scheme is "http://gdata.youtube.com/schemas/2007/keywords.cat">
				<cfset keywordList = listAppend(keywordList, arguments.entry.category[y].xmlAttributes.term)>
			<cfelseif entry.category[y].xmlAttributes.scheme is "http://gdata.youtube.com/schemas/2007/categories.cat">
				<cfset categoryList = listAppend(categoryList, arguments.entry.category[y].xmlAttributes.label)>
			</cfif>
		</cfloop>
	
		<!--- 
		<cfset s.keywords = keywordList>
		Note - now keywords are in a media:keyword item. This means part of the code above could be removed later.
		--->
	
		<cfset s.categories = categoryList>
		<cfset s.title = arguments.entry.title.xmlText>
		<cfif structKeyExists(arguments.entry, "content")>
			<cfset s.content = arguments.entry.content.xmlText>
		<cfelse>
			<cfset s.content = "">
		</cfif>
		<cfset s.author = arguments.entry.author.name.xmlText>
		<cfset s.authorurl = entry.author.uri.xmlText>
		
		<cfset s.link = "">
		<cfloop index="y" from="1" to="#arrayLen(arguments.entry.link)#">
			<cfif arguments.entry.link[y].xmlAttributes.rel is "alternate" and arguments.entry.link[y].xmlAttributes.type is "text/html">
				<cfset s.link = arguments.entry.link[y].xmlattributes.href>
			</cfif>
		</cfloop>
		
		<cfset s.description = "">
		<cfset s.duration = "">
		<cfset s.thumbnail_url = "">
		<cfset s.thumbnail_width = "">
		<cfset s.thumbnail_height = "">	
		<cfif structKeyExists(arguments.entry, "media:group")>
			<cfif structKeyExists(arguments.entry["media:group"], "media:description")>
				<cfset s.description = arguments.entry["media:group"]["media:description"].xmltext>
			<cfelse>
				<cfset s.description = "">
			</cfif>
			<cfif structKeyExists(arguments.entry["media:group"], "yt:duration")>
				<cfset s.duration = arguments.entry["media:group"]["yt:duration"].xmlattributes.seconds>
			<cfelse>
				<cfset s.duration = "">
			</cfif>
			<cfif structKeyExists(arguments.entry["media:group"], "media:thumbnail")>		
				<!--- Thumbnail is complex, has multiple records, but for getvideos, we will show just the first one. --->
				<cfset s.thumbnail_url = arguments.entry["media:group"]["media:thumbnail"].xmlAttributes.url>
				<cfset s.thumbnail_width = arguments.entry["media:group"]["media:thumbnail"].xmlAttributes.width>
				<cfset s.thumbnail_height =  arguments.entry["media:group"]["media:thumbnail"].xmlAttributes.height>
			<cfelse>
				<cfset s.thumbnail_url = "">
				<cfset s.thumbnail_width = "">
				<cfset s.thumbnail_height = "">
			</cfif>
			<cfif structKeyExists(arguments.entry["media:group"], "media:keywords")>
				<cfset s.keywords = arguments.entry["media:group"]["media:keywords"].xmltext>
			</cfif>
	
		</cfif>
	
		<cfset s.viewcount = "">
		<cfset s.favoritecount = "">
		
		<cfif structKeyExists(arguments.entry, "yt:statistics")>
			<cfif structKeyExists(arguments.entry["yt:statistics"].xmlAttributes, "viewCount")>
				<cfset s.viewcount = arguments.entry["yt:statistics"].xmlAttributes.viewcount>
			</cfif>
			<cfif structKeyExists(arguments.entry["yt:statistics"].xmlAttributes, "favoriteCount")>
				<cfset s.favoritecount = arguments.entry["yt:statistics"].xmlAttributes.favoritecount>
			</cfif>
		</cfif>
	
		<cfset s.averagerating = "">
		<cfset s.numratings = "">
		<cfif structKeyExists(arguments.entry, "gd:rating")>
			<cfset s.averagerating = arguments.entry["gd:rating"].xmlAttributes.average>
			<cfset s.numratings = arguments.entry["gd:rating"].xmlAttributes.numraters>
		</cfif>
	
		<cfif structKeyExists(arguments.entry, "gd:comments")>
			<cfset s.commentsurl = arguments.entry["gd:comments"]["gd:feedlink"].xmlAttributes.href>
			<cfset s.numcomments = arguments.entry["gd:comments"]["gd:feedlink"].xmlAttributes.countHint>
		</cfif>
	
		<cfset s.videostatus = "public">
		<cfif structKeyExists(arguments.entry, "app:control") and structKeyExists(arguments.entry["app:control"], "yt:state")>
			<cfif structKeyExists( arguments.entry["app:control"]["yt:state"].xmlAttributes, "reasonCode")>
				<cfset s.videostatus = arguments.entry["app:control"]["yt:state"].xmlAttributes.reasonCode>
			<cfelseif structKeyExists( arguments.entry["app:control"]["yt:state"].xmlAttributes, "name")>
				<cfset s.videostatus = arguments.entry["app:control"]["yt:state"].xmlAttributes.name>
			</cfif>
		</cfif>
	
		<cfreturn s>
	
	</cffunction>
	
	<cffunction name="setDeveloperKey" access="public" returnType="void" output="false"
				hint="Sets the developer key for the CFC.">
		<cfargument name="devkey" type="string" required="true">
		<cfset variables.devkey = arguments.devkey>
	</cffunction>
	
	<cffunction name="update" access="public" returnType="any" output="false" hint="I update a video.">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="categories" type="string" required="true">
		<cfargument name="keywords" type="string" required="true">
		<cfargument name="videoId" type="string" required="true">
		
		<cfset var theurl = "http://uploads.gdata.youtube.com/feeds/api/users/#variables.username#/uploads/">
		<cfset var result = "">
		<cfset var meta = "">
		<cfset var resxml = "">
		<cfset var tmpFile = expandPath("./#replace(createUUID(),'-','_','all')#")>
	
		<cfset theurl &=  arguments.videoId />
		<!--- todo, validate the categories --->
		<cfsavecontent variable="meta">
		<cfoutput>
	<?xml version="1.0"?>
	<entry xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007">
	<media:group>
		<media:title type="plain">#arguments.title#</media:title>
		<media:description type="plain">#arguments.description#</media:description>
		<media:category scheme="http://gdata.youtube.com/schemas/2007/categories.cat">#arguments.categories#</media:category>
		<media:keywords>#xmlFormat(fixKeywords(arguments.keywords))#</media:keywords>
	</media:group>
	</entry>
		</cfoutput>
		</cfsavecontent>
	
		<cfset meta = trim(meta)>
		<cfhttp url="#theurl#" method="put" result="result">
			<cfhttpparam type="header" name="Host" value="gdata.youtube.com">
			<cfhttpparam type="header" name="Content-Type" value="application/atom+xml">
			<cfhttpparam type="header" name="Content-Length" value="#len(meta)#">
			<cfhttpparam type="header" name="Authorization" value="GoogleLogin auth=#variables.authtoken#">
			<cfhttpparam type="header" name="X-GData-Client" value="youtubecfc">
			<cfhttpparam type="header" name="X-GData-Key" value="key=#variables.devkey#">
			<cfhttpparam type="header" name="rel" value="edit">
			<cffile action="write" file="#tmpfile#" output="#meta#">
			<cfhttpparam type="file" name="API_XML_Request" file="#tmpfile#" mimetype="application/atom+xml">
		</cfhttp>
		
		<cffile action="delete" file="#tmpfile#">
		
		<cfif result.responseheader.explanation is "OK">
			<cfset resxml = xmlParse(result.fileContent)>
			<cfreturn resxml.entry.id.xmlText>
		<cfelse>
		<cfoutput>#theurl#<p>#htmlcodeformat(meta)#</cfoutput>
			<cfif isXml(result.filecontent)>
				<cfset resxml = xmlParse(result.fileContent)>
				<cfthrow message="YouTubeCFC Upload Error: Domain=#resxml.errors.error.domain.xmlText#, Code=#resxml.errors.error.code.xmlText#">
			<cfelse>
				<cfthrow message="YouTubeCFC Upload Error: Status: #result.responseheader.status_code# / Explanation: #result.responseheader.explanation#">
			</cfif>	
		</cfif>
	
	</cffunction>	
	
	<cffunction name="upload" access="public" returnType="any" output="false" hint="I upload a video.">
		<cfargument name="video" type="string" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="description" type="string" required="true">
		<cfargument name="categories" type="string" required="true">
		<cfargument name="keywords" type="string" required="true">
		<cfargument name="logEntry" required="false">
		
		<cfset var theurl = "http://uploads.gdata.youtube.com/feeds/api/users/#variables.username#/uploads/">
		<cfset var result = "">
		<cfset var meta = "">
		<cfset var tmpFile = expandPath("./#replace(createUUID(),'-','_','all')#")>
		<cfset var resxml = "">
		
		<cfif not fileExists(arguments.video)>
			<cfthrow message="YouTubeCFC Upload Error: The video (#arguments.video#) could not be found.">
		</cfif>
	
		<!--- todo, validate the categories --->
		<cfsavecontent variable="meta">
		<cfoutput>
	<?xml version="1.0"?>
	<entry xmlns="http://www.w3.org/2005/Atom" xmlns:media="http://search.yahoo.com/mrss/" xmlns:yt="http://gdata.youtube.com/schemas/2007">
	<media:group>
		<media:title type="plain">#xmlFormat(arguments.title)#</media:title>
		<media:description type="plain">#xmlFormat(arguments.description)#</media:description>
		<media:category scheme="http://gdata.youtube.com/schemas/2007/categories.cat">#arguments.categories#</media:category>
		<media:keywords>#xmlFormat(fixKeywords(arguments.keywords))#</media:keywords>		
	</media:group>
	<yt:accessControl action="list" permission="denied"/>
	<yt:accessControl action="videoRespond" permission="moderated"/>
	<yt:accessControl action="comment" permission="moderated"/>
	</entry>
		</cfoutput>
		</cfsavecontent>
		<cfset meta = trim(meta)>
	
		<!--- store the xml --->
		<cffile action="write" file="#tmpfile#" output="#meta#">
	
		<cfhttp url="#theurl#" method="post" result="result" multiparttype="form-data" timeout="99999999999999999">
		<!--- cf <cfhttp url="#theurl#" method="post" result="result" multiparttype="related"> --->
			<cfhttpparam type="header" name="Authorization" value="Bearer #variables.authtoken#">
			<cfhttpparam type="header" name="X-GData-Client" value="youtubecfc">
			<cfhttpparam type="header" name="X-GData-Key" value="key=#variables.devkey#">
			<cfhttpparam type="header" name="Slug" value="#listLast(arguments.video,"\/")#">
			<cfhttpparam type="header" name="GData-Version" value="2.1">
			<!--- <cfhttpparam type="header" name="Content-Transfer-Encoding" value="binary"> --->
			<cfhttpparam type="file" name="API_XML_Request" file="#tmpfile#" mimetype="application/atom+xml; charset=UTF-8">
			<cfhttpparam type="file" name="file" file="#arguments.video#" mimetype="video/*">	
		</cfhttp>
		<cffile action="delete" file="#tmpfile#">
		
		<cfset test = "ClientLogin auth=#variables.authtoken#">	
		
		<cfif StructKeyExists(arguments,"logEntry") AND !StructKeyExists(result.responseheader,"explanation")>
			<cfset logEntry("Youtube.cfc Explanation Not Defined", result)>
		</cfif>
		
		<cfif result.responseheader.explanation is "created">
		
			<!--- Fix duplicate thumbnail keys --->
			<cfset xmlresult = result.fileContent>
			<cfloop from="1" to="6" index="i">
				<cfset xmlresult = Replace(xmlresult,"media:thumbnail","thumb-#i#")>
			</cfloop>
			
			<!--- Parse and return xml --->
			<cfset resxml = xmlParse(xmlresult)>
			<cfreturn resxml>
			
		<cfelse>
			<cfif isXml(result.filecontent)>
				<cfset resxml = xmlParse(result.fileContent)>
				<cfdump var="#resxml#" abort>
				<cfthrow message="YouTubeCFC Upload Error: Domain=#resxml.errors.error.domain.xmlText#, Code=#resxml.errors.error.code.xmlText#">
			<cfelse>
				<cfdump var="#result#" abort>
				<!--- <cfthrow message="YouTubeCFC Upload Error: Status: #result.responseheader.status_code# / Explanation: #result.responseheader.explanation#"> --->
			</cfif>	
		</cfif>
	
	</cffunction>	
	

</cfcomponent>