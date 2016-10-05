<cfset themeDir = "/views/layouts/admin/">
<cfset request.page.hideSidebar = true>
<cfset request.page.hideFooterCallToAction = true>
<cfset request.page.clearThemeWrapper = true>
<cfset request.page.noBgImage = true>
<cfset contentFor(siteTitle = "#sanitize(includeContent('headerTitle'))# | Web Panel")>
<cfoutput>  
	<cfsavecontent variable="adminbody">
		<!-- test -->
		<cfinclude template="#themeDir#assets/include/head.cfm">
		<!-- test -->
		<div id="wrapper" class="admin-content">
		
			<cfif NOT flashIsEmpty()>
				<div class="container">				
					<cfif flashKeyExists("error")>
						<div class="alert alert-danger alert-dismissable fade in">
							<button class="close" data-dismiss="alert">&times;</button>
							<strong>#flash("error")#</strong> 
							<cfif !isNull(errorMessagesName)>												
								#errorMessagesFor(errorMessagesName)#
							</cfif>
						</div>
					</cfif>
					
					<cfif flashKeyExists("success")>
						<div class="alert alert-success">
							<button type="button" class="close" data-dismiss="alert">&times;</button>
							<strong>#flash("success")#</strong>
						</div>
					</cfif>
				</div>
			</cfif>			
			
			#includeContent("formWrapStart")#			
			
			<!-- Main page container -->
			<section class="container" role="main">	
				
				<cfif len(includeContent("rightColumn"))>
					<cfset mainClass = "col-sm-9 leftside">
				<cfelse>
					<cfset mainClass = "col-sm-12">
				</cfif>
				
				#includeContent("extraSection")#
				
				<cfif !len(includeContent("clearLayout"))>
				
					<!-- Grid row -->
					<div class="row contentwrapper">
	
						<!-- Data block -->
						<div class="#mainClass#">
							<div class="data-block">
								<header>
									<cfif len(includeContent("headerTitle"))>
										<h2>#includeContent("headerTitle")# #includeContent("headerTitleAppend")#</h2>
										<cfif len(includeContent("headerButtons"))>
											<ul class="data-header-actions">#includeContent("headerButtons")#</ul>
											<br class="clear">
										</cfif>	
									</cfif>
								</header>
								<section>							
								
				</cfif>	
					
				#includeContent()#
								
				<cfif !len(includeContent("clearLayout"))>		
						
								</section>
							</div>
						</div>
						<!-- /Data block -->
						
						<cfif len(includeContent("rightColumn"))>
							<div class="col-sm-3 rightbar">
								#includeContent("rightColumn")#
							</div>
						</cfif>
						
					</div>
					<!-- /Grid row -->
				</cfif>
				
			</section>
			<!-- /Main page container -->
						
			<!-- Sticky footer push -->
			<div id="push"></div>
			
			#includeContent("formWrapEnd")#
			
			<cfif len(includeContent("plupload"))>
				<script type="text/javascript" src="/assets/vendor/plupload/plupload.full.min.js"></script>
				<script type="text/javascript" src="/assets/vendor/plupload/jquery.plupload.queue/jquery.plupload.queue.js"></script>
				<link rel="stylesheet" href="/assets/vendor/plupload/plupload.bootstrap/css/plupload.bootstrap.css" type="text/css" media="screen" />
				<script type="text/javascript" src="/assets/js/plupload.video.js"></script>
				
				<script type="text/html" id="tmpl_ytThumbs">	
					<div class="form-group">
						#bLabel(label="Choose a Thumbnail",class="control-label")#
						<div class="controls">
							<% for ( var id = 0; id < videos.length; id++ ) { %>	
							
								<div class="wiz_thumb">
									<label for="img">
										<img class="img" src="http://i.ytimg.com/vi/<%=videos[id]%>/hqdefault.jpg" />
										<input type="radio" name="thumbid" class="thumbid" value="<%=videos[id]%>" checked />
									</label>
								</div>
							
							<% } %>
							<br class="clear" />
						</div>
					</div>	
				</script>
				
			</cfif>
			
			<cfif len(includeContent("selectize")) OR len(includeContent("formy"))>
			
				#styleSheetLinkTag(sources='vendor/selectize/css/selectize.bootstrap3.css')#
				#javaScriptIncludeTag(sources='
					vendor/selectize/js/standalone/microplugin.min.js,
					vendor/selectize/js/standalone/sifter.min.js,
					vendor/selectize/js/standalone/selectize.js
				')#
				
				<script type="text/javascript">
					$(function() {
						$('.multiselectize').selectize({
							maxItems: null
						});
						$('.selectize').selectize();
						$('.selectizetags').selectize({
							delimiter: ',',
							persist: false,
							create: function(input) {
								return {
									value: input,
									text: input
								}
							}
						});
					});
				</script>	
			</cfif>
			
			<cfif len(includeContent("checkable")) OR len(includeContent("formy"))>
			
				#javaScriptIncludeTag(sources='vendor/js/plugins/prettyCheckable/prettyCheckable.js')#
				#styleSheetLinkTag(sources='vendor/css/plugins/prettycheckable/prettyCheckable.css')#
		
				<script>
					$(document).ready(function() {
		
						$('.styled-checkbox input, .styled-radio input').prettyCheckable();
		
					});
				</script>
		
			</cfif>
			
			<cfif len(includeContent("ajaxModal")) OR len(includeContent("formy"))>
				#javaScriptIncludeTag(
					sources="
						vendor/jquery.form.js,
						js/ajax.js				
				")#	
				<div id="ajax-modal" class="modal primary container hide fade" tabindex="-1"></div>
			</cfif>
		
		</div>
		
	</cfsavecontent>
	
	<!--- Inject the above variable into the parent layout --->
	<cfset contentFor(adminbody=adminbody)>
	
	<!--- Include the parent layout --->
	#includeLayout("/themes/#request.site.theme#/layout.cfm")#	
</cfoutput>