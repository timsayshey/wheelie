<cfscript>
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
			structAppend(application.runtimeconfig, createObject('java','java.lang.System').getenv(), false);
		}
		return application.runtimeconfig;
	}
</cfscript>
