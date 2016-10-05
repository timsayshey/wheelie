CKEDITOR.plugins.add( 'filemanager', {

	init: function( editor ) {
		editor.ui.addButton( 'filemanager', {
			label: 'Add Media',
			command: 'filemanager',
			icon: this.path + 'fm.png',
			command: 'filemanager'
		});

		editor.addCommand( 'filemanager', new CKEDITOR.dialogCommand( 'fmDialog',
		{ allowedContent: ['object[*]','param[*]','audio[*]','video[*]','object[*]','source[*]','iframe[*]'] } ) );
		CKEDITOR.dialog.add( 'fmDialog', this.path + 'dialogs/filemanager.js' );
	}
});