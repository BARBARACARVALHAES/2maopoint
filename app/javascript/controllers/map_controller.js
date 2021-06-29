import { Controller } from 'stimulus'; 
import mapboxgl from 'mapbox-gl';


export default class extends Controller {
  static targets = [ "select", "mapbox" ]

  connect() {
    this.markers = JSON.parse(this.mapboxTarget.dataset.markers)
    this.accessToken = this.mapboxTarget.dataset.mapboxApiKey
  }

  async selectUnit() {
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

    // example origin and destination
    // const start = {lat: markersUsers[0].lat, lng: markersUsers[0].lng}; 
    // const finish = {lat: selectedMarker.lat, lng: selectedMarker.lng};

    // const routes = await fetch(`https://api.mapbox.com/directions/v5/mapbox/driving/${start.lat},${start.lng};${finish.lat},${finish.lng}?alternatives=true&geometries=geojson&steps=true&access_token=${this.accessToken}`)
    //   .then(response => response.json())
    //   .then(data => data)


    // console.log(routes)

      // map.on('load', function () {
      //   map.addSource('route', {
      //     'type': 'geojson',
      //     'data': {
      //       'type': 'Feature',
      //       'properties': {},
      //       'geometry': {
      //         'type': 'LineString',
      //         'coordinates': routes.routes[0].geometry.coordinates
      //       }
      //     }
      //   });
      //   map.addLayer({
      //   'id': 'route',
      //   'type': 'line',
      //   'source': 'route',
      //   'layout': {
      //   'line-join': 'round',
      //   'line-cap': 'round'
      //   },
      //   'paint': {
      //   'line-color': '#888',
      //   'line-width': 8
      //   }
      //   });
      //   });

    fitMapToMarkers(map, markersUsers.concat(selectedMarker));
  }
}