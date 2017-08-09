component extends="models.Model" output="false"
{
	function init()
	{
		table(false);
	}

	function save() {
		writeDump([this,arguments]); abort;
	}

	function create(){
		writeDump([this,arguments]); abort;
	}

	function update(){
		writeDump([this,arguments]); abort;
	}

	function delete() {
		writeDump([this,arguments]); abort;
	}
	function getAll(required type) {
		var result = {"success":false};

		cfhttp(method="GET", url="http://apiendpoint.com/#arguments.type#/", result="result") {
		    cfhttpparam(name="Authorization", type="header", value="key");
		}

		if(result.status_code eq 200 AND isJSON(result.filecontent)) {
			var json = deserializeJSON(result.filecontent);
			result["data"] = data;
			result["success"] = true;
			return result;
		}

		return result;
	}

}
