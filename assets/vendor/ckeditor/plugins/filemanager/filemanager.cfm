<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
	<link rel="stylesheet" type="text/css" href="style.css">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/1.10.2/jquery.min.js" type="text/javascript"></script>
	<script src="filemanager.js" type="text/javascript"></script>
<body>
<cfinclude template = "settings.cfm" />

<div id="fmtopbar"><span id="fmbreadcrumb" data-path="My Files"></span>
<img id="fmclose" src="images/close.png">
<div class="clear"></div>
</div>

<div id="toolbar">
	<img src="images/upload.gif" id="fmupload" class="fmtabslink" />
	<img src="images/newfolder.gif" id="fmdir" class="fmtabslink" />
	<img src="images/moveup.gif" id="moveup" class="fmtabslink" style="display:none" />
	<span id="fmiconbar">
		<span data-type="">All</span>
		<span data-type="doc">Doc</span>
		<span data-type="image">Photo</span>
		<span data-type="media">Media</span>
		<span data-type="zip">Zip</span>
	</span>
	<div style="clear:both"></div>
</div>
<!---- file upload box       ---->
<div id="fmuploadbox" class="fmslider">
<form id="fmuploadform" action="upload.cfm" target="fmtube" method="post" enctype="multipart/form-data">
<table cellpadding="0" cellspacing="0" border="0">
<tr>
	<td class="fmsliderlft"><img style="vertical-align:top;" src="images/fmsliderlfttp.png" /></td>
	<td class="fmslidemid">
		<div class="fftoleft">
		Upload File <input type="file" style="width:250px" name="file" id="fmfile" class="input" /> 
		<button class="buttonblue" type="submit">Upload</button>
		<input type="hidden" name="path" />
		<img src="images/loading.gif" class="fmstates" alt="Uploading File">
		</div>
		<input type="button" class="closebtn" />
	</td>
	<td class="sliderright" valign="top"><img src="images/fmsliderighttp.png" /></td>
</tr>
<tr>
	<td width="6"><img src="images/sliderbtlft.png" ></td>
	<td class="fmslidersdow"></td>
	<td width="6"><img src="images/sliderbtrite.png"></td>
</tr>
</table>
</form>
</div>
<!---- new folder box        ---->
<div id="fmdirbox" class="fmslider">
<form id="fmuploadform" action="folder.cfm" target="fmtube" method="post">
<table cellpadding="0" cellspacing="0" border="0">
<tr>
	<td class="fmsliderlft" valign="top"><img src="images/fmsliderlfttp.png" /></td>
	<td class="fmslidemid">
		<div class="fftoleft">
			New Folder <input type="text" style="width:150px" name="folder" class="input" /> 
			<input type="submit" class="buttonblue" value="Create" />
		</div>
		<input type="button" class="closebtn" value="" />
		<input type="hidden" name="path" />
	</td>
	<td class="sliderright" valign="top"><img src="images/fmsliderighttp.png" /></td>
</tr>
<tr>
	<td width="6"><img src="images/sliderbtlft.png"></td>
	<td class="fmslidersdow"></td>
	<td width="6"><img src="images/sliderbtrite.png"></td>
</tr>
</table>
</form>
</div>

<div id="holderbox">
	<!--- bubble                  --->
	<div class="fmbubble">
	<div id="fmbubimg"><span class="fmbubexe fmbubbig" data-hint="Execute Code Block"></span><span class="fmbubcode fmbubbig" data-hint="Insert to Code Block"></span><span class="fmbubdw fmbubbig" data-hint="Insert Download Link"></span><span class="fmbubem fmbubbig" data-hint="Embed to My Post"></span><span class="fmbublg fmbubbig" data-hint="Insert Full Size"></span><span class="fmbubmid" data-hint="Insert Medium Size"></span><span class="fmbubsm" data-hint="Insert Thumbnail Size"></span></div>
	<div id="fmbubhint"></div><div id="fmbubinfo"><span></span> <span></span> <span>. <a href="javascript:">Delete</a></span></div>
	<img class="fmbubclose" src="images/popclose.png" title="Close" /></div>
	</div>
</div>

<!--- form submit go through this iframe                                            --->
<iframe id="fmtube" name="fmtube" style="width:0px; height:0px; display:block; visibility:hidden"></iframe>
<!--- <iframe id="fmtube" name="fmtube" style="width:500px; height:100px; position:absolute; bottom:0px"></iframe> --->
</body>
</html>
