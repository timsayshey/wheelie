<cfoutput>
	<ul class="nav navbar-nav">
		#renderadminMenu(adminNavMain)#
		#renderadminMenu(menuArray=adminNavMore,parentClass="hidden-md hidden-lg")#
	</ul>
	
	<ul class="navbar-right nav navbar-nav hidden-xs hidden-sm" style="margin-right:10px;">
		<li></li>
		<li class="dropdown">#renderadminMenu(adminNavMore)#</li>
	</ul>
</cfoutput>