<cfscript>
/*
	// Add to application scope in live
	FileMgr = CreateObject("component","video_converter.FileMgr").init(ExpandPath("/f/"),"/f/");
	VideoConverter = CreateObject("component","video_converter.VideoConverter").init(FileMgr);
	
	// Convert video
	convertVideo = convertVideo(
		VideoFilePath	= "",
		Folder			= "",
		Extension		= ""
	);
	
	// Generate video thumb
	videoThumb = generateVideoThumb(
		VideoFilePath = "",
		ThumbFolder	  = ""
	); 
	
	// Get Video Info
	videoinfo = getVideoInfo(file = "");
	
	// Get HTML5 Video Player
	videoplayer = getVideoHTML(
		VideoFiles	= "",
		Width		= "",
		Height		= "",
		Title		= "",
		Controls	= true,
		AutoPlay	= true
	);
	
	// Records.cfc Demo coming soon	
*/	
</cfscript>

<cfoutput>

	<cfset testSuite = createObject( "component", "mxunit.framework.TestSuite" ).TestSuite() />
	
	<cfset testSuite.addAll( "model.videoconverter.tests.TestVideoConverter" ) />
	
	<cfset results = testSuite.run() />
	
	<cfoutput>
		#results.getHtmlResults( "../../mxunit/" )#
	</cfoutput>

</cfoutput>