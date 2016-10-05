/**
 *  This demo uses Google Map Generator plugin
 *  https://github.com/clintioo/google-maps-generator
 */
function googleMapGenerator(h){if(!(this instanceof googleMapGenerator)){return new googleMapGenerator(h)}var x=googleMapGenerator.options,o=document.querySelectorAll("."+x.containerClass)[0],p,A,z;if(h){x=w(googleMapGenerator.options,h)}u();function u(){if(!q()&&x.docWidth>=x.breakpointDynamicMap){t();return false}if(x.docWidth<x.breakpointDynamicMap&&x.isStaticMap){g(x.docWidth,x.docWidth);d()}else{r()}window.onresize=function(){f()}}function f(){var D=document.body.clientWidth;if(x.docWidth<x.breakpointDynamicMap&&D>=x.breakpointDynamicMap&&!j()){t()}if(x.docWidth>=x.breakpointDynamicMap&&D<x.breakpointDynamicMap){n()}if(q()){C()}return x.docWidth=D}function r(){x.isStaticMap=false;x.markerAnimation=google.maps.Animation.DROP;z={zoom:x.mapZoom,center:new google.maps.LatLng(x.mapLat,x.mapLng),mapTypeControlOptions:{mapTypeIds:[google.maps.MapTypeId.ROADMAP,"map_style"]}};if(c()){p=document.querySelectorAll("."+x.frameClass)[0];A=new google.maps.Map(p,z)}else{var D=document.createElement("div");D.setAttribute("class",x.frameClass);o.appendChild(D);A=new google.maps.Map(D,z)}if(x.hasLegend){a()}if(x.styles){e()}if(x.locations){b()}if(x.hasPrint){l()}return A}function a(){var D=document.createElement("div");if(!document.querySelectorAll("."+x.legendClass)[0]){o.insertAdjacentHTML("beforeend",v())}D.setAttribute("class",x.legendClass);o.appendChild(D);x.legend=i(o,x.legendClass);return A.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(x.legend)}function v(){var D="",F=x.locations.length;if(x.hasLegend){D+='<div class="'+x.legendClass+'"><ul>';for(var E=0;E<F;E++){D+='<li><span class="map__marker">'+B(E)+"</span> <strong>"+x.locations[E][0]+"</strong><br>"+x.locations[E][1]+"</li>"}D+="</ul></div>"}return D}function e(){var D=new google.maps.StyledMapType(x.styles,{name:"Styled Map"});A.mapTypes.set("map_style",D);return A.setMapTypeId("map_style")}function k(){var E="",D=x.styles.length;for(var H=0;H<D;H++){E+="&amp;style=feature:"+x.styles[H].featureType+"%7Celement:"+x.styles[H].elementType;for(var F=0,I=x.styles[H].stylers.length;F<I;F++){var K=x.styles[H].stylers[F];for(var G in K){var J=K[G].toString().replace("#","0x");E+="%7C"+G+":"+J}}}return E}function b(){var E=window.scrollY||document.documentElement.scrollTop,F=[];if(!q()){return false}if(x.markersAdded){return false}if(x.markerLoad==="scroll"&&o.offsetTop>E){return false}if(x.isStaticMap===true){return false}if(x.hasInfoWindow){var G=null;G=new google.maps.InfoWindow({content:"",maxWidth:240})}for(var J=0,D=x.locations.length;J<D;J++){var N=x.locations[J],I=new google.maps.LatLng(N[3],N[4]),K;if(x.hasMarkerIcon){if(N[6]){x.markerIcon={url:N[6]}}else{x.markerIcon="http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld="+B(J)+"|"+x.markerIconHexBackground+"|"+x.markerIconHexColor}}K=new google.maps.Marker({position:I,map:A,icon:x.markerIcon,animation:x.markerAnimation,title:N[0],html:'<div><span class="map__title">'+N[0]+'</span><span class="map__address">'+N[1]+'</span><span class="map__description">'+N[2]+"</span></div>",zIndex:N[5]});F.push(K);if(x.hasLegend){var L=document.createElement("div");L.setAttribute("class","map__legend__item");L.innerHTML="<strong>"+x.markerIconLabel+'</strong>&nbsp;&nbsp;<a href="#">'+N[0]+"</a>";x.legend.appendChild(L)}if(x.hasInfoWindow){google.maps.event.addListener(K,"click",function(){G.setContent(this.html);G.open(A,this)});google.maps.event.addListener(A,"click",function(){G.close(A,this)})}}if(x.hasLegend){var H=document.querySelectorAll("."+x.legendClass+" a"),M=H.length;for(var J=0;J<M;J++){(function(O){H[J].onclick=function(P){P.preventDefault();google.maps.event.trigger(F[O],"click")}})(J)}}return x.markersAdded=true}function s(){var I="",H="",J="size:"+x.markerIconSize,G=x.locations.length;if(x.markerIconHexBackground){H="%7Ccolor:0x"+x.markerIconHexBackground}for(var F=0;F<G;F++){var E="%7Clabel:"+B(F),D="%7C"+x.locations[F][3]+","+x.locations[F][4];if(x.hasMarkerIcon&&location[6]&&G<=5){}else{I+="&amp;markers="+J+H+E+D}}return I}function l(){var D=document.createElement("a");D.setAttribute("class",x.printClass);D.setAttribute("href","#");D.innerHTML="Print";o.appendChild(D);x.print=i(o,x.printClass);x.print.onclick=function(){m();return false}}function g(E,D){return o.innerHTML=y(E,D)+v()}function y(D,M){var D=D||640,M=M||640,E="",N="",I="",L="http://maps.googleapis.com/maps/api/staticmap?",F="center="+x.mapLat+","+x.mapLng,H="&amp;size="+D+"x"+M,G="&amp;zoom="+x.mapZoom,K="",J="";if(x.key){E="&amp;key="+x.key}if(x.styles){J=k()}if(x.locations){K=s()}N='<div class="'+x.frameClass+'"><img style="-webkit-user-select: none" src="'+L+F+G+E+H+K+J+'"></div>';return N}function d(){var D=document.querySelectorAll("."+x.frameClass)[0];D.onclick=function(E){if(!j()){n();t();return false}}}function c(){return document.querySelectorAll("."+x.frameClass)[0]}function j(){return document.querySelectorAll("."+x.mapDynamicClass)[0]}function n(){if(!x.hasResizedMap){var D=document.querySelectorAll("."+x.frameClass)[0];x.hasResizedMap=true;return D.style.height=D.offsetHeight*2.5+"px"}}function C(){var D=A.getCenter();google.maps.event.trigger(A,"resize");return A.setCenter(D)}function t(){var D=document.createElement("script");googleMapGenerator.options.isStaticMap=false;googleMapGenerator.options.markerLoad="load";D.type="text/javascript";D.src="https://maps.googleapis.com/maps/api/js?v=3.exp&callback=googleMapGenerator&key=AIzaSyCs5mGWeXeIryCgPZZBQ6613-E75SDbxWM";return document.body.appendChild(D)}function q(){return typeof google==="object"&&typeof google.maps==="object"&&typeof google.maps.InfoWindow==="function"}function B(D){switch(x.markerIconType){case"alpha":x.markerIconLabel=String.fromCharCode(97+D).toUpperCase();break;case"numeric":x.markerIconLabel=D+1;break}return x.markerIconLabel}function m(){/* Remove this function - document.write conflict on Codepen*/ /*var D=window.open("","mapWin","width=640,height=640");D.focus();D.document.write("<style>body { margin:0 } img { width: 100%; height: auto; } .map__legend ul { padding: 0; margin: 1.5em 0 0; } .map__legend ul li { float: left; width: 50%; list-style: none; margin: 0 0 1em; font: 12px sans-serif; }</style>"+y()+v()+"<script>setTimeout(function () { window.focus(); window.print(); }, 1500);<\/script>");D.document.close();return D*/}function w(M,L){var O,F,D,E,J,K,I=arguments[0]||{},H=1,G=arguments.length,N=false;if(typeof I==="boolean"){N=I;I=arguments[1]||{};H=2}if(typeof I!=="object"&&!jQuery.isFunction(I)){I={}}if(G===H){I=this;--H}for(;H<G;H++){if((O=arguments[H])!=null){for(F in O){D=I[F];E=O[F];if(I===E){continue}if(N&&E&&(jQuery.isPlainObject(E)||(J=jQuery.isArray(E)))){if(J){J=false;K=D&&jQuery.isArray(D)?D:[]}else{K=D&&jQuery.isPlainObject(D)?D:{}}I[F]=jQuery.extend(N,K,E)}else{if(E!==undefined){I[F]=E}}}}}return I}function i(K,J){var I;for(var H=0,D=K.childNodes.length;H<D;H++){var G=(K.childNodes[H].className!=undefined)?K.childNodes[H].className.split(" "):[];for(var E=0,F=G.length;E<F;E++){if(G[E]==J){I=K.childNodes[H]}}}return I}return{init:u,onWindowResize:f,addGoogleMapDynamic:r,addGoogleMapDynamicLegend:a,addGoogleMapDynamicStyle:e,addGoogleMapDynamicMarkers:b,addGoogleMapDynamicPrintBtn:l,addGoogleMapStaticStyle:k,addGoogleMapStaticMarkers:s,addGoogleMapStatic:g,generateGoogleMapStatic:y,eventsGoogleMapStatic:d,addGoogleMapStaticLegend:v,hasGoogleMap:c,hasGoogleMapDynamic:j,resizeGoogleMapFrame:n,centerGoogleMapDynamic:C,loadGoogleMapJs:t,hasGoogleMapsJS:q,getGoogleMapMarkerLabel:B,printGoogleMap:m,extend:w,getChildByClass:i}}googleMapGenerator.options={containerClass:"map",frameClass:"map__frame",printClass:"map__print",legendClass:"map__legend",mapDynamicClass:"gm-style",apiKey:null,legend:null,print:null,mapLat:-33.85,mapLng:151.24,mapZoom:12,isStaticMap:true,hasResizedMap:false,hasInfoWindow:true,hasLegend:true,hasPrint:true,hasMarkerIcon:true,markerAnimation:null,markerLoad:"load",markerIconType:"alpha",markerIconLabel:"",markerIconHexColor:"ffffff",markerIconHexBackground:"cc0000",markerIconSize:"large",markerIcon:null,markersAdded:false,locations:[],styles:[],docWidth:document.body.clientWidth,breakpointDynamicMap:768};

/**
 *  Plugin config and init
 */
 
// Config
// Breakpoint in px (below breakpoint -> load static map, above breakpoint -> load dynamic map)
googleMapGenerator.options.key = 'AIzaSyCs5mGWeXeIryCgPZZBQ6613-E75SDbxWM';
googleMapGenerator.options.mapZoom = 12;
googleMapGenerator.options.breakpointDynamicMap = 768;
googleMapGenerator.options.mapLat = 40.77;
googleMapGenerator.options.mapLng = -73.98;
googleMapGenerator.options.mapZoom = 12;
googleMapGenerator.options.markerIconType = 'numeric';
googleMapGenerator.options.markerIconHexBackground = 'ff6600';
googleMapGenerator.options.markerIconHexColor = '000000';
googleMapGenerator.options.hasPrint = false;
googleMapGenerator.options.locations = [
  ['Central Park', 'New York, NY', 'Central Park is an urban park in the central part of the borough of Manhattan, New York City . It was initially opened in 1857, on 778 acres of city-owned land.', 40.783121, -73.965366, 1],
  ['Times Square', 'Manhattan, NY 10036', 'Times Square is a major commercial intersection and a neighborhood in Midtown Manhattan, New York City, at the junction of Broadway and Seventh Avenue and stretching from West 42nd to West 47th Streets.', 40.759159, -73.985131, 2],
  ['Empire State Building', '350 5th Ave, New York, NY 10118', 'The Empire State Building is a 103-story skyscraper located in Midtown Manhattan, New York City, at the intersection of Fifth Avenue and West 34th Street.', 40.748704, -73.985707, 3],
  ['Metropolitan Museum of Art', '1000 5th Ave, New York, NY 10028', 'The Metropolitan Museum of Art, located in New York City, is the largest art museum in the United States and one of the ten largest in the world.', 40.779701, -73.963255, 4],
  ['Rockefeller Center', '45 Rockefeller Plaza, New York, NY 10111', 'Rockefeller Center is a complex of 19 commercial buildings covering 22 acres between 48th and 51st streets in New York City, United States.', 40.758980, -73.978685, 5],
  ['Museum of Modern Art', '11 W 53rd St, New York, NY 10019', 'The Museum of Modern Art is an art museum located in Midtown Manhattan in New York City between Fifth and Sixth Avenues.', 40.761656, -73.977601, 6]
];
googleMapGenerator.options.styles = [
  {
    featureType: 'road',
    elementType: 'geometry',
    stylers: [
      {
        lightness: 100
      },
      {
        visibility: 'simplified'
      }
    ]
  }, {
    featureType: 'landscape.man_made',
    elementType: 'geometry.fill',
    stylers: [
      {
        color: '#eceaed'
      }
    ]
  }, {
    featureType: 'landscape.natural',
    elementType: 'geometry.fill',
    stylers: [
      {
        color: '#78aa37'
      }
    ]
  }, {
    featureType: 'poi.park',
    elementType: 'geometry.fill',
    stylers: [
      {
        color: '#78aa37'
      }
    ]
  }, {
    featureType: 'water',
    elementType: 'geometry.fill',
    stylers: [
      {
        color: '#73a4e6'
      }
    ]
  }, {
    featureType: 'road',
    elementType: 'labels',
    stylers: [
      {
        visibility: 'off'
      }
    ]
  }
];

// Init
var map = new googleMapGenerator();