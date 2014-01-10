<cfprocessingdirective pageencoding="utf-8">
<!--- ************************************************************************************ --->
<!--- Add User Authentication here                                                         --->
<!---<cfif not StructKeyExists(session,'userid')><cfabort></cfif>                          --->
<!--- ************************************************************************************ --->

<cfparam name="form.path" default="">
<cfparam name="form.file" default="">
<cfinclude template="settings.cfm">

<!--- ************************************************************ --->
<!--- path first position is a friendly name, like [home]. ignore  --->
<!--- ************************************************************ --->
<cfset form.path	= "/#ListDeleteAt(form.path,1,'/\')#">

<!--- ************************************************************ --->
<!--- thumb / medium and full size images saved in three folders   --->
<!--- ************************************************************ --->
<cfset filepath		= "#settings.UserFiles##form.path#">
<cfset midpath		= "#settings.UserFiles#/_middle#form.path#">
<cfset thumbpath	= "#settings.UserFiles#/_thumb#form.path#">

<!--- ************************************************************ --->
<!--- check & create system folders. these store image versions    --->
<!--- ************************************************************ --->
<cfif not DirectoryExists(filepath)>
	<cfdirectory action	="create" mode = "#settings.chomd#" directory ="#filepath#">
</cfif>
<cfif not DirectoryExists(midpath)>
	<cfdirectory action	="create" mode = "#settings.chomd#" directory ="#midpath#">
</cfif>
<cfif not DirectoryExists(thumbpath)>
	<cfdirectory action	="create" mode = "#settings.chomd#" directory ="#thumbpath#">
</cfif>

<cfif listfirst(server.coldfusion.productversion) gte 8>
	<cfparam name="types"	default="JPG,GIF,PNG,BMP">
<cfelse>
	<cfparam name="types"	default="jpg">
</cfif>

<cfif len(form.file)>
	<cffile
		action 			= "upload"
		filefield 		= "form.file" 
		nameconflict	= "makeunique"
		mode			= "#settings.chomd#"
		destination 	= "#filepath#">
	<!--- ************************************************************ --->
	<!--- Remove Disabled File Extensions                              --->
	<!--- ************************************************************ --->
	<cfif ListFindNoCase(settings.disfiles,file.clientFileExt)>
		<cffile action="delete" file="#filepath#/#cffile.serverFile#">
	</cfif>
	
	<!--- ************************************************************ --->
	<!--- images - make thumbnail and medium size images               --->
	<!--- ************************************************************ --->
	<cfif ListFindNoCase(types,file.clientFileExt)>
		<cfif listfirst(server.coldfusion.productversion) gte 8>
			<cfset myImage	= ImageRead('#filepath#/#cffile.serverFile#')>
			<cfset imginfo	= ImageInfo(myImage)>
			<cfif imginfo.width gt settings.middleSize OR imginfo.height gt settings.middleSize>
				<cfset ImageScaleToFit(myImage,settings.middleSize,settings.middleSize)>
				<cfset ImageWrite(myImage,'#midpath#/#cffile.serverFile#')>
			</cfif>
			<cfif imginfo.width gt settings.thumbSize OR imginfo.height gt settings.thumbSize>
				<cfset ImageScaleToFit(myImage,settings.thumbSize,settings.thumbSize)>
				<cfset ImageWrite(myImage,'#thumbpath#/#cffile.serverFile#')>
			</cfif>
		<cfelse>
			<cfset myImage = CreateObject("Component", "iedit")>
			<cfset myImage.SelectImage("#filepath#/#cffile.serverFile#")>
			<cfif myImage.getWidth() gt settings.middleSize OR myImage.getHeight() gt settings.middleSize>
				<cfset myImage.ScaletoFit(settings.middleSize,settings.middleSize)>
				<cfset myImage.output("#midpath#/#cffile.serverFile#", "jpg",100)>
			</cfif>
			<cfif myImage.getWidth() gt settings.thumbSize OR myImage.getHeight() gt settings.thumbSize>
				<cfset myImage.ScaletoFit(settings.thumbSize,settings.thumbSize)>
				<cfset myImage.output("#thumbpath#/#cffile.serverFile#", "jpg",100)>
			</cfif>
		</cfif>
	</cfif>
</cfif>

<script type="text/javascript">
	parent.fm.fmreturnhome()
</script>