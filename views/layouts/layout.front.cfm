<cfoutput>

<cfif params.action eq "index">
	<cfset isHome = 1>
<cfelse>
	<cfset isHome = 0>
</cfif>

<!DOCTYPE html>
<html lang="en" <cfif !isHome>style="background-image:url(#getOption(qOptions,'secondary_page_background').attachment#)"</cfif>>
<head>	
	
	<!-- Meta, title, CSS, favicons, etc. -->
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="description" content="#getOption(qOptions,'seo_description').label#">
	<meta name="keywords" content="#getOption(qOptions,'seo_keywords').label#">
	
	<title>		
		<cfif !isHome>#capitalize(activeMenuItem.name)# <cfif len(activeMenuItem.name)>-</cfif></cfif> 
		#getOption(qOptions,'seo_title').label#
	</title>
	
	<!-- Bootstrap core -->
	<script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
	<script src="http://code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
	
	<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Open+Sans:700,400,300" />
	
	<link href="http://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet">
	<script src="http://netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>
	
	<link href="/assets/css/front/style.css" rel="stylesheet">
	
	<cfif !isHome>
		<link href="/assets/css/front/vendor.css" rel="stylesheet">
		<link href="/assets/css/front/sub.css" rel="stylesheet">	
	</cfif>
	
	<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!--[if lt IE 9]>
		<script src="http://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.6.2/html5shiv.js"></script>
		<script src="http://cdnjs.cloudflare.com/ajax/libs/respond.js/1.3.0/respond.js"></script>
	<![endif]-->
	<!-- Place anything custom after this. -->
	
</head>
<body>
<div class="page-wrap">

	<cfif isHome><div class="slider_wrap" style="background-image:url(#getOption(qOptions,'home_slide_1').attachment#)"></cfif>
    
        <div class="navbar_wrap">
            <div class="navbar_top"></div>
            <div class="navbar">	
                <div class="container">
                    
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand" href="/"><img src="#getOption(qOptions,'site_name_and_logo').attachment#" alt="#getOption(qOptions,'site_name_and_logo').label#"></a>
                    </div>
            
                    <div class="navbar-collapse collapse">
                        <ul class="nav navbar-nav">
                            <li>
                                <a href="/"
                                    <cfif cgi.path_info eq "/">class="active"</cfif>>
                                    Home
                                </a>
                            </li>
                            <cfloop query="menuitems">
                                <li>
                                    <a href="#menuitems.urlPath#"
                                        <cfif menuitems.id eq activeMenuItem.id OR !isNull(activeParent) AND menuitems.id eq activeParent.id>class="active"</cfif>>
                                        #menuitems.name#
                                    </a>
                                </li>
                            </cfloop>
                        </ul>
                    </div><!--/.navbar-collapse -->
                
                </div>		
            </div>		
            <div class="navbar_bottom"></div>
            
            <cfif isHome>
                <div class="container">
                    <div class="bannercontent">
                    
                        <cfset spotlightTitle = getOption(qOptions,'home_spotlight_title')>
                        <h1 class="title">#spotlightTitle.label#</h1>
                        <p>#spotlightTitle.content#</p>
                        <br class="clear"><br><br>
                        
                        <cfset spotlightBtn = getOption(qOptions,'home_spotlight_button')>
                        <a href="#spotlightBtn.content#" class="btn btn-primary btn-lg" class="feature_btn">#spotlightBtn.label#</a>
                    </div>
                </div>
                
                <div class="slider_bottom"></div>
            </cfif>
            
        </div>
        
    <cfif isHome></div></cfif>
        
    <cfoutput>#includeContent()#</cfoutput>

</div>

<cfif isHome><br><br></cfif>

<footer class="site-footer">
	<div class="container">
		<div class="row">
			<div class="col-lg-2">
				<img src="#getOption(qOptions,'site_name_and_logo').attachment#" alt="#getOption(qOptions,'site_name_and_logo').label#" class="footer_logo">				
			</div>
			<div class="col-lg-9">
				<ul class="nav-footer">
					<li><a href="/" class="active">Home</a></li>
					<cfloop query="footerMenuItems">
						<li>
							<a href="#footerMenuItems.urlPath#"
								<cfif footerMenuItems.id eq activeMenuItem.id>class="active"</cfif>>
								#footerMenuItems.name#
							</a>
						</li>
					</cfloop>
				</ul>
			</div>
			<div class="col-lg-1">
				<a href="##"><img src="/assets/images/front/ico_fb.png" class="social_icon"></a>
			</div>
		</div>
	</div>
</footer>


</body>
</html>

</cfoutput>