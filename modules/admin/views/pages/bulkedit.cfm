<cftry>
	<cfoutput>
    
    	<script>
			$(function () {
				$("textarea").each(function () {
					this.style.height = (this.scrollHeight-10)+'px';
				});
				$('textarea').keyup(function () {
					autoresize(this);
				});
			});
			function autoresize(textarea) {
				textarea.style.height = '0px';     //Reset height, so that it not only grows but also shrinks
				textarea.style.height = (textarea.scrollHeight-10) + 'px';    //Set new height
			}
		</script> 
        <style type="text/css">
			textarea {
								
			}
		</style>
    
    	<cfif !isNull(params.pageids)>
            <cfloop list="#params.pageids#" index="pageid">
                <cfscript>
					pageContent = params['page_#pageid#'];
					page = model("Page").findByKey(pageid);
					saveResult = page.update(content = pageContent);
					writeDump(page.name & ": " & saveResult);
				</cfscript>
            </cfloop>
            <cfabort>
        </cfif>
               
        <cfset qPages = model("page").findAll()>
        
        #startFormTag(route="admin~Action", module="admin", controller="pages", action="bulkedit")#
        	
            <cfset pageids = "">
            <cfloop query="qPages">
                <cfif !find('team',lcase(qPages.name))>
					#btextareatag(
						name 		= 'page_#qPages.id#',	
						class		= "ckeditor2",
						label 		= "#qPages.name# Content",
						content		= qPages.content,
						style		= "width:100%;display:block;"
					)#	
					<cfset pageids = ListAppend(pageids,qPages.id)>
				</cfif>
            </cfloop>
            
            <br><br>
            
            <input type="hidden" name="pageIds" value="#pageids#">
            <button type="submit" name="submit" value="Submit" class="btn btn-primary">Submit</button>
        
        #endFormTag()#
        
    </cfoutput>
    <cfcatch><cfdump var="#cfcatch#" abort></cfcatch>
</cftry>