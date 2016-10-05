<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();				
		filters(through="setCache");		
	}
	
	function setCache()
	{		
		caches(actions="page,geolanding,index", time=300);
	} 

	function shared() {
		footerPageBlock = '';
		if(!isNull(page.footerPageBlockId) && len(page.footerPageBlockId) && isNumeric(page.footerPageBlockId)) {
			footerPageBlock = model("PageBlock").findAll(where="id = '#page.footerPageBlockId#'");
			footerPageBlock = footerPageBlock.content;			
		}
	}
	
	function index()
	{
		page = model("Page").findAll(where="#whereSiteid()# AND id = '#homeid#'");
		shared();
		if(!page.recordcount) 
		{
			writeOutput("No homepage has been set. Please try again.");abort;
		}
		editBtn = { controllerName = "pages", currentId = page.id };
		home = true; 
	} 

	function page()
	{	
		footerPageBlock = '';

		urlId = RemoveChars(cgi.path_info,1,1);
		if(listLen(urlId,".") GTE 2) {
			urlId = listDeleteAt(urlId,listLen(urlId,"."),".");
		}
		
		if(isDefined("params.id")) 
		{
			// Queries
			page = model("Page").findAll(where="#whereSiteid()# AND urlid = '#urlId#'");
			if(!page.recordcount) {
				page = model("Page").findAll(where="#whereSiteid()# AND urlid = '#params.id#'");			
			}

			if(len(trim(page.quoteUrlId))) {
				quoteformurl = page.quoteUrlId;
			}

			shared();			

			editBtn = { controllerName = "pages", currentId = page.id };
			
			if(!isNull(page.template) AND page.template eq "letter")
			{
				usesLayout("/layouts/layout.letter");		
			}
					
			if(page.postType eq "post")
			{
				location("/blog/post/#params.id#", false, 301);
			}
		}
		
		if(isNull(page) OR !len(page.id))
		{
			page = {
				name = "Page not found",
				content = "We apologize for the inconvenience. Please try clicking the menu above to find the page you are looking for."
			};
		}
	}

	function geolanding()
	{
		gStateAbbr = "unknown";
		gState = "unknown";
		gCity = "unknown";
		
		if(!isNull(params.state))
		{
			gState = lcase(replace(params.state,"-"," ","ALL"));
			gState = rereplace(gState,"\b(\w)","\u\1","all");
			
			if(len(ListLast(gState," ")) eq 2 AND ListLen(gState," ") GTE 2)
			{
				gStateAbbr = UCase(ListLast(gState," "));
				gState = ListDeleteAt(gState,ListLen(gState," ")," ");
			}
			else if(len(trim(gState)) eq 2)
			{
				gState = UCase(gState);
				gStateAbbr = gState;
			}
		}
		
		if(!isNull(params.city))
		{
			gCity = lcase(replace(params.city,"-"," ","ALL"));
			gCity = rereplace(gCity,"\b(\w)","\u\1","all");
		}
		
		// Try
		landingPage = model("geolanding").findOne(where="city LIKE '#gCity#' AND (state_acronym LIKE '#gStateAbbr#' OR state LIKE '#gState#')", returnAs="query", order="type DESC");
		
		// Try		
		if(!landingPage.recordcount) 
		{
			landingPage = model("geolanding").findOne(where="city LIKE '#gCity#' OR state_acronym LIKE '#gStateAbbr#' OR state LIKE '#gState#'", returnAs="query", order="type DESC");
		}
		
		if(landingPage.recordcount) 
		{
			stateUrl = "#replace(landingPage.state," ","-","ALL")#-#landingPage.state_acronym#";
			cityUrl = replace(landingPage.city," ","-","ALL");
			if(len(landingPage.city))
			{
				locationname = "#landingPage.city#, #landingPage.state#";
				geoUrl = urlFor(route="public~geolanding",state=stateUrl,city=cityUrl);
			}
			else
			{
				locationname = "#landingPage.state#";
				geoUrl = urlFor(route="public~geolandingState",state=stateUrl);
			}
			if(geoUrl neq cgi.path_info)
			{
				redirectFullUrl(geoUrl);	
			}
			
			gState 		= landingPage.state;
			gStateAbbr 	= landingPage.state_acronym;
			gCity 		= landingPage.city;
			
			if(!len(gCity))
			{
				cities = model("geolanding").findAll(where="type = 'city' AND state = '#gState#'",  order="type ASC");
			}
			
		}
		
	}  

}
</cfscript>