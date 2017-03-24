<cfscript>
	// Initialize system settings
	sitecfg = setRuntimeSettings();

	application.wheels.reloadPassword 	= getSiteSetting("wheelsReloadPassword","wheelie");
	application.wheels.dataSourceName	= getSiteSetting("wheelsdataSourceName","wheelie");

	application.wheels.youtubeDevKey	= getSiteSetting("youtubeDevKey");
	application.wheels.stripeKey		= getSiteSetting("stripeKey");
	application.wheels.passwordSalt		= getSiteSetting("passwordSalt","OkIeKNKoIvbZMFPuMJ3EMQ==");
	/* AES HEX Key // passcrypt(type="generateKey"); */

	include template="/views/setup/check.cfm";

	if(sitecfg.containsKey("s3enabled") && sitecfg.s3enabled) {

		application.s3 = {
			"accessKeyId" : sitecfg.s3accessKeyId, 
			"awsSecretKey" : sitecfg.s3awsSecretKey,
			"defaultLocation" : sitecfg.s3defaultLocation,
			"host" : sitecfg.s3host
		};
		application.s3info = {
			"defaultBucket" : sitecfg.s3defaultBucket
		};
	}
	
	application.wheels.defaultEmail			= getSiteSetting("defaultEmail");	
	application.wheels.noReplyEmail			= getSiteSetting("noReplyEmail");	
	application.wheels.adminEmail			= application.wheels.defaultEmail;
	application.wheels.errorEmailAddress	= application.wheels.defaultEmail;
	application.wheels.adminFromEmail		= application.wheels.noReplyEmail;	

	application.wheels.sendEmailOnError		= getSiteSetting("wheelsSendEmailOnError",true);
	application.wheels.urlRewriting			= getSiteSetting("wheelsUrlRewriting","on");
	application.wheels.rewriteFile 			= getSiteSetting("wheelsRewriteFile","index.cfm");

	function getSiteSetting(required string name,string default="") {
		return application.runtimeconfig.containsKey(name) ? application.runtimeconfig[name] : arguments.default;
	}
	function setRuntimeSettings() {
		if(!application.containsKey("runtimeconfig") OR !isNull(url.reload)) {
			application.runtimeconfig = {};	

			// Location to your properties file
			var pFile = expandPath('config/system.properties');
			// Init Props
			var props = CreateObject("java","java.util.Properties").init();
			// Load the file into the props
			props.load( CreateObject("java","java.io.FileInputStream").init(pFile) );
			props = Duplicate(props);

			for(var key in listToArray(structKeyList(props))) application.runtimeconfig[key] = props[key];
		}
		return application.runtimeconfig;
	}
</cfscript>