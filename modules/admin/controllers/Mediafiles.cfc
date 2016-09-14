<cfscript>
component extends="_main" output="false" 
{
	function init() 
	{
		super.init();		
	}
	
	function getMediafileType()
	{
		if(ListFindNoCase("propertyMediafile,panoramaMediafile",trim(params.modelName)))
		{
			return params.modelName;
		} else {
			throw('model is not in whitelist. #params.modelName# not valid.');
		}
	}

	function updateSorting()
	{
		var sortOrder = 0;
		for(var id in params.orderValues) {
			var mediafile = model(getMediafileType()).findOne(where="fileid = '#id#'");
			if(isObject(mediafile))
			{
				mediafile.update(sortorder=sortOrder++,validate=false);
			}
		}

		getpagecontext().getresponse().setcontenttype('application/json');
		writeOutput(serializeJSON({"success":true})); abort;
	}

	function uploadMedia()
	{
		var data = {};

		if(!isNull(form.file) AND len(form.file) AND FileExists(form.file))
		{								
			var imageid = CreateUUID();
			if(uploadImage("file",imageid))
			{
				data.fileid = imageid;
				data.type = "image";
				data.modelid = params.modelid;
			}
		}

		var savemediafile = model(getMediafileType()).new(data);
		var saveResult = savemediafile.save();

		if(arrayLen(savemediafile.allErrors())) {
			writeDump([data,savemediafile.allErrors()]); abort;
		}

		getpagecontext().getresponse().setcontenttype('application/json');
		writeOutput(serializeJSON({"success":true})); abort;
	}

	function uploadImage(field,filename,nonfieldpath)
	{
		var loc = {};
		
		if(!isNull(arguments.filename))
		{				
			if(arguments.containsKey("field")) {
				var result = fileUpload(getTempDirectory(),arguments.field, "image/*", "makeUnique");
				var theFile = result.serverdirectory & "/" & result.serverFile;
			}else {
				var result.fileWasSaved = true;
				var theFile = nonfieldpath;
			}

			if(result.fileWasSaved) {
				var thumbFile = expandPath("/assets/uploads/properties/#arguments.filename#-thumb.jpg");
				var smFile = expandPath("/assets/uploads/properties/#arguments.filename#-sm.jpg");
				var mdFile = expandPath("/assets/uploads/properties/#arguments.filename#-md.jpg");
				var xmFile = expandPath("/assets/uploads/properties/#arguments.filename#-xm.jpg"); // xtra medium
				var lgFile = expandPath("/assets/uploads/properties/#arguments.filename#-lg.jpg");
				
				if(!isImageFile(thefile)) {
					fileDelete(theFile);
					return false;
				} else {			
					try {
						fileDelete(thumbFile);
						fileDelete(smFile);
						fileDelete(mdFile);
						fileDelete(xmFile);
						fileDelete(lgFile);
					}catch(any e) {}	
					var img = imageRead(thefile);
					try {						
						imageWrite(img,lgFile,1);

						ImageResize(img, 1200, "");
						imageWrite(img,xmFile,1);
						
						imageScaleToFit(img, 900, "");
						imageWrite(img,mdFile,1);
						
						imageScaleToFit(img, 322, 322);
						ImageCrop(img,0,0,290,190);
						imageWrite(img,smFile,1);

						ImageCrop(img,0,0,180,180);
						imageWrite(img,thumbFile,1);
						
						fileDelete(theFile);
					} catch(e) {
						writeDump(e); abort;
						flashInsert(error="There was an issue with the image you tried to upload. Try uploading a JPG.");
						return false;
					}
					return true;
				}
			} 						
		}
		return false;
	}
	
	function sharedData()
	{
		mediafileInfo = model(getMediafileType()).mediafileInfo();
		mediafileType = getMediafileType();
		
		if(!isNull(params.modelid))
		{
			buttonParams = "modelid=#params.modelid#";
		}
		else if (!isNull(params.id))
		{
			buttonParams = "modelid=#params.id#";
		}
		else
		{
			buttonParams = "";	
		}
	}
	
	function index()
	{	
		sharedData();
		
		if(!isNull(params.modelid))
		{	
			mediafiles = model(getMediafileType()).findAll(where="modelid = #params.modelid# AND mediafileType = '#getMediafileType()#'", order="sortorder ASC");
		}
	}	
	
	function updateOrder()
	{
		orderValues = DeserializeJSON(params.orderValues);
				
		for(i=1; i LTE ArrayLen(orderValues); i = i + 1)
		{
			Value = orderValues[i];
			
			mediafile = model(getMediafileType()).findOne(where="id = #Value.Id#");
					
			if(isObject(mediafile))
			{
				mediafile.update(sortorder=Value.newIndex,validate=false);
			}
		}
		abort;
	}
	
	function toggleRecord()
	{
		var loc = {};
		mediafiles = model(getMediafileType()).findByKey(params.id);
		if(mediafiles[params.col] eq 1)
		{
			loc.toggleValue = 0;
		} else {
			loc.toggleValue = 1;
		}
		
		loc.newInsert = StructNew();
		StructInsert(loc.newInsert,params.col,loc.toggleValue);
		mediafiles.update(loc.newInsert);		
		
		flashInsert(success="Mediafiles updated successfully.");
		redirectTo(
			route		= "admin~Mediafile",
			controller	= "mediafiles",
			action		= "index",
			modelName	= params.modelName, 
			params		= buttonParams
		);
	}
	
	function new()
	{
		sharedData();
		
		// Queries
		mediafile = model(getMediafileType()).new(colStruct(getMediafileType()));
		
		// If not allowed redirect
		wherePermission("Mediafile");
		
		// Show meta
		renderPage(action="editor");
	}
	
	function edit()
	{						
		sharedData();
		
		if(isDefined("params.id")) 
		{
			// Queries
			mediafile = model(getMediafileType()).findAll(where="id = '#params.id#'#wherePermission("Mediafile","AND")#", maxRows=1, returnAs="Object");
			if(ArrayLen(mediafile))
			{				
				mediafile = mediafile[1];
			}
			
			// meta not found?
			if (!IsObject(mediafile))
			{
				flashInsert(error="Not found");
				redirectTo(
					route		= "admin~Mediafile",
					controller	= "mediafiles",
					action		= "index",
					modelName	= params.modelName, 
					params		= buttonParams
				);
			}			
		}
		
		renderPage(action="editor");		 
	}
	
	function save()
	{								
		sharedData();
		
		// Get mediafile object
		if(!isNull(params.mediafile.id)) 
		{
			mediafile = model(getMediafileType()).findByKey(params.mediafile.id);
			saveResult = mediafile.update(params.mediafile);
		} else {
			mediafile = model(getMediafileType()).new(params.mediafile);
			saveResult = mediafile.save();
			isNewMediafile = true;
		}

		if (saveResult){	
			response = {"success":true,"msg":""};						
		} else {						
			response = {"success":false,"msg":""};		
		}

		getpagecontext().getresponse().setcontenttype('application/json');
		writeOutput(serializeJSON(response)); abort;
	}
	
	function delete()
	{				
		var mediafile = model(getMediafileType()).findOne(where="fileid = '#params.fileid#'");
		var response = {};

		if(IsObject(mediafile) && mediafile.delete())
		{
			response = {"success":true,"msg":"The media was deleted successfully."};							
		} else {
			response = {"success":false,"msg":"The media could not be found."};
		}
				
		getpagecontext().getresponse().setcontenttype('application/json');
		writeOutput(serializeJSON(response)); abort;
	}
}
</cfscript>