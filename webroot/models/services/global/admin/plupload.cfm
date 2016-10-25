
<!--- Recieves file chunks from plupload and reassembles them into a file --->
<cffunction name="pluploader" access="remote" output="false">
	<!--- <cfargument name="name"			default="default.temp">
	<cfargument name="chunk"		default="">
	<cfargument name="chunks"		default="">
	<cfargument name="uploadDir"	default="#expandPath('.')#/assets/uploads/"> --->
	
	<cfscript>				
		var uploadFile	= arguments.uploadDir & arguments.NAME;
		var response	= { 'result' = arguments.NAME, 'id' = 0};
		var result		= {};
		
		// if chunked append chunk number to filename for reassembly
		if (structKeyExists(arguments, 'CHUNKS'))
		{
			uploadFile = uploadFile & '.' & arguments.CHUNK;
			response.id = arguments.CHUNK;
		}
	</cfscript>		
	
	<!--- save file data from multi-part form.FILE --->
	<cffile action="upload" result="result" filefield="FILE" destination="#uploadFile#" nameconflict="overwrite"/>
	
	<cfscript>
		// Example: you can return uploaded file data to client 
		response['size'] 	= result.fileSize;
		response['type']	= result.contentType;
		response['saved']	= result.fileWasSaved;
		
		// reassemble chunked file
		if (structKeyExists(arguments, 'CHUNKS') && arguments.CHUNK + 1 eq arguments.CHUNKS)
		{
			try 
			{
				var uploadFile = uploadDir & arguments.NAME; // file name for reassembled file - if using a temp directory then this should be the final output path/file
				if (fileExists(uploadFile))
				{
					fileDelete(uploadFile); // delete otherwise append will add chunks to an existing file
				}

				var tempFile = fileOpen(uploadFile,'append');
				for (var i = 0; i < arguments.CHUNKS; i++) 
				{
					var chunk = fileReadBinary('#uploadDir#/#arguments.NAME#.#i#');
					fileDelete('#uploadDir#/#arguments.NAME#.#i#');
					fileWrite(tempFile, chunk);
				}
				fileClose(tempFile);
			}
			catch(any err) 
			{
				// clean up chunks for incomplete upload
				var d = directoryList(uploadDir,false,'name');
				if (arrayLen(d) != 0)
				{
					for (var i = 1; i <= arrayLen(d); i++)
					{
						if (listFirst(d[i]) eq arguments.NAME && val(listLast(d[i])) != 0)
						{
							fileDelete('#uploadDir##d[i]#');
						}
					}
				}

				// you could add more error handling and return info from err 
				response = {'error' = {'code' = 500, 'message' = 'Internal Server Error'}, 'id' = 0};	
			}
		}		
	</cfscript>
	<cfreturn SerializeJSON(response)>
</cffunction>