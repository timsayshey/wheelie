<cfoutput>
	<cfif !application.containsKey("archive")>
		<cfset oldpages = model("OldPage").findAll()>
		<cfsavecontent variable="archive">
			<ul>
				<cfloop query="oldpages">
					<li><a href="/#oldpages.pageurl#">#oldpages.title#</a></li>
				</cfloop>
			</ul>	
		</cfsavecontent>
		<cfset application.archive = archive>
	</cfif>
	#application.archive#
	
</cfoutput>