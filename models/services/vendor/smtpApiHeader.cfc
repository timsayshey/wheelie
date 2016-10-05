<cfscript>
// Github won't syntax highlight this unless I wrap it in cfscript..bleh
component {
	

	public smtpApiHeader function init() {
		variables.data = {};

		return this;
	}

	public void function addTo( required addresses ) {

		if( !isDefined( 'variables.data.to' ) ) {
			variables.data['to'] = [];
		}
		
		if( isArray( arguments.addresses ) ) {
			variables.data.to = arrayMerge( arguments.addresses, variables.data.to );
		} else {
			arrayAppend( variables.data.to, arguments.addresses );
		}

	}

	public void function addSubVal( required string key, required array values ) {

		if( !isDefined( 'variables.data.sub' ) ) {
			variables.data['sub'] = {};
		}
		
		if( !isArray( 'variables.data.sub["#arguments.key#"]' ) ){
			variables.data.sub["#arguments.key#"] = [];
		}

		variables.data.sub["#arguments.key#"] = arrayMerge( variables.data.sub["#arguments.key#"], arguments.values  );

	}

	public void function setUniqueArgs( required struct values ) {
		
		variables.data['unique_args'] = arguments.values;

	}

	public void function setCategory( required string category ) {
		
		variables.data['category'] = arguments.category;

	}

	public void function addFilterSetting( filter, setting, value ) {
		
		if( !isDefined( 'variables.data.filters' ) ) {
			variables.data['filters'] = {};
		}

		if( !isStruct( 'variables.data.filters["#arguments.filter#"]' ) ) {
			variables.data['filters']["#arguments.filter#"] = {};
		}

		if( !isStruct( 'variables.data.filters["#arguments.filter#"]["settings"]' ) ) {
			variables.data['filters']["#arguments.filter#"]['settings'] = {};
		}

		variables.data['filters']["#arguments.filter#"]['settings']["#arguments.setting#"] = arguments.value;

	}

	/**
	 *	Appends array2 to the bottom of array1
	 */
	private array function arrayMerge( required array array1, required array array2  ) {
		var i = '';

		for( i = 1; i LTE arrayLen( arguments.array2 ); i++ ) {
			arrayAppend( arguments.array1, arguments.array2[i] );
		}

		return arguments.array1;
	}

	public string function asJSON() {
		var json = serializeJSON( variables.data );

		// Adds spaces so that if the string wraps, data isn't broken.
		json = reReplace( json, '(["\]}])([,:])(["\[{])', '\1\2 \3', 'all' );

		return json;
	}

	public string function asString() {
		var json = asJSON();
		var str = 'X-SMTPAPI: ' & wrap( json, 76 );

		return str;
	}

}
</cfscript>