<cfoutput>
	
	<cfparam name="selectWrap" default='$(".sortable")'>
	<cfparam name="selectElement" default='.listbox'>
	<cfparam name="urlcontroller">
	<cfparam name="reEndRow">
	<cfscript>			
		// Returns rearrange button and script
		returnHtml = "";
		if(!isNull(params.rearrange) AND params.rearrange eq 1)
		{
			returnHtml = returnHtml & linkTo(
				text		= '<span class=''elusive icon-arrow-left''></span> Go Back',
				href		= 'javascript:window.history.back();',
				class		= 'btn btn-default'
			);			
			returnHtml = returnHtml & 
				'<script type="text/javascript" src="//code.jquery.com/ui/1.10.1/jquery-ui.js"></script>
				<link href="//code.jquery.com/ui/1.10.1/themes/base/jquery-ui.css" type="text/css" rel="stylesheet" media="all">
				<script type="text/javascript" src="/views/layouts/admin/assets/js/reorder.js"></script>
				<script type="text/javascript">	
					$(function() {
						initSortable(
							URLpath = ''#urlFor(				
								route		= "admin~Action",
								controller	= "#urlcontroller#",
								action		= "updateOrder"
							)#'',
							selectWrap = #selectWrap#,
							selectElement = "#selectElement#"
						);
					});
				</script>';		
			request.reStartRow = 1;
			request.reEndRow = reEndRow;
		} else {
			returnHtml = returnHtml & linkTo(
				text		= '<span class=''elusive icon-move''></span> Rearrange',
				route		= 'admin~index',
				controller	= '#urlcontroller#',
				params		= 'rearrange=1',
				class		= 'btn btn-default'
			);
			request.reStartRow = pagination.getStartRow();
			request.reEndRow = pagination.getendrow();
		}	
		
		writeOutput(returnHtml);	
	</cfscript>
	
</cfoutput>