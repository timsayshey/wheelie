<cfparam name="menus">
<cfparam name="menu">
<cfoutput> 
	
	<cfif !isNull(params.id)>
		#hiddenfieldtag(name='menu[id]', value=params.id)#	
	</cfif>
	
	#hiddenfieldtag(name="menu[menuid]", value="Primary")#		
	
	#btextfield(
		objectName 		= "menu",
		property 		= 'name', 
		label 			= 'Label',
		id 				= 'menuItemLabel',
		placeholder 	= "Coolest Menu Item Ever"
	)#	
	
	#bselect(
		label 		= 'Type',
		objectName 	= 'menu',
		property 	= 'itemType', 
		id 			= 'typeChooser',
		options		= [
			{text="Page",value="page"},
			{text="Post",value="post"},
			{text="Custom URL",value="custom"}
		]
	)#
	
	<div class="type-page" style="display:none;">
		#bselecttag(
			label 			= 'Page',
			name 			= 'menu[pageId]', 
			options			= pages,
			selected 		= menu.itemId,
			valueField 		= "id", 
			textField 		= "name"
		)#
	</div>
	
	<div class="type-post" style="display:none;">
		#bselecttag(
			label 			= 'Post',
			name 			= 'menu[postId]', 
			options			= posts,
			selected 		= menu.itemId,
			valueField 		= "id", 
			textField 		= "name"
		)#
	</div>
	
	<div class="type-custom" style="display:none;">
		#btextfield(
			label			= "Custom Url",
			objectName 		= "menu",
			property 		= 'customUrl', 												
			placeholder	 	= "http://"
		)#
	</div>	
	
</cfoutput>