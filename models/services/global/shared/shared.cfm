<cfoutput>

<cffunction name="spamChecker">
	<cfargument name="formStruct">
	<cfscript>
		var formFields = StructKeyList(formStruct);
		for (i=1; i lte listLen(formFields); i++) 
		{ 
			FieldName = ListGetAt(formFields, i);								
			FieldValue = formStruct[FieldName];			
			var keywords = [
				"free trial",
				"visitors",
				"<a href",
				" SEO ",
				"|",
				"http",
				"vuitton"
			];
			for (j = 1; j LTE arrayLen(keywords); j++)
			{			
				if(find(lcase(keywords[j]),lcase(FieldValue)))
				{
					return true;
				}
			}			
		}
		return false;
	</cfscript>	
</cffunction>

<cffunction name="checkUrlExtension">
	<cfargument name="checkUrl" default="">
	<cfif !isNull(params.format) AND (len(trim(request.site.urlExtension)) AND params.format neq request.site.urlExtension)>
		<cfheader statuscode="301" statustext="Moved Permanently">
		<cfheader name="Location" value="#arguments.checkUrl#.#request.site.urlExtension#">
		<cfabort>
	<cfelseif !isNull(params.format) AND len(params.format) AND !len(trim(request.site.urlExtension))>
		<cfheader statuscode="301" statustext="Moved Permanently">
		<cfheader name="Location" value="#arguments.checkUrl#">
		<cfabort>
	</cfif>
</cffunction>

<cffunction name="facebookLikeButton">
	<cfargument name="facebookid" default="#application.wheels.facebookid#">
	<cfargument name="style" default="width:100px; height:20px; display:inline-block; margin-right:10px; margin-top:5px;">
	<cfif request.site.id eq 1>
		<cfreturn '<iframe src="//www.facebook.com/plugins/like.php?locale=en_US&amp;send=false&amp;layout=button_count&amp;colorscheme=light&amp;href=https%3A%2F%2Fwww.facebook.com%2Fpages%2F#arguments.facebookid#" scrolling="no" frameborder="0" allowtransparency="true" class="fb-like-widget" style="#arguments.style#"></iframe><br>'>
	<cfelseif request.site.id eq 2>
		<cfreturn '<br>'>
	</cfif>
</cffunction>

<cffunction name="getResumeUrl">
	<cfargument name="appId">
	<cfscript>
		resumeFilename = "";
		resumeDirectory = "/assets/uploads/resumes/";
		resumeFilenameWithoutExtension = "resume_#appId#";
		resumeFilepathWithoutExtension = "#ExpandPath(resumeDirectory)##resumeFilenameWithoutExtension#";
		if(fileExists("#resumeFilepathWithoutExtension#.pdf")) {
			return "#resumeDirectory##resumeFilenameWithoutExtension#.pdf";
			
		} else if(fileExists("#resumeFilepathWithoutExtension#.doc")) {
			return "#resumeDirectory##resumeFilenameWithoutExtension#.doc";
			
		} else if(fileExists("#resumeFilepathWithoutExtension#.docx")) {
			return "#resumeDirectory##resumeFilenameWithoutExtension#.docx";
		}		
		return "";
	</cfscript>	
</cffunction>

<cffunction name="isValidEmail">
	<cfargument name="inputEmail">
	<cfscript>
		if(countOccurences(inputEmail,"@") eq 1)
		{
			return true;
		}
		else
		{
			return false;
		}		
	</cfscript>	
</cffunction>

<cffunction name="countOccurences">
	<cfargument name="string">
	<cfargument name="substring">
	<cfreturn (Len(string) - Len(Replace(string,substring,'','all'))) / Len(substring)>
</cffunction>

<cffunction name="arrayRemoveEmpty" access="public" returntype="array">
	<cfargument name="theArray" required="true" type="array" />
	<cfset newArray = []>
	<cfloop array="theArray" index="arrayValue">
		<cfif len(trim(arrayValue))>
			<cfset ArrayAppend(newArray,arrayValue)>
		</cfif>
	</cfloop>
	
	<cfreturn newArray />
</cffunction>

<cffunction name="randomizeQuery">
	<cfargument name="inputquery">
	<cfif !isNull(arguments.inputquery)>
		<cfquery name="qry_set" dbtype="query">
			SELECT *, '' as sorter FROM #arguments.inputquery#
		</cfquery>
		
		<cfloop query="qry_set">
			<cfset querySetCell(qry_set,"sorter",rand(),currentRow)>
		</cfloop>
		
		<cfquery name="qry_set" dbtype="query">
			select * from qry_set
			order by sorter
		</cfquery>
		
		<cfreturn qry_set>
	</cfif>
</cffunction>

<cffunction name="getSiteId">
	<cfscript>
		if(isNull(request.site.id))
		{
			setSiteInfo();
		}
		return request.site.id;
	</cfscript>
</cffunction>

<cffunction name="datamgrInit">
	<cfscript>
		if (!structKeyExists(application, 'db')) 
		{
			application.db = CreateObject("component","models.services.vendor.datamgr.DataMgr").init(application.wheels.dataSourceName);		
		}
		db = application.db;
	</cfscript>	
</cffunction>
 
<cffunction name="siteQuery">
	<cfargument name="urlid" required="yes">
	<cfquery name="qSiteData" datasource="#application.wheels.dataSourceName#">
		SELECT * FROM sites
		WHERE urlid = '#arguments.urlid#' AND deletedAt IS NULL
	</cfquery>
	<cfreturn qSiteData>
</cffunction>

<cffunction name="setSiteInfo">
	<cfscript>
		var loc = {};
		
		if(isNull(request.site.id))
		{
			loc.domain = cgi.http_host;			
			if(listlen(loc.domain,".") GT 2)
			{
				loc.subdomain = ListGetAt(loc.domain,listlen(loc.domain,".") - 2,".");
				loc.domainName = ListGetAt(loc.domain,listlen(loc.domain,".") - 1,"."); // domain
				loc.domainExt  = ListGetAt(loc.domain,listlen(loc.domain,"."),"."); // .com
				if(loc.subdomain eq "www" OR loc.subdomain eq "beta" OR loc.subdomain eq "secure")
				{
					loc.domain = loc.domainName & "." & loc.domainExt;	
				} else {
					loc.domain = loc.subdomain & "." & loc.domainName & "." & loc.domainExt;
					loc.domainName = loc.subdomain & "." & ListGetAt(loc.domain,listlen(loc.domain,".") - 1,"."); // domain
				}
			}
			
			if(isNull(db)) { datamgrInit(); }			
			
			loc.siteResult = siteQuery(urlid=loc.domain);
			//writeDump(loc.siteResult); abort;
			//loc.siteResult = model("site").findAll(where="urlid = '#loc.domain#'");	
			if(loc.siteResult.recordcount)
			{
				request.site = 
				{
					id 				= loc.siteResult.id,
					name 			= loc.siteResult.name,
					domain 			= loc.siteResult.urlid,
					urlid 			= loc.siteResult.urlid,
					ssl 			= loc.siteResult.sslenabled,
					theme 			= loc.siteResult.theme,
					urlExtension 	= loc.siteResult.urlExtension,
					emailMatchDomainRequired = loc.siteResult.emailMatchDomainRequired,
					emailMatchOtherDomains   = loc.siteResult.emailMatchOtherDomains,
					registrationDisabled 	 = loc.siteResult.registrationDisabled
				};
			}
			else 
			{
				writeOutput("Sorry, this site is currently unavailable."); abort;
			}
		}
	</cfscript>
</cffunction>

<cffunction name="getDepartmentEmails">
	<cfargument name="currentDepartment" default="">
	<cfswitch expression="#arguments.currentDepartment#">
		<cfcase value="Residential Coach,Night Staff,Residential Coach - Night Shift">
			<cfreturn { 
				emailTo = jobEmails.coaches.sendTo,
				emailCC = jobEmails.coaches.sendCC
			}>
		</cfcase>
		<cfcase value="Therapist">
			<cfreturn { 
				emailTo = jobEmails.therapist.sendTo,
				emailCC = jobEmails.therapist.sendCC
			}>
		</cfcase>
		<cfcase value="Clerical,Junior IT Technician,Human Resources Director">
			<cfreturn { 
				emailTo = jobEmails.hr.sendTo,
				emailCC = jobEmails.hr.sendCC
			}>
		</cfcase>
		<cfcase value="Director of Nursing,Registered Nurse">
			<cfreturn { 
				emailTo = jobEmails.nurse.sendTo,
				emailCC = jobEmails.nurse.sendCC
			}>
		</cfcase>
		<cfdefaultcase>
			<cfreturn { 
				emailTo = jobEmails.other.sendTo,
				emailCC = jobEmails.other.sendCC
			}>
		</cfdefaultcase>
	</cfswitch>
</cffunction>

<cffunction name="isMobile">
	<cfif reFindNoCase("(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino",CGI.HTTP_USER_AGENT) GT 0 OR reFindNoCase("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-",Left(CGI.HTTP_USER_AGENT,4)) GT 0>
		<cfreturn true>
	<cfelse>
		<cfreturn false>
	</cfif>
</cffunction>.

<cffunction name="getIpAddress">
	<cfreturn len(trim(cgi.HTTP_CF_CONNECTING_IP)) ? cgi.HTTP_CF_CONNECTING_IP : cgi.REMOTE_ADDR>
</cffunction>

<cffunction name="menuitemLink">
	<cfargument name="activeClass" default="active current">
	<cfset isActive = "">
	<cfif 
		menuitem.id eq activeMenuId OR 
		!isNull(activeParent) AND menuitem.id eq activeMenuId OR 
		!isNull(subParentId) AND menuitem.id eq subParentId>
			<cfset isActive = arguments.activeClass>
	</cfif>	
	<cfif menuitem.itemType eq "page">
		<cfif len(trim(request.site.urlExtension))>
			<cfset menuitemurl = urlFor(route="public~secondaryPage", format=request.site.urlExtension, id=menuitem.urlid)>
		<cfelse>
			<cfset menuitemurl = urlFor(route="public~secondaryPage", id=menuitem.urlid)>
		</cfif>
		<a href='#len(trim(menuitem.redirect)) GT 1 ? menuitem.redirect : menuitemurl#'
			class="#isActive#">								
			#menuitem.name#
		</a>
	<cfelseif menuitem.itemType eq "custom">
		<a href='#menuitem.customurl#' class="#isActive#">								
			#menuitem.name#
		</a>
	</cfif>	
</cffunction>

<cffunction name="generateMenu">
	<cfargument name="includeChildren" default="true">
	<cfloop query="menuitems">
		<cfset menuitem = menuitems>		
		<li>
			#menuitemLink()#		
			<cfif includeChildren>
				<cfset children = model("Menu").findAll(where="parentid LIKE '#menuitems.id#'", order="sortOrder ASC, name ASC", include="AllPost")>
				<cfif children.recordcount>
					<ul>
					<cfloop query="children">
						<cfset menuitem = children>
						<li>#menuitemLink()#</li>
					</cfloop>
					</ul>
				</cfif>	
			</cfif>
		</li>			
	</cfloop>		
</cffunction>

<cffunction name="generateSubmenu">	
	<ul>		
		<cfset generatingSubmenu = true>
		<cfif activeMenuItem.parentid eq 0>
			<cfset menuitem = activeMenuItem>
			<cfset currentclass = "current">
		<cfelseif len(activeParent.urlid)>
			<cfset menuitem = activeParent>
			<cfset currentclass = "">
		</cfif>	
		
		<li>#menuitemLink(activeClass=currentclass)#</li>
		
		<cfloop query="subMenuItems">
			<cfset menuitem = subMenuItems>
			<li>#menuitemLink()#</li>
		</cfloop>
	</ul>	
</cffunction>

<cffunction name="log404">
	<cfscript> 
		try {
			// DB
			newErrorPath = "#cgi.path_info##len(cgi.query_string) ? "?" : ""##cgi.query_string#";
			getError = model("NotFound").findAll(where="urlPath LIKE '#newErrorPath#'");
			if(!getError.recordcount)
			{
				notFound = model("NotFound").new(urlPath=newErrorPath, referrer=cgi.http_referrer);
				notFound = notFound.save();
			}
		} catch(e) {
		}		
	</cfscript>
</cffunction>

<cffunction name="mailgun">
	<cfargument name="mailTo" default="">
	<cfargument name="from" default="">
	<cfargument name="reply" default="">
	<cfargument name="bcc" default="#application.wheels.adminEmail#">
	<cfargument name="cc" default="">
	<cfargument name="subject" default="">
	<cfargument name="apiKey" default="xyz">
	<cfargument name="html" default=""> 
	<cfargument name="txt" default="">
		
	<!--- Try postmark
	<cfset pmCode = CreateObject("component","com.PostMarkAPI").sendMail(
		mailTo		= arguments.mailTo,
		mailFrom 	= arguments.From,
		mailReply 	= arguments.Reply,
		mailBcc 	= arguments.Bcc,
		mailSubject = arguments.Subject,            
		apiKey 		= arguments.apiKey,
		mailHTML 	= arguments.HTML,
		mailTxt 	= arguments.Txt
	)>
	
	<!--- If postmark fails --->
	<cfif !Find("200",pmCode)>
	
		<cfmail        
			type="html"
			from="error@churchinviter.org"  
			to="timsayshey@gmail.com"      
			subject="CI Postmark Error">        
			Code Length: #len(pmCode)# - Code: #pmCode#<br><br>
			
			<cfif isDefined("form")>
				<cfdump var="#form#"><br>                    
			</cfif>
			
			<cfif isDefined("cgi")>
				<cfdump var="#cgi#">                  
			</cfif>        
		</cfmail>
		
		<cfmail        
			type="html"
			from="Church Inviter <evite@churchinviter.org>" 
			replyto="#arguments.Reply#" 
			to="#arguments.mailTo#" 
			bcc="#arguments.Bcc#"        
			subject="#arguments.Subject#">   
				 
			#arguments.HTML#
			
		</cfmail>
	</cfif> --->
	
	<cfmail        
		type="html"
		from="#arguments.from#" 
		replyto="#arguments.reply#" 
		to="#arguments.mailTo#" 
		bcc="#arguments.bcc#" 
		cc="#arguments.cc#"        
		subject="[#request.site.domain#] #arguments.subject#">   
			 
		#arguments.html#
		
	</cfmail>
</cffunction>

</cfoutput>