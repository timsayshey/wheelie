<cfcomponent extends="models.Model">
	<cfscript>					
		function init()
		{						
			// Properties
			this.setWhere = setWhere;	
			
			// Relations
			//hasMany(name="VideoCategoryJoins", foreignKey="id");			
			belongsTo(name="VideoCategoryJoin", foreignKey="id", joinKey="videoid", joinType="outer");
			
			// Validations
			validatesUniquenessOf(property="urlid", scope="siteid");
			validatesPresenceOf(property ="urlid", when="onCreate");
			
			// Other
			super.init();
			beforeSave("sanitizeNameAndURLId");
		}		
		function setWhere()
		{
			return wherePermission('Video');
		}		
	</cfscript>
	
	<cffunction name="convertVideo">
		<cfargument name="inputVideoPath">
		<cfargument name="videoModel" default="">
		<cfscript>
			// Do local stuff
			newVideoPath = videoconverter.convertVideo(
				videoFilePath	= inputVideoPath,
				folder			= "videos",
				extension		= "flv",
				scale			= "420x240",
				videoCompression= 22,
				audioQuality	= "8k"
			);
			
			// Set new filename (may have been renamed if there was a conflict)
			newFilename = ListLast(newVideoPath,"\");
			
			// thumbnew			 
			thumbNew = ListFirst(newFilename,".") & ".jpg";
			thumbNewPath = expandPath("/assets/uploads/videos/thumbs/#thumbNew#");
			
			// thumbold
			thumbOld = ListFirst(ListLast(inputVideoPath,"\"),".") & ".jpg";
			thumbOldPath = expandPath("/assets/uploads/videos/thumbs/#thumbOld#");
			
			// Rename thumbnail
			if(thumbNew NEQ thumbOld AND fileExists(thumbOldPath))
			{
				fileCopy(thumbOldPath,thumbNewPath);
			}
			
			// Once video has been converted remove original file if name is different
			if(newVideoPath NEQ inputVideoPath AND fileexists(inputVideoPath))
			{
				fileDelete(inputVideoPath);
			}
			
			if(isObject(videoModel))
			{				
				
				// Set filesize
				videoFileInfo = GetFileInfo(newVideoPath);
				
				// Update file with new filename and filesize
				videoModel.update(filename = newFilename, bytesize = videoFileInfo.size);	
			}
			
			return newVideoPath;
		</cfscript>
	</cffunction>
	
	<!--- Loop over thumbs till ya find the high quality one then go get it --->
	<cffunction name="getYoutubeThumb">
		<cfargument name="params">
		<cfargument name="youtubeResults">
		<cfscript>
			maxCount = 6;
			for(i=1; i LTE maxCount; i++)
			{
				thumbUrl = youtubeResults.entry["media:group"]["thumb-#i#"].xmlAttributes.url;
				if(find("hqdefault.jpg",thumbUrl)) 
				{ 
					// Save thumb
					logEntry("Thumb result", tryToSaveYoutubeThumb(params,thumbUrl));
					break; 
				};
			}
		</cfscript>
	</cffunction>
	
	<!--- Try to save every 10 seconds until thumbnail is available --->
	<cffunction name="tryToSaveYoutubeThumb">
		<cfargument name="params">
		<cfargument name="imgUrl">
		
		<cfset thumbNotSaved = true>
		<cfset maxTries = 2>
		<cfset currentTries = 0>
		
		<cfloop condition="#thumbNotSaved#">
			<cfset logEntry("tryToSaveYoutubeThumb",imgUrl)>
			<cfset thumbNotSaved = saveYoutubeThumb(params.qVideo.filename,imgUrl,10000)>
			
			<cfif currentTries GTE maxTries>
				<cfbreak>
			</cfif>
			<cfset currentTries++>		
				
		</cfloop>
		
		<cfreturn true>		
	</cffunction>
	
	<!--- Check for youtube thumb and save if available --->
	<cffunction name="saveYoutubeThumb">
		<cfargument name="filename">
		<cfargument name="imgUrl">
		<cfargument name="minutesToWait" default="1">
		<cfargument name="videoid" default="">
		<cfscript>		
			try {
				logEntry("saveYoutubeThumb Start",imgUrl);
				Sleep(minutesToWait);	
				
				// Video thumbnail paths
				tempThumbPath = "#info.fileuploads#videos/thumbs/#videoid#.jpg";
				
				// Retrieve and save thumbnail
				imgsrc = imageRead(imgUrl);						
				imageWrite(imgsrc, tempThumbPath, "true"); 
				
				logEntry("saveYoutubeThumb Success",imgUrl);
				
				return false;
			} catch(any e) {
				logEntry("saveYoutubeThumb Failed",e,imgUrl,filename);			
				return true;
			}
		</cfscript>
	</cffunction>
	
</cfcomponent>
	