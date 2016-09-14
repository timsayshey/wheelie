<cfcomponent output="false">

<!---

      Pagination.cfc
/---------^---------------------------------------------------------------------------------------\
Nathan Strutz | strutz@gmail.com | http://www.dopefly.com/
Purpose: Provides customizable "nextN"-style navigation
License: BSD



      History
/---------^---------------------------------------------------------------------------------------\
Version 1.0 - 9/20/2008 - Release!



      Enhancements under consideration
/---------^---------------------------------------------------------------------------------------\
"Bridging" numbers like amazon - 1 number out of range will show if it bridges the "..." gap.
	// « Previous|Page:1 2 3 ... |Next »        page 1, 1000 pages total
	// « Previous|Page:1 2 3 4 5 ... |Next »    page 4  <--- this is a sticky #2!
	// « Previous|Page:1 ... 5 6 7 ... |Next »  page 6
Separate Left and Right (beginning and end) numeric padding - does anyone care?
Show exactly this number maximum, e.g. sticky is 5 but we are on pg.1, show 11 on pg.1 and 5
Number separators, 1 | 2 | 3 or 1, 2, 3



      Pagination learning, samples and further reading
/---------^---------------------------------------------------------------------------------------\
http://kurafire.net/log/archive/2007/06/22/pagination-101
http://developer.yahoo.com/ypatterns/pattern.php?pattern=itempagination
http://www.smashingmagazine.com/2007/11/16/pagination-gallery-examples-and-good-practices/
http://woork.blogspot.com/2008/03/perfect-pagination-style-using-css.html



      Suggested Use Example:
/---------^---------------------------------------------------------------------------------------\
<cfset pagination = createObject("component", "Pagination").init() />
<cfset pagination.setQueryToPaginate(myQuery) /><!--- required --->
<cfset pagination.setBaseLink("/app/photolist.cfm?year=#year#") /><!--- recommended --->
<cfset pagination.setItemsPerPage(25) /><!--- default is 10 --->
<cfset pagination.setShowNumericLinks(true) /><!--- default is false, will not display numbers --->

#pagination.getRenderedHTML()#

<cfoutput query="myQuery" startrow="#pagination.getStartRow()#" maxrows="#pagination.getMaxRows()#">
	... loop over records ...
</cfoutput>

#pagination.getRenderedHTML()#



     Copyright Notice (BSD License)
/---------^---------------------------------------------------------------------------------------\
Copyright (c) 2008, Nathan Strutz

All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted
provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of
	  conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of
	  conditions and the following disclaimer in the documentation and/or other materials provided
	  with the distribution.
    * Neither the name of Pagination.cfc nor the names of its contributors may be used to endorse or
	  promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--->

	<cffunction name="init" access="public" output="false" returntype="Pagination">

		<!--- local storage defaults --->
		<cfset variables.my = structNew() />
		
		<!--- Visual Options --->
		<cfset setBaseLink(cgi.PATH_INFO & '?' & cgi.query_string) />
		<cfset setAppendToLinks("") />
		<cfset setShowPrevNextHTML(true)>
		<cfset setPreviousLinkHTML("&lt;") />
		<cfset setNextLinkHTML("&gt;") />
		<cfset setShowPrevNextDisabledHTML(true)>
		<cfset setPreviousLinkDisabledHTML(getPreviousLinkHTML()) />
		<cfset setNextLinkDisabledHTML(getNextLinkHTML()) />

		<cfset setShowFirstLastHTML(false)>
		<cfset setFirstLinkHTML("&lt;&lt; First") />
		<cfset setLastLinkHTML("Last &gt;&gt;") />
		<cfset setShowFirstLastDisabledHTML(false)>
		<cfset setFirstLinkDisabledHTML(getFirstLinkHTML()) />
		<cfset setLastLinkDisabledHTML(getLastLinkHTML()) />

		<cfset setShowNumericLinks(true) />
		<cfset setNumericDistanceFromCurrentPageVisible(2) />
		<cfset setNumericEndBufferCount(1) />
		<cfset setShowMissingNumbersHTML(true) />
		<cfset setMissingNumbersHTML('<li class="disabled"><span href="javascript:void(0)">...</span></li>') />
		<cfset setBeforeNumericLinksHTML("") />
		<cfset setBeforeNextLinkHTML("") />

		<cfset setClassName("") />
		<!--- Configuration Options --->
		<cfset variables.my.QueryToPaginate = 0 />
		<cfset variables.my.ArrayToPaginate = 0 />
		<cfset variables.my.StructToPaginate = 0 />
		<cfset variables.my.PaginationDataType = "query" />

		<cfset setItemsPerPage(10) />
		
		<cfset setUrlPageIndicator("p") />
		<cfset setCompressHTML(false) />
		<!--- Caculated Options --->
		<cfset variables.my.TotalNumberOfPages = 1 />
		<cfset variables.my.StartRow = 1 />
		<cfset variables.my.CurrentPage = 1 />
		<cfset variables.my.EndRow = 10 />
		<!--- Resulting data --->
		<cfset variables.my.RenderedHTML = "" />
		<cfset variables.my.rendered = false />
		<cfset variables.my.configured = false />
		<cfset variables.my.paginationTextRendered = false />


		<!--- logical shortcut: query = queryToPaginate --->
		<cfset variables.getQuery = variables.getQueryToPaginate />
		<cfset this.getQuery = this.getQueryToPaginate />
		<cfset variables.setQuery = variables.setQueryToPaginate />
		<cfset this.setQuery = this.setQueryToPaginate />

		<!--- logical shortcut: array = arrayToPaginate --->
		<cfset variables.getArray = variables.getArrayToPaginate />
		<cfset this.getArray = this.getArrayToPaginate />
		<cfset variables.setArray = variables.setArrayToPaginate />
		<cfset this.setArray = this.setArrayToPaginate />

		<!--- logical shortcut: struct = structToPaginate --->
		<cfset variables.getStruct = variables.getStructToPaginate />
		<cfset this.getStruct = this.getStructToPaginate />
		<cfset variables.setStruct = variables.setStructToPaginate />
		<cfset this.setStruct = this.setStructToPaginate />

		<!--- locical shortcut: Items Per Page = cfquery MaxRows --->
		<cfset variables.getMaxRows = variables.getItemsPerPage />
		<cfset this.getMaxRows = this.getItemsPerPage />
		<cfset variables.setMaxRows = variables.setItemsPerPage />
		<cfset this.setMaxRows = this.setItemsPerPage />

		<cftrace category="Pagination" text="Initialized Pagination CFC" />

		<cfreturn this />
	</cffunction>


<!--- -------------- Visual Options -------------- --->
	<cffunction name="getShowPrevNextHTML" returntype="boolean" output="false" access="public" hint="Option to display next and previous buttons.">
		<cfreturn variables.my.ShowPrevNextHTML />
	</cffunction>
	<cffunction name="setShowPrevNextHTML" returntype="void" output="false" access="public" hint="Option to display next and previous buttons.">
		<cfargument name="_ShowPrevNextHTML" type="boolean" />
		<cfset variables.my.ShowPrevNextHTML = arguments._ShowPrevNextHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getPreviousLinkHTML" returntype="string" output="false" access="public" hint="Text for the previous link word. Default is '&lt; Previous'.">
		<cfreturn variables.my.PreviousLinkHTML />
	</cffunction>
	<cffunction name="setPreviousLinkHTML" output="false" access="public" hint="Text for the previous link word. Default is '&lt; Previous'.">
		<cfargument name="_PreviousLinkHTML" type="string" />
		<cfset variables.my.PreviousLinkHTML = arguments._PreviousLinkHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getNextLinkHTML" returntype="string" output="false" access="public" hint="Text for the next link word. Default is 'Next &gt;'.">
		<cfreturn variables.my.NextLinkHTML />
	</cffunction>
	<cffunction name="setNextLinkHTML" output="false" access="public" hint="Text for the next link word. Default is 'Next &gt;'.">
		<cfargument name="_NextLinkHTML" type="string" />
		<cfset variables.my.NextLinkHTML = arguments._NextLinkHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getShowPrevNextDisabledHTML" returntype="string" output="false" access="public" hint="Option to display Previous and Next text even when the link is not available.">
		<cfreturn variables.my.ShowPrevNextDisabledHTML />
	</cffunction>
	<cffunction name="setShowPrevNextDisabledHTML" returntype="void" output="false" access="public" hint="Option to display Previous and Next text even when the link is not available.">
		<cfargument name="_ShowPrevNextDisabledHTML" type="string" />
		<cfset variables.my.ShowPrevNextDisabledHTML = arguments._ShowPrevNextDisabledHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getPreviousLinkDisabledHTML" returntype="string" output="false" access="public" hint="Text for the previous link word when the link is disabled. Default is the same as PreviousLinkHTML.">
		<cfreturn variables.my.PreviousLinkDisabledHTML />
	</cffunction>
	<cffunction name="setPreviousLinkDisabledHTML" returntype="void" output="false" access="public" hint="Text for the previous link word when the link is disabled. Default is the same as PreviousLinkHTML.">
		<cfargument name="_PreviousLinkDisabledHTML" type="string" />
		<cfset variables.my.PreviousLinkDisabledHTML = arguments._PreviousLinkDisabledHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getNextLinkDisabledHTML" returntype="string" output="false" access="public" hint="Text for the next link word when the link is disabled. Default is the same as NextLinkHTML.">
		<cfreturn variables.my.NextLinkDisabledHTML />
	</cffunction>
	<cffunction name="setNextLinkDisabledHTML" returntype="void" output="false" access="public" hint="Text for the next link word when the link is disabled. Default is the same as NextLinkHTML.">
		<cfargument name="_NextLinkDisabledHTML" type="string" />
		<cfset variables.my.NextLinkDisabledHTML = arguments._NextLinkDisabledHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getShowFirstLastHTML" returntype="boolean" output="false" access="public" hint="Option to display next and previous buttons.">
		<cfreturn variables.my.ShowFirstLastHTML />
	</cffunction>
	<cffunction name="setShowFirstLastHTML" returntype="void" output="false" access="public" hint="Option to display next and previous buttons.">
		<cfargument name="_ShowFirstLastHTML" type="boolean" />
		<cfset variables.my.ShowFirstLastHTML = arguments._ShowFirstLastHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getFirstLinkHTML" returntype="string" output="false" access="public" hint="Text for the First link word. Default is '&lt; First'.">
		<cfreturn variables.my.FirstLinkHTML />
	</cffunction>
	<cffunction name="setFirstLinkHTML" output="false" access="public" hint="Text for the First link word. Default is '&lt; First'.">
		<cfargument name="_FirstLinkHTML" type="string" />
		<cfset variables.my.FirstLinkHTML = arguments._FirstLinkHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getLastLinkHTML" returntype="string" output="false" access="public" hint="Text for the Last link word. Default is 'Last &gt;'.">
		<cfreturn variables.my.LastLinkHTML />
	</cffunction>
	<cffunction name="setLastLinkHTML" output="false" access="public" hint="Text for the Last link word. Default is 'Last &gt;'.">
		<cfargument name="_LastLinkHTML" type="string" />
		<cfset variables.my.LastLinkHTML = arguments._LastLinkHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getShowFirstLastDisabledHTML" returntype="string" output="false" access="public" hint="Option to display Previous and Next text even when the link is not available.">
		<cfreturn variables.my.ShowFirstLastDisabledHTML />
	</cffunction>
	<cffunction name="setShowFirstLastDisabledHTML" returntype="void" output="false" access="public" hint="Option to display Previous and Next text even when the link is not available.">
		<cfargument name="_ShowFirstLastDisabledHTML" type="string" />
		<cfset variables.my.ShowFirstLastDisabledHTML = arguments._ShowFirstLastDisabledHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getFirstLinkDisabledHTML" returntype="string" output="false" access="public" hint="Text for the First link word when the link is disabled. Default is the same as FirstLinkHTML.">
		<cfreturn variables.my.FirstLinkDisabledHTML />
	</cffunction>
	<cffunction name="setFirstLinkDisabledHTML" returntype="void" output="false" access="public" hint="Text for the First link word when the link is disabled. Default is the same as FirstLinkHTML.">
		<cfargument name="_FirstLinkDisabledHTML" type="string" />
		<cfset variables.my.FirstLinkDisabledHTML = arguments._FirstLinkDisabledHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getLastLinkDisabledHTML" returntype="string" output="false" access="public" hint="Text for the Last link word when the link is disabled. Default is the same as LastLinkHTML.">
		<cfreturn variables.my.LastLinkDisabledHTML />
	</cffunction>
	<cffunction name="setLastLinkDisabledHTML" returntype="void" output="false" access="public" hint="Text for the Last link word when the link is disabled. Default is the same as LastLinkHTML.">
		<cfargument name="_LastLinkDisabledHTML" type="string" />
		<cfset variables.my.LastLinkDisabledHTML = arguments._LastLinkDisabledHTML />
		<cfset variables.my.rendered = false />
	</cffunction>


	<cffunction name="getShowNumericLinks" returntype="boolean" output="false" access="public" hint="Option to show numeric pagination links. False only displays prev/next links. Default is false.">
		<cfreturn variables.my.ShowNumericLinks />
	</cffunction>
	<cffunction name="setShowNumericLinks" output="false" access="public" hint="Option to show numeric pagination links. False only displays prev/next links. Default is false.">
		<cfargument name="_ShowNumericLinks" type="boolean" />
		<cfset variables.my.ShowNumericLinks = arguments._ShowNumericLinks />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getNumericDistanceFromCurrentPageVisible" returntype="numeric" output="false" access="public" hint="The amount of numbers displayed in sequence to the immediate left and right of the currently selected page number. Default is 3.">
		<cfreturn variables.my.NumericDistanceFromCurrentPageVisible />
	</cffunction>
	<cffunction name="setNumericDistanceFromCurrentPageVisible" output="false" access="public" hint="The amount of numbers displayed in sequence to the immediate left and right of the currently selected page number. Default is 3.">
		<cfargument name="_NumericDistanceFromCurrentPageVisible" type="numeric" />
		<cfset variables.my.NumericDistanceFromCurrentPageVisible = arguments._NumericDistanceFromCurrentPageVisible />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getNumericEndBufferCount" returntype="numeric" output="false" access="public" hint="The count of numbers displayed at the beginning and end of the numeric pagination. Default is 2.">
		<cfreturn variables.my.NumericEndBufferCount />
	</cffunction>
	<cffunction name="setNumericEndBufferCount" output="false" access="public" hint="The count of numbers displayed at the beginning and end of the numeric pagination. Default is 2.">
		<cfargument name="_NumericEndBufferCount" type="numeric" />
		<cfset variables.my.NumericEndBufferCount = arguments._NumericEndBufferCount />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getShowMissingNumbersHTML" returntype="boolean" output="false" access="public" hint="Option to show number skipped missing dots, i.e. 1 2 ... 5 6.">
		<cfreturn variables.my.ShowMissingNumbersHTML />
	</cffunction>
	<cffunction name="setShowMissingNumbersHTML" returntype="void" output="false" access="public" hint="Option to show number skipped missing dots, i.e. 1 2 ... 5 6.">
		<cfargument name="_ShowMissingNumbersHTML" type="boolean" />
		<cfset variables.my.ShowMissingNumbersHTML = arguments._ShowMissingNumbersHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getMissingNumbersHTML" returntype="string" output="false" access="public" hint="HTML to put when a number is skipped (out of range). Default is '...'.">
		<cfreturn variables.my.MissingNumbersHTML />
	</cffunction>
	<cffunction name="setMissingNumbersHTML" returntype="void" output="false" access="public" hint="HTML to put when a number is skipped (out of range). Default is '...'.">
		<cfargument name="_MissingNumbersHTML" type="string" />
		<cfset variables.my.MissingNumbersHTML = arguments._MissingNumbersHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getBeforeNumericLinksHTML" returntype="string" output="false" access="public">
		<cfreturn variables.my.BeforeNumericLinksHTML />
	</cffunction>
	<cffunction name="setBeforeNumericLinksHTML" output="false" access="public">
		<cfargument  name="_BeforeNumericLinksHTML" type="string" />
		<cfset variables.my.BeforeNumericLinksHTML = arguments._BeforeNumericLinksHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getBeforeNextLinkHTML" returntype="string" output="false" access="public">
		<cfreturn variables.my.BeforeNextLinkHTML />
	</cffunction>
	<cffunction name="setBeforeNextLinkHTML" output="false" access="public">
		<cfargument  name="_BeforeNextLinkHTML" type="string" />
		<cfset variables.my.BeforeNextLinkHTML = arguments._BeforeNextLinkHTML />
		<cfset variables.my.rendered = false />
	</cffunction>

	<cffunction name="getClassName" returntype="string" output="false" access="public" hint="CSS class name to put on highest level pagination HTML element.">
		<cfreturn variables.my.ClassName />
	</cffunction>
	<cffunction name="setClassName" output="false" access="public" hint="CSS class name to put on highest level pagination HTML element.">
		<cfargument  name="_ClassName" type="string" />
		<cfset variables.my.ClassName = arguments._ClassName />
		<cfset variables.my.rendered = false />
	</cffunction>

<!--- -------------- Configuration Options -------------- --->
	<cffunction name="getQueryToPaginate" returntype="query" output="false" access="public" hint="The query you will be paginating through. This property is required!">
		<cfif not isQuery(variables.my.QueryToPaginate)>
			<cfthrow message="You did not define the query to paginate." detail="You attempted to use the QueryToPaginate property, but have not yet set it. You must set the property with setQueryToPaginate(myQuery) before you can use it." />
		</cfif>
		<cfreturn variables.my.QueryToPaginate />
	</cffunction>
	<cffunction name="setQueryToPaginate" output="false" access="public" hint="The query you will be paginating through. This property is required!">
		<cfargument name="_QueryToPaginate" type="query" />
		<cfset variables.my.QueryToPaginate = arguments._QueryToPaginate />
		<cfset variables.my.rendered = false />
		<cfset variables.my.configured = false />
		<cfset variables.my.paginationDataType = "query" />
	</cffunction>

	<cffunction name="getArrayToPaginate" returntype="Array" output="false" access="public">
		<cfif not isArray(variables.my.ArrayToPaginate)>
			<cfthrow message="You did not define the array to paginate." detail="You attempted to use the ArrayToPaginate property, but have not yet set it. You must set the property with setArrayToPaginate(myArray) before you can use it." />
		</cfif>
		<cfreturn variables.my.ArrayToPaginate />
	</cffunction>
	<cffunction name="setArrayToPaginate" output="false" access="public">
		<cfargument  name="_ArrayToPaginate" type="Array" />
		<cfset variables.my.ArrayToPaginate = arguments._ArrayToPaginate />
		<cfset variables.my.rendered = false />
		<cfset variables.my.configured = false />
		<cfset variables.my.paginationDataType = "array" />
	</cffunction>

	<cffunction name="getStructToPaginate" returntype="struct" output="false" access="public">
		<cfif not isStruct(variables.my.StructToPaginate)>
			<cfthrow message="You did not define the struct to paginate." detail="You attempted to use the StructToPaginate property, but have not yet set it. You must set the property with setStructToPaginate(myStruct) before you can use it." />
		</cfif>
		<cfreturn variables.my.StructToPaginate />
	</cffunction>
	<cffunction name="setStructToPaginate" output="false" access="public">
		<cfargument  name="_StructToPaginate" type="struct" />
		<cfargument  name="_OrderedKeyList" type="string" default="#structKeyList(arguments._StructToPaginate)#" />
		<cfset variables.my.StructToPaginate = arguments._StructToPaginate />
		<cfset variables.my.OrderedKeyList = arguments._OrderedKeyList />
		<cfset variables.my.rendered = false />
		<cfset variables.my.configured = false />
		<cfset variables.my.paginationDataType = "struct" />
	</cffunction>

	<cffunction name="getItemsPerPage" returntype="numeric" output="false" access="public" hint="Number of records per page to display. Default is 10.">
		<cfreturn variables.my.ItemsPerPage />
	</cffunction>
	<cffunction name="setItemsPerPage" output="false" access="public" hint="Number of records per page to display. Default is 10.">
		<cfargument name="_ItemsPerPage" type="numeric" />
		<cfset variables.my.ItemsPerPage = arguments._ItemsPerPage />
		<cfset variables.my.rendered = false />
		<cfset variables.my.configured = false />
	</cffunction>

	<cffunction name="getBaseLink" returntype="string" output="false" access="public" hint="Base link to current and/or subsequent pages not including the URL page indicator. This property is required!">
		<cfset returnBaseLink = variables.my.BaseLink>		
		<cfset returnBaseLink = ListFirst(returnBaseLink,"?")>
		<cfset returnBaseLink = ListFirst(returnBaseLink,"&")>
		<cfreturn returnBaseLink & "?">
	</cffunction>
	<cffunction name="setAppendToLinks" output="false" access="public">
		<cfargument name="_appendToLinks" type="string" />
		<cfset variables.my.appendToLinks = arguments._appendToLinks />		
	</cffunction>
	<cffunction name="getAppendToLinks" output="false" access="public">
		<cfreturn variables.my.appendToLinks>
	</cffunction>
	<cffunction name="setBaseLink" output="false" access="public" hint="Base link to current and/or subsequent pages not including the URL page indicator. This property is required!">
		<cfargument name="_BaseLink" type="string" />
		
		<cfif find("?", arguments._BaseLink)>
			<!--- a query string exists, so we will append to it --->
			<cfset arguments._BaseLink = _BaseLink & "&" />
		<cfelse>
			<!--- a query string does not exist, so we will create one --->
			<cfset arguments._BaseLink = _BaseLink & "?" />
		</cfif>
		<cfset variables.my.BaseLink = arguments._BaseLink />		
		<cfset variables.my.rendered = false />
	</cffunction>
	<cffunction name="findBaseLink" returntype="string" output="false" access="private" hint="Attempts to determine your base link based CGI variables - this method is not reliable but works in a pinch.">
		<cfabort>
		<cfset var baseLink = cgi.PATH_INFO & '?' & cgi.query_string />
		<cftrace category="Pagination" text="Dynamically creating base link" />
		<cfset baseLink = reReplace(baseLink, "(\?|(&(amp;)))$", "") />
		<cfset baseLink = reReplace(baseLink, "(&(amp;)?|\?)?#getUrlPageIndicator()#=\d+", "", "ALL") />
		<cfreturn baseLink />
	</cffunction>

	<cffunction name="getUrlPageIndicator" returntype="string" output="false" access="public" hint="The URL variable to track which page we currently are on, default is 'pagenumber'.">
		<cfreturn variables.my.UrlPageIndicator />
	</cffunction>
	<cffunction name="setUrlPageIndicator" output="false" access="public" hint="The URL variable to track which page we currently are on, default is 'pagenumber'.">
		<cfargument name="_UrlPageIndicator" type="string" />
		<cfset variables.my.UrlPageIndicator = arguments._UrlPageIndicator />
		<cfset variables.my.rendered = false />
		<cfset variables.my.configured = false />
	</cffunction>

	<cffunction name="getCompressHTML" returntype="boolean" output="false" access="public" hint="Option to compress the HTML Output">
		<cfreturn variables.my.CompressHTML />
	</cffunction>
	<cffunction name="setCompressHTML" returntype="void" output="false" access="public" hint="Option to compress the HTML Output">
		<cfargument name="_CompressHTML" type="boolean" />
		<cfset variables.my.CompressHTML = arguments._CompressHTML />
		<cfset variables.my.rendered = false />
	</cffunction>


<!--- -------------- Internally Managed and Calculated Options (only getters are public) -------------- --->
	<cffunction name="getTotalNumberOfPages" returntype="numeric" output="false" access="public" hint="The calculated total number of pages based on number of records and records per page.">
		<!--- has to be calculated --->
		<cfif not variables.my.configured>
			<cfset configureInputs() />
		</cfif>
		<cfreturn variables.my.TotalNumberOfPages />
	</cffunction>
	<cffunction name="setTotalNumberOfPages" output="false" access="private" hint="The calculated total number of pages based on number of records and records per page.">
		<cfargument name="_TotalNumberOfPages" type="numeric" />
		<cfset variables.my.TotalNumberOfPages = arguments._TotalNumberOfPages />
		<cfset variables.my.rendered = false />
		<cfset variables.my.configured = false />
	</cffunction>

	<cffunction name="getCurrentPage" returntype="numeric" output="false" access="public" hint="Current page number the user is viewing.">
		<!--- has to be calculated --->
		<cfif not variables.my.configured>
			<cfset configureInputs() />
		</cfif>
		<cfreturn variables.my.CurrentPage />
	</cffunction>
	<cffunction name="setCurrentPage" returntype="void" output="false" access="private" hint="Current page number the user is viewing.">
		<cfargument name="_CurrentPage" type="numeric" />
		<cfset variables.my.CurrentPage = arguments._CurrentPage />
		<cfset variables.my.rendered = false />
		<cfset variables.my.configured = false />
		<!--- TODO: make this pubilc? would force reconfiguration, but doable --->
	</cffunction>

	<cffunction name="getStartRow" returntype="numeric" output="false" access="public" hint="The calculated starting row for your cfoutput tag.">
		<!--- has to be calculated --->
		<cfif not variables.my.configured>
			<cfset configureInputs() />
		</cfif>
		<cfreturn variables.my.StartRow />
	</cffunction>
	<cffunction name="setStartRow" output="false" access="private" hint="The calculated starting row for your cfoutput tag.">
		<cfargument name="_StartRow" type="numeric" />
		<cfset variables.my.StartRow = arguments._StartRow />
		<cfset variables.my.rendered = false />
		<cfset variables.my.configured = false />
		<!--- TODO: make this pubilc? would force reconfiguration, but doable --->
	</cffunction>

	<cffunction name="getEndRow" returntype="numeric" output="false" access="public" hint="The calculated last row number that will be displayed on the current page.">
		<!--- has to be calculated --->
		<cfif not variables.my.configured>
			<cfset configureInputs() />
		</cfif>
		<cfreturn variables.my.EndRow />
	</cffunction>
	<cffunction name="setEndRow" returntype="void" output="false" access="private" hint="The calculated last row number that will be displayed on the current page.">
		<cfargument name="_EndRow" type="numeric" />
		<cfset variables.my.EndRow = arguments._EndRow />
		<cfset variables.my.rendered = false />
		<cfset variables.my.configured = false />
		<!--- TODO: EndRow could be public and set instead of (or in addition to) ItemsPerPage, itemsPerPage would then be recalculated - logic could go both ways --->
	</cffunction>

	<cffunction name="getTotalNumberOfItems" returntype="numeric" output="false" access="public" hint="The total number of records, indexes, keys, etc., in the given data to paginate.">
		<!--- has to be calculated --->
		<cfif not variables.my.configured>
			<cfset configureInputs() />
		</cfif>
		<cfreturn variables.my.TotalNumberOfItems />
	</cffunction>
	<cffunction name="setTotalNumberOfItems" output="false" access="private" hint="The total number of records, indexes, keys, etc., in the given data to paginate.">
		<cfargument  name="_TotalNumberOfItems" type="numeric" />
		<cfset variables.my.TotalNumberOfItems = arguments._TotalNumberOfItems />
	</cffunction>

	<cffunction name="getFirstPageLink" returntype="string" output="false" access="public" hint="Link to first page">
		<cfreturn "#getBaseLink()##getUrlPageIndicator()#=1#variables.my.appendToLinks#" />
	</cffunction>

	<cffunction name="getPreviousPageLink" returntype="string" output="false" access="public" hint="Link to previous sequential page">
		<cfreturn "#getBaseLink()##getUrlPageIndicator()#=#max(1, getCurrentPage()-1)##variables.my.appendToLinks#" />
	</cffunction>

	<cffunction name="getNextPageLink" returntype="string" output="false" access="public" hint="Link to next sequential page">
		<cfreturn "#getBaseLink()##getUrlPageIndicator()#=#min(getTotalNumberOfPages(), getCurrentPage()+1)##variables.my.appendToLinks#" />
	</cffunction>

	<cffunction name="getLastPageLink" returntype="string" output="false" access="public" hint="Link to last page">
		<cfreturn "#getBaseLink()##getUrlPageIndicator()#=#getTotalNumberOfPages()##variables.my.appendToLinks#" />
	</cffunction>



<!--- -------------- Where the real work happens -------------- --->

	<cffunction name="hasMinimumAttributesToRender" returntype="boolean" access="public" hint="Determines if the requirements are met for rendering the pagination HTML.">
		<!--- either was already rendered, or if not, has the minimum requirements for rendering --->
		<cftry>
			<cfreturn variables.my.rendered or len(variables.my.baseLink) and (isQuery(variables.my.queryToPaginate) OR isArray(variables.my.arrayToPaginate) OR isStruct(variables.my.structToPaginate) ) />
			<cfcatch><cfreturn false /></cfcatch>
		</cftry>
	</cffunction>


	<cffunction name="getRenderedHTML" returntype="string" output="false" access="remote" hint="Creates and returns pagination HTML output.">
		<cfset var renderedOutput = "" />

		<cftrace category="Pagination" text="Call to render HTML" />
		
		<cfif not hasMinimumAttributesToRender()>
			<cfthrow message="You must supply the query, array or struct to paginate before rendering the output." detail="This message may also mean that you did not call init() when you initially created the object.<br/>Please call init to initialize this component: <code>createObject('component','[...]Pagination').init()</code>" />
		</cfif>

		<cfif not variables.my.configured>
			<cfset configureInputs() />
		</cfif>

		<!--- check if this is the 2nd+ attempt at same render, return previous render --->
		<cfif variables.my.rendered>
			<cfreturn variables.my.renderedHTML />
		</cfif>

		<!--- 1 page = no pagination necessary --->
		<cfif getTotalNumberOfPages() EQ 1>
			<cfsavecontent variable="renderedOutput"><div class="pagination empty">&nbsp;</div></cfsavecontent>
		<cfelse>
			<cfset renderedOutput = renderHTML() />
		</cfif>

		<cfif getCompressHTML()>
			<cfset renderedOutput = compressHTML(renderedOutput) />
		</cfif>

		<cfset variables.my.renderedHTML = renderedOutput />
		<cfset variables.my.rendered = true />

		<cfreturn renderedOutput />
	</cffunction>


	<cffunction name="configureInputs" returntype="void" output="false" access="private" hint="Sets the query start row and makes sure your URL page number indicator is not broken.">
		<cfscript>
			var urlPageNo = 1;
			var numberOfRecords = 0;

			if (variables.my.PaginationDataType EQ "query") {
				numberOfRecords = getQueryToPaginate().recordcount;
			} else if (variables.my.PaginationDataType EQ "array") {
				numberOfRecords = arrayLen(getArrayToPaginate());
			} else if (variables.my.PaginationDataType EQ "struct") {
				numberOfRecords = listLen(variables.my.OrderedKeyList);
			}

			setTotalNumberOfItems( numberOfRecords );
			setTotalNumberOfPages( Ceiling(numberOfRecords / getItemsPerPage()) );

			if (structKeyExists(url, getUrlPageIndicator())) {
				urlPageNo = url[getUrlPageIndicator()];
			}

			// safety measure for URL pagination variable
			if (not isNumeric(urlPageNo) or urlPageNo LT 1) {
				urlPageNo = 1;
			} else if (urlPageNo GT variables.my.TotalNumberOfPages and numberOfRecords) {
				// url page number is higher than number of pages possible
				urlPageNo = variables.my.TotalNumberOfPages;
			}


			// set the actual URL variable
			variables.my.currentPage = urlPageNo;
			url[getUrlPageIndicator()] = urlPageNo;

			// set query start row for the currently selected page number
			setStartRow( (urlPageNo - 1) * getItemsPerPage() + 1 );
			// set query end row - this is the last row number visible on the page
			setEndRow( min(urlPageNo * getItemsPerPage(), numberOfRecords) );

			// make sure there is a base link
			if (getBaseLink() EQ "?" or getBaseLink() EQ "&") {
				setBaseLink(findBaseLink());
			}

			// We have now been configured
			variables.my.configured = true;
		</cfscript>
	</cffunction>


	<cffunction name="renderHTML" returntype="string" output="false" access="private" hint="Creates the pagination HTML output.">
		<cfset var renderedOutput = "" />
		<cfset var displayDots = true />
		<cfset var i = 0 />

		<cftrace category="Pagination" text="Rendering fresh HTML" />

		<cfsavecontent variable="renderedOutput">
			<cfoutput>
				<ul class="pagination #getClassName()#">
				<cfif getCurrentPage() GT 1 and getShowFirstLastHTML()>
					<li><a href="#getFirstPageLink()#" class="first">#getFirstLinkHTML()#</a></li>
				<cfelseif getShowFirstLastDisabledHTML()>
					<li><span class="first">#getFirstLinkDisabledHTML()#</span></li>
				</cfif>
				<cfif getCurrentPage() GT 1 and getShowPrevNextHTML()>
					<li><a href="#getPreviousPageLink()#" class="previous">#getPreviousLinkHTML()#</a></li>
				<cfelseif getShowPrevNextDisabledHTML()>
					<li><span class="previous">#getPreviousLinkDisabledHTML()#</span></li>
				</cfif>
				<cfif getShowNumericLinks()>
					#getBeforeNumericLinksHTML()#
					#renderNumericLinksHTML()#
				</cfif>
				#getBeforeNextLinkHTML()#
				<cfif getCurrentPage() LT getTotalNumberOfPages() and getShowPrevNextHTML()>
					<li><a href="#getNextPageLink()#" class="next">#getNextLinkHTML()#</a></li>
				<cfelseif getShowPrevNextDisabledHTML()>
					<li><span class="next">#getNextLinkDisabledHTML()#</span></li>
				</cfif>
				<cfif getCurrentPage() LT getTotalNumberOfPages() and getShowFirstLastHTML()>
					<li><a href="#getLastPageLink()#" class="last">#getLastLinkHTML()#</a></li>
				<cfelseif getShowFirstLastDisabledHTML()>
					<li><span class="last">#getLastLinkDisabledHTML()#</span></li>
				</cfif>
				</ul>
			</cfoutput>
		</cfsavecontent>

		<cfreturn renderedOutput />
	</cffunction>


	<cffunction name="renderNumericLinksHTML" returntype="string" output="false" access="private" hint="Creates the pagination numeric links HTML output. Separate from renderHTML so it can be called from an extended method easier, or overwritten if desired.">
		<cfset var renderedOutput = "" />
		<cfset var displayDots = true />
		<cfset var i = 0 />

		<cftrace category="Pagination" text="Rendering fresh HTML" />

		<cfsavecontent variable="renderedOutput">
			<cfoutput>
				<cfloop from="1" to="#getTotalNumberOfPages()#" index="i">
					<!--- TODO: getFixedMaximumNumbersShown does not work, but could, with some polish
					 	OR (getFixedMaximumNumbersShown() and getFixedMaximumNumbersShown() GT getNumericEndBufferCount() * 2 and abs( getCurrentPage() - i ) LTE ceiling((getFixedMaximumNumbersShown()-getNumericEndBufferCount()*2)/2))
					 --->
					<cfif (i LTE getNumericEndBufferCount()) or (i GT (getTotalNumberOfPages()-getNumericEndBufferCount())) or (abs( getCurrentPage() - i ) LTE getNumericDistanceFromCurrentPageVisible())>
						<!--- first 2 numbers or last 2 numbers, or within n either direction of the selected page --->
						<cfif getCurrentPage() NEQ i>
							<li><a href="#getBaseLink()##getUrlPageIndicator()#=#i##variables.my.appendToLinks#">#i#</a></li>
						<cfelse>
							<li class="active"><a href="javascript:void(0);">#i#</a></li>
						</cfif>
						<cfset displayDots = false />
					<cfelse>
						<cfif not displayDots>
							<cfif getShowMissingNumbersHTML()>
								<!--- show ... when numbers are skipped --->
								#getMissingNumbersHTML()#
							</cfif>
							<cfset displayDots = true />							
						</cfif>
					</cfif>
				</cfloop>
			</cfoutput>
		</cfsavecontent>

		<cfreturn renderedOutput />
	</cffunction>



	<cffunction name="compressHTML" returntype="string" output="false" access="private" hint="Compresses any HTML given.">
		<cfargument name="htmlToCompress" type="string" required="true" />
		<cfset var compressedHTML = htmlToCompress />

		<!--- put tags together --->
		<cfset compressedHTML = reReplace(htmlToCompress, "\>\s+\<", "> <", "ALL") />
		<!--- take out extra spaces --->
		<cfset compressedHTML = reReplace(htmlToCompress, "\s{2,}", chr(13), "ALL") />

		<cfreturn compressedHTML />
	</cffunction>

</cfcomponent>