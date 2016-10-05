<cfoutput>
       
		<cfset contentFor(siteTitle = "#capitalize(userTag.name)# Team - #getOption(qOptions,'seo_subpage_title').label#")>
		<cfset contentFor(siteDesc = getOption(qOptions,'seo_subpage_description').label)>
		<cfset contentFor(siteKeywords = getOption(qOptions,'seo_subpage_keywords').label)>
		
		<cfset checkUrlExtension(checkUrl="/team/#userTag.urlid#")>
        
        <cfset pageTemplate = getThemeTemplate("users-single")>
		
		<cfif len(pageTemplate)>
			<cfinclude template="#pageTemplate#">
		<cfelse>
		    <section class="page-wrapper"> 
            <article class="page-content-full">
			<cfif IsStruct(users)>
                <h1>#users.name#</h1>
                #users.content#
            <cfelse>
                <h1>#userTag.name# Team</h1>
                <br class="clear"><br>
                
                <cfif len(trim(userTag.description))>                    
                    #userTag.description#<br><br>
                </cfif>
                
                <cfloop query="users">
                                
                    <div class="row">                	
                        <div class="col-sm-10"> 
                            <h2>
                                <cfif users.fullLastname eq 1>
                                    <cfset userLastname = users.zx_lastname>
                                <cfelseif len(users.zx_lastname)>
                                    <cfset userLastname = left(users.zx_lastname,1) & ".">
                                <cfelse>
                                    <cfset userLastname = "">
                                </cfif>
                                #users.zx_firstname# #userLastname#<cfif len(trim(users.zx_designatory_letters))>, #users.zx_designatory_letters#</cfif>
                                <cfif len(trim(users.zx_jobtitle))>
                                    <span>#users.zx_jobtitle#</span>
                                </cfif>
                            </h2>
                            <div class="trunkToggle">
                                 #users.zx_about# 
                            </div>
                        </div>
                        <div class="col-sm-2">
                            <cfset imagePath = ExpandPath("/assets/userpics/#users.id#.jpg")>                
                            <cfif FileExists(imagePath)> 
                                <img src="/assets/userpics/#users.id#.jpg" style="border:4px solid ##fff; margin-top:40px;" class="img-responsive" />
                            </cfif>
                        </div>  
                    </div> 
                    <br class="clear"><br>
                    
                </cfloop>
                    
            </cfif>
            </article>
            </section>
        </cfif>	
        
</cfoutput>