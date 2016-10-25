<cfsilent>

	<cffunction name="textFieldy">
		<cfargument name="label">
		<cfargument name="name">
		<cfargument name="colspan" default="4">
		<cfset request.fieldslist = ListAppend(request.fieldslist,arguments.name)>
		<cfset inputName = "#arguments.name#"> 	
		
		<cfoutput>
			<div class="col-#request.jobappColSize#-#arguments.colspan#">
				<cfif isNull(params.id)>
					#btextfieldtag(label='#arguments.label#', name='email[#inputName#]', value="#getFieldVal(inputName)#")#
				<cfelseif find("security",lcase(arguments.label)) AND !isNull(params.id)>
					<label>Social Security:</label><br>
					<cfset redirUrl = URLEncodedFormat("/m/admin/secure/jobssn?id=#params.id#")>
					<a href="http://#request.site.domain#/m/admin/users/login?redir=#redirUrl#">Access Securely</a>	
				<cfelse>
					<label>#arguments.label#</label><br>		
					#getFieldVal(inputName)#
					<div class="separator"></div>
				</cfif>
			</div>
		</cfoutput>
	</cffunction>
	
	<cffunction name="dateField">
		<cfargument name="label">
		<cfargument name="name">
		<cfargument name="selectedVal" default="">
		<cfset request.fieldslist = ListAppend(request.fieldslist,arguments.name)>
		<cfset inputName = "#arguments.name#">
		
		<cfoutput>
			<div class="col-#request.jobappColSize#-4">
				<cfif isNull(params.id)>		
					<label>#arguments.label#</label><br>			
					#dateSelectTags(
						name='email[#inputName#]',
						startYear="1950",
						class="dateSelect",
						includeBlank=true,
						selected=#len(arguments.selectedVal) ? arguments.selectedVal : now()#		
					)#	
					<div class="separator"></div>		
				<cfelseif IsDate(getFieldVal(inputName))>
					<label>#arguments.label#</label><br>		
					#DateFormat(getFieldVal(inputName),"MMMM D, YYYY")#
					<div class="separator"></div>
				</cfif>
			</div>
		</cfoutput>
	</cffunction>
	
	<cffunction name="yesOrNoField">
		<cfargument name="label">
		<cfargument name="name">
		<cfargument name="colspan" default="4">
		<cfset request.fieldslist = ListAppend(request.fieldslist,arguments.name)>
		<cfset inputName = "#arguments.name#">	
		
		<cfoutput>
			<div class="col-#request.jobappColSize#-#arguments.colspan#">			
				<cfif isNull(params.id)>		
					#bselecttag(
						label=arguments.label, 
						name='email[#inputName#]',
						options = [
							{text="", value=""},
							{text="Yes", value="Yes"},
							{text="No", value="No"}
						],
						selected=getFieldVal(inputName)
					)#		
				<cfelse>
					<label>#arguments.label#</label><br>		
					#getFieldVal(inputName)#
					<div class="separator"></div>
				</cfif>	
			</div>
		</cfoutput>
	</cffunction>

</cfsilent>