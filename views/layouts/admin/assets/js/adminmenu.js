$(function () 
{
	$.get("/m/admin/main/usermenu", function(data) 
	{
		$("body").prepend(data);
	});
});
