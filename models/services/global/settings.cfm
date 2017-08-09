<cfscript>
	include template="/models/services/global/app/systemvars.cfm";
	application.runtimeconfig = setRuntimeSettings();

	// Initialize system settings
	sitecfg = application.runtimeconfig;

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
</cfscript>
