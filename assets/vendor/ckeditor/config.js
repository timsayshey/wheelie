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
		{ name: 'document',	   groups: [ 'mode', 'document', 'doctools' ] },	
		{ name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
		{ name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },		
		{ name: 'tools' },		
		'/',
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
		{ name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ] },
		{ name: 'styles' },
		{ name: 'colors' },
		{ name: 'links' },
		{ name: 'forms' }
	];

	// Remove some buttons, provided by the standard plugins, which we don't
	// need to have in the Standard(s) toolbar.
	config.removeButtons = 'Underline,Subscript,Superscript';

	// Se the most common block elements.
	config.format_tags = 'p;h1;h2;h3;pre';

	// Make dialogs simpler.
	config.removeDialogTabs = 'image:advanced;link:advanced';
	
	config.enterMode = CKEDITOR.ENTER_BR;
	config.shiftEnterMode = CKEDITOR.ENTER_BR;
	
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
	
	config.allowedContent = true;
	
	config.extraPlugins = 'codemirror,filemanager';
	
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
		showSearchButton: true,
	
		 // Whether or not to show Trailing Spaces
		showTrailingSpace: true,
		
		// Whether or not to show the format button on the toolbar
		showFormatButton: true,
		
		// Whether or not to show the comment button on the toolbar
		showCommentButton: true,
		
		// Whether or not to show the uncomment button on the toolbar
		showUncommentButton: true,
	
		 // Whether or not to show the showAutoCompleteButton button on the toolbar
		showAutoCompleteButton: true
	};
};
