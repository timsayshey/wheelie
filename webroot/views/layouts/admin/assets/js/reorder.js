function initSortable(URLpath,selectWrap,selectElement)
{
	var fixHelper = function(e, ui) {
		ui.children().each(function() {
			$(this).width($(this).width());
		});
		return ui;
	};
	
	if(typeof selectWrap == 'undefined')
	{
		selectWrap = $("#sortable tbody");
	}
	
	if(typeof selectElement == 'undefined')
	{
		selectElement = "tr";
	}
	
	var newSortArray = [];
	$sortTable = selectWrap;
	$sortTable.sortable({
		helper: fixHelper,
		connectWith: selectElement,
		update: function() {
			$(selectElement, $sortTable).each(function(index, elem) {
				var $listItem = $(elem);								
				newSortArray.push({
					newIndex : +$listItem.index(),
					fieldid : +$listItem.attr("rel")
				});				
			});
			
			$.ajax({
				url : URLpath,
				type: "POST",
				data : {orderValues:JSON.stringify(newSortArray)},
				success: function(data, textStatus, jqXHR)
				{
					console.log("Order updated.");
				},
				error: function (jqXHR, textStatus, errorThrown)
				{
					console.log("Order update failed.");
				}
			});
		},
		start: function(e, ui){
			ui.placeholder.height(ui.item.height() - 4);
			ui.placeholder.css("visibility","visible");
		}
	}).disableSelection();
}
