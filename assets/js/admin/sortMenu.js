$(document).ready(function(){
	
	$('.submitBtn').attr('disabled', true);
	
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
		update: function(event, ui) {	
			enableSaveAndUpdateOutput();			
        }
	});
	
	/* Delete
	---------------------------------------------------------------------------- */
	$('body').on('click', '.delete-menu', function() {
		var li = $(this).closest('li');
		var param = { id : $(this).next().val() };
		var menu_title = $(this).parent().parent().children('.ns-title').text();
		li.remove();
		enableSaveAndUpdateOutput();
		return false;
	});	
	
	/* Edit
	---------------------------------------------------------------------------- */
	$('body').on('click', '.edit-menu', function() {		
		var li = $(this).closest('li');
		li.children(".ns-form").toggle();		
		enableSaveAndUpdateOutput();
		return false;
	});
	
	

	/* Add
	---------------------------------------------------------------------------- */
	$('#addItem #submit').click(function() {	
		var selector = $("#addItem[rel=" + $(this).attr("rel") + "] option:selected");
		var val		 = selector.val();
		var label	 = selector.text();		
					
		html = tmpl("tmpl_menuListItem", {
			name 		: label,
			id 			: val,
			parentid 	: "",
			sortOrder 	: ""
		});	
		$('#nestable').append(html);
		enableSaveAndUpdateOutput();
		
		return false;
	});
	
	$('#addTextItem #submit').click(function() {	
		var label	 = $("#addTextItem #customlabel").val();	
		var val		 = $("#addTextItem #customlink").val();	
					
		html = tmpl("tmpl_menuListItem", {
			name 		: label,
			id 			: val,
			parentid 	: "",
			sortOrder 	: ""
		});	
		$('#nestable').append(html);
		enableSaveAndUpdateOutput();
		
		return false;
	});

	$('body').on('keydown', '#gbox input', function(e) {
		if (e.which == 13) {
			$('#gbox_footer .primary').trigger('click');
			return false;
		}
	});
	
	$(document).on("click", ".submitBtn", function(e) 
	{				
		var jsonData,
			finalData = {},
			dataArray = [];
		
		$('.submitBtn').attr('disabled', true);
		
		e.preventDefault();
		
		$("#nestable li").each(function(index)
		{
			currentObj = {
				parentid	 : $($(this).find(".parentid")[0]).val(),
				sortOrder	 : $($(this).find(".sortOrder")[0]).val(),
				urlpath		 : $($(this).find(".urlpath")[0]).val(),
				itemname 	 : $($(this).find(".itemname")[0]).val()
			};
			
			dataArray.push(currentObj);
		});
		
		console.log(dataArray);
		
		finalData = {
			data : dataArray,
			menuid : $("#menuid").val()
		};
		
		jsonData = JSON.stringify(finalData);
		
		$.post(
			$("form").attr("action"),
			{ data : jsonData },
			function(data, textStatus, jqXHR)
			{
				data = $.parseJSON(data);
				console.log(data);
				if(data.Success == true)
				{
					location.reload();
				} else {
					alert("Update failed.");		
				}
				$('.submitBtn').attr('disabled', false);
			}).fail(function(jqXHR, textStatus, errorThrown) 
			{
				alert("Error");		
				$('.submitBtn').attr('disabled', false);				
			}
		);
		
	});
	
});

function idFoundInSortList(id)
{
	var id = parseInt(id);
	var thisId = 0;
	var returntype = false;
	
	$("#nestable li").each(function( index ) {
		 thisId = parseInt($($(this).find(".sortOrder")[0]).val());
		 
		 if(id == thisId)
		 {
			returntype = true;
		 }
	});
	
	return returntype;
}

function enableSaveAndUpdateOutput()
{
	$('.submitBtn').attr('disabled', false);
	
	// Update order
	var indexCount = 1;
	$('input.sortOrder').each(function(idx) {
		$(this).val(indexCount);
		indexCount++;
	});
	
	// Update parentid
	$('ul#nestable li').each(function(idx) {
		newParentId = $($(this).parent().closest('li').find(".sortOrder")[0]).val();
		if(typeof newParentId == 'undefined')
		{
			newParentId = 0;
		}		
		$(this).find(".parentid").val(newParentId);
	});
	
	
}