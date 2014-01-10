<cfoutput>

<div class="container">
	<h2>#getOption(qOptions,'home_welcome_title').label#</h2>
	
	<cfset content = REReplace(home.content,'<[^>]*>','','all')>
	<cfset content = ListToArray(content," ")>
	<cfset colOneStart = 1>
	<cfset colOneStop = ArrayLen(content) / 2>
	<cfset colTwoStart = ArrayLen(content) / 2 + 1>
	<cfset colTwoStop = ArrayLen(content)>	
	
	<div class="row">
		<div class="col-lg-6">
		
			<cfloop from="#colOneStart#" to="#colOneStop#" index="i">
				#content[i]#
			</cfloop>
			
		</div>
		<div class="col-lg-6">
		
			<cfloop from="#colTwoStart#" to="#colTwoStop#" index="i">
				#content[i]#
			</cfloop>
			 
		</div>
	</div>
	
</div>

<hr>
<br><br>

<div class="container">

	<div class="row">
		<div class="col-lg-4">
			<cfset feature = getOption(qOptions,'home_feature_1')>
			<a href="#feature.content#" class="featured_event">
				<div class="featured_text">#feature.label#</div>
				<img src="#feature.attachment#" width="301" height="147">
			</a>
		</div>
		<div class="col-lg-4">
			<cfset feature = getOption(qOptions,'home_feature_2')>
			<a href="#feature.content#" class="featured_event">
				<div class="featured_text">#feature.label#</div>
				<img src="#feature.attachment#" width="301" height="147">
			</a>
	 	</div>
		<div class="col-lg-4">
			<cfset feature = getOption(qOptions,'home_feature_3')>
			<a href="#feature.content#" class="featured_event">
				<div class="featured_text">#feature.label#</div>
				<img src="#feature.attachment#" width="301" height="147">
			</a>
		</div>
	</div>

</div> 

<hr>

<div class="container">
	
	<div class="row">
		
		<div class="col-lg-6">
			<cfset info = getOption(qOptions,'home_info_left')>
			
			<h2>#info.label#</h2>
			
			#info.content#
						
		</div>
		<div class="col-lg-6">
			<cfset info = getOption(qOptions,'home_info_right')>
		
			<h2>#info.label#</h2>
			
			#info.content#
			
		</div>
	</div>
	
</div>

</cfoutput>