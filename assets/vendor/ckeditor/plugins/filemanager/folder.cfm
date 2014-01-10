<cfprocessingdirective pageEncoding="utf-8">
<!--- ************************************************************************************ --->
<!--- Add User Authentication here                                                         --->
<!---<cfif not StructKeyExists(session,'userid')><cfabort></cfif>                          --->
<!--- ************************************************************************************ --->

<cfparam name="form.path" 	default="">
<cfparam name="form.folder" default="">

<cfinclude template="settings.cfm">
<!--- ************************************************************ --->
<!--- path first position is a friendly name, like [home]. ignore  --->
<!--- ************************************************************ --->
<cfset form.path	= "/#ListDeleteAt(form.path,1,'/\')#">

<cfif len(trim(form.folder))>
<cfset dirpath		= "#settings.UserFiles##form.path#/#form.folder#">
<cfif not DirectoryExists(dirpath)>
	<cfdirectory directory="#dirpath#" action="create" mode="#settings.chomd#">
</cfif>

<script type="text/javascript">
	parent.fm.fmreturnhome()
</script>
</cfif>