// Init
$(function() {
	setCategoryListeners();
});

// Add listeners 
function setCategoryListeners()
{			
	$(document).off("click", "#editcategory");
	$(document).on("click", "#editcategory", function(e) { 
		categoryForm();
	});
	
	$(document).off("click", "#addnewcategory");
	$(document).on("click", "#addnewcategory", function(e) { 
		categoryForm();
	});
	
	$(document).off("click", "#editcategory");
	$(document).on("click", "#editcategory", function(e) { 
		categoryForm($(this).attr("data-id"));
	});
	
	$(document).off("click", "#deletecategory");
	$(document).on("click", "#deletecategory", function(e) { 
		deleteCategory($(this).attr("data-id"),this);
	});
}
function deleteCategory(deleteid,el)
{
	var categoryInfo = getCategoryInfo();
	
	$.ajax({
		type: "GET",
		url: "/m/admin/categories/delete/" + categoryInfo.model + "/" + deleteid + "?ajax",
		success: function(data)
		{			
			if($.parseJSON(data).Success == true)
			{
				var preserveChildren = $(el).parent().parent().parent().find("ul").html();
				$(el).parent().parent().parent().parent().append(preserveChildren);
				$(el).parent().parent().parent().remove();
				enableSaveAndUpdateOutput();
				
				// Submit form order to prevent any orphaned children
				$.post(
					$("form").attr("action"),
					$("form").serialize(),
					function(data, textStatus, jqXHR)
					{
						//alert("Success.");							
					}).fail(function(jqXHR, textStatus, errorThrown) 
					{
						//alert("Error");						
					}
				);
			} else {
				alert("Delete failed, refresh and try again.");
			}
		}
	});
}

function modalCategoryLoader(type)
{
	if(type == "show")
	{
		$("#addcategory .modalloader").show();
		$("#addcategory #content").hide();
	} else { // hide loader
		$("#addcategory .modalloader").hide();
		$("#addcategory #content").show();
	}
}

function getCategoryInfo()
{
	return { 
		addType 	: $("#addCategoryType").val(), // sortlist or dropdown
		model 		: $("#categoryModel").val() // usertag, videocategory, etc
	}
}

function categoryForm(editid)
{	
	var categoryInfo = getCategoryInfo(),
		$modal = $('#addcategory');		
	
	modalCategoryLoader("show");
	$modal.modal('toggle');
	
	if(typeof editid == 'undefined')
	{
		GetUrl = "/m/admin/categories/new/" + categoryInfo.model + "/" + "?ajax&type=" + categoryInfo.addType;
		CrudType = "new";
	}
	else
	{
		GetUrl = "/m/admin/categories/edit/" + categoryInfo.model + "/" + editid + "/?ajax&type=" + categoryInfo.addType;		
		CrudType = "update";
	}
	PostUrl = $("#addcategory #form").attr("data-actionUrl");
	console.log(GetUrl,PostUrl,editid);
	
	$.ajax({
		type: "GET",
		url: GetUrl,
		success: function(data)
		{			
			$("#addcategory #content #form").html(data);	
			$(".helper").tooltip('fixTitle');
			
			modalCategoryLoader("hide");
			
			$(document).off("click", "#addcategorybtn");
			$(document).on("click", "#addcategorybtn", function(e) 
			{				
				var formData = $("#addcategory #form").serializeAnything();
				modalCategoryLoader("show");
				
				$.post(
					PostUrl,
					formData,
					function(data, textStatus, jqXHR)
					{
						data = $.parseJSON(data);
						console.log(data);
						
						if(data.RESPONSE == "error")
						{
							$("#formerrors").html(data.ERRORS);
						}
						else if (data.RESPONSE == "success")
						{
							$("#formerrors").html("");
							$modal.modal('toggle');	
							
							if(categoryInfo.addType == "dropdown" && CrudType == "new")
							{
								// Add and select new category
								var videoCategorySelectize = window.$catselectize[0].selectize;
								
								videoCategorySelectize.addOption({ 
									value : data.OPTION.VALUE,
									text : data.OPTION.TEXT
								});
								videoCategorySelectize.addItem(data.OPTION.VALUE);
								
								videoCategorySelectize.refreshOptions();
							}
							else if (categoryInfo.addType == "sortlist" && CrudType == "new")
							{
								// Add list item
								html = tmpl("tmpl_categoryListItem", {
									name 		: data.OPTION.TEXT,
									id 			: data.OPTION.VALUE,
									parentid 	: "",
									sortOrder 	: ""
								});	
								$('#nestable').append(html);
								enableSaveAndUpdateOutput();
							}
							else if (categoryInfo.addType == "sortlist" && CrudType == "update")
							{
								$("li[data-id=" + data.OPTION.VALUE + "] .ns-title:first").text(data.OPTION.TEXT);
								enableSaveAndUpdateOutput();
							}
						}
						
						modalCategoryLoader("hide");
					}).fail(function(jqXHR, textStatus, errorThrown) 
					{
				 		alert("Error");
						modalCategoryLoader("hide");
					}
				);
				
			});
				
		}
	});		
}