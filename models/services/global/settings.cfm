<cfscript>
	include template="/models/services/global/app/systemvars.cfm";
	application.runtimeconfig = setRuntimeSettings();

	application.wheels.reloadPassword 	= getSiteSetting("WHEELIE_APPRELOADPASS","wheelie");
	application.wheels.dataSourceName	= getSiteSetting("WHEELIE_DATASOURCE","wheelie");

	application.wheels.youtubeDevKey	= getSiteSetting("youtubeDevKey");
	application.wheels.stripeKey		= getSiteSetting("stripeKey");
	application.wheels.passwordSalt		= getSiteSetting("WHEELIE_PASSWORDSALT","OkIeKNKoIvbZMFPuMJ3EMQ==");
	/* AES HEX Key // passcrypt(type="generateKey"); */

	sitecfg = application.runtimeconfig;
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

	application.wheels.defaultEmail			= getSiteSetting("WHEELIE_DEFAULTEMAIL");
	application.wheels.noReplyEmail			= getSiteSetting("WHEELIE_NOREPLYEMAIL");
	application.wheels.adminEmail			= getSiteSetting("WHEELIE_ADMINEMAIL");
	application.wheels.errorEmailAddress	= getSiteSetting("WHEELIE_ERROREMAILADDRESS");
	application.wheels.adminFromEmail		= getSiteSetting("WHEELIE_ADMINFROMEMAIL");

	application.wheels.sendEmailOnError		= getSiteSetting("WHEELIE_EMAILONERROR",true);
	application.wheels.urlRewriting			= getSiteSetting("WHEELIE_URLREWRITING","on");
	application.wheels.rewriteFile 			= getSiteSetting("WHEELIE_REWRITEFILE","index.cfm");
</cfscript>
