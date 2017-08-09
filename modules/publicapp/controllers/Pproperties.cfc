component extends="_main" output="false"
{
	function init()
	{
		super.init();
	}
	function index()
	{
		request.site.theme = "property-theme";
		property = model("Property").findAll(where="id = '#params.id#'");
		agent = model("User").findAll(where="id = '#property.createdby#'");

		if(url.containsKey("demo")) {
			agent = model("User").findAll(where="id = '1'");
		}

		photos = model("PropertyMediafile").findAll(where="modelid = '#params.id#' AND type = 'image' AND mediafiletype = 'property'",order="sortorder asc");
		dataFieldsMap = dataFieldsToMap(3,params.id,"propertyfield");
	}

	function dataFieldsToMap(modelid,oreignid,metafieldType) {
		var dataFields = model("FieldData").getAllFieldsAndUserData(
			modelid = modelid,
			foreignid = oreignid,
			metafieldType = metafieldType
		);
		var dataFieldMap = {};
		for(var dataField in dataFields) {
			dataFieldMap[dataField.identifier] = dataField.fielddata;
		}
		return dataFieldMap;
	}

	function panoJson() {

		var result = {
			"default": {

		        "sceneFadeDuration": 1000,

		        "hotSpotDebug": true,

			    "type": "equirectangular",

			    "showFullscreenCtrl": false,

			    "autoLoad": params.containsKey("editorUrls"),
			    "autoRotate": -2
			},

			"scenes": {}

		};

		var mediafiles = model("PanoramaMediafile").findAll(where="modelid = '#params.id#' AND mediafileType = 'panorama'",order="sortorder");

		for(var mediafile in mediafiles) {
			var panoPath = "/assets/uploads/mediafiles/#mediafile.fileid#-lg.jpg";
	        var panoPathMobile = "/assets/uploads/mediafiles/#mediafile.fileid#-mobile.jpg";
	        resizeImage(panoPath,panoPathMobile,4096);

	        if(!result.default.containsKey("firstScene") AND !params.containsKey("editorUrls")) {
	        	result.default["firstScene"] = mediafile.fileid;
	        } else if (params.containsKey("editorUrls") AND params.editorUrls eq mediafile.id) {
	        	result.default["firstScene"] = mediafile.fileid;
	        }

			result.scenes[mediafile.fileid] = {
	            "title": "#mediafile.name#",
	            "yaw": 117,
	            "type": "equirectangular",
	            "panorama": "#isMobile() ? panoPathMobile : panoPath#",
	            "hotSpots": []
	        };

	        var panoInfo = ImageNew(expandPath(panoPath));

	        if(ImageGetWidth(panoInfo)/imageGetHeight(panoInfo) GT 4) {
	        	structAppend(result.scenes[mediafile.fileid], {
				 	"vaov": 73,

				    "minHfov": 73,
				    "maxHfov": 99,

				    "minPitch": 0,
				    "maxPitch": 0.1,

				    "minYaw": -360,
				    "maxYaw": 360
				});
	        }

	        if(isJson(mediafile.settings) AND isArray(deserializeJSON(mediafile.settings))) {
	        	var hotspots = deserializeJSON(mediafile.settings);
	        	for(var hotspot in hotspots) {
	        		var hotspotSet = {
	        			"yaw": hotspot.yaw,
	                    "pitch": 0,
	                    "text": hotspot.containsKey("caption") && len(hotspot.caption) ? hotspot.caption : "View"
	        		};

	        		if(hotspot.containsKey("type") AND hotspot.type eq "photo") {
	        			hotspotSet["URL"] = "javascript:showPhoto('/assets/uploads/mediafiles/#hotspot.fileid#-xm.jpg','#hotspot.containsKey("caption") && len(hotspot.caption) ? hotspot.caption : "Photo"#');";
						hotspotSet["type"] = "info";
	        		} else if(params.containsKey("editorUrls")) {
	        			hotspotSet["URL"] = "/m/admin/properties/panoeditor/#hotspot.mediafileid#?propertyid=#mediafile.modelid#";
						hotspotSet["type"] = "info";
	        		} else {
	        			hotspotSet["sceneId"] = hotspot.fileid;
	        			hotspotSet["type"] = "scene";
	        		}

	        		arrayAppend(result.scenes[mediafile.fileid].hotSpots,hotspotSet);
	        	}
	        }
		}

		var response = getPageContext().getResponse();
		response.setContentType("application/json");
		writeOutput(serializeJSON(result)); abort;
	}

	function resizeImage(string inputPath,string outputPath,numeric width=4096) {
		try {
			if(fileExists(expandPath(inputPath)) && !fileExists(expandPath(outputPath))) {
	            // args = "#expandPath(inputPath)# -resize #width# #expandPath(outputPath)#";
	            // execute variable="result" name="/usr/bin/convert" timeout="60" arguments=args;

	            var img = imageRead(expandPath(inputPath));
				ImageResize(img, width, "");
				imageWrite(img, expandPath(outputPath), 1);
            }
        } catch(any e) {writeDump(e); abort; }
	}

}
