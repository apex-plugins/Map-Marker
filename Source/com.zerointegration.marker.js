/*
 * 0integration Map Marker
 * Plug-in Type: Region
 * Summary: Google map marker cluster region plugin used to display location marker cluster on google map.
 *
 * ^^^ Contact information ^^^
 * Developed by 0integration
 * http://www.zerointegration.com
 * apex@zerointegration.com
 *
 * ^^^ License ^^^
 * Licensed Under: GNU General Public License, version 3 (GPL-3.0) -
http://www.opensource.org/licenses/gpl-3.0.html
 *
 * @author Kartik Patel - kartik.patel@zerointegration.com
 */
 
var markerClusterer = null;
var map = null;
var imageUrl = 'http://chart.apis.google.com/chart?cht=mm&chs=24x32&' +
          'chco=FFFFFF,008CFF,000000&ext=.png';
// Enable the visual refresh
google.maps.visualRefresh = true;

function refreshMap() {

  if (markerClusterer) {
          markerClusterer.clearMarkers();}
          
  var marker_arr=new Array();
  var markers = [];
  var markerImage = new google.maps.MarkerImage(imageUrl,new google.maps.Size(24, 32));
  var markers=new Array();
  var gData=JSON.parse($("div.map-data").html());
  
  if (gData.loc.length>0)
  {
    for (i = 0; i < gData.loc.length; i++) {
  	  marker_arr[i] = {lat: gData.loc[i].lat, lng: gData.loc[i].lng, desc:gData.loc[i].info};
    }
  }
  else
  {
  	alert($("div.no-data-found").html());
  }
  
  // Create the markers ad infowindows.
  for (index in marker_arr) 
    addMarker(marker_arr[index]);
    
  function addMarker(data) {
    
    var latLng = new google.maps.LatLng(data.lat,data.lng)
      var marker = new google.maps.Marker({
       position: latLng,
       icon: markerImage
      });
    
    // Create the infowindow with two DIV placeholders
    // One for a text string, the other for the StreetView panorama.
    var content = document.createElement("DIV");
    var title = document.createElement("DIV");
    var description = document.createElement("DIV");
    description.innerHTML = data.desc;
    content.appendChild(title);
    content.appendChild(description);
    var infowindow = new google.maps.InfoWindow({
    content: content
    });
    
    // Open the infowindow on marker click
    google.maps.event.addListener(marker, "click", function() {
      infowindow.open(map, marker);
    });
    
    markers.push(marker);
    
    }
    
    var zoom = null;
    var size = null;

    markerClusterer = new MarkerClusterer(map, markers, {
      maxZoom: zoom,
      gridSize: size
    });

    // onClick OVERRIDE
    markerClusterer.onClick = function(clickedClusterIcon) { 
    return multiChoice(clickedClusterIcon.cluster_);
    }
    
    // Zoom and center the map to fit the markers
    // This logic could be conbined with the marker creation.
    // Just keeping it separate for code clarity.
    var bounds = new google.maps.LatLngBounds();
    for (index in marker_arr) {
      var data = marker_arr[index];
      bounds.extend(new google.maps.LatLng(data.lat, data.lng));
    }
    map.fitBounds(bounds);
}    

function initialize() {
  map = new google.maps.Map(document.getElementById('map-canvas'), {
    zoom: 12,
    center: new google.maps.LatLng(0,0),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });
refreshMap();
}

function clearClusters(e) {
  e.preventDefault();
  e.stopPropagation();
  markerClusterer.clearMarkers();
}

google.maps.event.addDomListener(window, 'load', initialize);