<cfoutput>
<cfabort>
	<cfscript>
		jsoup = createObject('java','org.jsoup.Jsoup','/assets/tools/jsoup.jar');
		whitelist = CreateObject("java", "org.jsoup.safety.Whitelist",'/assets/tools/jsoup.jar');
		siteposts = db.getRecords("posts",{siteid=3,postType="post"});		
		imgCount = numberFormat(1, 9999999);
	</cfscript>
	
	<cfloop query="siteposts">	
		<cfscript>
			jContent = jsoup.parse(content);
			jImgs = jContent.select("img");
			currentOldImages = [];
			
			for ( img in jImgs )
			{
				imgUrl = img.attr("src");
				
				if(find("http",lcase(imgUrl)))
				{
					// Set img name and path
					imgName = ListLast(imgUrl,"/");
					imgName = ListFirst(imgName,".");
					imgName	= "image-#imgCount#";
					imgExt	= ListLast(imgUrl,".");
					imgExt	= len(imgExt) eq 3 ? imgExt : "jpg";
					
					newImagePath="/assets/nvw/blog/";
					
					// Save to server
					saveImageToServer(remoteImgUrl=imgUrl, serverImgPath=newImagePath, serverImgName="#imgName#.#imgExt#");
					
					// Replace in source
					newFullImgPath = "#newImagePath##imgName#.#imgExt#";
					//img.attr("src",newFullImgPath);
					
					ArrayAppend(currentOldImages,{old=imgUrl,new=newFullImgPath});
					
					imgCount++;
				}				
			}
			
			newContent = jContent.html();
			
			for(oldImgUrl in currentOldImages)
			{
				newContent = replace(newContent,oldImgUrl.old,oldImgUrl.new,"ALL");
			}
			
			// Clean up the code, usually full of junk
			newContent = jsoup.clean(
				newContent, 
				"http://newvisionwilderness.com/",
				Whitelist.basicWithImages().preserveRelativeLinks(true)
			);
			
			writeOutput(newContent & "<hr><br><br><br><br>");
			
			// Save it
			//db.updateRecord("posts",{id=siteposts.id,content=newContent});			
		</cfscript>
	</cfloop>
	
	<cffunction name="saveImageToServer">
		<cfargument name="remoteImgUrl">
		<cfargument name="serverImgPath">
		<cfargument name="serverImgName">
		
		<cfif find("http",lcase(remoteImgUrl)) AND !FileExists("#expandPath(serverImgPath)##serverImgName#")>
			<cfhttp method="get" getAsBinary="yes" url="#remoteImgUrl#" path="#expandPath(serverImgPath)#" file="#serverImgName#" ></cfhttp>
			<cfreturn true>
		<cfelse>
			<cfreturn false>
		</cfif>
			
	</cffunction>
	
	Images fixed.
	
</cfoutput>