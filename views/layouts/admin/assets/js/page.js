// Init
$(function() {	
	toggleHomeOptions();
	$('#isHomeCheckbox').change(function() {
    	toggleHomeOptions();
    });
	
	toggleMetaOptions();
	$('#metagenerated').change(function() {
    	toggleMetaOptions();
    });
});

function toggleHomeOptions()
{
	$homeOptions = $("#homeOptions");
	
	if($('#isHomeCheckbox').is(':checked'))
	{
		$homeOptions.show();
	} else {
		$homeOptions.hide();
	}	
}

function toggleMetaOptions()
{
	$metaOptions = $("#metaOptions");
	
	if($('#metagenerated').is(':checked'))
	{
		$metaOptions.hide();
	} else {
		$metaOptions.show();
	}
	
}

// Add listeners 
function setPageListeners()
{			
	
}