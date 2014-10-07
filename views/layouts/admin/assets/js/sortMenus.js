$(document).ready(function(){
	
	$('.submitBtn').attr('disabled', true);
	initMenuSort();
});

function initMenuSort()
{
	/* nested sortables
	------------------------------------------------------------------------- */
	var menu_serialized;
	$('#nestable').nestedSortable({
		listType: 'ul',
		handle: 'div',
		items: 'li',
		placeholder: 'ns-helper',
		opacity: .8,
		handle: '.ns-title',
		toleranceElement: '> div',
		forcePlaceholderSize: true,
		tabSize: 15,
		update: function() {
			enableSaveAndUpdateOutput();
		}
	});	
}

function idFoundInSortList(id)
{
	var id = parseInt(id);
	var thisId = 0;
	var returntype = false;
	
	$("#nestable li").each(function( index ) {
		 thisId = parseInt($(this).attr("data-id"));
		 
		 if(id == thisId)
		 {
			returntype = true;
		 }
	});
	
	return returntype;
}

function enableSaveAndUpdateOutput()
{
	$("#serializedOutput").val(JSON.stringify($('#nestable').nestedSortable('toArray')));
	$('.submitBtn').attr('disabled', false);
}