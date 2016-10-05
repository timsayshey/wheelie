<cfparam name="categories">
<cfparam name="category">
<cfoutput>

	<div class="col-sm-12">	
	
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
			prependedText	= '#cgi.HTTP_HOST#/#lcase(categoryInfo.singularShort)#/', 
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
	
	</div>
							
	<div class="col-sm-6 ">	
		#bcheckbox(
			objectName	= 'category', 
			property	= "defaultpublic",
			help		= "If checked, this category will be set as the default public facing category",
			label		= "Default Public Category?"
		)#
	</div>
					
	<div class="col-sm-6 ">	
		#bcheckbox(
			objectName	= 'category', 
			property	= "defaultadmin",
			help		= "If checked, this category will be set as the default admin facing category",
			label		= "Default Admin Category?"
		)#
	</div>
	
	<br class="clear">
	
</cfoutput>