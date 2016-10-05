<cfoutput>
    
	<cfset contentFor(headerTitle	= '<span class="elusive icon-property"></span> 360° Panorama')>
    
    <cfset contentFor(headerButtons = 
		'<li class="headertab">			
			#linkTo(
				text		= '<span class=''elusive icon-arrow-left''></span> Back to 360° Virtual Tour Builder',
				route		= "admin~Id", 
                controller	= "properties", 
                action		= "panoedit",
                id 			= property.id,
				class		= 'btn btn-default'
			)#
			<a class="btn btn-default" target="_blank" href="//#property.urlid#.propertylure.com"><span class="elusive icon-eye-open"></span> Preview</a>
		  </li>')>

        #hiddenfield(objectName='property', property='id', id="propertyid")#
        #hiddenFieldTag("id",params.id)#

		<script src="/views/layouts/admin/assets/js/panorama.js" type="text/javascript"></script>
		<link rel="stylesheet" href="/assets/vendor/pannellum/pannellum.css"/>
    	<script type="text/javascript" src="/assets/vendor/pannellum/pannellum.js"></script>

		<style>
			
			.panowrap {
				overflow: scroll;
				height: 500px;
				border:1px solid ##eee;
			}
			.panoimg {
				height: 490px;
				width:100%;
			}
			.panochoices {
			}
			.panochoices div {
				cursor: pointer;
				padding: 5px;
				border-bottom: 1px solid ##999;
			}
			.panochoices img {
				width:100%;
			}
		</style>
		<script>
			window.propertyid = #params.propertyid#;
			window.mediafileid = #params.id#;
			window.panoramaImg = "/assets/uploads/properties/#panorama.fileid#-lg.jpg";
			window.update_link_endpoint = "#urlFor(
				route 		= "admin~Id", 
				controller 	= "properties", 
				action 		= "updateLink",
				id  		= params.id
			)#";
			window.add_link_endpoint = "#urlFor(
				route 		= "admin~Id", 
				controller 	= "properties", 
				action 		= "addLink",
				id  		= params.id
			)#";
			window.remove_link_endpoint = "#urlFor(
				route 		= "admin~Id", 
				controller 	= "properties", 
				action 		= "removeLink",
				id  		= params.id
			)#";
			window.get_link_endpoint = "#urlFor(
				route 		= "admin~Id", 
				controller 	= "properties", 
				action 		= "panoLinks",
				id  		= params.id
			)#";
		</script>

		<b>Add Panorama Link:</b> Right click and accept<br><br>

		<div class="panowrap">
			<div class="main" id="panorama"></div>
		</div>

		<b>Current links:</b><br>

		<div id="links"></div>

		<div id="photos"></div>

		<div class="modal fade" id="LinkModal" tabindex="-1" role="dialog" aria-labelledby="LinkModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="LinkModalLabel">Add Link</h4>
					</div>
					<div class="modal-body">


						<ul class="nav nav-tabs">
						  <li class="active"><a data-toggle="tab" href="##home">360 Panoramas</a></li>
						  <li><a data-toggle="tab" href="##menu1">Photos</a></li>
						</ul>

						<div class="tab-content">
						  <div id="home" class="tab-pane fade in active">
						    <h3>360 Panoramas</h3>
						    <p>
						    	<div class="panochoices">
									<b>Choose panorama to link to:</b>
									<cfloop query="panoramas">
										<div id="#id#" data-childfileid="#fileid#" data-type="pano">
											<img src="/assets/uploads/properties/#fileid#-md.jpg"> #name#
										</div>	
									</cfloop>
								</div>
						    </p>
						  </div>
						  <div id="menu1" class="tab-pane fade">
						    <h3>Photos</h3>
						    <p>
						    	<div class="panochoices">
							    	<b>Choose photo to pop-up:</b>
									<cfloop query="photos">
										<div id="#id#" data-childfileid="#fileid#" data-type="photo">
											<img src="/assets/uploads/properties/#fileid#-sm.jpg"> #name#
										</div>	
									</cfloop>
								</div>
						    </p>
						  </div>
						</div>
						
					</div>
				</div>
			</div>
		</div>

		<script>
			function showPhoto(imgpath,caption) {
				$("##PhotoModal img").attr("src",imgpath);
				$("##PhotoModalLabel").text(caption);
				$('##PhotoModal').modal('show');
			}
		</script>
		<div class="modal fade" id="PhotoModal" tabindex="-1" role="dialog" aria-labelledby="PhotoModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="PhotoModalLabel">Photo</h4>
					</div>
					<div class="modal-body">
						<img width="100%" src="">						
					</div>
				</div>
			</div>
		</div>
		

	<!--- Right area --->
	<cfsavecontent variable="submitBox"></cfsavecontent>
	
	<cfsavecontent variable="rightColumn"></cfsavecontent>
	
	<cfset contentFor(rightColumn = rightColumn)>		
	<cfset contentFor(formWrapStart = startFormTag(route="moduleAction", module="admin", controller="properties", action="save", enctype="multipart/form-data", id = "fileupload"))>		
	<cfset contentFor(formWrapEnd = endFormTag())>		
	
</cfoutput>





