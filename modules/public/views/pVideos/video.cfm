<cfoutput>

	<cfscript>
		request.video.hideSidebar = true;
		request.video.hideFooterCallToAction = true;
	</cfscript>
	
	<h1>#video.name#</h1><br class="clear">
<br>

	<cfif len(video.password) AND isNull(session.videoaccess[video.id])>
		<cfif flashKeyExists("error")>
			<div class="alert alert-danger alert-dismissable fade in">
				<button class="close" data-dismiss="alert">&times;</button>
				<strong>#flash("error")#</strong> 
				<cfif !isNull(errorMessagesName)>												
					#errorMessagesFor(errorMessagesName)#
				</cfif>
			</div>
		</cfif>
			
		<strong>Password Required:</strong><br>
		<form action="/video/#video.id#" method="post">
			<input type="text" name="password" class="form-control"><br>
			<input type="submit" class="btn btn-warning btn-lg">
		</form>
	<cfelse>
		<iframe src="https://player.vimeo.com/video/#video.vimeoid#" style="width:720px;height:480px;" frameborder="0" webkitallowfullscreen="" mozallowfullscreen="" allowfullscreen=""></iframe>
	</cfif>
	
</cfoutput>