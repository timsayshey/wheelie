<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
<script src="ckeditor.js"></script>


</head>
<body>
	<textarea id="editor1" name="editor1">hello</textarea>

<textarea id="editor2" name="editor2">hello</textarea>

<script type="text/javascript">
//<![CDATA[
	// Replace the <textarea id="editor1"> with a CKEditor
	// instance, using default configuration.
	CKEDITOR.replace( 'editor1',
		{
			extraPlugins : 'filemanager,flash' 
		});

	CKEDITOR.replace( 'editor2',
		{
			extraPlugins : 'filemanager' 
		});
//]]>
</script>
</body>
</html>