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
	
    <link href='http://fonts.googleapis.com/css?family=Montserrat:400,700' rel='stylesheet' type='text/css'>  
	
	<link href="#themeDir#assets/css/bootstrap.min.css" rel="stylesheet">
	
	<link href="#themeDir#assets/css/style.css" rel="stylesheet">
	
	<link href="#themeDir#assets/css/vendor.css" rel="stylesheet">
	<link href="#themeDir#assets/css/sub.css" rel="stylesheet">	
		
	
	<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
	<!--[if lt IE 9]>
		<script src="http://cdnjs.cloudflare.com/ajax/libs/html5shiv/3.6.2/html5shiv.js"></script>
		<script src="http://cdnjs.cloudflare.com/ajax/libs/respond.js/1.3.0/respond.js"></script>
	<![endif]-->
	<!-- Place anything custom after this. -->
	
</head>
<body>
<div class="page-wrap">
		<!--- Admin bar for logged in users // Remove this if you don't want the admin bar on the frontend --->
		#includePartial(
			partial="/_partials/adminmenufull"
		)#
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
                        <h2 class="logo-text">#request.site.name#</h2>
                    </div>
            
                    <div class="navbar-collapse collapse">
                        <ul class="nav navbar-nav">
                            <li> 
								<a href="/"
									<cfif !isNull(home)>class="active"</cfif>>
									Home
								</a>
							</li>
							
							#generateMenu(false)#
                        </ul>
                    </div><!--/.navbar-collapse -->
                
                </div>		
            </div>		
            <div class="navbar_bottom"></div>
            
        </div>
		<cfif len(includeContent("adminbody"))>
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
</div>


<footer class="site-footer">
	<div class="container">
		<div class="row">
			<div class="col-lg-2">
				<img src="#getOption(qOptions,'site_name_and_logo').attachment#" alt="#getOption(qOptions,'site_name_and_logo').label#" class="footer_logo">				
			</div>
			<div class="col-lg-9">
				<ul class="nav-footer">
					<li> 
						<a href="/"
							<cfif !isNull(home)>class="active"</cfif>>
							Home
						</a>
					</li>
					
					#generateMenu(false)#
				</ul>
			</div>
			<div class="col-lg-1">
				<a href="##"><img src="#themeDir#assets/images/ico_fb.png" class="social_icon"></a>
			</div>
		</div>
	</div>
</footer>


</body>
</html>

</cfoutput>