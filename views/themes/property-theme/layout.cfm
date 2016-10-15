<cfoutput>
<cfset themeDir = "/views/themes/#request.site.theme#/">
<cfset listingPhone = len(trim(property.phone_number)) ? property.phone_number : agent.phone> 
<!DOCTYPE html>
<html lang="en">

<head>
    <cfif isNull(property)>Fail.<cfabort></cfif>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <cfset fulladdress = "#property.address#, #property.city#, #property.state# #property.zip#">
    <title>#property.name# - #fulladdress#</title>

    <meta property="og:title" content="#property.name# - #fulladdress#" />
    <meta property="og:url" content="#replaceNoCase(cgi.request_url,"/rewrite.cfm","")#" />
    <meta property="og:type" content="website" />       
    <meta property="og:description" content="#property.description#" /> 
    <meta property="og:image" content="http://#property.urlid#.propertylure.com/assets/uploads/mediafiles/#photos.fileid#-xm.jpg" />   
    <meta property="og:site_name" content="PropertyLure.com" />

    <!--- Public head sets admin colors and adds tags: jquery, bootstrap, modernizer, adminmenu --->
    #includePartial(
        partial="/_partials/publicHeadTags", 
        adminHeadColor = "54a5de"
    )#

    <cfset cssPaths = [
        "#themeDir#assets/css/bootstrap.min.css",
        "#themeDir#assets/css/owl.carousel.css",
        "#themeDir#assets/css/owl.theme.css",

        "#themeDir#assets/css/animate.css",

        "#themeDir#assets/css/flexslider.css",

        "#themeDir#assets/css/responsive.css",

        "#themeDir#assets/css/baguetteBox.min.css",
        
        "#themeDir#assets/css/line-icons.min.css",
        "/assets/vendor/justifiedGallery/justifiedGallery.min.css"
    ]>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css">
    <link href="http://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css">

    <link href="/models/services/vendor/combine/combine.cfm?files=#arrayToList(cssPaths)#" type="text/css" rel="stylesheet" />
    <link rel="stylesheet" href="#themeDir#style.css">

    <!--- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries --->
    <!--- WARNING: Respond.js doesn't work if you view the page via file:// --->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body id="page-top" data-spy="scroll" data-target=".navbar-fixed-top">   

    <div class="hide"><img src='/assets/uploads/mediafiles/#photos.fileid#-xm.jpg'></div>
    
    <nav class="navbar">
        #includePartial(
            partial="/_partials/adminmenufull"
        )#

        <div class="container">

            <div class="navbar-header">                
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-main-collapse">
                    <i class="fa fa-bars"></i>
                </button>
                <a <cfif !isMobile()>class="navbar-brand page-scroll wow pulse animated" href="##section-contact"<cfelse>
                    class="navbar-brand" href="tel:1-#listingPhone#"</cfif>
                >Call #listingPhone#</a>
            </div>

            
           
            
            <div class="collapse navbar-collapse navbar-right navbar-main-collapse">           
                <ul class="nav navbar-nav pull-right">
                    <li class="active"><a class="page-scroll" href="##section-slider">Home</a></li>
                    <li><a class="page-scroll" href="##section-counter">Overview</a></li>
                    <li><a class="page-scroll" href="##section-tour">Virtual Walkthrough</a></li>
                    <li><a class="page-scroll" href="##section-portfolio">Details</a></li>
                    <li><a class="page-scroll" href="##section-gallery">Gallery</a></li>                    
                    <li><a class="page-scroll" href="##section-map">Map</a></li>
                    <!--- <li><a class="page-scroll" href="##section-gallery">Documents</a></li> --->
                    <li><a class="page-scroll" href="##section-contact">Contact</a></li>
                </ul>
            </div>
            
        </div>
        
    </nav>

    

	
	<div class="jumbotron text-center">
        <div class="flex-caption " style="z-index:1020">
            <h4 class="wow slideInRight">#property.name#</h4>
            <h2 class="wow slideInLeft">#fulladdress#</h2>
            <cfset price = listFirst(DollarFormat(property.price),".")>
            <h4 class="wow slideInRight">#price#</h4>            
            <div class="text-center">
                Status: Active &bull; Last Updated: Today, #dateFormat(now(), "DDDD, MMMM D, YYYY")#
            </div>
            <div class="btn-container wow fadeInUp">
                <a href="##section-counter" class="page-scroll btn btn-primary white">Learn more</a>
                <cfif isMobile()>
                    <a href="##section-gallery" class="page-scroll btn btn-primary black">Gallery</a>
                <cfelse>
                    <a href="##section-tour" class="page-scroll btn btn-primary black">Virtual Walkthrough</a>
                </cfif>
            </div>
        </div>
		<ul class="slides">
            <cfset count = 1>
             <cfloop query="photos">
               <li style="background-image: url('/assets/uploads/mediafiles/#photos.fileid#-xm.jpg');"></li>
               <cfif count GTE 5><cfbreak></cfif>
               <cfset count++>
            </cfloop>
		</ul>
	</div>
    
    
    <section id="section-counter">
        <div class="bg-overlay"></div>
        <div class="container">
            <div class="row">
                <div class="col-md-3 col-sm-6 col-xs-6 wow fadeInRight" data-wow-delay=".3s">
                    <div class="counter-box">
                        <div class="count">#property.beds#</div> 
                        <h5>beds</h5>
                        <!--- <sup>plus extra office/sewing room</sup> --->
                    </div>
                </div> 
                <div class="col-md-3 col-sm-6 col-xs-6 wow fadeInRight" data-wow-delay=".6s">
                    <div class="counter-box">
                        <div class="count">#property.full_baths#</div> 
                        <h5>baths</h5>
                    </div>
                </div> 
                <div class="col-md-3 col-sm-6 col-xs-6 wow fadeInRight" data-wow-delay=".9s">
                    <div class="counter-box">
                        <div class="count">#NumberFormat(property.finished_square_feet,",")#</div> 
                        <h5>interior sqft</h5>
                    </div>
                </div> 
                <div class="col-md-3 col-sm-6 col-xs-6 wow fadeInRight" data-wow-delay=".9s">
                    <div class="counter-box">
                        <div class="count">#NumberFormat(property.lot_size,",")#</div> 
                        <h5>#property.lot_size_type# lot</h5>
                    </div>
                </div> 
            </div>
        </div>
    </section>
    
   
    
    <section id="section-services">
        <div class="container">
            <div class="row">
                <div class="col-md-12 wow slideInLeft">
                    <div class="section-heading text-center">
                        <h2 class="section-title">Overview</h2>
                        <p>#property.description#</p>
                    </div>
                </div>
            </div> 
        </div> 
    </section>
    

    <section id="section-tour" class="blue-section section">
        <div class="container">
            <div class="row">
                <div class="col-md-12 wow fadeInUp">
                    <div class="section-heading text-center">
                        <h2 class="section-title">Virtual Walkthrough</h2>
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="panorama-wrap">
                        <div class="panorama">
                        <cfif agent.lastname eq "Bogema" AND !url.containsKey("demo")>
                            <iframe width="853" height="480" src="https://my.matterport.com/webgl_player/##model=6xwMivRx3uo" frameborder="0" allowfullscreen=""></iframe>
                        <cfelse>
                            <iframe allowfullscreen="true" webkitallowfullscreen="true" mozallowfullscreen="true" src="/assets/vendor/pannellum/pannellum.htm?config=/property/panoJson/#property.id#"></iframe>
                        </cfif>                           

                        </div>
                    </div>
                    <br class="clear"><br><br><br>
                </div>
            </div> 
        </div> 
    </section>

    
    <section id="section-portfolio" class="section-padding">
        <div class="container">
            <div class="row">
                <div class="col-md-12 wow fadeInDown">
                    <div class="section-heading text-center">
                        <h2 class="section-title">Details</h2>
                    </div>
                </div>
            </div> <!--heading row end -->
        </div> <!--heading row end -->
            
        <div class="container">
            <div class="row">
                <div class="col-md-12 wow slideInLeft" data-wow-delay=".3s">

                    <div class="col-md-6 feature-boxes">
                        <h4>Facts</h4>
                        <ul>
                            <li>Lot: #NumberFormat(property.lot_size,",")# #property.lot_size_type#</li>
                            <li>#property.home_type#</li>
                        </ul>
                        <ul>
                            <li>Built in #property.year_built#</li>
                            <li>Cooling: #getDataField('cooling-type')#</li>
                        </ul>
                    </div>

                    <div class="col-md-6 feature-boxes">
                        <h4>Features</h4>
                        #dataFieldListHtml('indoor-features',2)#
                        <ul>
                            <li>Basement: #getDataField('basement')#</li>
                            <li>Flooring: #getDataField('floor-covering')#</li>
                        </ul>
                        <ul>
                             <li>Parking: #getDataField('parking')#, #property.covered_parking# spaces, #NumberFormat(property.garage_square_feet,",")# sqft garage</li>
                        </ul>
                    </div>

                    <cfif len(trim(property.additional_features))>
                        <div class="col-md-6 feature-boxes">
                            <h4>Additional Features</h4>
                            <ul>
                                <cfloop list="#property.additional_features#" index="item">
                                    <li>#item#</li>
                                </cfloop>
                            </ul>
                        </div>
                    </cfif>

                    #dataFieldHtml("Appliances Included","appliances",2)#

                    #dataFieldHtml("Room Types","rooms",2)#

                    <div class="col-md-6 feature-boxes">
                        <h4>Construction</h4>
                        <ul>
                            #dataFieldListItemHtml("exterior","Exterior material")#
                            #dataFieldListItemHtml("roof","Roof type")#
                        </ul>
                        <ul>
                            #dataListItemHtml("number_of_stories","Stories")#
                            #dataFieldListItemHtml("architectural-style","Structure type")#
                        </ul>
                    </div>

                    #dataFieldHtml("Building Amenities","Building-Amenities",2)#

                    #dataFieldHtml("Outdoor Amenities","Outdoor-Amenities",2)#

                    <div class="col-md-6 feature-boxes">
                        <h4>Other</h4>
                        <ul>
                            <li>Floor size: #NumberFormat(property.finished_square_feet,",")# sqft</li>
                            <li>View: #getDataField('view')#</li>
                        </ul>
                        <ul>
                            <li>Heating type: #getDataField('heating-type')#</li>
                            <li>Heating fuel: #getDataField('heating-fuel')#</li>
                        </ul>
                        <ul>                            
                            <cfif property.hoa_dues GT 0><li>HOA Dues: #DollarFormat(property.hoa_dues)#</li></cfif>               
                        </ul>
                    </div>

                </div>
            </div>
        </div>
    </section>

    
    <section id="section-gallery" class="section-padding">
        <div class="container">
            <div class="row">
                <div class="col-md-12 wow bounceInUp">
                    <div class="section-heading text-center light">
                        <h2 class="section-title">Property Gallery</h2>
                        <p>Take a look around!</p>
                    </div>
                </div>
            </div> 
        </div>
        <div id="justifiedGallery" class="gallery">
            <cfloop query="photos">
                <a href="/assets/uploads/mediafiles/#photos.fileid#-#isMobile() ? "md" : "xm"#.jpg" data-caption="#photos.name#">
                    <img data-original="/assets/uploads/mediafiles/#photos.fileid#-sm.jpg" alt="#photos.name#">
                </a>
            </cfloop>
        </div>
    </section>

    <section id="section-map" class="section">
        <div class="container">
            <div class="row">
                <div class="col-md-12 wow fadeInUp">
                    <div class="section-heading text-center">
                        <h2 class="section-title">Map</h2>
                    </div>
                </div>                    
            </div> 
        </div> 
        <div class='embed-container maps'>
            <iframe src="https://www.google.com/maps/embed/v1/place?key=AIzaSyCs5mGWeXeIryCgPZZBQ6613-E75SDbxWM&q=#fulladdress#" frameborder="0" style="width:100%;height:400px;border:0;margin-bottom:-10px;" allowfullscreen></iframe></section>
        </div>
    <section id="section-contact" class="section-padding blue-section">
        <div class="container">
            <div class="row">
                <div class="col-md-12 wow fadeInDown">
                    <div class="section-heading text-center">
                        <h2 class="section-title">Get in touch</h2>
                        <h4>Contact us today to schedule a showing!</h4>
                    </div>
                </div>
            </div> 
            <div class="row">
                <div class="col-md-4 col-sm-4 wow fadeInLeft">
                    <div class="contact-info">
                        <cfif agent.lastname neq "Badolato">
                            <div class="info-box">
                                <div class="info-img">
                                    <cfif fileExists(expandPath('/assets/userpics/#agent.id#.jpg'))>
                                        <img style="max-height:50px;" src='/assets/userpics/#agent.id#.jpg'>
                                    </cfif>
                                </div>
                                <div class="info-desc">
                                    <p>#agent.firstname# #agent.lastname#</p>
                                </div>
                            </div>  
                        </cfif>

                        <cfif len(trim(listingPhone))>
                            <div class="info-box">
                                <i class="fa fa-phone"></i>
                                <div class="info-desc">
                                    <p><cfif isMobile()><a href="tel:1-#listingPhone#">#listingPhone#</a><cfelse>#listingPhone#</cfif></p>
                                </div>
                            </div>
                        </cfif>

                        <cfif agent.lastname neq "Badolato">
                            <div class="info-box">
                                <i class="fa fa-envelope"></i>
                                <div class="info-desc">
                                    <p>#agent.email#</p>
                                </div>
                            </div>
                        </cfif>

                        <div class="info-box">
                            <i class="fa fa-map"></i>
                            <div class="info-desc">
                                <p>#property.address#<br> #property.city#, #property.state# #property.zip#</p>
                            </div>
                        </div>
                        
                    </div>
                </div> 
                <div class="col-md-8 col-sm-8 wow fadeInRight">
                    #generateForm(formid=2,formwrap=true,overrideRecipientId=property.ownerid)#
                </div>
            </div> 
        </div>
    </section>

    <footer id="section-footer">
        <div class="container">
            <div class="row">
                <div class="col-md-12 wow bounceInUp">
                    <span class="text-left copy">
                        Copyright &copy; #dateFormat(now(),"YYYY")#
                    </span>
                    <span class="text-right copy pull-right">
                        Proudly powered by <a href="http://PropertyLure.com" style="color:white">PropertyLure.com</a>
                    </span>                    
                </div>
            </div>
        </div>
    </footer>

    <cfset jsPaths = [
        "#themeDir#assets/js/jquery.js",
        "#themeDir#assets/js/bootstrap.min.js",
        "#themeDir#assets/js/jquery.easing.min.js",
        "#themeDir#assets/js/respond.js",
        "#themeDir#assets/js/html5shiv.js",
        "#themeDir#assets/js/jquery.flexslider.js",
        "#themeDir#assets/js/jquery.waypoints.min.js",
        "#themeDir#assets/js/jquery.counterup.min.js",
        "#themeDir#assets/js/wow.min.js",
        "#themeDir#assets/js/baguetteBox.min.js",
        "/assets/vendor/justifiedGallery/jquery.justifiedGallery.min.js",
        "#themeDir#app.js"
    ]>
    <script src="/models/services/vendor/combine/combine.cfm?files=#arrayToList(jsPaths)#" type="text/javascript"></script>
</body>

</html>
<cffunction returntype="String" name="getDataField" output="false">
    <cfargument name="field">
    <cfif dataFieldsMap.containsKey(field) AND listLen(dataFieldsMap[field])>
        <cfreturn replace(dataFieldsMap[field],",",", ","ALL")>
    <cfelse>
        <cfreturn "">
    </cfif>
</cffunction>
<cffunction name="dataFieldHtml">
    <cfargument name="label">
    <cfargument name="field">
    <cfargument name="groupLimit">
    <cfif dataFieldsMap.containsKey(field) AND listLen(dataFieldsMap[field])>
        <div class="col-md-6 feature-boxes">
            <h4>#label#</h4>
            #dataFieldListHtml(field,groupLimit)#
        </div>
    </cfif> 
</cffunction>
<cffunction name="dataFieldListHtml">
    <cfargument name="field">
    <cfargument name="groupLimit" default="2">
    <cfset var count = 0>
    <cfset var totalCount = 0>

    <cfif dataFieldsMap.containsKey(field)>
        <cfset var list = dataFieldsMap[field]>
        <cfloop list="#list#" index="item">
            <cfset count++>
            <cfset totalCount++>
            <cfif count eq 1><ul></cfif>
            <li>#item#</li>
            <cfif totalCount GTE listLen(list) OR count GTE groupLimit>
                </ul>
                <cfset count = 0>
            </cfif>        
        </cfloop> 
    </cfif>
</cffunction>
<cffunction name="dataListItemHtml">
    <cfargument name="field">
    <cfargument name="label">
    <cfif len(property[field])><li>#label#: #property[field]#</li></cfif>
</cffunction>
<cffunction name="dataFieldListItemHtml">
    <cfargument name="field">
    <cfargument name="label">
    <cfset var fieldData = getDataField(field)>
    <cfif len(trim(fieldData))><li>#label#: #fieldData#</li></cfif>
</cffunction>

</cfoutput>
