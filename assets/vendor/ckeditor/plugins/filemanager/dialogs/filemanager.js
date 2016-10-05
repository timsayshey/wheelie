var x = Math.floor((Math.random()*10000)+1)
//console.log( CKEDITOR.dialog )
CKEDITOR.dialog.add( 'fmDialog', function( editor ) {
    return {
        title: 'File Manager',
        resizable: CKEDITOR.DIALOG_RESIZE_NONE,
        buttons : [],
        onShow : function() { 
                    // reload the home page when every time dialog come to view. This is a workaround for ck dialog catching
                    var alle = document.getElementsByClassName("fmmainholder");
                    for(var i=0; i < alle.length; i++) {
                        thisalle = alle[i]
                        if ( isVisible(thisalle) ) {
                            thisalle.innerHTML = '<iframe style="width:100%;" scrolling="No" class="filemanageriframe" src="/assets/vendor/ckeditor/plugins/filemanager/filemanager.cfm"></iframe>'
                        }
                    }
                },
        contents: [
        {
            id: 'filebox',
            label: 'filebox',
            title: 'filebox',
            elements: [
                {
                    type: 'html',
                    html: '<div class="fmmainholder">Loading</div>'
                }
            ]
        }
    ],

    };
})


function isVisible(obj)
{
    if (obj == document) return true
    if (!obj) return false
    if (!obj.parentNode) return false
    if (obj.style) {
        if (obj.style.display == 'none') return false
        if (obj.style.visibility == 'hidden') return false
    }
    if (window.getComputedStyle) {
        var style = window.getComputedStyle(obj, "")
        if (style.display == 'none') return false
        if (style.visibility == 'hidden') return false
    }
    var style = obj.currentStyle
    if (style) {
        if (style['display'] == 'none') return false
        if (style['visibility'] == 'hidden') return false
    }
    return isVisible(obj.parentNode)
}