<cfoutput>
	<cfif !isNull(params.id)>
		<cfset isNew = false>
	<cfelse>
		<cfset isNew = true>
	</cfif> 

	<cfif !isNew>
		<script src="/views/layouts/admin/assets/js/category.js" type="text/javascript"></script>
		<script src="/assets/vendor/jquery.simplyCountable.js" type="text/javascript"></script>
		<script type="text/javascript">
			$(function(){
				$('##aboutlimit').simplyCountable({
					counter: '##aboutcounter',
					maxCount: 2255,
					strictMax: true
				});
			});
		</script>
	</cfif>
    
	<!--- For category.js --->
	#hiddenfieldtag(name="categoryController", id="categoryController", value="propertyCategories")#	
	#hiddenfieldtag(name="categoryModel", id="categoryModel", value="propertyCategory")#	
	#hiddenFieldTag(name="addCategoryType", id="addCategoryType", value="dropdown")#
    
	<cfset contentFor(formy			= true)>
    
	<cfif isNull(params.id)>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-property"></span> Add Property')>
	<cfelse>
		<cfset contentFor(headerTitle	= '<span class="elusive icon-property"></span> Edit Property')>
	</cfif>
    
    <cfset contentFor(headerButtons = 
		'<li class="headertab">			
			#linkTo(
				text		= '<span class=''elusive icon-arrow-left''></span> Back to Properties',
				route		= "admin~Action", 
                controller	= "properties", 
                action		= "index",
				class		= 'btn btn-default'
			)#
			<a class="btn btn-default" target="_blank" href="//#property.urlid#.propertylure.com"><span class="elusive icon-eye-open"></span> Preview</a>
		  </li>')>

	<cfif !isNew>
        #hiddenfield(objectName='property', property='id', id="propertyid")#
        #hiddenFieldTag("id",params.id)#

        <div class="col-sm-6">	
			#bselect(
				label		= 'Home Status',
				objectName 	= 'property',
				property 	= 'home_status',
				options		= [
					{text="For Sale",value="For Sale"},
					{text="Pending",value="Pending"},
					{text="Sold",value="Sold"}
				]
			)#
		</div>

	    <div class="col-sm-6">	
			#bselect(
				label		= 'Home Type',
				objectName 	= 'property',
				property 	= 'home_type',
				options		= [
					{text='Single family',value='Single family'},
					{text='Condo',value='Condo'},
					{text='Townhouse',value='Townhouse'},
					{text='Multi family',value='Multi family'},
					{text='Apartment',value='Apartment'},
					{text='Mobile / Manufactured',value='Mobile / Manufactured'},
					{text='Coop Unit',value='Coop Unit'},
					{text='Vacant land',value='Vacant land'},
					{text='Other',value='Other'}
				]
			)#
		</div>

	    <div class="col-sm-6 ">	   
	        #btextfield(
				objectName	= 'property', 
				property	= 'price', 
				label		= 'Price',
				placeholder	= "Ex: 175000"
			)#
		</div> 

		<div class="col-sm-6 ">	   
	        #btextfield(
				objectName	= 'property', 
				property	= 'phone_number', 
				label		= 'Phone',
				placeholder	= "Ex: 555-555-5555"
			)#
		</div> 

		#includePartial(partial="/_partials/formSeperator")#
    </cfif>

    <div class="col-sm-12">	
		#btextfield(
			objectName	= 'property', 
			property	= 'name', 
			label		= 'Property Name',
			placeholder	= "Ex: Stunning Home For Sale"
		)#
    </div> 
    <div class="col-sm-6">	
		#btextfield(
			objectName	= 'property', 
			property	= 'address', 
			label		= 'Street',
			placeholder	= "Ex: 123 Hampton Bay Rd"
		)#
    </div>

    <div class="col-sm-6">	
		#btextfield(
			objectName	= 'property', 
			property	= 'city', 
			label		= 'City',
			placeholder	= "Ex: Lake Ozark"
		)#
    </div>

    <div class="col-sm-6">	
		#btextfield(
			objectName	= 'property', 
			property	= 'state', 
			label		= 'State',
			placeholder	= "Ex: MO"
		)#
    </div>

    <div class="col-sm-6">	
		#btextfield(
			objectName	= 'property', 
			property	= 'zip', 
			label		= 'Zip',
			placeholder	= "Ex: 65049"
		)#
    </div>

	<cfif isNew>
		<br class="clear">
	<cfelse>

		#includePartial(partial="/_partials/formSeperator")#

	    <link rel="stylesheet" href="/assets/vendor/dropzone/dropzone.css">
		<script src="/assets/vendor/dropzone/dropzone.js" type="text/javascript"></script>
		<link href="/assets/vendor/sortpics/base.css" rel="stylesheet">
		<script src="/views/layouts/admin/assets/js/mediafile.js" type="text/javascript"></script>
		<script>
			window.mediaSettings = {
				"upload_endpoint":"#urlFor(
					route		= "admin~Mediafile",
					action		= "uploadMedia",
					modelName	= "propertyMediafile",
					params 		= "modelid=#params.id#"
				)#",
				"sorting_endpoint":"#urlFor(
					route		= "admin~Mediafile",
					action		= "updateSorting",
					modelName	= "propertyMediafile",
					params 		= "modelid=#params.id#"
				)#",
				"delete_endpoint":"#urlFor(
					route		= "admin~Mediafile",
					action		= "delete",
					modelName	= "propertyMediafile",
					params 		= "modelid=#params.id#"
				)#",
				"update_endpoint":"#urlFor(
					route		= "admin~Mediafile",
					action		= "save",
					modelName	= "propertyMediafile",
					params 		= "modelid=#params.id#"
				)#",
				"photos_endpoint":"#urlFor(
					route="admin~Id", 
					controller="properties", 
					action="photos",
					id=params.id
				)#"
			};
		</script>

	    <a data-toggle="modal" href="##mediaModal" class="btn btn-primary">Add Photos</a>
	    <a data-toggle="modal" href="#urlFor(
	    		route		= "admin~Id", 
	            controller	= "properties", 
	            action		= "panoedit",
	            id 			= property.id
			)#" class="btn btn-danger pull-right">360° Virtual Tour Builder</a><br><br>

		<div id="photos"></div>
	    
	    <br>
	    Note: First image is cover image.<br>

		#includePartial(partial="/_partials/formSeperator")#
		
	    <div class="col-sm-6">	
			#btextfield(
				objectName	= 'property', 
				property	= 'video_walkthrough_url', 
				label		= 'Video Walkthrough URL',
				placeholder	= 'http://'
			)#
		</div>

	    <div class="col-sm-6">	
			#btextfield(
				objectName	= 'property', 
				property	= 'virtual_tour_url', 
				label		= 'Virtual Tour URL',
				placeholder	= 'http://'
			)#
		</div>

		<div class="col-sm-6">	
			#btextfield(
				objectName	= 'property', 
				property	= 'related_website', 
				label		= 'Related Website',
				placeholder	= 'http://'
			)#
		</div>

		#includePartial(partial="/_partials/formSeperator")#

	    <div class="col-sm-6">	
			#btextfield(
				objectName	= 'property', 
				property	= 'total_rooms', 
				label		= 'Total Rooms',
				placeholder	= 'Ex: 5'
			)#
		</div>

	    <div class="col-sm-6">	
			#btextfield(
				objectName	= 'property', 
				property	= 'beds', 
				label		= 'Beds',
				placeholder	= 'Ex: 3'
			)#
		</div>

		<div class="col-sm-3">	
			#btextfield(
				objectName	= 'property', 
				property	= 'full_baths', 
				label		= 'Full Baths',
				placeholder	= 'Ex: 2'
			)#
		</div>

		 <div class="col-sm-3">	
			#btextfield(
				objectName	= 'property', 
				property	= 'half_baths', 
				label		= '1/2 Baths',
				placeholder	= 'Ex: 1'
			)#
		</div>

	    <div class="col-sm-3">	
			#btextfield(
				objectName	= 'property', 
				property	= 'three_quarter_baths', 
				label		= '3/4 Baths',
				placeholder	= 'Ex: 1'
			)#
		</div>  

	    <div class="col-sm-3">	
			#btextfield(
				objectName	= 'property', 
				property	= 'quarter_baths', 
				label		= '1/4 Baths',
				placeholder	= 'Ex: 1'
			)#
		</div>

		 <div class="col-sm-6">	
			#btextfield(
				objectName	= 'property', 
				property	= 'finished_square_feet', 
				label		= 'Finished Square Feet',
				placeholder	= 'Ex: 2500'
			)#
		</div>

		<div class="col-sm-6">	
			#btextfield(
				objectName	= 'property', 
				property	= 'garage_square_feet', 
				label		= 'Garage Square Feet',
				placeholder	= 'Ex: 2500'
			)#
		</div>
		
	   <div class="col-sm-6">
		   <div class="row">	
				<div class="col-sm-12">	
					<label>Lot Size</label>
				</div>
				<div class="col-sm-6">	
					#btextfield(
						objectName	= 'property', 
						property	= 'lot_size'
					)#
				</div>
				<div class="col-sm-6">	
					#bselect(
						objectName 	= 'property',
						property 	= 'lot_size_type', 
						options		= [
							{text="Sq ft",value="Sq ft"},
							{text="Acres",value="Acres"}
						]
					)#
				</div>
			</div>
		</div>

		<div class="col-sm-6">	
			#btextfield(
				objectName	= 'property', 
				property	= 'hoa_dues', 
				label		= 'HOA Dues',
				placeholder	= 'Ex: $500'
			)#
		</div>

	    <div class="col-sm-6">	
			#btextfield(
				objectName	= 'property', 
				property	= 'year_built', 
				label		= 'Year Built',
				placeholder	= 'Ex: 1999'
			)#
		</div>

	    <div class="col-sm-6">	
			#btextfield(
				objectName	= 'property', 
				property	= 'structural_remodel_year', 
				label		= 'Structural Remodel Year',
				placeholder	= 'Ex: 2014'
			)#
		</div>

	    <div class="col-sm-6">	
			#btextfield(
				objectName	= 'property', 
				property	= 'number_of_stories', 
				label		= 'Number of Stories',
				placeholder	= 'Ex: 2'
			)#
		</div>

	    <div class="col-sm-6">	
			#btextfield(
				objectName	= 'property', 
				property	= 'covered_parking', 
				label		= '## Covered Parking',
				placeholder	= 'Ex: 2'
			)#
		</div>

	    <div class="col-sm-6">	
			#btextfield(
				objectName	= 'property', 
				property	= 'additional_features', 
				label		= 'Additional Features',
				placeholder	= 'Ex: Gold toilets, cat pool, etc.'
			)#
		</div>

		<div class="col-sm-12">
			<!--- Description --->
			#btextarea(
				objectName 		='property', 
				property 		='love_description', 	
				label 		 	= "Tell us what you love",
		        style			= "height:60px;"
			)#
		</div>		

		<div class="col-sm-12">
			<!--- Description --->
			#btextarea(
				objectName 		='property', 
				property 		='description', 	
				label 		 	= "Property Description",
				help 			= "Shows on the property page",
		        id				= "aboutlimit",
		        style			= "height:60px;"
			)#
			<span id="aboutcounter"></span> characters left	
		</div>	

		#includePartial(partial="/_partials/formSeperator")#	

		<!--- Get Custom Fields --->
		#includePartial(partial="/_partials/formFieldsRender")# 
		<br class="clear">

	</cfif>	
    
	<!--- Right area --->
	<cfsavecontent variable="submitBox">
		<div class="{{class-here}} data-block">
			<section>
				<div class="btn-group dropdown">
					<button type="submit" name="submit" value="save-continue" class="btn btn-primary">Save & continue</button>
					<button class="btn btn-primary dropdown-toggle" data-toggle="dropdown"><span class="caret"></span></button> 
					<ul class="dropdown-menu dropdown-blue pull-right">
						<li><button type="submit" name="submit" value="save" class="btn-linky">Save & exit</button></li>					
						<cfif !isNew><li><a href='#urlFor(route="moduleId", module="admin", controller="properties", action="delete", id=params.id)#' class="btn-danger">Trash it</a></li></cfif>
						<li><a href='#urlFor(route="moduleAction", module="admin", controller="properties", action="index")#'>Back to users</a></li>
					</ul>
				</div>
			</section>
		</div>
	</cfsavecontent>
	
	<cfsavecontent variable="rightColumn">
		<div class="rightbarinner">
		
			#includePartial(partial="/_partials/editorSubmitBox", controllerName="properties")#	

			<div class="data-block">
		        <section>
			        #bcheckbox(
			            objectName	= 'property', 
			            property	= "published",
			            help		= "If checked, this property will be visible on the website",
			            label		= "Is Published?"
			        )#
		        </section>
			</div>

			<cfif checkPermission("ismanager")>
				<div class="data-block">
					<section>	
						<h4>Admin Options</h4>
					    #bcheckbox(
					        objectName	= 'property', 
					        property	= "isfeatured",
					        help		= "If checked, this property will show up in the featured section",
					        label		= "Featured?"
					    )#

					    #bselecttag(
					        name			= "property[ownerid]",
					        selected		= isNumeric(property.ownerid) ? property.ownerid : session.user.id,
					        label			= 'Property Author',
					        options			= userlist,
					        valueField 		= "id", 
					        textField 		= "email",
					        includeBlank	= true
					    )#
					</section>
				</div>
			</cfif>
            
		</div>
		
		</div>

		<cfif !isNew>
			<div class="rightBottomBox  hidden-xs hidden-sm">
				#includePartial(partial="/_partials/editorSubmitBox", controllerName="properties", rightBottomClass="col-sm-3")#	
			</div> 
		</cfif>

		<div class="modal fade" id="mediaModal" tabindex="-1" role="dialog" aria-labelledby="mediaModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="mediaModalLabel">Upload Media</h4>
					</div>
					<div class="modal-body">								
					
						<div id="dZUpload" class="dropzone">
							<div class="dz-default dz-message">
								<span class="elusive icon-upload" style="font-size:60px"></span><br>
								Drop files here or click to upload.
							</div>
						</div>
																
					</div>
				</div>
			</div>
		</div> 

		<div class="modal fade" id="captionModal" tabindex="-1" role="dialog" aria-labelledby="captionModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="captionModalLabel">Edit Caption</h4>
					</div>
					<div class="modal-body">
						<input id="caption" data-id="" class="form-control"><br>
						<a href="javascript:void(0)" id="saveCaption" class="btn btn-primary">Save</a>
					</div>
				</div>
			</div>
		</div> 
		
	</cfsavecontent>
	
	<cfset contentFor(rightColumn = rightColumn)>		
	<cfset contentFor(formWrapStart = startFormTag(route="moduleAction", module="admin", controller="properties", action="save", enctype="multipart/form-data", id = "fileupload"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>		
			
	<script type="text/html" id="tmpl_menuListProperty">
		<li id="menu-<%=id%>" data-id="<%=id%>" class="sortable">						
			<div class="ns-row">
				<div class="ns-title"><%=name%></div>
				<div class="ns-actions">
					<a href="##" class="edit-menu" title="Edit"><span class="elusive icon-pencil"></span></a>
					<a href="##" class="delete-menu" title="Delete"><span class="elusive icon-trash"></span></a>							
				</div>
			</div>		
			<div class="ns-form">
				Name: <input type="text" name="propertyname" value="<%=name%>" />
				URL: <input type="text" name="urlpath" value="<%=id%>" />
				<input type="hidden" class="parentid" name="parentid" value="<%=parentid%>" />
				<input type="hidden" class="sortOrder" name="sortOrder" value="<%=sortOrder%>" />
			</div>
		</li>
	</script>
	
</cfoutput>





