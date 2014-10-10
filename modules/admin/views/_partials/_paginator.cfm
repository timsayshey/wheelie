<script>
$(function() {
	var options = {
		currentPage: 1,
		totalPages: $(".pagedPage").length,
		onPageClicked: function(e,originalEvent,type,page){
			$(".pagedPage").hide();
			$(".pagedPage[rel=" + page + "]").show();
		}
	}

	$('.bspager').bootstrapPaginator(options);
});
</script>

<div class="bspager"></div>