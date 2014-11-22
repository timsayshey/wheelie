<cfscript>
	request.page.hideSidebar = true;
	request.page.noBgImage = true;
	request.video.hideSidebar = true;
	request.video.hideFooterCallToAction = true;
	if(isSingleCategory)
	{
		contentFor(siteTitle = "#qCategoryOfVideos.name# | #getOption(qOptions,'seo_videos_title').label#");
		contentFor(siteDescription = qCategoryOfVideos.description);
	}
	else
	{
		contentFor(siteTitle = "Videos | #getOption(qOptions,'seo_videos_title').label#");
		contentFor(siteDescription = videoCategory.description);
	}
</cfscript>

<style type="text/css">
	.boxtitle {
		white-space:normal;
		overflow:auto;	
	}
	.listbox {
		font-size:12px;	
	}
	.listbox a {
		font-size:15px;	
	}
	.limit-height {
		height:70px;
		overflow:hidden;
	}
</style>

<cfif !isSingleCategory>
	<h1>Browse videos by topic</h1>
	<cfif request.site.id eq 1>
		<br class="clear"><br>
	</cfif>
	Explore the most recently updated topics below.<br><br>
</cfif>

<cfif isNull(qCategoryOfVideos)>
	<h1>Sorry, couldn't find that category. Please try again.</h1>
<cfelse>
	
	<cfoutput query="qCategoryOfVideos" group="videocategoryid">
		
		<!--- Get category video count --->
		<cfset currCatVidCnt = 0>
		<cfoutput group="videoid">
			<cfset currCatVidCnt++>
		</cfoutput>
		
		<!--- Output category header --->
		<cfif !isSingleCategory>			
			<div class="row">
				<div class="col-md-9"><h2>#name#</h2></div>	
				<cfif currCatVidCnt GT videoLimitPerCategory>
					<div class="col-md-3 text-right"><a href="#urlfor(route='public~videos',action='category',id=urlid)#">View all #currCatVidCnt# videos</a></div>
				</cfif>			
			</div><br>			
		<cfelse>
			<h1>#name#</h1>
			<cfif request.site.id eq 1>
				<br class="clear"><br>
			</cfif>
			#description#<br><hr>
		</cfif>
		
		<!--- Output category videos --->
		<cfset currCatVideoArray = []>
		<cfoutput group="videoid">
			<cfset ArrayAppend(currCatVideoArray,{
				sortorder = videosortorder,
				videoid	  = videoid,
				videourlid= videourlid,
				videoname =	videoname
			})>
		</cfoutput>
		<cfset currCatVideoArray = arrayOfStructsSort(currCatVideoArray,"sortorder")>
				
		<cfset currentVideoCnt = 1>
		<cfloop array="#currCatVideoArray#" index="video">
			<cfif currentVideoCnt LTE videoLimitPerCategory>			
				<div class="listbox col-sm-3" rel="#video.videoid#">
					<cfset thumbPath = "#info.videoThumbPath##video.videoid#.jpg">
					<cfif len(thumbPath) AND fileExists(expandPath(thumbPath))>									
						<a href='#urlFor(route="public~videos",action="video",id=video.videourlid)#' class="filethumb roundy" style="background-image:url('#thumbPath#'); display:block;">
							<img src="/assets/img/videooverlay-lg.png"><br class="clear">
						</a>
					</cfif>					
					<a href='#urlFor(route="public~videos",action="video",id=video.videourlid)#' class="boxtitle limit-height truncate-2">#video.videoname#</a><br class="clear" />															
				</div>
				<cfset currentVideoCnt++>
			</cfif>
		</cfloop>
		<br class="clear"><hr>
	</cfoutput>

</cfif>
		
