/*
 * jQuery File Upload Plugin JS Example 5.0.2
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://creativecommons.org/licenses/MIT/
 */

/*jslint nomen: true */

$(function () {
    'use strict';

    // Initialize the jQuery File Upload widget:
    $('.fileupload').each(initFileUpload);

    // Enable iframe cross-domain access via redirect page:
    var redirectPage = window.location.href.replace(
        /\/[^\/]*$/,
        '/result.html?%s'
    );
    $('.fileupload').bind('fileuploadsend', function (e, data) {
        if (data.dataType.substr(0, 6) === 'iframe') {
            var target = $('<a/>').prop('href', data.url)[0];
            if (window.location.host !== target.host) {
                data.formData.push({
                    name: 'redirect',
                    value: redirectPage
                });
            }
        }
    });

    // Open download dialogs via iframes,
    // to prevent aborting current uploads:
    $('.fileupload .files').delegate(
        'a:not([rel^=gallery])',
        'click',
        function (e) {
            e.preventDefault();
            $('<iframe style="display:none;"></iframe>')
                .prop('src', this.href)
                .appendTo(document.body);
        }
    );

});

function initFileUpload(){
	$(this).fileupload({
		dropZone: $(this)
	});
	$(this).data("numSending", 0);
	$(this)
		.bind('fileuploadalways', function (e, data) {
			$(this).data("numSending", $(this).data("numSending")-1);//used for prevention of hiding the file upload when there are still files uploading.
		})
		.bind('fileuploadsend', function (e, data) {
			$(this).data("numSending", $(this).data("numSending")+1);//used for prevention of hiding the file upload when there are still files uploading.
		});
		
	// Load existing files:
    var that = this;
    $.getJSON(this.action, function (result) {
        if (result && result.length) {
            $(that).fileupload('option', 'done')
                .call(that, null, {result: result});
        }
    });
}
