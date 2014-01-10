<cfparam name="categories">
<cfparam name="category">
<cfoutput>
	
	<cfif !isNull(params.id)>
		#hiddenfieldtag(name='category[id]', value=params.id)#	
	</cfif>
	
	#btextfield(
		objectName 		= "category",
		property 		= 'name', 
		label 			= 'Name',
		placeholder 	= "Coolest #categoryInfo.singular# Ever"
	)#	
	
	#btextfield(
		prependedText	= '#cgi.server_name#/#lcase(categoryInfo.singularShort)#/',
		label			= "#categoryInfo.singular# URL",
		objectName 		= "category",
		property 		= 'urlid', 												
		placeholder	 	= "coolest-#lcase(categoryInfo.singularShort)#-ever",
		help 			= "This is name of the #categoryInfo.singular#'s url address (Can't be changed in the future)"
	)#	
	
	#btextarea(
		objectName 		= "category",
		property 		= 'description', 	
		label 		 	= "Description",
		help 			= "Shows on the #categoryInfo.singular# page"
	)#	
	
	<!--- <cfif !isNull(params.type) AND params.type eq "dropdown">
		#bselect(
			objectName 		= "category",
			property 		= "parentid",
			label			= 'Parent #categoryInfo.singular#',
			help			= 'Select #categoryInfo.singular# that you want this #categoryInfo.singular# to show up under',
			options			= categories,
			valueField 		= "id", 
			textField 		= "name"
		)#
	</cfif> --->
	
	<!--- Hide for now, use for multisites later --->
	<span style="display:none;">
		#bselect(
			objectName 		= 'category', 
			property 		= 'siteid', 
			label 			= 'Site',
			help			= "This determines which site that this #categoryInfo.singular# will show on",				
			options			= sites,
			valueField 		= "id", 
			textField 		= "name"
		)#
	</span>
	
</cfoutput>