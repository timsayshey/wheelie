<cfoutput>

	<div class="blog-post">
    <cfset currentPageUrl = "http://#request.site.domain##cgi.PATH_INFO#">
    
    <cfset isNotFound = isStruct(post)>
    
    <cfif isNotFound>
    
    	<cfheader statuscode="301" statustext="Moved Permanently">
		<cfheader name="Location" value="/blog">
        <cfset log404()>
		<cfabort>
        
	<cfelseif !isNull(post.quoteImg)>
    
		<cfif len(post.redirect)>
			<cflocation addtoken="no" url="#post.redirect#">
		</cfif>
        
		<cfset checkUrlExtension(checkUrl="/blog/post/#post.urlid#")>
        
		<cfset contentFor(quoteImg = post.quoteImg)>
		<cfset contentFor(youtubeId = post.youtubeId)>
		<cfset contentFor(sideContent = post.sideContent)>
		<cfset contentFor(siteTitle = "#capitalize(post.name)# - #getOption(qOptions,'seo_blog_title').label#")>
		<cfset contentFor(quoteImg = post.quoteImg)>		
		<cfset contentFor(siteDesc = post.metadescription)>		
		<cfset contentFor(siteKeywords = post.metakeywords)>
        
	<cfelseif !isNull(params.format) AND !isNull(params.id) AND ListFind("jpg,pdf,mp3",lcase(params.format))>
    
		<cfheader statuscode="301" statustext="Moved Permanently">
		<cfheader name="Location" value="/assets/site/#params.id#.#params.format#">
		<cfabort>
        
	<cfelse>
    
		<cfheader statusCode="404" statusText="Not Found">
		<cfset log404()>
        
	</cfif>
	
    <cfset staticPath = "/views/static/#request.site.urlid#/#params.id#.cfm">
    <cfset staticPathFull = expandPath(staticPath)>
    
    <cfif FileExists(staticPathFull)>
    	<cfset contentFor(staticpost = true)>
    	<cfmodule template="#staticPath#">

    <cfelseif post.containsKey("template") AND post.template.trim().length()>
		<cfset postTemplate = getThemeTemplate(post.template)>
		<cfset pagetitle = capitalize(post.name)>
		<cfset pagecontent = post.content>
		<cfinclude template="#postTemplate#">

    <cfelse> 
    	<cfset blogTemplate = getThemeTemplate("blog-single")>
		<cfset post.content = processShortcodes(post.content)>
		
		<cfif len(blogTemplate)>
			<cfset pagetitle = capitalize(post.name)>
			<cfset pagecontent = post.content>
			<cfinclude template="#blogTemplate#">
		<cfelse>
			
			<h1>#capitalize(post.name)#</h1>
			<cfif request.site.id eq 1>
			<br class="clear"><br>
			</cfif>
			
			<cfif post.fullLastname eq 1>
				<cfset userLastname = post.zx_lastname>
			<cfelseif len(post.zx_lastname)>
				<cfset userLastname = left(post.zx_lastname,1) & ".">
			<cfelse>
				<cfset userLastname = "">
			</cfif>
			
			By <a href='##viewProfile'>#post.zx_firstname# #userLastname#</a> | Added #DateFormat(post.createdAt,"MMMM D")#
			#facebookLikeButton(style="width:100px; height:20px; display:inline-block; margin-left:10px;")#
			
			<cfif request.site.id neq 1>
			<br>
			</cfif>
			
			<br> 
			<cfset showSocial = 1>
			
			#post.content#  
			
			<cfif isNull(showSocial)>
				<br><br>
			<cfelse>
				<cfset endodedDomain = URLEncodedFormat('http://#request.site.domain#')>
				<cfset encodedUrl = URLEncodedFormat(currentPageUrl)>
				<div>
				#facebookLikeButton()#
				
				</div>
				<br><br>              
			</cfif>
			
			<div class="profileBox" id="viewProfile">
				<h2>About the Author</h2>
				<div class="row">                	
					<div class="col-xs-10">
						<h3> 
							#post.zx_firstname# #userLastname#<cfif len(trim(post.zx_designatory_letters))>, #post.zx_designatory_letters#</cfif>
							<cfif len(trim(post.zx_jobtitle))>
								<span>#post.zx_jobtitle#</span>
							</cfif>
						</h3>
						<div class="trunkToggle">
						<cfif post.showOnSite>
							 #post.zx_about# 
						</cfif>
						</div>
					</div>
					<div class="col-xs-2">
						<cfset imagePath = ExpandPath("/assets/userpics/#post.userid#.jpg")>                
						<cfif FileExists(imagePath)> 
							<img src="/assets/userpics/#post.userid#.jpg" style="border:4px solid ##fff;" class="img-responsive" />
						</cfif>
					</div>  
				</div>        
			</div> 
        </cfif>	
    </cfif>    
    </div>
</cfoutput>