<cfoutput>
    
	<cfset contentFor(headerTitle	= '<span class="elusive icon-property"></span> 360° Virtual Tour Builder')>
    
    <cfset contentFor(headerButtons = 
		'<li class="headertab">			
			#linkTo(
				text		= '<span class=''elusive icon-arrow-left''></span> Back to Property',
				route		= "admin~Id", 
                controller	= "properties", 
                action		= "edit",
                id 			= property.id,
				class		= 'btn btn-default'
			)#
			<a class="btn btn-default" target="_blank" href="//#property.urlid#.propertylure.com"><span class="elusive icon-eye-open"></span> Preview</a>
		  </li>')>

        #hiddenfield(objectName='property', property='id', id="propertyid")#
        #hiddenFieldTag("id",params.id)#

	    <link rel="stylesheet" href="/assets/vendor/dropzone/dropzone.css">
		<script src="/assets/vendor/dropzone/dropzone.js" type="text/javascript"></script>
		<link href="/assets/vendor/sortpics/base.css" rel="stylesheet">
		<script src="/views/layouts/admin/assets/js/mediafile.js" type="text/javascript"></script>

		<style>
			ul.sortable li img {
			    width: 100%;
			}
			ul.sortable li {
			    height: auto;
			    width: 100%;
			}
			.modal-lg {
			    width: 80% !important;
			    margin:20px auto !important;
			}
			.panowrap {
				overflow: scroll;
				height: 500px;
				border:1px solid ##eee;
			}
			.panoimg {
				height: 490px;
				width:100%;
			}
		</style>
		<script>
			window.mediaSettings = {
				"upload_endpoint":"#urlFor(
					route		= "admin~Mediafile",
					action		= "uploadMedia",
					modelName	= "panoramaMediafile",
					params 		= "modelid=#params.id#"
				)#",
				"sorting_endpoint":"#urlFor(
					route		= "admin~Mediafile",
					action		= "updateSorting",
					modelName	= "panoramaMediafile",
					params 		= "modelid=#params.id#"
				)#",
				"delete_endpoint":"#urlFor(
					route		= "admin~Mediafile",
					action		= "delete",
					modelName	= "panoramaMediafile",
					params 		= "modelid=#params.id#"
				)#",
				"update_endpoint":"#urlFor(
					route		= "admin~Mediafile",
					action		= "save",
					modelName	= "panoramaMediafile",
					params 		= "modelid=#params.id#"
				)#",
				"photos_endpoint":"#urlFor(
					route 		= "admin~Id", 
					controller 	= "properties", 
					action 		= "panoramas",
					id  		= params.id
				)#"
			};
		</script>

		<b>Shoot your own 360° Virtual Tour photos!</b> Using <a href="https://play.google.com/store/apps/details?id=com.google.vr.cyclops&hl=en" target="_blank">this Android app</a> or <a href="https://itunes.apple.com/us/app/panorama-360/id1034161360?mt=8&ign-mpt=uo%3D4" target="_blank">this iPhone app</a> you can capture beautiful 360 panoramas and upload and link them together here<br><br>

	    <a data-toggle="modal" href="##mediaModal" class="btn btn-primary">Upload Panoramas</a><br><br>

		<div id="photos"></div>
		

	<!--- Right area --->
	<cfsavecontent variable="submitBox"></cfsavecontent>
	
	<cfsavecontent variable="rightColumn">

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
	
</cfoutput>





