<div id="map" style="width:100%; height:350px; margin: 0 auto;"></div>
<script src="http://maps.googleapis.com/maps/api/js?libraries=places&sensor=false&key=AIzaSyAepWZTMl004ANnzDQGywV3affbMxD6JCA"></script>
<script>
	var locations = [
		['<b>All Saints Parish</b><br>6403 Clemens Ave.,<br>St. Louis, MO<br>314.721.6403', 38.65868,-90.3031, 1,"#"],
		['<b>All Saints Parish</b><br>7 McMenamy Rd.,<br>St. Peters, MO<br>636.397.1440', 38.796574,-90.62916, 2,"#"],
		['<b>All Souls Parish</b><br>9550 Tennyson Ave.,<br>St. Louis, MO<br>314.427.0442', 38.70422,-90.36665, 3,"#"],
		['<b>Annunciation Parish</b><br>12 W. Glendale Rd.,<br>Webster Groves, MO<br>314.962.5955', 38.57635,-90.35904, 4,"#"]
	];

	var map = new google.maps.Map(document.getElementById('map'), {
	    zoom: 10,
	    center: new google.maps.LatLng(38.65868,-90.3031),
	    mapTypeId: google.maps.MapTypeId.ROADMAP
	});

	var infowindow = new google.maps.InfoWindow();

	var marker, i;

	for (i = 0; i < locations.length; i++) {
	    marker = new google.maps.Marker({
	        position: new google.maps.LatLng(locations[i][1], locations[i][2]),
	        map: map,
	        clickable: true,
	        url:locations[i][4]
	    });

	    google.maps.event.addListener(marker, 'click', (function (marker, i) {
	        return function () {
	            infowindow.setContent(locations[i][0]);
	            infowindow.open(map, marker);
	            window.location.href = marker.url;
	        }
	    })(marker, i));
	}
</script>
<script src="/assets/googlemap/js/index.js"></script>
