<cfscript>

	string function generateMetaDescription( string description="" )
	{
		return Left( Trim( replaceMultipleSpacesWithSingleSpace( removeUnrequiredCharacters( stripHTML( arguments.description ) ) ) ), 200 );
	}
	
	string function generateMetaKeywords( string keywords="" )
	{
		return Left( replaceMultipleSpacesWithSingleSpace( removeUnrequiredCharacters( listDeleteDuplicatesNoCase( ListChangeDelims( removeNonKeywords( stripHTML( arguments.keywords ) ), ",", " ." ) ) ) ), 200 );
	}
	
	string function generatePageTitle(required string pagetitle )
	{
		return Left( stripHTML( arguments.pagetitle ), 100 );
	}
	
	string function stripHTML( required string thestring )
	{
		return Trim( replaceMultipleSpacesWithSingleSpace( REReplaceNoCase( arguments.thestring, "<[^>]{1,}>", " ", "all" ) ) );
	}
	
	string function replaceMultipleSpacesWithSingleSpace( required string thestring )
	{
		return Trim( REReplaceNoCase( arguments.thestring, "\s{2,}", " ", "all" ) );
	}
	
	string function removeUnrequiredCharacters( required string thestring )
	{
		return replaceMultipleSpacesWithSingleSpace( REReplaceNoCase( arguments.thestring, "([#Chr(09)#-#Chr(30)#])", " ", "all" ) );
	}
	
	string function removeNonKeywords( required string thestring )
	{
		var elements = ListToArray( arguments.thestring, " " );
		var newstring = "";
		for( element in elements ){
			if( !ListFindNoCase( "&,a,an,and,are,as,i,if,in,is,it,that,the,this,it,to,of,on,or,us,we", element ) ){
				newstring = ListAppend( newstring, element, " " );
			}
		}
		return Trim( Replace( newstring, ".", "", "all" ) );
	}
	
	string function listDeleteDuplicatesNoCase( required string thelist, string delimiter="," )
	{
		var elements = ListToArray( arguments.thelist, arguments.delimiter );
		elements = CreateObject( "java", "java.util.HashSet" ).init( elements ).toArray();
		return ArrayToList( elements );
	}

</cfscript>