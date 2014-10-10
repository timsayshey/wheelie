<cfcomponent extends="_main">
	
	<cffunction name="init">
		<cfset super.init()>
	</cffunction>
	
	<cffunction name="toyoutube" access="remote" output="true">		
	
		<cfset params.qVideo = model("File").findByKey(params.id)>
		<cfset params.filepath = "#info.filevideos##params.qVideo.filename#">
		<cfset params.db = db>
		
		<cfthread action="run" name="thread#TimeFormat(now(),'s')#" priority="normal" params="#params#" timeout="99999999999">
			<cftry>	
				<cfscript>					
					logEntry("Youtube Upload Start");
					
					// Set Video Path and Get Data
					filepath	= params.filepath;
					
					// Login and post to youtube's api
					if(FileExists(filepath))
					{							
						data = {
							id		  = params.id,
							status	  = "youtubePending",
							filetype  = "video"
						};
						
						params.db.saveRecord(tn.files,data);
						
						youtube.setToken(params.token);
						results = youtube.upload(
							video		= params.filepath,
							title		= listFirst(params.qVideo.filename,".") & " - Change this",
							description = "Find out more at http://google.com",
							categories	= "Howto",
							keywords 	= "Key, words, here",
							logEntry	= logEntry
						);
						
						// Set and Handle Results							
						if(!isNull(results.entry["media:group"]["yt:videoid"].xmlText))
						{
							newVideoPath = model("Video").convertVideo(filepath);
							newFilename = ListLast(newVideoPath,"\");							
							
							data = {
								youtubeid = results.entry["media:group"]["yt:videoid"].xmlText,
								id		  = params.id,
								status	  = "youtubeUploaded",
								filename  = newFilename
							};							
						}
						else {
							data = {
								id		  = params.id,
								status	  = "youtubeFailed"
							};
						}
						
						params.db.saveRecord(tn.files,data);												
						
						
						logEntry("Youtube Upload Finish");						
						
						// Save youtube thumbnail
						// model("Video").getYoutubeThumb(params,results);						
						
					} else 
					{
						writeOutput("0"); 
						logEntry("Youtube fail - Video file not found", filepath);
					}
				</cfscript>
				<cfcatch>
					<cfset logEntry("Youtube Thread Error",cfcatch,params)>
					<cfset params.db.saveRecord(tn.files, {
								id		  = params.id,
								status	  = "youtubeFailed"
							})>						
				</cfcatch>
			</cftry>
		</cfthread>					
		
		<cfif FileExists(params.filepath)>		
			<cfset flashInsert(success="Your video is now being sent to and processed on Youtube. This could take awhile. Check back later.")>
			<cfset ajaxReturn = 1>
		<cfelse>			
			<cfset flashInsert(error="Your video was not found. Please try again.")>
			<cfset ajaxReturn = 0>
		</cfif>
		
		<cfif !isNull(params.isAjax)>
			<cfoutput>#ajaxReturn#</cfoutput>
			<cfabort>
		<cfelse>
			<cfset redirectTo(route="admin~Action", module="admin", controller="files", action="index")>
		</cfif>
		
	</cffunction>
	
	<cffunction name="tolocal" access="remote" output="true">
	
		<cfdump var="#params#">
		
		<cfabort>
	
	</cffunction>
	
	<cffunction name="getUploads" access="remote" output="true">
		
		<cfscript>
			qUploads = DirectoryList(
				info.filevideos, 			// path
				false, 				// recurse
				"query", 			// list info
				"*.*", 				// filter
				"datelastmodified DESC" 	// sort
			);
		</cfscript>
		
		<cfoutput query="qUploads">
		
			<cfset mbs = size / 1024 / 1024>
			<cfset mbs = NumberFormat(mbs, '9.99')>
			
			<li class="plupload">
				<div class="plupload_file_name">
					<span>#name#</span>
					Host on  
					<a href="##long" data-toggle="modal" class="video_add_youtube btn btn-small btn-danger">Youtube</a> or
					<a href="##long" data-toggle="modal" class="video_add_local btn btn-small">Local Site</a> ?
				</div>
				<div class="plupload_file_status">#mbs# MB</div>
				<div class="plupload_file_size">#DateFormat(dateLastModified,"MM-DD-YYYY")#</div>
				<div class="plupload_clearer">&nbsp;</div>
			</li>
			
		</cfoutput>	
		
		<cfabort>
		
	</cffunction>
	
	<cffunction name="oauth" access="remote" output="false">
	
		<cfscript>	
			session.oauth = {
				email = params.email,
				name = params.name,
				token = params.token
			};	
		</cfscript>
		
		Please wait...
		
		<cfabort>
	</cffunction>
	
	
	<cffunction name="videoFinished" access="remote" output="false">
	
		<cfscript>			
			if(isNull(params.id))
			{		
				video = model("File").new({ filename = 'temp', filepath = 'temp' });
				
				if (video.save())
				{			
					uploadFromFileManager = true;
					params.id =  video.id;
				}
			}
			
			var videoid		= params.id;			
			var videoext	= listlast(params.filename,".");
			var filename	= listfirst(params.filename,".");
			var uploadTo	= params.uploadTo;			
			
			var newfilename 	 = cleanseFilename(filename) & "." & videoext;
			var uploadedfilepath = info.filevideos & params.filename;
			var renamedfilepath  = info.filevideos & newfilename;
			
			if (fileExists(uploadedfilepath))
			{	
				// If name needs cleanup then rename the video and delete the old
				if(trim(newfilename) NEQ trim(params.filename))
				{
					fileCopy(uploadedfilepath,renamedfilepath);
					fileDelete(uploadedfilepath);
				}
				
				videoModel = model("File").findByKey(params.id);
				videoModel.update(filename = newfilename, filepath = info.videosPath, filetype = "video");
				
				if(params.uploadTo eq "yt") 
				{					
					// Do youtube stuff
					noIssues = true;
				} else 
				{										
					// Convert video and return new path
					renamedfilepath = model("Video").convertVideo(renamedfilepath,videoModel);		
					
					// Set new filename (may have been renamed if there was a conflict)
					newFilename = ListLast(renamedfilepath,"\");
					
					noIssues = true;
				}
				
				// Generate the thumbnail manually, no need to jack around with youtube
				try {
					videoThumb = videoconverter.generateVideoThumb(
						VideoFilePath = renamedfilepath,
						ThumbFolder	  = "/videos/thumbs/"
					); 
				} catch(any e) {
					
				}
				
				writeOutput(SerializeJSON({ 
					code 		= 1, 
					name 		= newfilename, 
					ext 		= videoext, 
					videoid 	= params.id, 
					uploadTo	= params.uploadTo, 
					noIssues 	= noIssues 
				})); 
				abort;
			}
			
			writeOutput(SerializeJSON({ code = 0 })); abort;
			
		</cfscript>
		
		<!---
			TODO:
			* Recieve fileid
			* Copy file from hidden temp folder and rename to something human
			* Delete temp file
			* Return success or fail
		--->
		
	</cffunction>	
	
	<cffunction name="videoUpload" access="remote" output="false">			
		
		<cfscript>			
			writeOutput(pluploader(
				name		= params.name,
				chunk		= params.chunk,
				chunks		= params.chunks,
				params		= params,
				uploadDir	= info.filevideos
			));
			abort;
		</cfscript>
		
	</cffunction>
	
</cfcomponent>