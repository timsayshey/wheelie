var fm = {}
fm.filemanagerpath = 'filemanager.cfc'
fm.ckinstance = parent.CKEDITOR.dialog.getCurrent().getParentEditor().name;

// =====================================================================
// Remove everything unnecessary from the default CK dialog
// =====================================================================
try {
fm.dialogelm = $('iframe.filemanageriframe:visible',window.parent.document).closest('.cke_dialog_body')
$('.cke_dialog_title,.cke_dialog_close_button,.cke_dialog_footer', fm.dialogelm ).remove()
$('.cke_dialog_footer', fm.dialogelm ).parent().remove()
$('.cke_dialog_contents_body,.cke_dialog_ui_vbox_child', fm.dialogelm ).css('padding','0')
}  
catch(e){};

// =====================================================================
// Get Files From Server                                 
// =====================================================================
fm.getfiles = function() {
    var path = $('#fmbreadcrumb').attr('data-path')
    $('.fmbubble').css('display', 'none');
    // Hide [Move Up] link if on top folder
    if (path.split("/").length > 1) {
        $('#moveup').css('display', 'inline')
    } else {
        $('#moveup').css('display', 'none')
    };
    // go the server, get data
    $.ajax({
        url: fm.filemanagerpath + "?method=getfmfiles&returnformat=plain&path=" + path,
        dataType: "text",
        cache: false,
        success: function (data) {
            // simple animation before display data
            $('#holderbox').fadeOut(200,function(){
            $('#holderbox #fmdatalist').remove()
            $('#holderbox').append(data);
                $('#holderbox').fadeIn(300,fm.filesUpdated)   
            })
            // display path to the user
           $('#fmbreadcrumb').css('cursor', 'pointer').html('<strong>' + path.replace(/\//g, '</strong> / <strong>') + '</strong>')
        }
    })
};
// =====================================================================
// CLose All Open layers/popup and things
// =====================================================================
fm.closeAllPopUp = function() {
    $('.fmbubble .fmbubclose').click();
    $('.closebtn').click()
    //hide progress images
    $('.fmstates').css('display','none');
}
// =====================================================================
// Page List Changed. Show/Hide filters
// =====================================================================
fm.filesUpdated = function () {
    fm.closeAllPopUp()
    $('#holderbox').promise().done(function(){
        $('#fmiconbar span').each(function(i,e) {
            var t = $(this).attr('data-type');
            if ( t !=='' && $('.fmi img[data-type='+t+']:visible').length == 0 ) {
                $('#fmiconbar span[data-type='+t+']').fadeOut(200)
            } else {
                $('#fmiconbar span[data-type='+t+'], #fmiconbar span[data-type=""]').fadeIn(200)
            }
        });
        $('#fmiconbar span[data-type=""]').click();
    })
}

// =====================================================================
// Returns from iframe
// =====================================================================
fm.fmreturnhome = function () {
    fm.getfiles()
}

// =====================================================================
// Open Bubble                                   
// =====================================================================
fm.openbuble= function (item) {
    $(item).addClass('fmselect');
    $('#fmbubimg span').css('display', 'none');
    $('#fmbubinfo span:eq(1)').html('Download');
    switch ($(item).children('img').attr('class')) {
    case 'fmimg':
        //Image
        $('.fmbublg').css('display', 'inline-block');
        if ($(item).children('img').attr('data-thumb') == 'Yes') $('.fmbubsm').css('display', 'inline-block');
        if ($(item).children('img').attr('data-midle') == 'Yes') $('.fmbubmid').css('display', 'inline-block');
        break;
    default:
        //File
        var ext = $(item).text().split('.');
        ext = ext[ext.length - 1];
        // Different file types have different options
        switch (ext.toLowerCase()) {
        case 'swf':
        case 'pdf':
        case 'mov':
        case 'wmv':
        case 'm4v':
        case 'mp3':
        case 'ogg':
            $('.fmbubdw,.fmbubem').css('display', 'inline-block');
            break;
// if you want to enable following file types and code embed functions, you have to handle them in the form action page.
//            case 'html':
//            case 'js':
//            case 'css':
//                $('.fmbubdw,.fmbubcode').css('display', 'inline-block');
//            case 'php':
//                $('.fmbubcode').css('display', 'inline-block');
//                $('#fmbubinfo span:eq(1)').empty() // no downloading
//                break;
//             case 'cfm':
//             case 'cfc':
//                 $('.fmbubcode').css('display', 'inline-block');
//                 $('#fmbubinfo span:eq(1)').empty() // no downloading
//              break;
        default:
            $('.fmbubdw').css('display', 'inline-block');
        }
    }
    $('#fmbubinfo span:first-child').html($(item).attr('data-size'));
    $('#fmbubinfo span:eq(1):not(:empty)').html('. <a target="_blank" href="'+$(item).children('img').attr('data-wh')+$(item).children('img').attr('data-file')+'">Download</a>')

    // Position and Show the bubble
    if ($(window).width() - $(item).offset().left > 350) {
        $('.fmbubble').removeClass('fmbubRight').css({
            'right': 'auto',
            'left': $(item).position().left + 14 + $(item).width(),
            'top': $(item).position().top +$('#holderbox').scrollTop() + 5
        }).show('blind', {direction: "horizontal"}, 500)
    } else {
        $('.fmbubble').addClass('fmbubRight').css({
            'left' : $(item).position().left-231,
            'right': 'auto' ,
            'top': $(item).position().top +$('#holderbox').scrollTop() + 5
        }).show('blind', {direction: "horizontal"}, 500)
        if (typeof InstallTrigger !== 'undefined') {
            $('.fmbubble').show('blind', {direction: "right"}, 500)
        } else {
            $('.fmbubble')
        }
    }
}

$(document).ready(function($) {
     fm.getfiles();
    // =====================================================================
    // Handle window size on page resize                                    
    // =====================================================================
    $(window.parent).resize(function(event) {
         var w = Number($(window.parent).innerWidth())
         w = ( (w > 850 ) ? w-50 : 800)
         var h = Number($(window.parent).innerHeight())
         h = ( (h > 360 ) ? h-60 : 300)
        parent.CKEDITOR.dialog.getCurrent().resize( w, h )
        parent.CKEDITOR.dialog.getCurrent().move(20,20)
        $('.fmslider').width( w -60)
        $('#toolbar, #fmtopbar').width( w - 25 )
        $('.cke_dialog_contents_body',window.parent.document).css('min-width',w)
        $('iframe.filemanageriframe',window.parent.document).css('height',h)
        $('#holderbox').css('height',h-90)
        $('.fmbubble .fmbubclose').click()
    }).trigger('resize')
    // =====================================================================
    // Close Window                                                         
    // =====================================================================
    $('#fmclose').click(function(e) {
        $('.closebtn').click()
        $('.fmbubble .fmbubclose').click()
        parent.CKEDITOR.dialog.getCurrent().hide() 
    });
    // =====================================================================
    // Sliders                                                              
    // =====================================================================
    $('.fmtabslink').click(function () {
        $('.fmbubble:visible .fmbubclose').trigger('click');
        var i = $(this).attr('id') + 'box';
        $('.fmslider:visible').slideUp(800)
        if ( ! $('#' + i).is(':visible') ) {
            $('.fmslider').promise().done(function(){
                $('#' + i).slideDown(800)
            })
        }
    });
    // =====================================================================
    // Close Sliders
    // =====================================================================
    $('.closebtn').click(function () {
        $(this).prev('span').html('');
        $('.fmslider:visible').slideUp( 800, function () {$(this).find('form')[0].reset() })
    })
    // =====================================================================
    // Close Bubble
    // =====================================================================
    $('.fmbubble .fmbubclose').click(function () {
        $('.fmbubble').hide('blind', {direction: "horizontal"}, 500, function () { $('.fmselect').removeClass('fmselect') })
    })
    // =====================================================================
    // Bubble Window Stuff
    // =====================================================================
    $('#fmbubimg span').hover(function () {
        $('#fmbubhint').html('&bull; ' + $(this).attr('data-hint'))
    }, function () {
        $('#fmbubhint').html('')
    });
    // =====================================================================
    // Insert into Editor
    // =====================================================================
    $('.fmbubsm').click(function () {
        parent.CKEDITOR.instances[fm.ckinstance].insertHtml('<a class="thumbnail" href="' + $('.fmselect').children('img').attr('src').replace("/_thumb/", "/") + '" target="_blank"><img src="' + $('.fmselect').children('img').attr('src') + '" /></a>');
        $('#fmclose').click();
    });
    $('.fmbubmid').click(function () {
        parent.CKEDITOR.instances[fm.ckinstance].insertHtml('<a class="mediumimage " href="' + $('.fmselect').children('img').attr('src').replace("/_thumb/", "/") + '" target="_blank"><img src="' + $('.fmselect').children('img').attr('src').replace("/_thumb/", "/_middle/") + '" /></a>');
        $('#fmclose').click();
    });
    $('.fmbublg').click(function () {
        parent.CKEDITOR.instances[fm.ckinstance].insertHtml('<img src="' + $('.fmselect').children('img').attr('src').replace("/_thumb/", "/") + '" class="largeimage" />');
        $('#fmclose').click();
    });
   // Embad File
    $('.fmbubem').click(function () {
        var file = $('.fmselect').children('img').attr('data-wh') + $('.fmselect').children('img').attr('data-file')
        var ext = file.split('.');
        ext = ext[ext.length - 1];
        switch (ext.toLowerCase()) {
        case 'pdf':
            parent.CKEDITOR.instances[fm.ckinstance].insertHtml('<iframe style="height:500px" src ="' + file + '" width="100%" class="innerimg"></iframe>');
            break;
        case 'swf':
            parent.CKEDITOR.instances[fm.ckinstance].insertHtml('<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0"><param name="quality" value="high" /><param name="movie" value="'+file+'" /><embed pluginspage="http://www.macromedia.com/go/getflashplayer" quality="high" src="'+file+'" type="application/x-shockwave-flash"></embed></object><br>');
            break;
        case 'm4v':
            parent.CKEDITOR.instances[fm.ckinstance].insertHtml('<video controls><source src="'+file+'" type="video/mp4">[Your browser does not support the video tag.]</video><br>');
            break;
        case 'mov':
            parent.CKEDITOR.instances[fm.ckinstance].insertHtml('<video controls><source src="'+file+'" type="video/mov">[Your browser does not support the video tag.]</video><br>');
            break;
        case 'wmv':
            parent.CKEDITOR.instances[fm.ckinstance].insertHtml('<object width="320" height="240" data="'+file+'" type="application/x-mplayer2"><param name="url" value="'+file+'" /></object><br>');
            break;
        case 'mp3':
        case 'ogg':
            parent.CKEDITOR.instances[fm.ckinstance].insertHtml('<audio controls="controls"><source src="'+file+' " type="audio/mpeg" /></audio><br>');
            break;
        }
        $('#fmclose').click();
    });
    // Downoload Link
    $('.fmbubdw').click(function () {
        parent.CKEDITOR.instances[fm.ckinstance].insertHtml('<a href="' + $('.fmselect').children('img').attr('data-wh') + $('.fmselect').children('img').attr('data-file') + '" target="_blank"> Download ' + $('.fmselect').text() + '</a>');
        $('#fmclose').click();
    });
    // Code Block
    $('.fmbubcode').click(function () {
        parent.CKEDITOR.instances[fm.ckinstance].insertHtml('<span class="cfmfile">' + $('.fmselect').children('img').attr('data-file') + '</span>');
        $('#fmclose').click();
    })

    // =====================================================================
    // Delete
    // =====================================================================
    $('#fmbubinfo span:last-child a').click(function () {
        var r = confirm("Are You Sure You Want to Delete This File Permanently?");
        if (r) {
            $.ajax({
                url: fm.filemanagerpath + "?method=delfmfiles&returnformat=plain&path=" + $('#fmbreadcrumb').attr('data-path') + "/" + $('.fmselect').text(),
                dataType: "text",
                cache: false,
                success: function (data) {
                    fm.filesUpdated();
                    $('.fmselect').hide("blind", {direction: "horizontal"}, 1000, function(){
                        $(this).remove()
                    })
                }
            })
        }
    });
    // =====================================================================
    // Click on folder, update the bread-crumb and go to the server
    // =====================================================================
   $('#holderbox').on('click','.fmd', function () {
        $('#fmbreadcrumb').attr('data-path',$('#fmbreadcrumb').attr('data-path') + '/' + $(this).text());
        fm.getfiles()
    });
    // =====================================================================
    // Click on bread-crumb
    // =====================================================================
    $('#fmbreadcrumb').on('click','strong', function () {
        var i = $(this).index() + 1;
        $('#fmbreadcrumb').attr('data-path', $('#fmbreadcrumb').attr('data-path').split("/").slice(0, i).join('/') );
        fm.getfiles()
    });
    // =====================================================================
    // Move up
    // =====================================================================
    $('#moveup').click(function () {
        var i = $('#fmbreadcrumb strong').length -2 ;
        $('#fmbreadcrumb strong:eq(' + i + ')').trigger('click')
    });
    // =====================================================================
    // New folder
    // =====================================================================
    $('#fmdirbox').submit(function () {
        if ($(this).find('input[name="folder"]').val() == '') {
            alert('Please Enter Folder Name');
            return false;
        } else {
            $(this).parent().find('input[name="path"]').val( $('#fmbreadcrumb').attr('data-path') )
        }
    });
    // =====================================================================
    // Upload
    // =====================================================================
    $('#fmuploadform').submit(function () {
        if ($('#fmfile').val() == '') {
            alert("Please Select File");
            return false;
        } else {
            $(this).parent().find('.fmstates').css('display','inline-block');
            $(this).parent().find('input[name="path"]').val( $('#fmbreadcrumb').attr('data-path') )
        }
    });
    // =====================================================================
    // Clicked on a file, Open bubble
    // =====================================================================
    $('#holderbox').on('click','.fmi', function () {
        fm.closeAllPopUp();
        var item = $(this)
        // open new bubble once existing closed
        $('.fmbubble:visible').promise().done( function() {
            fm.openbuble( item )
        })    
    });
    // =====================================================================
    // Filter files by type
    // =====================================================================
    $('#fmiconbar span').click(function(e) {
        $('#fmiconbar span.fmselected').removeClass('fmselected')
        $(this).addClass('fmselected')
        fm.closeAllPopUp()
        var t = $(this).attr('data-type');
        if (t !== '') {
            $('#holderbox .fmi:not(:visible)').children('img[data-type='+t+']').parent().show("blind", {direction: "horizontal"},300);
            $('#holderbox .fmi:visible').children('img:not([data-type='+t+'])').parent().hide("blind", {direction: "horizontal"},300);
        } else {
            $('#holderbox .fmi').show("blind", {direction: "horizontal"},300);
        }
    });
});


/*! jQuery UI - v1.10.3 - 2013-09-30
* http://jqueryui.com
* Includes: jquery.ui.effect.js, jquery.ui.effect-blind.js
* Copyright 2013 jQuery Foundation and other contributors; Licensed MIT */

(function(t,e){var i="ui-effects-";t.effects={effect:{}},function(t,e){function i(t,e,i){var s=u[e.type]||{};return null==t?i||!e.def?null:e.def:(t=s.floor?~~t:parseFloat(t),isNaN(t)?e.def:s.mod?(t+s.mod)%s.mod:0>t?0:t>s.max?s.max:t)}function s(i){var s=h(),n=s._rgba=[];return i=i.toLowerCase(),f(l,function(t,a){var o,r=a.re.exec(i),l=r&&a.parse(r),h=a.space||"rgba";return l?(o=s[h](l),s[c[h].cache]=o[c[h].cache],n=s._rgba=o._rgba,!1):e}),n.length?("0,0,0,0"===n.join()&&t.extend(n,a.transparent),s):a[i]}function n(t,e,i){return i=(i+1)%1,1>6*i?t+6*(e-t)*i:1>2*i?e:2>3*i?t+6*(e-t)*(2/3-i):t}var a,o="backgroundColor borderBottomColor borderLeftColor borderRightColor borderTopColor color columnRuleColor outlineColor textDecorationColor textEmphasisColor",r=/^([\-+])=\s*(\d+\.?\d*)/,l=[{re:/rgba?\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*(?:,\s*(\d?(?:\.\d+)?)\s*)?\)/,parse:function(t){return[t[1],t[2],t[3],t[4]]}},{re:/rgba?\(\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*(?:,\s*(\d?(?:\.\d+)?)\s*)?\)/,parse:function(t){return[2.55*t[1],2.55*t[2],2.55*t[3],t[4]]}},{re:/#([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})/,parse:function(t){return[parseInt(t[1],16),parseInt(t[2],16),parseInt(t[3],16)]}},{re:/#([a-f0-9])([a-f0-9])([a-f0-9])/,parse:function(t){return[parseInt(t[1]+t[1],16),parseInt(t[2]+t[2],16),parseInt(t[3]+t[3],16)]}},{re:/hsla?\(\s*(\d+(?:\.\d+)?)\s*,\s*(\d+(?:\.\d+)?)\%\s*,\s*(\d+(?:\.\d+)?)\%\s*(?:,\s*(\d?(?:\.\d+)?)\s*)?\)/,space:"hsla",parse:function(t){return[t[1],t[2]/100,t[3]/100,t[4]]}}],h=t.Color=function(e,i,s,n){return new t.Color.fn.parse(e,i,s,n)},c={rgba:{props:{red:{idx:0,type:"byte"},green:{idx:1,type:"byte"},blue:{idx:2,type:"byte"}}},hsla:{props:{hue:{idx:0,type:"degrees"},saturation:{idx:1,type:"percent"},lightness:{idx:2,type:"percent"}}}},u={"byte":{floor:!0,max:255},percent:{max:1},degrees:{mod:360,floor:!0}},d=h.support={},p=t("<p>")[0],f=t.each;p.style.cssText="background-color:rgba(1,1,1,.5)",d.rgba=p.style.backgroundColor.indexOf("rgba")>-1,f(c,function(t,e){e.cache="_"+t,e.props.alpha={idx:3,type:"percent",def:1}}),h.fn=t.extend(h.prototype,{parse:function(n,o,r,l){if(n===e)return this._rgba=[null,null,null,null],this;(n.jquery||n.nodeType)&&(n=t(n).css(o),o=e);var u=this,d=t.type(n),p=this._rgba=[];return o!==e&&(n=[n,o,r,l],d="array"),"string"===d?this.parse(s(n)||a._default):"array"===d?(f(c.rgba.props,function(t,e){p[e.idx]=i(n[e.idx],e)}),this):"object"===d?(n instanceof h?f(c,function(t,e){n[e.cache]&&(u[e.cache]=n[e.cache].slice())}):f(c,function(e,s){var a=s.cache;f(s.props,function(t,e){if(!u[a]&&s.to){if("alpha"===t||null==n[t])return;u[a]=s.to(u._rgba)}u[a][e.idx]=i(n[t],e,!0)}),u[a]&&0>t.inArray(null,u[a].slice(0,3))&&(u[a][3]=1,s.from&&(u._rgba=s.from(u[a])))}),this):e},is:function(t){var i=h(t),s=!0,n=this;return f(c,function(t,a){var o,r=i[a.cache];return r&&(o=n[a.cache]||a.to&&a.to(n._rgba)||[],f(a.props,function(t,i){return null!=r[i.idx]?s=r[i.idx]===o[i.idx]:e})),s}),s},_space:function(){var t=[],e=this;return f(c,function(i,s){e[s.cache]&&t.push(i)}),t.pop()},transition:function(t,e){var s=h(t),n=s._space(),a=c[n],o=0===this.alpha()?h("transparent"):this,r=o[a.cache]||a.to(o._rgba),l=r.slice();return s=s[a.cache],f(a.props,function(t,n){var a=n.idx,o=r[a],h=s[a],c=u[n.type]||{};null!==h&&(null===o?l[a]=h:(c.mod&&(h-o>c.mod/2?o+=c.mod:o-h>c.mod/2&&(o-=c.mod)),l[a]=i((h-o)*e+o,n)))}),this[n](l)},blend:function(e){if(1===this._rgba[3])return this;var i=this._rgba.slice(),s=i.pop(),n=h(e)._rgba;return h(t.map(i,function(t,e){return(1-s)*n[e]+s*t}))},toRgbaString:function(){var e="rgba(",i=t.map(this._rgba,function(t,e){return null==t?e>2?1:0:t});return 1===i[3]&&(i.pop(),e="rgb("),e+i.join()+")"},toHslaString:function(){var e="hsla(",i=t.map(this.hsla(),function(t,e){return null==t&&(t=e>2?1:0),e&&3>e&&(t=Math.round(100*t)+"%"),t});return 1===i[3]&&(i.pop(),e="hsl("),e+i.join()+")"},toHexString:function(e){var i=this._rgba.slice(),s=i.pop();return e&&i.push(~~(255*s)),"#"+t.map(i,function(t){return t=(t||0).toString(16),1===t.length?"0"+t:t}).join("")},toString:function(){return 0===this._rgba[3]?"transparent":this.toRgbaString()}}),h.fn.parse.prototype=h.fn,c.hsla.to=function(t){if(null==t[0]||null==t[1]||null==t[2])return[null,null,null,t[3]];var e,i,s=t[0]/255,n=t[1]/255,a=t[2]/255,o=t[3],r=Math.max(s,n,a),l=Math.min(s,n,a),h=r-l,c=r+l,u=.5*c;return e=l===r?0:s===r?60*(n-a)/h+360:n===r?60*(a-s)/h+120:60*(s-n)/h+240,i=0===h?0:.5>=u?h/c:h/(2-c),[Math.round(e)%360,i,u,null==o?1:o]},c.hsla.from=function(t){if(null==t[0]||null==t[1]||null==t[2])return[null,null,null,t[3]];var e=t[0]/360,i=t[1],s=t[2],a=t[3],o=.5>=s?s*(1+i):s+i-s*i,r=2*s-o;return[Math.round(255*n(r,o,e+1/3)),Math.round(255*n(r,o,e)),Math.round(255*n(r,o,e-1/3)),a]},f(c,function(s,n){var a=n.props,o=n.cache,l=n.to,c=n.from;h.fn[s]=function(s){if(l&&!this[o]&&(this[o]=l(this._rgba)),s===e)return this[o].slice();var n,r=t.type(s),u="array"===r||"object"===r?s:arguments,d=this[o].slice();return f(a,function(t,e){var s=u["object"===r?t:e.idx];null==s&&(s=d[e.idx]),d[e.idx]=i(s,e)}),c?(n=h(c(d)),n[o]=d,n):h(d)},f(a,function(e,i){h.fn[e]||(h.fn[e]=function(n){var a,o=t.type(n),l="alpha"===e?this._hsla?"hsla":"rgba":s,h=this[l](),c=h[i.idx];return"undefined"===o?c:("function"===o&&(n=n.call(this,c),o=t.type(n)),null==n&&i.empty?this:("string"===o&&(a=r.exec(n),a&&(n=c+parseFloat(a[2])*("+"===a[1]?1:-1))),h[i.idx]=n,this[l](h)))})})}),h.hook=function(e){var i=e.split(" ");f(i,function(e,i){t.cssHooks[i]={set:function(e,n){var a,o,r="";if("transparent"!==n&&("string"!==t.type(n)||(a=s(n)))){if(n=h(a||n),!d.rgba&&1!==n._rgba[3]){for(o="backgroundColor"===i?e.parentNode:e;(""===r||"transparent"===r)&&o&&o.style;)try{r=t.css(o,"backgroundColor"),o=o.parentNode}catch(l){}n=n.blend(r&&"transparent"!==r?r:"_default")}n=n.toRgbaString()}try{e.style[i]=n}catch(l){}}},t.fx.step[i]=function(e){e.colorInit||(e.start=h(e.elem,i),e.end=h(e.end),e.colorInit=!0),t.cssHooks[i].set(e.elem,e.start.transition(e.end,e.pos))}})},h.hook(o),t.cssHooks.borderColor={expand:function(t){var e={};return f(["Top","Right","Bottom","Left"],function(i,s){e["border"+s+"Color"]=t}),e}},a=t.Color.names={aqua:"#00ffff",black:"#000000",blue:"#0000ff",fuchsia:"#ff00ff",gray:"#808080",green:"#008000",lime:"#00ff00",maroon:"#800000",navy:"#000080",olive:"#808000",purple:"#800080",red:"#ff0000",silver:"#c0c0c0",teal:"#008080",white:"#ffffff",yellow:"#ffff00",transparent:[null,null,null,0],_default:"#ffffff"}}(jQuery),function(){function i(e){var i,s,n=e.ownerDocument.defaultView?e.ownerDocument.defaultView.getComputedStyle(e,null):e.currentStyle,a={};if(n&&n.length&&n[0]&&n[n[0]])for(s=n.length;s--;)i=n[s],"string"==typeof n[i]&&(a[t.camelCase(i)]=n[i]);else for(i in n)"string"==typeof n[i]&&(a[i]=n[i]);return a}function s(e,i){var s,n,o={};for(s in i)n=i[s],e[s]!==n&&(a[s]||(t.fx.step[s]||!isNaN(parseFloat(n)))&&(o[s]=n));return o}var n=["add","remove","toggle"],a={border:1,borderBottom:1,borderColor:1,borderLeft:1,borderRight:1,borderTop:1,borderWidth:1,margin:1,padding:1};t.each(["borderLeftStyle","borderRightStyle","borderBottomStyle","borderTopStyle"],function(e,i){t.fx.step[i]=function(t){("none"!==t.end&&!t.setAttr||1===t.pos&&!t.setAttr)&&(jQuery.style(t.elem,i,t.end),t.setAttr=!0)}}),t.fn.addBack||(t.fn.addBack=function(t){return this.add(null==t?this.prevObject:this.prevObject.filter(t))}),t.effects.animateClass=function(e,a,o,r){var l=t.speed(a,o,r);return this.queue(function(){var a,o=t(this),r=o.attr("class")||"",h=l.children?o.find("*").addBack():o;h=h.map(function(){var e=t(this);return{el:e,start:i(this)}}),a=function(){t.each(n,function(t,i){e[i]&&o[i+"Class"](e[i])})},a(),h=h.map(function(){return this.end=i(this.el[0]),this.diff=s(this.start,this.end),this}),o.attr("class",r),h=h.map(function(){var e=this,i=t.Deferred(),s=t.extend({},l,{queue:!1,complete:function(){i.resolve(e)}});return this.el.animate(this.diff,s),i.promise()}),t.when.apply(t,h.get()).done(function(){a(),t.each(arguments,function(){var e=this.el;t.each(this.diff,function(t){e.css(t,"")})}),l.complete.call(o[0])})})},t.fn.extend({addClass:function(e){return function(i,s,n,a){return s?t.effects.animateClass.call(this,{add:i},s,n,a):e.apply(this,arguments)}}(t.fn.addClass),removeClass:function(e){return function(i,s,n,a){return arguments.length>1?t.effects.animateClass.call(this,{remove:i},s,n,a):e.apply(this,arguments)}}(t.fn.removeClass),toggleClass:function(i){return function(s,n,a,o,r){return"boolean"==typeof n||n===e?a?t.effects.animateClass.call(this,n?{add:s}:{remove:s},a,o,r):i.apply(this,arguments):t.effects.animateClass.call(this,{toggle:s},n,a,o)}}(t.fn.toggleClass),switchClass:function(e,i,s,n,a){return t.effects.animateClass.call(this,{add:i,remove:e},s,n,a)}})}(),function(){function s(e,i,s,n){return t.isPlainObject(e)&&(i=e,e=e.effect),e={effect:e},null==i&&(i={}),t.isFunction(i)&&(n=i,s=null,i={}),("number"==typeof i||t.fx.speeds[i])&&(n=s,s=i,i={}),t.isFunction(s)&&(n=s,s=null),i&&t.extend(e,i),s=s||i.duration,e.duration=t.fx.off?0:"number"==typeof s?s:s in t.fx.speeds?t.fx.speeds[s]:t.fx.speeds._default,e.complete=n||i.complete,e}function n(e){return!e||"number"==typeof e||t.fx.speeds[e]?!0:"string"!=typeof e||t.effects.effect[e]?t.isFunction(e)?!0:"object"!=typeof e||e.effect?!1:!0:!0}t.extend(t.effects,{version:"1.10.3",save:function(t,e){for(var s=0;e.length>s;s++)null!==e[s]&&t.data(i+e[s],t[0].style[e[s]])},restore:function(t,s){var n,a;for(a=0;s.length>a;a++)null!==s[a]&&(n=t.data(i+s[a]),n===e&&(n=""),t.css(s[a],n))},setMode:function(t,e){return"toggle"===e&&(e=t.is(":hidden")?"show":"hide"),e},getBaseline:function(t,e){var i,s;switch(t[0]){case"top":i=0;break;case"middle":i=.5;break;case"bottom":i=1;break;default:i=t[0]/e.height}switch(t[1]){case"left":s=0;break;case"center":s=.5;break;case"right":s=1;break;default:s=t[1]/e.width}return{x:s,y:i}},createWrapper:function(e){if(e.parent().is(".ui-effects-wrapper"))return e.parent();var i={width:e.outerWidth(!0),height:e.outerHeight(!0),"float":e.css("float")},s=t("<div></div>").addClass("ui-effects-wrapper").css({fontSize:"100%",background:"transparent",border:"none",margin:0,padding:0}),n={width:e.width(),height:e.height()},a=document.activeElement;try{a.id}catch(o){a=document.body}return e.wrap(s),(e[0]===a||t.contains(e[0],a))&&t(a).focus(),s=e.parent(),"static"===e.css("position")?(s.css({position:"relative"}),e.css({position:"relative"})):(t.extend(i,{position:e.css("position"),zIndex:e.css("z-index")}),t.each(["top","left","bottom","right"],function(t,s){i[s]=e.css(s),isNaN(parseInt(i[s],10))&&(i[s]="auto")}),e.css({position:"relative",top:0,left:0,right:"auto",bottom:"auto"})),e.css(n),s.css(i).show()},removeWrapper:function(e){var i=document.activeElement;return e.parent().is(".ui-effects-wrapper")&&(e.parent().replaceWith(e),(e[0]===i||t.contains(e[0],i))&&t(i).focus()),e},setTransition:function(e,i,s,n){return n=n||{},t.each(i,function(t,i){var a=e.cssUnit(i);a[0]>0&&(n[i]=a[0]*s+a[1])}),n}}),t.fn.extend({effect:function(){function e(e){function s(){t.isFunction(a)&&a.call(n[0]),t.isFunction(e)&&e()}var n=t(this),a=i.complete,r=i.mode;(n.is(":hidden")?"hide"===r:"show"===r)?(n[r](),s()):o.call(n[0],i,s)}var i=s.apply(this,arguments),n=i.mode,a=i.queue,o=t.effects.effect[i.effect];return t.fx.off||!o?n?this[n](i.duration,i.complete):this.each(function(){i.complete&&i.complete.call(this)}):a===!1?this.each(e):this.queue(a||"fx",e)},show:function(t){return function(e){if(n(e))return t.apply(this,arguments);var i=s.apply(this,arguments);return i.mode="show",this.effect.call(this,i)}}(t.fn.show),hide:function(t){return function(e){if(n(e))return t.apply(this,arguments);var i=s.apply(this,arguments);return i.mode="hide",this.effect.call(this,i)}}(t.fn.hide),toggle:function(t){return function(e){if(n(e)||"boolean"==typeof e)return t.apply(this,arguments);var i=s.apply(this,arguments);return i.mode="toggle",this.effect.call(this,i)}}(t.fn.toggle),cssUnit:function(e){var i=this.css(e),s=[];return t.each(["em","px","%","pt"],function(t,e){i.indexOf(e)>0&&(s=[parseFloat(i),e])}),s}})}(),function(){var e={};t.each(["Quad","Cubic","Quart","Quint","Expo"],function(t,i){e[i]=function(e){return Math.pow(e,t+2)}}),t.extend(e,{Sine:function(t){return 1-Math.cos(t*Math.PI/2)},Circ:function(t){return 1-Math.sqrt(1-t*t)},Elastic:function(t){return 0===t||1===t?t:-Math.pow(2,8*(t-1))*Math.sin((80*(t-1)-7.5)*Math.PI/15)},Back:function(t){return t*t*(3*t-2)},Bounce:function(t){for(var e,i=4;((e=Math.pow(2,--i))-1)/11>t;);return 1/Math.pow(4,3-i)-7.5625*Math.pow((3*e-2)/22-t,2)}}),t.each(e,function(e,i){t.easing["easeIn"+e]=i,t.easing["easeOut"+e]=function(t){return 1-i(1-t)},t.easing["easeInOut"+e]=function(t){return.5>t?i(2*t)/2:1-i(-2*t+2)/2}})}()})(jQuery);(function(t){var e=/up|down|vertical/,i=/up|left|vertical|horizontal/;t.effects.effect.blind=function(s,n){var a,o,r,l=t(this),h=["position","top","bottom","left","right","height","width"],c=t.effects.setMode(l,s.mode||"hide"),u=s.direction||"up",d=e.test(u),p=d?"height":"width",f=d?"top":"left",g=i.test(u),m={},v="show"===c;l.parent().is(".ui-effects-wrapper")?t.effects.save(l.parent(),h):t.effects.save(l,h),l.show(),a=t.effects.createWrapper(l).css({overflow:"hidden"}),o=a[p](),r=parseFloat(a.css(f))||0,m[p]=v?o:0,g||(l.css(d?"bottom":"right",0).css(d?"top":"left","auto").css({position:"absolute"}),m[f]=v?r:o+r),v&&(a.css(p,0),g||a.css(f,r+o)),a.animate(m,{duration:s.duration,easing:s.easing,queue:!1,complete:function(){"hide"===c&&l.hide(),t.effects.restore(l,h),t.effects.removeWrapper(l),n()}})}})(jQuery);