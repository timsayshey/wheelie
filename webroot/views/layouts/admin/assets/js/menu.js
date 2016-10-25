// Init
$(function() {
	setMenuListeners();
});

// Add listeners 
function setMenuListeners()
{			
	// Menu Item Type Chooser
	$(document).on("change", "#typeChooser", function (e) {
		$(".type-page,.type-post,.type-custom").hide();
		$(".type-" + $(this).val()).show();
	});
	
	$(document).on("change", ".type-post select", function (e) {
		$("#menuItemLabel").val($(".type-page select option:selected").text());															
	});
	
	$(document).on("change", ".type-page select", function (e) {
		$("#menuItemLabel").val($(".type-page select option:selected").text());															
	});
	
	$(document).off("click", "#editmenu");
	$(document).on("click", "#editmenu", function(e) { 
		menuForm();
	});
	
	$(document).off("click", "#addnewmenu");
	$(document).on("click", "#addnewmenu", function(e) { 
		menuForm();
	});
	
	$(document).off("click", "#editmenu");
	$(document).on("click", "#editmenu", function(e) { 
		menuForm($(this).attr("data-id"));
	});
	
	$(document).off("click", "#deletemenu");
	$(document).on("click", "#deletemenu", function(e) { 
		deleteMenu($(this).attr("data-id"),this);
	});
}
function deleteMenu(deleteid,el)
{
	var menuInfo = getMenuInfo();
	
	$.ajax({
		type: "GET",
		url: "/m/admin/menus/delete/" + menuInfo.model + "/" + deleteid + "?ajax",
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

function modalMenuLoader(type)
{
	if(type == "show")
	{
		$("#addmenu .modalloader").show();
		$("#addmenu #content").hide();
	} else { // hide loader
		$("#addmenu .modalloader").hide();
		$("#addmenu #content").show();
	}
}

function getMenuInfo()
{
	return { 
		addType 	: $("#addMenuType").val(), // sortlist or dropdown
		model 		: $("#menuModel").val() // usertag, videomenu, etc
	}
}

function menuForm(editid)
{	
	var menuInfo = getMenuInfo(),
		$modal = $('#addmenu');		
	
	modalMenuLoader("show");
	$modal.modal('toggle');
	
	if(typeof editid == 'undefined')
	{
		GetUrl = "/m/admin/menus/new/" + menuInfo.model + "/" + "?ajax&type=" + menuInfo.addType;
		CrudType = "new";
	}
	else
	{
		GetUrl = "/m/admin/menus/edit/" + menuInfo.model + "/" + editid + "/?ajax&type=" + menuInfo.addType;		
		CrudType = "update";
	}
	PostUrl = $("#addmenu #form").attr("data-actionUrl");
	console.log(GetUrl,PostUrl,editid);
	
	$.ajax({
		type: "GET",
		url: GetUrl,
		success: function(data)
		{					
			$("#addmenu #content #form").html(data);	
			$(".helper").tooltip('fixTitle');
			
			modalMenuLoader("hide");
			
			$(".type-page,.type-post,.type-custom").hide();
			$(".type-" + $("#typeChooser").val()).show();
			
			$(document).off("click", "#addmenubtn");
			$(document).on("click", "#addmenubtn", function(e) 
			{				
				var formData = $("#addmenu #form").serializeAnything();
				modalMenuLoader("show");
				
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
							
							if(menuInfo.addType == "dropdown" && CrudType == "new")
							{
								// Add and select new menu
								var videoMenuSelectize = window.$catselectize[0].selectize;
								
								videoMenuSelectize.addOption({ 
									value : data.OPTION.VALUE,
									text : data.OPTION.TEXT
								});
								videoMenuSelectize.addItem(data.OPTION.VALUE);
								
								videoMenuSelectize.refreshOptions();
							}
							else if (menuInfo.addType == "sortlist" && CrudType == "new")
							{
								// Add list item
								html = tmpl("tmpl_menuListItem", {
									name 		: data.OPTION.TEXT,
									id 			: data.OPTION.VALUE,
									parentid 	: "",
									sortOrder 	: ""
								});	
								$('#nestable').append(html);
								enableSaveAndUpdateOutput();
							}
							else if (menuInfo.addType == "sortlist" && CrudType == "update")
							{
								$("li[data-id=" + data.OPTION.VALUE + "] .ns-title:first").text(data.OPTION.TEXT);
								enableSaveAndUpdateOutput();
							}
						}
						
						modalMenuLoader("hide");
					}).fail(function(jqXHR, textStatus, errorThrown) 
					{
				 		alert("Error");
						modalMenuLoader("hide");
					}
				);
				
			});
				
		}
	});		
}