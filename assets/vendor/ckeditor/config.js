/**
 * @license Copyright (c) 2003-2013, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here.
	// For the complete reference:
	// http://docs.ckeditor.com/#!/api/CKEDITOR.config

	/* The toolbar groups arrangement, optimized for two toolbar rows.
	config.toolbarGroups = [
		{ name: 'document',	   groups: [ 'mode', 'document', 'doctools' ] },
		{ name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
		{ name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
		{ name: 'links' },{ name: 'others' },
		
		{ name: 'tools' },	
		
				
		'/',
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
		{ name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ] },
		{ name: 'styles' },
		{ name: 'insert' }
	];*/
	

	config.toolbarGroups = [
		{ name: 'others' },
		{ name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
		{ name: 'clipboard', groups: [ 'clipboard', 'undo' ] },		
		{ name: 'links', groups: [ 'links' ] },
		{ name: 'insert', groups: [ 'insert' ] },
		
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
		'/',
		{ name: 'editing', groups: [ 'find', 'selection', 'spellchecker', 'editing' ] },
		{ name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
		{ name: 'styles', groups: [ 'styles' ] },
		{ name: 'colors', groups: [ 'colors' ] },
		{ name: 'about', groups: [ 'about' ] }
	];

	config.removeButtons = 'NewPage,Save,Cut,Copy,Paste,PasteText,PasteFromWord,Undo,Redo,Styles,About,Preview,Print,Templates,Find,Replace,SelectAll,Language,Image,Flash,CreateDivContainer,BidiLtr,BidiRtl,CreateDiv,Smiley,Iframe,Font';

	// Se the most common block elements.
	config.format_tags = 'p;h1;h2;h3;pre';

	// Make dialogs simpler.
	config.removeDialogTabs = 'image:advanced;link:advanced';
	
	config.enterMode = CKEDITOR.ENTER_BR;
	config.shiftEnterMode = CKEDITOR.ENTER_BR;
	
	config.htmlEncodeOutput = false;
	config.entities = false;

	config.bodyClass = 'content-body';
	
	/*config.extraAllowedContent = [	
        "*[class,id]",
        "a[*]",
        "img[style,src,class,id]",
        "strong", "em", "small",
        "u", "s", "i", "b",
        "p", "blockquote[class,id]",
        "div(*){*}[*]",
        "ul", "ol", "li",
        "br", "hr",
        "h1", "h2", "h3", "h4", "h5", "h6",
        "script[src,charset,async]",
        "iframe[*]", "embed[*]", "object[*]",
        "cite", "mark", "time",
        "dd", "dl", "dt",
        "table", "th", "tr", "td", "tbody", "thead", "tfoot"
    ].join("; ");*/
	config.protectedSource = [/<safe>[\s\S]*<\/safe>/g]; 
	config.allowedContent = true;
	
	config.extraPlugins = 'codemirror,filemanager,showprotected';
	
	config.codemirror = {
		
		// Set this to the theme you wish to use (codemirror themes)
		theme: 'default',
		
		// Whether or not you want to show line numbers
		lineNumbers: true,
		
		// Whether or not you want to use line wrapping
		lineWrapping: true,
		
		// Whether or not you want to highlight matching braces
		matchBrackets: true,
		
		// Whether or not you want to highlight matching tags
		matchTags: true,
		
		// Whether or not you want tags to automatically close themselves
		autoCloseTags: true,
		
		// Whether or not you want Brackets to automatically close themselves
		autoCloseBrackets: true,
		
		// Whether or not to enable search tools, CTRL+F (Find), CTRL+SHIFT+F (Replace), CTRL+SHIFT+R (Replace All), CTRL+G (Find Next), CTRL+SHIFT+G (Find Previous)
		enableSearchTools: true,
		
		// Whether or not you wish to enable code folding (requires 'lineNumbers' to be set to 'true')
		enableCodeFolding: true,
		
		// Whether or not to enable code formatting
		enableCodeFormatting: true,
		
		// Whether or not to automatically format code should be done when the editor is loaded
		autoFormatOnStart: true, 
		
		// Whether or not to automatically format code which has just been uncommented
		autoFormatOnUncomment: true,
		
		// Whether or not to highlight the currently active line
		highlightActiveLine: true,
		
		// Whether or not to highlight all matches of current word/selection
		highlightMatches: true,
	
		 // Define the language specific mode 'htmlmixed' for html  including (css, xml, javascript), 'application/x-httpd-php' for php mode including html, or 'text/javascript' for using java script only 
		mode: 'htmlmixed',
	
		 // Whether or not to show the search Code button on the toolbar
		showSearchButton: false,
	
		 // Whether or not to show Trailing Spaces
		showTrailingSpace: true,
		
		// Whether or not to show the format button on the toolbar
		showFormatButton: false,
		
		// Whether or not to show the comment button on the toolbar
		showCommentButton: false,
		
		// Whether or not to show the uncomment button on the toolbar
		showUncommentButton: false,
	
		 // Whether or not to show the showAutoCompleteButton button on the toolbar
		showAutoCompleteButton: false
	};
};

(function() {
	var isChrome = /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor);
	if (isChrome) {
		CKEDITOR.on( 'instanceLoaded', function( e ){
			this.addCss('.cke_editable { line-height: normal; }');
		});
	}
})();

CKEDITOR.on( 'instanceReady', function( ev )
{
	var writer = ev.editor.dataProcessor.writer; 	
 	var dtd = CKEDITOR.dtd;	
	for ( var e in CKEDITOR.tools.extend( {}, dtd.$block, dtd.$inline ) )
	{
		ev.editor.dataProcessor.writer.setRules( e, {					
			breakBeforeOpen : true,		
			breakAfterOpen : true,
			breakAfterClose : false,
			breakBeforeClose : true
		});
	}
});

CKEDITOR.config.enterMode = CKEDITOR.ENTER_BR;
CKEDITOR.config.forcePasteAsPlainText = false; // default so content won't be manipulated on load
CKEDITOR.config.basicEntities = true;
CKEDITOR.config.entities = true;
CKEDITOR.config.entities_latin = false;
CKEDITOR.config.entities_greek = false;
CKEDITOR.config.entities_processNumerical = false;
CKEDITOR.config.fillEmptyBlocks = function (element) {
		return true; // DON'T DO ANYTHING!!!!!
};
// CKEDITOR.config.contentsCss = ['/assets/vendor/ckeditor/contents.css','/assets/css/ltc.css'];
CKEDITOR.config.allowedContent = true; // don't filter my data

