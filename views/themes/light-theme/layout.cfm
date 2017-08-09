<cfoutput>
<cfset themeDir = "/views/themes/#request.site.theme#/">

<cfif params.action eq "index">
	<cfset isHome = 1>
<cfelse>
	<cfset isHome = 0>
</cfif>

<!DOCTYPE html>
<html lang="en">
<head>

	<!-- Meta, title, CSS, favicons, etc. -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="#getOption(qOptions,'seo_description').label#">
    <meta name="keywords" content="#getOption(qOptions,'seo_keywords').label#">

    <title>
        <cfif !isHome>#capitalize(activeMenuItem.name)# <cfif len(activeMenuItem.name)>-</cfif></cfif>
        <cfif len(getOption(qOptions,'seo_title').label)>
            #getOption(qOptions,'seo_title').label#
        <cfelse>
            #request.site.name#
        </cfif>
    </title>

	<!--- Public head sets admin colors and adds tags: jquery, bootstrap, modernizer, adminmenu --->
	#includePartial(
		partial="/_partials/publicHeadTags",
		adminHeadColor = "54a5de"
	)#

    <meta name="robots" content="index, follow">

    <link href="#themeDir#assets/bootstrap.min.css" media="all" rel="stylesheet" type="text/css">
    <link href="#themeDir#assets/todc-bootstrap.min.css" media="all" rel="stylesheet" type="text/css">
    <link href="#themeDir#assets/jquery.bxslider.css" media="all" rel="stylesheet" type="text/css">
    <link href="#themeDir#assets/menu.css" media="all" rel="stylesheet" type="text/css">

    <link href='//fonts.googleapis.com/css?family=Lato:300,400,300italic,400italic' rel='stylesheet' type='text/css'>
    <link href='//fonts.googleapis.com/css?family=Montserrat:400,700' rel='stylesheet' type='text/css'>
    <link href="/assets/css/shared.css" rel="stylesheet" type="text/css"/>
    <link href="#themeDir#style.css" rel="stylesheet" type="text/css">

    <script src="#themeDir#assets/jquery.bxslider.min.js" type="text/javascript"></script>
    <script src="#themeDir#assets/jquery.placeholder.js" type="text/javascript"></script>

    <link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">

    <script>
    $(function() {
        $('input, textarea').placeholder();
    });
    </script>

	<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!--[if lt IE 9]>
		<script src="http://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.6.2/html5shiv.js"></script>
		<script src="http://cdnjs.cloudflare.com/ajax/libs/respond.js/1.3.0/respond.js"></script>
	<![endif]-->
	<!-- Place anything custom after this. -->

</head>
<cfset adminmode = len(includeContent("adminbody")) ? 'adminmode' : ''>
<body class="#adminmode#">
<div class="page-wrap #adminmode#">
	<!--- Admin bar for logged in users // Remove this if you don't want the admin bar on the frontend --->
	#includePartial(
		partial="/_partials/adminmenufull"
	)#
	<div id="wrapper">
        <div class="headerWrap">
            <header id="header" class="container">
                <div class="row">
                    <div class="col-md-8">
                        <h1 class="logo pull-left">#request.site.name#</h1>
                    </div>
                    <div class="col-md-4">
                        <cfif !isNull(session.user)>
                            <cfset editAccount = urlFor(
                                route       = "admin~Id",
                                module      = "admin",
                                controller  = "profiles",
                                action      = "profile",
                                id          = session.user.id
                            )>
                            <a href='#editAccount#'><img class="img-circle img-responsive pull-right" src="#fileExists(expandThis('/assets/userpics/#session.user.id#.jpg')) ? assetUrlPrefix() & '/assets/userpics/#session.user.id#.jpg' : '/assets/img/user_thumbholder.jpg'#" style="max-width: 50px;"></a>
                        </cfif>
                    </div>
                </div>
            </header>
            <div class="navwrap">
                <div class="topnav">
                    <nav class="container">
                        <div id="menu-wrap"  class="row">
                        <ul id="menu" style="display: none;">
                            <li>
                                <a href="/"
                                    <cfif !isNull(home)>class="active"</cfif>>
                                    Home
                                </a>
                            </li>

                            #generateMenu(true)#
                            </li>
                        </ul>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
    </div>
    <div class="bg-slider-wrap">
        <ul class="bg-slider">
            <li style="background-image:url(#themeDir#assets/bg.jpg);">
                <img width="1280" height="190" src="#themeDir#assets/bg.jpg" title="A safe place for healing">
            </li>
        </ul>
    </div>
    <div class="wrap container">
        <div class="content row">
            <div class="main col-sm-12">
                <div class="main-container heads-up">
                    <div class="row contentwrapper">
                        <!--- <div class="col-md-9 leftside"> --->
                            <cfif len(includeContent("adminbody"))>
                                <style>
                                    .main-container.heads-up {
                                        padding:0px !important;
                                    }
                                    .admin-content {
                                        padding-top: 0px !important;
                                        margin-top: -80px !important;
                                    }
                                    .main-container {
                                        background: none;
                                    }
                                </style>
                                #includeContent("adminbody")#
                            <cfelse>
                                <cfif isNull(request.templateActive)>
                                    <section class="page-wrapper">
                                        <article class="page-content-full">
                                            #includeContent()#
                                        </article>
                                    </section>
                                <cfelse>
                                    #includeContent()#
                                </cfif>
                            </cfif>

                        <!--- </div>
                        <div class="col-md-3 rightbar">
                            <div class="data-block">
                                <section>
                                    <form enctype="multipart/form-data" method="post" action="##">
                                        <input id="qform-id" name="qform[id]" type="hidden" value="12">
                                        <div class="col-md-12">
                                            <h2>
										Contact Us
										</h2>
                                            <p>
                                                Fill out the form below.
                                            </p>
                                        </div>
                                        <div class="col-md-12">
                                            <label class="" for="fielddata-74">Name</label>
                                            <input class="form-control  " id="fielddata-74" name="fielddata[74]" placeholder="" style="" type="text" value="">
                                            <div class="separator"></div>
                                        </div>

                                        <div class="col-md-12">
                                            <button type="submit" class="btn btn-sm btn-warning btn-block">Send</button>
                                        </div>
                                    </form>
                                    <br class="clear">
                                </section>
                            </div>
                            <div class="extras"></div>
                        </div> --->
                        <br class="clear">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="footerNav">
        <div class="container">
            <ul class="footerMenu">
                <li>
                    <a href="/"
                        <cfif !isNull(home)>class="active"</cfif>>
                        Home
                    </a>
                </li>

                #generateMenu(false)#
            </ul>
        </div>
    </div>

</div>

<script src="#themeDir#assets/menu.js"></script>
<script>
    jQuery(document).ready(function($) {
        var pageSlides = $('.bg-slider').children(),
            slideIndex = 0,
            slideCount = pageSlides.length;
        pageSlides.each(function(i) {
            var $el = $(this),
                $img = $el.find('img');
            if (i == 0) {
                slideIndex++;
            } else {
                var myImage = new Image();
                myImage.onload = function() {
                    $img.css('visibility', 'hidden');
                    slideIndex++;
                    if (slideIndex == slideCount) {
                        $('.bg-slider').bxSlider({
                            touchEnabled: false,
                            captions: false,
                            pager: false,
                            controls: false,
                            auto: true,
                            mode: 'fade',
                            onSliderLoad: function() {
                                pageSlides.find('img').each(function() {
                                    var $my = $(this);
                                    $my.closest('li').css('backgroundImage', 'url(' + $my.attr('src') + ')');
                                });
                                // Captions
                                $(".bx-caption").addClass("slider-caption").addClass("container").removeClass("bx-caption");
                            },
                            onSlideNext: function($slideElement) {
                                $(".slider-caption").text($slideElement.find("img").attr("title"));
                            }
                        });
                    }
                };
                myImage.src = $img.attr('src');
            }
        });
    });
</script>

</body>
</html>

</cfoutput>
