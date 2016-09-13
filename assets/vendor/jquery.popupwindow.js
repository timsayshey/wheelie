/*!
* Display popup window.
*
* Requires: jQuery v1.3.2
*/
(function($) {
    var defaults = {
        height: 500,
        width: 500,
        toolbar: false,
        scrollbars: false, // os x always adds scrollbars
        status: false,
        resizable: false,
        left: 0,
        top: 0,
        center: true,
        createNew: true,
        name: null,
        location: false,
        menubar: false,
        onUnload: null
    };
        
    $.popupWindow = function(url, opts) {
        var options = $.extend({}, defaults, opts);

        // center the window
        if (options.centerOn == "parent") {
          options.top = window.screenY + Math.round(($(window).height() - options.height) / 2);
          options.left = window.screenX + Math.round(($(window).width() - options.width) / 2);
        } else if (options.center || options.centerOn == "screen") {
            // 50px is a rough estimate for the height of the chrome above the document area
            options.top = ((screen.height - options.height) / 2) - 50;
            options.left = (screen.width - options.width) / 2;
        }

        // params
        var params = [];
        params.push('location=' + (options.location ? 'yes' : 'no'));
        params.push('menubar=' + (options.menubar ? 'yes' : 'no'));
        params.push('toolbar=' + (options.toolbar ? 'yes' : 'no'));
        params.push('scrollbars=' + (options.scrollbars ? 'yes' : 'no'));
        params.push('status=' + (options.status ? 'yes' : 'no'));
        params.push('resizable=' + (options.resizable ? 'yes' : 'no'));
        params.push('height=' + options.height);
        params.push('width=' + options.width);
        params.push('left=' + options.left);
        params.push('top=' + options.top);

        // open window
        var random = new Date().getTime();
        var name = options.name || (options.createNew ? 'popup_window_' + random : 'popup_window');
        var win = window.open(url, name, params.join(','));

        // unload handler
        if (options.onUnload && typeof options.onUnload === 'function') {
            var unloadInterval = setInterval(function() {
                if (!win || win.closed) {
                    clearInterval(unloadInterval);
                    options.onUnload();
                }
            }, 50);
        }

        // focus window
        if (win && win.focus) win.focus();
        
        // return handle to window
        return win;
    };
})(jQuery);
