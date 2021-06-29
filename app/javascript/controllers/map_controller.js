import { Controller } from 'stimulus'; 
import mapboxgl from 'mapbox-gl';


export default class extends Controller {
  static targets = [ "select", "mapbox" ]

  connect() {
    this.markers = JSON.parse(this.mapboxTarget.dataset.markers)
  }

  selectUnit() {
    const selectedMarker = this.markers.find(marker => marker.id === +this.selectTarget.value)
    this.mapboxTarget.dataset.markers = selectedMarker
    // Reset the markers on the map
    document.querySelector('.mapboxgl-canvas-container').innerHTML = ''

    const fitMapToMarkers = (map, markers) => {
      const bounds = new mapboxgl.LngLatBounds();
      markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
      map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
    };
    
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    new mapboxgl.Marker()
      .setLngLat([ selectedMarker.lng, selectedMarker.lat ])
      .addTo(map);

    const markersUsers = JSON.parse(this.mapboxTarget.dataset.markersUsers);
    markersUsers.forEach((marker) => {
      new mapboxgl.Marker({
        color: "red",
      })
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(map);
    });

    const popup = new mapboxgl.Popup().setHTML(selectedMarker.info_window);

    new mapboxgl.Marker()
      .setLngLat([ selectedMarker.lng, selectedMarker.lat ])
      .setPopup(popup) // add this
      .addTo(map);

    fitMapToMarkers(map, markersUsers.concat(selectedMarker));
  }
}