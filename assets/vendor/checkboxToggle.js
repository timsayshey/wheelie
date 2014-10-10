/*  HTML Markup
	Example - put both checkboxes in a parent element
	
	<td class="checkboxes">
		<input class="setFalse" type="checkbox" name="test" value="0" style="display:none;">
		<input class="setTrue" type="checkbox" name="test" value="1" checked>
	</td>		
*/

$(function() {			
	$(document).on("click", ".setFalse", function (e) {
		if(this.checked)
		{
			setFlase(this);
		} else {
			setTrue(this);
		}
	});
	
	$(document).on("click", ".setTrue", function (e) {
		if(this.checked)
		{
			setTrue(this);
		} else {
			setFlase(this);
		}
	});
	
	function setTrue(thisEl)
	{
		$(thisEl).parent().find(".setFalse").attr('checked', false);
		$(thisEl).parent().find(".setTrue").attr('checked', true);
	}
	
	function setFlase(thisEl)
	{
		$(thisEl).parent().find(".setFalse").attr('checked', true);
		$(thisEl).parent().find(".setTrue").attr('checked', false);
	}
});