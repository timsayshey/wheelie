<cfoutput>

	<script src="/views/layouts/admin/assets/js/page.js" type="text/javascript"></script>
	
	<cfset contentFor(plupload		= true)>
	<cfset contentFor(formy			= true)>
	
	<cfif isNull(params.id)>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-file-new"></span> Add Page')>
	<cfelse>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-file-new"></span> Edit Page')>
	</cfif>
	
	<cfif !isNull(params.id)>
		<cfset isNew = false>
		<cfset currentStatus = page.status>
	<cfelse>
		<cfset isNew = true>
		<cfset currentStatus = "draft">
	</cfif>
	
	<cfif !isNew>
		#hiddenfield(objectName='page', property='id', id="pageid")#
		#hiddenFieldTag("id",params.id)#
	</cfif>			
													
	<!--- Title --->	
	#btextfield(
		objectName	= 'page', 
		property	= 'sysname', 
		label		= 'System Label',
		placeholder	= "Ex: Homepage",
		help		= 'For internal system reference'
	)#

	<!--- Title --->	
	#btextfield(
		objectName	= 'page', 
		property	= 'name', 
		label		= 'Title',
		placeholder	= "Ex: Welcome to our Website",
		help		= 'Main title that shows at the top of the page'
	)#

	<!--- Title --->	
	#btextfield(
		objectName	= 'page', 
		property	= 'subname', 
		label		= 'Sub-Title',
		placeholder	= "Ex: You really are welcome",
		help		= 'Title that shows under the main title'
	)#
	
	<!--- Password
	#btextfield(
		objectName	= 'page', 
		property	= 'password', 
		label		= 'Password',
		placeholder	= "Ex: Password"
	)# --->	
	
	<!--- Page URL 
		,disabled = !isNew
	--->	
	#btextfield(
		prependedText	= '#cgi.HTTP_HOST#/', 
		label			= "Permalink",
		objectName		= 'page', 
		property		= 'urlid', 												
		placeholder	 	= "Coolest-Page-Ever",
		help 			= "This page's permalink"
	)#	

	#btextfield(
		prependedText	= '#cgi.HTTP_HOST#/', 
		label			= "Quote Permalink",
		objectName		= 'page', 
		property		= 'quoteUrlId', 												
		placeholder	 	= "quote",
		help 			= "This page's quote form permalink"
	)#	

	<!--- Description --->
	#btextarea(
		objectName 		= 'page', 
		property 		= 'content', 	
		class			= "ckeditor",
		label 		 	= "Content",
		help 			= "Shows on the page"
	)#	

	<a href="javascript:void(0)" class="btn btn-default btn-large" data-html="true" data-toggle="popover" title="Shortcodes" data-content='
		[bootwrap class="row"][/bootwrap]<br>
		[bootgrid cols="12" colsize="md"][/bootgrid]<br>		
		[formly formid="11"]<br>
		<sup>Pro tip: Switch to Source view and wrap shortcodes with &prec;safe&succ;&prec;/safe&succ;</sup>
	'>Shortcodes</a>
	<br class="clear"><br>

	<script>
	$(function() {
		$('[data-toggle="popover"]').popover();
	});
	</script>

	<cfscript>
		templates = [];
		templateFiles = DirectoryList(path='#info.fileroot#/views/themes/#request.site.theme#/pagetemplates/');		

		ArraySort(templateFiles, "textnocase", "asc");

		for(templateFile in templateFiles) {
			templateFile = replaceNoCase(listLast(templateFile,"/"),".cfm","","ALL");
			arrayAppend(templates,{ text = templateFile, value = templateFile });
		}	
	</cfscript>

	#bselecttag(
		name	 = 'page[template]',
		label	 = 'Template',
		options	 = templates,
		selected = page.template,
		class	 = "selectize",
		append	 = ""
	)#

	<cfparam name="page.featuredImg" default="">
	#bImageUploadTag(
		name			= "featuredImg",
		value			= "", 	
		filepath		= "/assets/images/featured/feat-#page.id#.jpg",
		label			= 'Hero Template Image (JPG Only)'
	)#

	#bselect(
		objectName	= 'page', 
		property	= 'footerPageBlockId', 
		label		= 'Hero Footer Page Block',
		options		= pageBlockOptions
	)#
	
	#includePartial(partial="/_partials/formSeperator")#	
	
	<!--- Generate SEO Automatically --->
	<cfif isNew>
		<cfset page.metagenerated = 1>
	</cfif>
								
	#bcheckbox(
		objectName	= 'page', 
		property	= 'metagenerated', 
		label		= 'Auto generate meta',
		help		= 'Automatically generate meta tags for seo. Better meta means better search engine ranks.',
		id			= 'metagenerated'
	)#	
	
	<div id="metaOptions">		
						
		#bLabel(label="Homepage options",help="Set various aspects of homepage here")#
		<br class="clear" />
		
		#btextfield(
			label			= 'Title',
			objectName		= 'page', 
			property		= 'metatitle',
			placeholder		= 'Meta title'
		)#	
		#btextfield(
			label			= 'Description',
			objectName		= 'page', 
			property		= 'metadescription',
			placeholder		= 'Meta description'
		)#	
		#btextfield(
			label			= 'Keywords',
			objectName		= 'page', 
			property		= 'metakeywords',
			placeholder		= 'Meta keywords'
		)#	
		<br />
	</div>
	
	<br class="clear" />
	
	<!--- Homepage Options --->									
	<cfif currentPageIsHome>			
		#bcheckboxtag(
			name		= "isHome",
			value		= 1,
			id			= "isHomeCheckbox",
			checked		= true,
			disabled	= true,
			label		= "Set as homepage?",
			help		= "Can't be disabled. Set a different page as the homepage to disable this one."
		)#	
		#checkboxtag(
			name		= "isHome",
			value		= 1,
			checked		= true,
			style		= "display:none"
		)#
	<cfelse>								
		#bcheckboxtag(
			name		= "isHome",
			value		= 1,
			label		= "Set as hompage?",
			id			= "isHomeCheckbox",
			help		= "Check the box below to set this page as the homepage."
		)#							
	</cfif>
	
	<div id="homeOptions">							
		#bLabel(label="Homepage options",help="Set various aspects of homepage here")#
		<br class="clear" />
		
		#includePartial(partial="/_partials/bulkOptionsForm",qOptions=homeOptions)#								
	</div>
	
	<br class="clear" />
	
	<cfsavecontent variable="rightColumn">
		<div class="rightbarinner">			
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="pages", currentStatus=currentStatus)#				
		</div>
		</div>
		<div class="rightBottomBox  hidden-xs hidden-sm">
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="pages", currentStatus=currentStatus, rightBottomClass="col-sm-3")#	
		</div>
	</cfsavecontent>
	<cfset contentFor(rightColumn = rightColumn)>
	<cfset contentFor(formWrapStart = startFormTag(route="admin~Action", module="admin", controller="pages", action="save", enctype="multipart/form-data", id = "fileupload"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>	
	
</cfoutput>