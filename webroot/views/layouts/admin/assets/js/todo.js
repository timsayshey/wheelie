// Init
$(function() {
	setTodoListeners();
});

function checkEnter(e){
	e = e || event;
	var txtArea = /textarea/i.test((e.target || e.srcElement).tagName);
	return txtArea || (e.keyCode || e.which || e.charCode || 0) !== 13;
}

// Add listeners 
function setTodoListeners()
{			
	// Prevents enter from submitting form
	document.querySelector('form').onkeypress = checkEnter;
	
	// Todo Item Type Chooser
	$(document).on("change", "#typeChooser", function (e) {
		$(".type-page,.type-post,.type-custom").hide();
		$(".type-" + $(this).val()).show();
	});
	
	$(document).on("change", ".type-post select", function (e) {
		$("#todoItemLabel").val($(".type-page select option:selected").text());															
	});
	
	$(document).on("change", ".type-page select", function (e) {
		$("#todoItemLabel").val($(".type-page select option:selected").text());															
	});
	
	$(document).off("click", "#edittodo");
	$(document).on("click", "#edittodo", function(e) { 
		todoForm();
	});
	
	$(document).off("click", "#addnewtodo");
	$(document).on("click", "#addnewtodo", function(e) { 
		todoForm();
	});
	
	$(document).off("click", "#edittodo");
	$(document).on("click", "#edittodo", function(e) { 
		todoForm($(this).attr("data-id"));
	});
	
	$(document).off("click", "#deletetodo");
	$(document).on("click", "#deletetodo", function(e) { 
		deleteTodo($(this).attr("data-id"),this);
	});
	
	$(document).off("click", ".todo-movedown");
	$(document).on("click", ".todo-movedown", function(e) { 
		todoMoveDown($(this).attr("data-id"),this);
	});
		
	$(document).off("click", ".markdone-todo");
	$(document).on("click", ".markdone-todo", function(e) { 
		todoMarkDone($(this).attr("data-id"),this);
	});
	
	$(document).off("click", ".marknotdone-todo");
	$(document).on("click", ".marknotdone-todo", function(e) { 
		todoMarkNotDone($(this).attr("data-id"),this);
	});
	
	$(document).off("click", ".view-expanded");
	$(document).on("click", ".view-expanded", function(e) { 
		$(".ns-extra").show();
		$(".ns-extra").css("display","block");
		$(".view-expanded").hide();
		$(".view-simple").show();
	});
	
	$(document).off("click", ".view-simple");
	$(document).on("click", ".view-simple", function(e) { 
		$(".ns-extra").hide();
		$(".view-expanded").show();
		$(".view-simple").hide();
	});
}

function todoMoveDown(todoid,el)
{
	var todoInfo = getTodoInfo();
	var $nsRow = $(el).parent().parent();
	var $nsFullRow = $(el).parent().parent().parent();
	
	$savedRow = $nsRow.parent();
	preserveElHtml = deleteTodoDom(el,todoid);
	$('#nestable').append(preserveElHtml);
	enableSaveAndUpdateOutput();	
}

function todoMarkDone(todoid,el)
{
	var todoInfo = getTodoInfo();
	var $nsRow = $(el).parent().parent();
	var $nsFullRow = $(el).parent().parent().parent();
	
	$.ajax({
		type: "GET",
		url: "/m/admin/todos/markdone/" + todoInfo.model + "/" + todoid + "?ajax",
		success: function(data)
		{			
			if($.parseJSON(data).RESPONSE == "success")
			{
				$(el).removeClass("markdone-todo");
				$(el).addClass("marknotdone-todo");
				$nsRow.addClass("opacity50");
				//$savedRow = $nsRow.parent();
				//preserveElHtml = deleteTodoDom(el,todoid);
				//$('#nestable').append(preserveElHtml);
				//enableSaveAndUpdateOutput();
			} else {
				alert("Failed, refresh and try again.");
			}
		}
	});
	
}

function todoMarkNotDone(todoid,el)
{
	var todoInfo = getTodoInfo();
	var $nsRow = $(el).parent().parent();
	
	$.ajax({
		type: "GET",
		url: "/m/admin/todos/marknotdone/" + todoInfo.model + "/" + todoid + "?ajax",
		success: function(data)
		{			
			if($.parseJSON(data).RESPONSE == "success")
			{
				$(el).addClass("markdone-todo");
				$(el).removeClass("marknotdone-todo");
				$nsRow.removeClass("opacity50");
			} else {
				alert("Failed, refresh and try again.");
			}
		}
	});
}

function deleteTodo(deleteid,el)
{
	var todoInfo = getTodoInfo();
	
	$.ajax({
		type: "GET",
		url: "/m/admin/todos/delete/" + todoInfo.model + "/" + deleteid + "?ajax",
		success: function(data)
		{			
			if($.parseJSON(data).Success == true)
			{
				deleteTodoDom(el,deleteid);
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

function deleteTodoDom(el,elid)
{
	var preserveChildren = $(el).parent().parent().parent().find("ul").html();	
	var removeChildren = $(el).parent().parent().parent().find("ul").remove();	
	var addChildrenToMainList = $(el).parent().parent().parent().parent().append(preserveChildren);	
	var preserveEl = $(el).parent().parent().parent();	
	var deleteEl = $(el).parent().parent().parent().remove();
	
	return '<li id="todo-' + elid + '" data-id="' + elid + '" class="sortable">' + preserveEl.html() + '</li>';
}

function modalTodoLoader(type)
{
	if(type == "show")
	{
		$("#addtodo .modalloader").show();
		$("#addtodo #content").hide();
	} else { // hide loader
		$("#addtodo .modalloader").hide();
		$("#addtodo #content").show();
	}
}

function getTodoInfo()
{
	return { 
		addType 	: $("#addTodoType").val(), // sortlist or dropdown
		model 		: $("#todoModel").val() // usertag, videotodo, etc
	}
}

function todoForm(editid)
{	
	var todoInfo = getTodoInfo(),
		$modal = $('#addtodo');		
	
	modalTodoLoader("show");
	$modal.modal('toggle');
	
	if(typeof editid == 'undefined')
	{
		GetUrl = "/m/admin/todos/new/" + todoInfo.model + "/" + "?ajax&type=" + todoInfo.addType;
		CrudType = "new";
	}
	else
	{
		GetUrl = "/m/admin/todos/edit/" + todoInfo.model + "/" + editid + "/?ajax&type=" + todoInfo.addType;		
		CrudType = "update";
	}
	PostUrl = $("#addtodo #form").attr("data-actionUrl");
	console.log(GetUrl,PostUrl,editid);
	
	$.ajax({
		type: "GET",
		url: GetUrl,
		success: function(data)
		{					
			$("#addtodo #content #form").html(data);	
			$(".helper").tooltip('fixTitle');
			
			modalTodoLoader("hide");
			
			$(".type-page,.type-post,.type-custom").hide();
			$(".type-" + $("#typeChooser").val()).show();
			
			$(document).off("click", "#addtodobtn");
			$(document).on("click", "#addtodobtn", function(e) 
			{				
				var formData = $("#addtodo #form").serializeAnything();
				modalTodoLoader("show");
				
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
							
							if(todoInfo.addType == "dropdown" && CrudType == "new")
							{
								// Add and select new todo
								var videoTodoSelectize = window.$catselectize[0].selectize;
								
								videoTodoSelectize.addOption({ 
									value : data.OPTION.VALUE,
									text : data.OPTION.TEXT
								});
								videoTodoSelectize.addItem(data.OPTION.VALUE);
								
								videoTodoSelectize.refreshOptions();
							}
							else if (todoInfo.addType == "sortlist" && CrudType == "new")
							{
								// Add list item
								html = tmpl("tmpl_todoListItem", {
									name 		: data.OPTION.TEXT,
									id 			: data.OPTION.VALUE,
									parentid 	: "",
									sortOrder 	: "",
									description : data.OPTION.DESCRIPTION,
									duedate     : data.OPTION.DUEDATE,
									priority    : data.OPTION.PRIORITY
								});	
								$('#nestable').prepend(html);
								enableSaveAndUpdateOutput();
							}
							else if (todoInfo.addType == "sortlist" && CrudType == "update")
							{
								$updateTodo = $("li[data-id=" + data.OPTION.VALUE + "]");
								$updateTodo.find(".ns-title:first").text(data.OPTION.TEXT);
								$updateTodo.find(".ns-description:first").text(data.OPTION.DESCRIPTION);
								$updateTodo.find(".ns-duedate:first").text(data.OPTION.DUEDATE);
								$updateTodo.find(".ns-priority:first").text(data.OPTION.PRIORITY);
								enableSaveAndUpdateOutput();
							}
						}
						
						modalTodoLoader("hide");
					}).fail(function(jqXHR, textStatus, errorThrown) 
					{
				 		alert("Error");
						modalTodoLoader("hide");
					}
				);
				
			});
				
		}
	});		
}