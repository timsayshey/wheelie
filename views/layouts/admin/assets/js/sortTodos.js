$(document).ready(function(){
	
	$('.submitBtn').attr('disabled', true);
	initTodoSort();
});

function initTodoSort()
{
	/* nested sortables
	------------------------------------------------------------------------- */
	var todo_serialized;
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
	//var submitUrl = $("form").attr("action");
	//var todoOrder = JSON.stringify($('#nestable').nestedSortable('toArray'));
	
	//$.post( "test.php", { todoOrder: todoOrder })
	//	.done(function( data ) {
	//		alert( "Data Loaded: " + data );
	//	}
	//);
	
	$("#serializedOutput").val(JSON.stringify($('#nestable').nestedSortable('toArray')));
	$('.submitBtn').attr('disabled', false);
	
	$.post(
		$("form").attr("action"),
		$("form").serialize(),
		function(data, textStatus, jqXHR)
		{
			//alert("Success.");							
		}).fail(function(jqXHR, textStatus, errorThrown) 
		{
			alert("Sorry, an error prevented your changes from saving. Please try again.");						
		}
	);
}