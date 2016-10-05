
<cfcomponent
	output="false"
	hint="Handles a CFHTTP session by sending an receving cookies behind the scenes.">
	
	<!--- 
		Pseudo constructor. Set up data structures and 
		default values. 
	--->
	<cfset VARIABLES.Instance = {} />
	
	<!--- This is the log file path used for debugging. --->
	<cfset VARIABLES.Instance.LogFilePath = "" />
	
	<!--- 
		These are the cookies that get returned from the 
		request that enable us to keep the session across 
		different CFHttp requests. 
	--->
	<cfset VARIABLES.Instance.Cookies = {} />
	
	<!--- 
		The request data contains the various types of data that
		we will send with our request. These will be both for the
		CFHttpParam tags as well as the CFHttp property values.
	--->
	<cfset VARIABLES.Instance.RequestData = {} />
	<cfset VARIABLES.Instance.RequestData.Url = "" />
	<cfset VARIABLES.Instance.RequestData.Referer = "" />
	<cfset VARIABLES.Instance.RequestData.UserAgent = "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6" />
	<cfset VARIABLES.Instance.RequestData.Params = [] />
	
	
	<cffunction
		name="Init"
		access="public"
		returntype="any"
		output="false"
		hint="Returns an initialized component.">
		
		<!--- Define arguments. --->
		<cfargument 
			name="LogFilePath" 
			type="string" 
			required="false" 
			hint="I am the full path to the log file that will be used to debug the request / response data."
			/>
			
		<cfargument
			name="UserAgent"
			type="string"
			required="false"
			hint="The user agent that will be used on the subseqent page requests."
			/>
			
		<!--- Check to see if we have a user agent. --->
		<cfif StructKeyExists( ARGUMENTS, "LogFilePath" )>
			<cfset VARIABLES.Instance.LogFilePath = ARGUMENTS.LogFilePath />
		</cfif>
		
		<!--- Check to see if we have a user agent. --->
		<cfif StructKeyExists( ARGUMENTS, "UserAgent" )>
			<cfset THIS.SetUserAgent( ARGUMENTS.UserAgent ) />
		</cfif>
		
		<!--- Return This reference. --->
		<cfreturn THIS />
	</cffunction>
	
	
	<cffunction
		name="AddCGI"
		access="public"
		returntype="any"
		output="false"
		hint="Adds a CGI value. Returns THIS scope for method chaining.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Name"
			type="string"
			required="true"
			hint="The name of the CGI value."
			/>
			
		<cfargument
			name="Value"
			type="string"
			required="true"
			hint="The CGI value."
			/>
			
		<cfargument
			name="Encoded"
			type="string"
			required="false"
			default="yes"
			hint="Determins whether or not to encode the CGI value."
			/>
			
		<!--- Set parameter and return This reference. --->
		<cfreturn THIS.AddParam(
			Type = "CGI",
			Name = ARGUMENTS.Name,
			Value = ARGUMENTS.Value,
			Encoded = ARGUMENTS.Encoded
			) />
	</cffunction>
	
	
	<cffunction
		name="AddCookie"
		access="public"
		returntype="any"
		output="false"
		hint="Adds a cookie value. Returns THIS scope for method chaining.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Name"
			type="string"
			required="true"
			hint="The name of the CGI value."
			/>
			
		<cfargument
			name="Value"
			type="string"
			required="true"
			hint="The CGI value."
			/>
			
		<!--- Set parameter and return This reference. --->
		<cfreturn THIS.AddParam(
			Type = "Cookie",
			Name = ARGUMENTS.Name,
			Value = ARGUMENTS.Value
			) />
	</cffunction>
	
	
	<cffunction
		name="AddFile"
		access="public"
		returntype="any"
		output="false"
		hint="Adds a file value. Returns THIS scope for method chaining.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Name"
			type="string"
			required="true"
			hint="The name of the form field for the posted file."
			/>
			
		<cfargument
			name="Path"
			type="string"
			required="true"
			hint="The expanded path to the file."
			/>
			
		<cfargument
			name="MimeType"
			type="string"
			required="false"
			default="application/octet-stream"
			hint="The mime type of the posted file. Defaults to *unknown* mime type."
			/>
			
		<!--- Set parameter and return This reference. --->
		<cfreturn THIS.AddParam(
			Type = "File",
			Name = ARGUMENTS.Name,
			File = ARGUMENTS.Path,
			MimeType = ARGUMENTS.MimeType
			) />
	</cffunction>
	
	
	<cffunction
		name="AddFormField"
		access="public"
		returntype="any"
		output="false"
		hint="Adds a form value. Returns THIS scope for method chaining.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Name"
			type="string"
			required="true"
			hint="The name of the form field."
			/>
			
		<cfargument
			name="Value"
			type="string"
			required="true"
			hint="The form field value."
			/>
			
		<cfargument
			name="Encoded"
			type="string"
			required="false"
			default="yes"
			hint="Determins whether or not to encode the form value."
			/>
			
		<!--- Set parameter and return This reference. --->
		<cfreturn THIS.AddParam(
			Type = "FormField",
			Name = ARGUMENTS.Name,
			Value = ARGUMENTS.Value,
			Encoded = ARGUMENTS.Encoded
			) />
	</cffunction>
	
	
	<cffunction
		name="AddHeader"
		access="public"
		returntype="any"
		output="false"
		hint="Adds a header value. Returns THIS scope for method chaining.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Name"
			type="string"
			required="true"
			hint="The name of the header value."
			/>
			
		<cfargument
			name="Value"
			type="string"
			required="true"
			hint="The header value."
			/>
			
		<!--- Set parameter and return This reference. --->
		<cfreturn THIS.AddParam(
			Type = "Header",
			Name = ARGUMENTS.Name,
			Value = ARGUMENTS.Value
			) />
	</cffunction>
	
	
	<cffunction
		name="AddParam"
		access="public"
		returntype="any"
		output="false"
		hint="Adds a CFHttpParam data point. Returns THIS scope for method chaining.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Type"
			type="string"
			required="true"
			hint="The type of data point."
			/>
			
		<cfargument
			name="Name"
			type="string"
			required="false"
			hint="The name of the data point."
			/>
			
		<cfargument
			name="Value"
			type="any"
			required="false"
			hint="The value of the data point."
			/>
			
		<cfargument
			name="File"
			type="string"
			required="false"
			default=""
			hint="The expanded path to be used if the data piont is a file."
			/>
			
		<cfargument
			name="MimeType"
			type="string"
			required="false"
			default=""
			hint="The mime type of the file being passed (if file is being passed)."
			/>
			
		<cfargument
			name="Encoded"
			type="string"
			required="false"
			default="yes"
			hint="The determines whether or not to encode Form Field and CGI values."
			/>
			
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
			
		<!--- 
			Check to see which kind of data point we are dealing 
			with so that we can see how to create the param.
		--->
		<cfswitch expression="#ARGUMENTS.Type#">
			
			<cfcase value="Body">
			
				<!--- Create the param. --->
				<cfset LOCAL.Param = {
					Type = ARGUMENTS.Type,
					Value = ARGUMENTS.Value
					} />
			
			</cfcase>
			
			<cfcase value="CGI">
			
				<!--- Create the param. --->
				<cfset LOCAL.Param = {
					Type = ARGUMENTS.Type,
					Name = ARGUMENTS.Name,
					Value = ARGUMENTS.Value,
					Encoded = ARGUMENTS.Encoded
					} />
			
			</cfcase>
			
			<cfcase value="Cookie">
			
				<!--- Create the param. --->
				<cfset LOCAL.Param = {
					Type = ARGUMENTS.Type,
					Name = ARGUMENTS.Name,
					Value = ARGUMENTS.Value
					} />
			
			</cfcase>
			
			<cfcase value="File">
			
				<!--- Create the param. --->
				<cfset LOCAL.Param = {
					Type = ARGUMENTS.Type,
					Name = ARGUMENTS.Name,
					File = ARGUMENTS.File,
					MimeType = ARGUMENTS.MimeType
					} />
			
			</cfcase>
			
			<cfcase value="FormField">
			
				<!--- Create the param. --->
				<cfset LOCAL.Param = {
					Type = ARGUMENTS.Type,
					Name = ARGUMENTS.Name,
					Value = ARGUMENTS.Value,
					Encoded = ARGUMENTS.Encoded
					} />
			
			</cfcase>
			
			<cfcase value="Header">
			
				<!--- Create the param. --->
				<cfset LOCAL.Param = {
					Type = ARGUMENTS.Type,
					Name = ARGUMENTS.Name,
					Value = ARGUMENTS.Value
					} />
			
			</cfcase>
			
			<cfcase value="Url">
			
				<!--- Create the param. --->
				<cfset LOCAL.Param = {
					Type = ARGUMENTS.Type,
					Name = ARGUMENTS.Name,
					Value = ARGUMENTS.Value
					} />
			
			</cfcase>
			
			<cfcase value="Xml">
			
				<!--- Create the param. --->
				<cfset LOCAL.Param = {
					Type = ARGUMENTS.Type,
					Value = ARGUMENTS.Value
					} />
			
			</cfcase>
					
		</cfswitch>
		
		
		<!--- Add the parameter for the next request. --->
		<cfset ArrayAppend(
			VARIABLES.Instance.RequestData.Params,
			LOCAL.Param
			) />	
		
		<!--- Return This reference. --->
		<cfreturn THIS />
	</cffunction>
	
	
	<cffunction
		name="AddUrl"
		access="public"
		returntype="any"
		output="false"
		hint="Adds a url value. Returns THIS scope for method chaining.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Name"
			type="string"
			required="true"
			hint="The name of the header value."
			/>
			
		<cfargument
			name="Value"
			type="string"
			required="true"
			hint="The header value."
			/>
			
		<!--- Set parameter and return This reference. --->
		<cfreturn THIS.AddParam(
			Type = "Url",
			Name = ARGUMENTS.Name,
			Value = ARGUMENTS.Value
			) />
	</cffunction>
	
	
	<cffunction 
		name="Get"
		access="public"
		returntype="struct"
		output="false"
		hint="Uses the GET method to place the next request. Returns the CFHttp response.">
		
		<!--- Define arguments. --->
		<cfargument
			name="GetAsBinary"
			type="string"
			required="false"
			default="auto"
			hint="Determines how to return the file content - return as binary value." 
			/>
			
		<!--- Return response. --->
		<cfreturn THIS.Request(
			Method = "get",
			GetAsBinary = ARGUMENTS.GetAsBinary
			) />
	</cffunction>
	
	
	<cffunction
		name="GetCookies"
		access="public"
		returntype="struct"
		output="false"
		hint="Returns the internal session cookies.">
		
		<cfreturn VARIABLES.Instance.Cookies />
	</cffunction>
	
	
	<cffunction 
		name="LogRequestData" 
		access="public" 
		returntype="void" 
		output="false" 
		hint="I log the given request to the log file, if it exists.">
		
		<cfargument
			name="Method"
			type="string"
			required="false"
			default="get"
			hint="The type of request to make." 
			/>
			
		<cfargument
			name="GetAsBinary"
			type="string"
			required="false"
			default="auto"
			hint="Determines how to return body." 
			/>
			
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
		
		<!--- 
			Check to see if the log file path is set. If not, 
			just return out. 
		--->
		<cfif NOT Len( VARIABLES.Instance.LogFilePath )>
			<cfreturn />
		</cfif>
		
		
		<!--- Create a data buffer for the request data. --->
		<cfsavecontent variable="LOCAL.Output">
			<cfoutput>
			
				+----------------------------------------------+
				REQUEST: #TimeFormat( Now(), "HH:mm:ss:L" )#
			
				URL: #VARIABLES.Instance.RequestData.Url#
				
				Method: #ARGUMENTS.Method#
				
				UserAgent: #VARIABLES.Instance.RequestData.UserAgent#
				
				GetAsBinary: #ARGUMENTS.GetAsBinary#
				
				-- Cookies --
				
				<cfloop
					item="LOCAL.Key"
					collection="#VARIABLES.Instance.Cookies#">
					#LOCAL.Key#: #VARIABLES.Instance.Cookies[ LOCAL.Key ].Value#
				</cfloop>
				
				-- Headers --
				
				Referer: #VARIABLES.Instance.RequestData.Referer#
				
				-- Params --
				
				<cfloop
					index="LOCAL.Param"
					array="#VARIABLES.Instance.RequestData.Params#">
					
					<cfloop 
						item="LOCAL.ParamKey"
						collection="#LOCAL.Param#">
						#LOCAL.ParamKey# : #LOCAL.Param[ LOCAL.ParamKey ]#
					</cfloop>
					
				</cfloop>
			
			</cfoutput>
		</cfsavecontent>
		
		
		<!--- Clean up request data. --->
		<cfset LOCAL.Output = REReplace(
			LOCAL.Output,
			"(?m)^[ \t]+|[ \t]+$",
			"",
			"all"
			) />
			
		<!--- Write the output to log file. --->
		<cffile
			action="append"
			file="#VARIABLES.Instance.LogFilePath#"
			output="#LOCAL.Output#"
			addnewline="true"
			/>
		
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
	
	<cffunction 
		name="LogResponseData" 
		access="public" 
		returntype="void" 
		output="false" 
		hint="I log the given response to the log file, if it exists.">
		
		<cfargument 
			name="Response" 
			type="struct" 
			required="true" 
			hint="I am the CFHTTP response object."
			/>
		
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
		
		<!--- 
			Check to see if the log file path is set. If not, 
			just return out. 
		--->
		<cfif NOT Len( VARIABLES.Instance.LogFilePath )>
			<cfreturn />
		</cfif>
		
		<!--- Create a data buffer for the request data. --->
		<cfsavecontent variable="LOCAL.Output">
			<cfoutput>
			
				+----------------------------------------------+
				RESPONSE: #TimeFormat( Now(), "HH:mm:ss:L" )#
			
				-- Cookies --
				
				<cfif StructKeyExists( ARGUMENTS.Response.ResponseHeader, "Set-Cookie" )>
					
					<cfif IsSimpleValue( ARGUMENTS.Response.ResponseHeader[ "Set-Cookie" ] )>
					
						#ARGUMENTS.Response.ResponseHeader[ "Set-Cookie" ]#
					
					<cfelse>
					
						<cfloop
							item="LOCAL.CookieIndex"
							collection="#ARGUMENTS.Response.ResponseHeader[ 'Set-Cookie' ]#">
							
							#ARGUMENTS.Response.ResponseHeader[ 'Set-Cookie' ][ LOCAL.CookieIndex ]#
							
						</cfloop>
							
					</cfif>
				
				</cfif>
				
				-- Redirect --
				
				<cfif StructKeyExists( ARGUMENTS.Response.ResponseHeader, "Location" )>
					
					#ARGUMENTS.Response.ResponseHeader.Location#
				
				</cfif>
				
			</cfoutput>
		</cfsavecontent>
		
		
		<!--- Clean up seponse data. --->
		<cfset LOCAL.Output = REReplace(
			LOCAL.Output,
			"(?m)^[ \t]+|[ \t]+$",
			"",
			"all"
			) />
			
		<!--- Write the output to log file. --->
		<cffile
			action="append"
			file="#VARIABLES.Instance.LogFilePath#"
			output="#LOCAL.Output#"
			addnewline="true"
			/>
		
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="NewRequest"
		access="public"
		returntype="any"
		output="false"
		hint="Sets up the object for a new request. Returns THIS scope for method chaining.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Url"
			type="string"
			required="true"
			hint="The URL for the new request."
			/>
			
		<cfargument
			name="Referer"
			type="string"
			required="false"
			default=""
			hint="The referring URL for the request. By default, it will be the same directory as the target URL."
			/>
			
			
		<!--- 
			Before we store the URL, let's check to see if we 
			already had one in memory. If so, then we can use 
			that for a referer (which we then have the option 
			to override. The point here is that each URL can 
			be the referer for the next one.
		--->
		<cfif Len( VARIABLES.Instance.RequestData.Url )>
		
			<!--- 
				Store the previous url as the next referer. We 
				may override this in a second.
			--->
			<cfset VARIABLES.Instance.RequestData.Referer = VARIABLES.Instance.RequestData.Url />
		
		</cfif>
		
		
		<!--- Store the passed-in url. --->
		<cfset VARIABLES.Instance.RequestData.Url = ARGUMENTS.Url />
		
		<!--- 
			Check to see if the referer was passed in. Since we 
			are using previous URLs as the next referring url, 
			we only want to store the passed in value if it has 
			length
		--->
		<cfif Len( ARGUMENTS.Referer )>
		
			<!--- Store manually set referer. --->
			<cfset VARIABLES.Instance.RequestData.Referer = ARGUMENTS.Referer />
		
		</cfif>
		
		
		<!--- Clear the request data. --->
		<cfset VARIABLES.Instance.RequestData.Params = [] />
		
		<!--- Return This reference. --->
		<cfreturn THIS />
	</cffunction>
	
	
	<cffunction 
		name="Post"
		access="public"
		returntype="struct"
		output="false"
		hint="Uses the POST method to place the next request. Returns the CFHttp response.">
		
		<!--- Define arguments. --->
		<cfargument
			name="GetAsBinary"
			type="string"
			required="false"
			default="auto"
			hint="Determines how to return the file content - return as binary value." 
			/>
			
		<!--- Return response. --->
		<cfreturn THIS.Request(
			Method = "post",
			GetAsBinary = ARGUMENTS.GetAsBinary
			) />
	</cffunction>
	
	
	<cffunction 
		name="Request"
		access="public"
		returntype="struct"
		output="false"
		hint="Performs the CFHttp request and returns the response.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Method"
			type="string"
			required="false"
			default="get"
			hint="The type of request to make." 
			/>
			
		<cfargument
			name="GetAsBinary"
			type="string"
			required="false"
			default="auto"
			hint="Determines how to return body." 
			/>
			
		<!--- Define the local scope. --->
		<cfset var LOCAL = {} />
		
		<!--- 
			Before we make the actual request, log request data 
			for debugging pursposes. Pass the same arguments to 
			the logging method.
		--->
		<cfset THIS.LogRequestData( ArgumentCollection = ARGUMENTS ) />
			
		<!--- 
			Make request. When the request comes back, we don't 
			want to follow any redirects. We want this to be 
			done manually.
		--->
		<cfhttp
			url="#VARIABLES.Instance.RequestData.Url#"
			method="#ARGUMENTS.Method#"
			useragent="#VARIABLES.Instance.RequestData.UserAgent#"
			getasbinary="#ARGUMENTS.GetAsBinary#"
			redirect="no"
			result="LOCAL.Get">
			
			<!--- 
				In order to maintain the user's session, we are 
				going to resend any cookies that we have stored 
				internally. 
			--->
			<cfloop
				item="LOCAL.Key"
				collection="#VARIABLES.Instance.Cookies#">
				
				<cfhttpparam
					type="cookie"
					name="#LOCAL.Key#"
					value="#VARIABLES.Instance.Cookies[ LOCAL.Key ].Value#"
					/>
				
			</cfloop>
			
			
			<!--- 
				At this point, we have done everything that we 
				need to in order to maintain the user's session 
				across CFHttp requests. Now we can go ahead and 
				pass along any addional data that has been specified.
			--->
			
			
			<!--- Let's spoof the referer. --->
			<cfhttpparam
				type="header"
				name="referer"
				value="#VARIABLES.Instance.RequestData.Referer#"
				/>
			
			
			<!--- Loop over params. --->
			<cfloop
				index="LOCAL.Param"
				array="#VARIABLES.Instance.RequestData.Params#">
				
				<!--- 
					Pass the existing param object in as our 
					attributes collection. 
				--->
				<cfhttpparam
					attributecollection="#LOCAL.Param#"
					/>
				
			</cfloop>
			
		</cfhttp>
		
		
		<!--- Debug the response. --->
		<cfset THIS.LogResponseData( LOCAL.Get ) />
		
					
		<!--- 
			Store the response cookies into our internal cookie 
			storage struct.
		--->
		<cfset StoreResponseCookies( LOCAL.Get ) />
		
		
		<!--- 
			Check to see if there was some sort of redirect 
			returned with the repsonse. If there was, we want 
			to redirect with the proper value. 
		--->
		<cfif StructKeyExists( LOCAL.Get.ResponseHeader, "Location" )>
		
			<!--- 
				There was a response, so now we want to do a 
				recursive call to return the next page. When 
				we do this, make sure we have the proper URL 
				going out. 
			--->
			<cfif REFindNoCase( 
				"^http", 
				LOCAL.Get.ResponseHeader.Location
				)>
				
				<!--- Proper url. --->
				<cfreturn THIS
					.NewRequest( LOCAL.Get.ResponseHeader.Location )
					.Get()
					/>
				
			<!--- Check for absolute-relative URLs. --->
			<cfelseif REFindNoCase( 
				"^[\\\/]", 
				LOCAL.Get.ResponseHeader.Location
				)>
				
				<!--- 
					With an absolute-relative URL, we need to 
					append the given location to the DOMAIN of 
					our current url.
				--->
				<cfreturn THIS
					.NewRequest( 
						REReplace(
							VARIABLES.Instance.RequestData.Url,
							"^(https?://[^/]+).*",
							"\1",
							"one"
							) & 
						LOCAL.Get.ResponseHeader.Location 
					)
					.Get()
					/>
			
			<cfelse>
				
				<!--- 
					Non-root url. We need to append the current 
					redirect url to our last URL for relative 
					path traversal.
				--->
				<cfreturn THIS
					.NewRequest( 
						GetDirectoryFromPath( VARIABLES.Instance.RequestData.Url ) & 
						LOCAL.Get.ResponseHeader.Location 
					)
					.Get()
					/>
					
			</cfif>
		
		<cfelse>
		
			<!--- 
				No redirect, so just return the current 
				request response object.
			--->
			<cfreturn LOCAL.Get />
			
		</cfif>
	</cffunction>
	
	
	<cffunction
		name="SetBody"
		access="public"
		returntype="any"
		output="false"
		hint="Sets the body data of next request. Returns THIS scope for method chaining.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="any"
			required="false"
			hint="The data body."
			/>
		
		<!--- Set parameter and return This reference. --->
		<cfreturn THIS.AddParam(
			Type = "Body",
			Name = "",
			Value = ARGUMENTS.Value
			) />
	</cffunction>
	
	
	<cffunction
		name="SetUserAgent"
		access="public"
		returntype="any"
		output="false"
		hint="Sets the user agent for next request. Returns THIS scope for method chaining.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="string"
			required="false"
			hint="The user agent that will be used on the subseqent page requests."
			/>
		
		<!--- Store value. --->
		<cfset VARIABLES.Instance.RequestData.UserAgent = ARGUMENTS.Value />
		
		<!--- Return This reference. --->
		<cfreturn THIS />
	</cffunction>
	
	
	<cffunction
		name="SetXml"
		access="public"
		returntype="any"
		output="false"
		hint="Sets the XML body data of next request. Returns THIS scope for method chaining.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="any"
			required="false"
			hint="The data body."
			/>
		
		<!--- Set parameter and return This reference. --->
		<cfreturn THIS.AddParam(
			Type = "Xml",
			Name = "",
			Value = ARGUMENTS.Value
			) />
	</cffunction>
		
	
	<cffunction 
		name="StoreResponseCookies"
		access="public"
		returntype="void"
		output="false"
		hint="This parses the response of a CFHttp call and puts the cookies into a struct.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Response"
			type="struct"
			required="true"
			hint="The response of a CFHttp call."
			/>
		
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
		
		<!--- 
			Create the default struct in which we will hold 
			the response cookies. This struct will contain structs
			and will be keyed on the name of the cookie to be set.
		--->
		<cfset LOCAL.Cookies = StructNew() />
		
		<!--- 
			Get a reference to the cookies that werew returned 
			from the page request. This will give us an numericly 
			indexed struct of cookie strings (which we will have
			to parse out for values). BUT, check to make sure
			that cookies were even sent in the response. If they
			were not, then there is not work to be done.	
		--->
		<cfif NOT StructKeyExists(
			ARGUMENTS.Response.ResponseHeader,
			"Set-Cookie"
			)>
		
			<!--- No cookies were send back so just return. --->
			<cfreturn />
		
		</cfif>
		
		
		<!--- 
			ASSERT: We know that cookie were returned in the page
			response and that they are available at the key, 
			"Set-Cookie" of the reponse header.
		--->
		
		
		<!--- 
			The cookies might be coming back as a struct or they
			might be coming back as a string. If there is only 
			ONE cookie being retunred, then it comes back as a 
			string. If that is the case, then re-store it as a 
			struct. 
		--->
		<cfif IsSimpleValue( ARGUMENTS.Response.ResponseHeader[ "Set-Cookie" ] )>
			
			<cfset LOCAL.ReturnedCookies = {} />
			<cfset LOCAL.ReturnedCookies[ 1 ] = ARGUMENTS.Response.ResponseHeader[ "Set-Cookie" ] />
			
		<cfelse>
		
			<!--- Get a reference to the cookies struct. --->
			<cfset LOCAL.ReturnedCookies = ARGUMENTS.Response.ResponseHeader[ "Set-Cookie" ] />
			
		</cfif>
		
		
		<!--- 
			At this point, we know that no matter how the 
			cookies came back, we have the cookies in a 
			structure of cookie values. 
		--->
		<cfloop
			item="LOCAL.CookieIndex"
			collection="#LOCAL.ReturnedCookies#">
			
			<!--- 
				As we loop through the cookie struct, get 
				the cookie string we want to parse.
			--->
			<cfset LOCAL.CookieString = LOCAL.ReturnedCookies[ LOCAL.CookieIndex ] />
			
			
			<!--- 
				For each of these cookie strings, we are going 
				to need to parse out the values. We can treate 
				the cookie string as a semi-colon delimited list.
			--->
			<cfloop
				index="LOCAL.Index"
				from="1"
				to="#ListLen( LOCAL.CookieString, ';' )#"
				step="1">
			
				<!--- Get the name-value pair. --->
				<cfset LOCAL.Pair = ListGetAt(
					LOCAL.CookieString,
					LOCAL.Index,
					";"
					) />			
			
				<!---
					Get the name as the first part of the pair 
					sepparated by the equals sign.
				--->
				<cfset LOCAL.Name = ListFirst( LOCAL.Pair, "=" ) />
			
				<!--- 
					Check to see if we have a value part. Not all
					cookies are going to send values of length, 
					which can throw off ColdFusion.
				--->
				<cfif (ListLen( LOCAL.Pair, "=" ) GT 1)>
				
					<!--- Grab the rest of the list. --->
					<cfset LOCAL.Value = ListRest( LOCAL.Pair, "=" ) />
				
				<cfelse>
				
					<!--- 
						Since ColdFusion did not find more than 
						one value in the list, just get the empty 
						string as the value.
					--->
					<cfset LOCAL.Value = "" />
				
				</cfif>
			
			
				<!--- 
					Now that we have the name-value data values, 
					we have to store them in the struct. If we 
					are looking at the first part of the cookie 
					string, this is going to be the name of the 
					cookie and it's struct index.
				--->
				<cfif (LOCAL.Index EQ 1)>
				
					<!---
						Create a new struct with this cookie's name
						as the key in the return cookie struct.
					--->
					<cfset LOCAL.Cookies[ LOCAL.Name ] = StructNew() />
					
					<!--- 
						Now that we have the struct in place, lets
						get a reference to it so that we can refer 
						to it in subseqent loops.
					--->
					<cfset LOCAL.Cookie = LOCAL.Cookies[ LOCAL.Name ] />
					
					
					<!--- Store the value of this cookie. --->
					<cfset LOCAL.Cookie.Value = LOCAL.Value />
				
				
					<!--- 
						Now, this cookie might have more than just
						the first name-value pair. Let's create an 
						additional attributes struct to hold those 
						values.
					--->
					<cfset LOCAL.Cookie.Attributes = StructNew() />
				
				<cfelse>
				
					<!--- 
						For all subseqent calls, just store the 
						name-value pair into the established 
						cookie's attributes strcut.
					--->
					<cfset LOCAL.Cookie.Attributes[ LOCAL.Name ] = LOCAL.Value />
					
				</cfif>
			
			</cfloop>
			
			
		</cfloop>	
		
		
		<!--- 
			Now that we have all the response cookies in a 
			struct, let's append those cookies to our internal 
			response cookies. 
		--->
		<cfset StructAppend( 
			VARIABLES.Instance.Cookies,
			LOCAL.Cookies
			) />
		
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
</cfcomponent>
