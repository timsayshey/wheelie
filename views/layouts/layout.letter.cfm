<!DOCTYPE html> 
<html itemscope itemtype="http://schema.org/Organization">
<head prefix="og: http://ogp.me/ns## fb: http://ogp.me/ns/fb## website: http://ogp.me/ns/website##">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta charset="utf-8">
	
	<cfoutput>	
		<title>#len(includeContent("siteTitle")) ? includeContent("siteTitle") : request.site.name#</title>
		<meta name="description" content="#len(includeContent("siteDesc")) ? includeContent("siteDesc") : request.site.name#">
		<meta name="keywords" content="#len(includeContent("siteKeywords")) ? includeContent("siteKeywords") : request.site.name#">
		<meta name="robots" content="index, follow">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
	</cfoutput>
	
	<link rel="icon" type="image/png"  href="/favicon.png">

<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
<style type="text/css">
	h1 {
		margin-bottom:0;
		font-size:20px;		
	}
	.clear {
		clear: both;
		display: block;
		overflow: hidden;
		visibility: hidden;
		width: 0;
		height: 0;
		display:none;
	}
	.fb-like-widget {
		margin-bottom:20px;	
	}
	.page-wrap {
		-webkit-box-shadow: 0px 0px 5px 0px rgba(50, 50, 50, 0.75);
		-moz-box-shadow:    0px 0px 5px 0px rgba(50, 50, 50, 0.75);
		box-shadow:         0px 0px 5px 0px rgba(50, 50, 50, 0.75);	
		background:#fff; 
		box-shadow:8px #888; 
		padding:40px 60px; 
		margin:40px 0;
	}
	.img-responsive {
		display:inline-block;	
	}
	
	/* Mobile */
	@media (max-width: 991px) {
		.page-wrap {
			padding:20px;
			margin:0;
			margin:15px 0;
		}
	}
</style>
</head>
<body style="background:#cccccc;">
	<cfoutput>	
		<div class="container">
			<div class="row">	
				<div class="col-md-8 col-md-offset-2">
					<div class="page-wrap">
						<div class="text-center">
							<img src="#getOption(qOptions,'site_logo').attachment#" width="285" class="img-responsive">
						</div>						
						#includeContent()#
					</div>
				</div>
			</div>
		</div>
	</cfoutput>
</body>
</html>