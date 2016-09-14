<cfoutput> 
	
	<style type="text/css">
		hr {
			margin:5px 0;	
		}
		.ns-actions {
			width: 105px;
		}
		.ns-extra {
			min-height:11px;
			display:none;	
		}
		.view-simple {
			display:none;	
		}
		* {
			font-family: 'Montserrat', sans-serif;
			font-size:9px;
			line-height:20px;
			
		}
		.notebox {
			width:280px;
			height:880px;
			float:right;
			border:1px dashed ##555;
			padding:10px;
			margin-left:20px;
		}
		ul {
			padding-left:10px;
			margin-top:0;
		}
	</style>
	
	<link href='http://fonts.googleapis.com/css?family=Montserrat' rel='stylesheet' type='text/css'>
	
	<div class="notebox">
		<strong>Notes</strong>
	</div>
	
	<strong>To-Dos #DateFormat(now(),"MM-DD-YYYY")#</strong>
	
	<ul id="nestable" class="sortable">
		#getNestable(todos,"todo")#
	</ul>
	
</cfoutput>