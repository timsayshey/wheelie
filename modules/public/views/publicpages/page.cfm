<cfscript>
	if (!isNull(page.quoteImg)) 
	{
		if (len(page.redirect)) 
		{
			location addtoken="no" url="#page.redirect#";
		}
		
		checkUrlExtension(checkUrl="/#page.urlid#");
		
		contentFor(quoteImg = page.quoteImg);
		contentFor(youtubeId = page.youtubeId);
		contentFor(sideContent = page.sideContent);
		subPageTitle = getOption(qOptions,'seo_subpage_title').label;
		contentFor(siteTitle = "#capitalize(page.metatitle)#");		
		contentFor(siteDesc = page.metadescription);
		contentFor(siteKeywords = page.metakeywords);
	} 
	else if ( !isNull(params.format) AND !isNull(params.id) AND ListFind("jpg,pdf,mp3",lcase(params.format)) ) 
	{
		// For Old Files // Should Remove Later
		header statuscode="301" statustext="Moved Permanently";
		header name="Location" value="/assets/site/#params.id#.#params.format#";
		abort;
	} 
	else 
	{
		header statusCode="404" statusText="Not Found";
		log404();
	}

	contentFor(footerPageBlock = footerPageBlock);
	
    // Check Static Page
    staticDir = "/views/static/";	
	staticDirFull = expandPath(staticDir);
	
	// Find Static Folder ie "3 - My Site"
	directory action="list" directory="#staticDirFull#" listinfo="name" name="qStaticDir" filter="#request.site.id#_*";
	
	staticPath = "#staticDir##qStaticDir.name#";
    staticPathFull = expandPath(staticPath);

	if (isNull(page.id)) 
	{
		// No DB Record / Just static file
		staticPath = "#staticDir##qStaticDir.name#/#params.id#.cfm";
		staticPathFull = expandPath(staticPath);
	} 
	else 
	{
		// Find Static Page ie "14 - about us.cfm"
		directory action="list" directory="#staticPathFull#" listinfo="name" name="qStaticPage" filter="#page.id#_*";
		
		staticPath = "#staticPath#\#qStaticPage.name#";
		staticPathFull = expandPath(staticPath);
	}

	if (FileExists(staticPathFull)) 
	{
		// Load Static Page
		contentFor(staticPage = true);
		include template="#staticPath#";
	} 
	else 
	{
		// Load DB Page
		pageTemplate = 
			page.containsKey("template") AND page.template.trim().length() ?
				getThemeTemplate(page.template) :
					getThemeTemplate("page-single");
					
		page.content = processShortcodes(page.content);
		
		if(len(pageTemplate)) 
		{
			pagetitle = capitalize(page.name);
			subtitle = page.containsKey("subname") ? capitalize(page.subname) : "";
			pagecontent = page.content;
			include template="#pageTemplate#";
		} 
		else 
		{
			writeOutput('
				<h1>#capitalize(page.name)#</h1>        
				<br class="clear">
				#facebookLikeButton()#	
				#page.content#
			');
		}
	}   
 </cfscript> 