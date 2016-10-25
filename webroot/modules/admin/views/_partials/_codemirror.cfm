<cfoutput>

	<link rel="stylesheet" href="/assets/vendor/codemirror/codemirror.css">
	<script src="/assets/vendor/codemirror/codemirror.js"></script>
	<script src="/assets/vendor/codemirror/foldgutter.js"></script>
	<script src="/assets/vendor/codemirror/foldcode.js"></script>
	<script src="/assets/vendor/codemirror/formatting.js"></script>
	<script src="/assets/vendor/codemirror/autoFormatAll.js"></script>
	<script src="/assets/vendor/codemirror/xml-fold.js"></script>
	<script src="/assets/vendor/codemirror/comment-fold.js"></script>
	<script src="/assets/vendor/codemirror/xml.js"></script>
	<script src="/assets/vendor/codemirror/css.js"></script>
	<script src="/assets/vendor/codemirror/htmlmixed.js"></script>

	<script>
	  var editor = CodeMirror.fromTextArea(document.getElementById("CodeMirror"), {
	    lineNumbers: true,
	    lineWrapping: true,
	    mode: "text/html"
	  });
	</script>

</cfoutput>