<cfscript>	
	// Only available after initial run
	if (!isNull(application.db)) 
	{ db = application.db; }
	
	if (!isNull(application.yt)) 
	{ youtube = application.yt; }
	
	if (!isNull(application._)) 
	{ _ = application._; }
	
	if (!isNull(application.fileMgr)) 
	{ fileMgr = application.fileMgr; }
	
	if (!isNull(application.privateFileMgr)) 
	{ privateFileMgr = application.privateFileMgr; }
	
	if (!isNull(application.pagination)) 
	{ pagination = application.pagination; }
</cfscript>