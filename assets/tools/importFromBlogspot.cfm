<cfoutput>
<cfabort>
	<cffeed action="read" source="/assets/tools/blogspot-nvw.xml" query="feed">
	
	<cfloop query="feed">	
		<cfscript>	
		
			// get urlid
			if(len(content) GT 150 AND !find("xml version",content))
			{
				thisRow = {
					postType = "post",
					urlid = cleanUrlId(lcase(feed.TITLE)),
					name = feed.TITLE,
					content = REReplace(feed.CONTENT,"[^0-9A-Za-z -_~!@##$%^&*()+'`]","","all"),
					metagenerated = 1,
					metatitle = feed.TITLE,
					metakeywords = feed.TITLE,
					metadescription = feed.TITLE,
					status = "published",
					createdat = feed.PUBLISHEDDATE,
					createdby = 1,
					siteid = 3,
					authorName = "",
					oldUrl = "" 
				};				
				
				// Save to DB
				// db.insertRecord("posts",thisRow);
				
				// This generates redirects that you can paste in the the Blogspot layout html
				hreflist = ArrayToList(LINKHREF);	
				hrefarray = ListToArray(hreflist);
				for(href in hrefarray)
				{
					if(find(".html",lcase(href)) AND !find("##",lcase(href)))
					{
						oldhref = href;
					} else {
						// Means it was probably deleted
						oldhref = "FAIL";
					}
				}
				
				writeOutput("&lt;!-- <a href='#oldhref#'>#oldhref#</a> --&gt;<br>
				&lt;b:if cond='data:blog.url == &quot;#oldhref#&quot;'&gt;<br>
					&lt;meta content='0;url=http://newvisionwilderness.com/blog/post/#cleanUrlId(lcase(feed.TITLE))#' http-equiv='refresh'/&gt;<br>
				&lt;/b:if&gt;
				
				<br><br>");
			}
			
		</cfscript>
	</cfloop>
	
	Import complete.
	
</cfoutput>