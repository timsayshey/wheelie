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
    
    	<cfif !isNull(params.pageblockids)>
            <cfloop list="#params.pageblockids#" index="pageblockid">
                <cfscript>
					pageblockContent = params['pageblock_#pageblockid#'];
					pageblock = model("PageBlock").findByKey(pageblockid);
					saveResult = pageblock.update(content = pageblockContent);
					writeDump(pageblock.name & ": " & saveResult);
				</cfscript>
            </cfloop>
            <cfabort>
        </cfif>
               
        <cfset qPageBlocks = model("pageblock").findAll()>
        
        #startFormTag(route="admin~Action", module="admin", controller="pageblocks", action="bulkedit")#
        	
            <cfset pageblockids = "">
            <cfloop query="qPageBlocks">
                <cfif !find('team',lcase(qPageBlocks.name))>
					#btextareatag(
						name 		= 'pageblock_#qPageBlocks.id#',	
						class		= "ckeditor2",
						label 		= "#qPageBlocks.name# Content",
						content		= qPageBlocks.content,
						style		= "width:100%;display:block;"
					)#	
					<cfset pageblockids = ListAppend(pageblockids,qPageBlocks.id)>
				</cfif>
            </cfloop>
            
            <br><br>
            
            <input type="hidden" name="pageblockIds" value="#pageblockids#">
            <button type="submit" name="submit" value="Submit" class="btn btn-primary">Submit</button>
        
        #endFormTag()#
        
    </cfoutput>
    <cfcatch><cfdump var="#cfcatch#" abort></cfcatch>
</cftry>