import { Controller } from 'stimulus'; 
import mapboxgl from 'mapbox-gl';
import { initMapbox } from '../components/init_mapbox';


export default class extends Controller {
  static targets = [ "select", "mapbox" ]

  async connect() {
    this.markers = JSON.parse(this.mapboxTarget.dataset.markers)
    this.accessToken = this.mapboxTarget.dataset.mapboxApiKey
    // Wait for controller to connect before activate the function
    await initMapbox()
    this.clickablePopup()
  }

  async selectUnit() {
    const fitMapToMarkers = (map, markers) => {
      const bounds = new mapboxgl.LngLatBounds();
      markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
      map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
    };

    document.querySelector('.mapboxgl-canvas-container').innerHTML = ''
      
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    const markersUsers = JSON.parse(this.mapboxTarget.dataset.markersUsers);
      markersUsers.forEach((marker) => {
        new mapboxgl.Marker({
          color: "red",
        })
          .setLngLat([ marker.lng, marker.lat ])
          .addTo(map);
      });

    // Se a gente selecionou uma opção
    if(this.selectTarget.value) {
      const selectedMarker = this.markers.find(marker => marker.id === +this.selectTarget.value)
      this.mapboxTarget.dataset.markers = selectedMarker
      // Reset the markers on the map

      const popup = new mapboxgl.Popup().setHTML(selectedMarker.info_window);
      const el = document.createElement('div');
      el.setAttribute('class', 'mapboxgl-marker mapboxgl-marker-anchor-center marker-carrefour')
      el.setAttribute('id', this.selectTarget.value);
      el.style.backgroundImage = `url(${require('../../assets/images/marker-carrefour.png')})`;
      el.style.width = '40px';
      el.style.height = '25px';
      el.style.cursor = 'pointer';
      el.style.backgroundSize = 'cover';
      new mapboxgl.Marker(el)
        .setLngLat([ selectedMarker.lng, selectedMarker.lat ])
        .setPopup(popup) // add this
        .addTo(map);

      fitMapToMarkers(map, markersUsers.concat(selectedMarker));
    } else {
      // Seleciona só os 10 mais próximos
      const markersClose = this.markers.slice(0, 10)
      markersClose.forEach((marker) => {
      // Add carrefour unit ID to the marker
        const popup = new mapboxgl.Popup().setHTML(marker.info_window); // add this
        const el = document.createElement('div');
        el.setAttribute('class', 'mapboxgl-marker mapboxgl-marker-anchor-center marker-carrefour')
        el.setAttribute('id', marker.id);
        el.style.backgroundImage = `url(${require('../../assets/images/marker-carrefour.png')})`;
        el.style.width = '40px';
        el.style.height = '25px';
        el.style.cursor = 'pointer';
        el.style.backgroundSize = 'cover';
        new mapboxgl.Marker(el)
          .setLngLat([ marker.lng, marker.lat ])
          .setPopup(popup)
          .addTo(map);
      });
      
      fitMapToMarkers(map, markersClose);
    }
    this.clickablePopup()
  }

  clickablePopup() {
    const markers = document.querySelectorAll('.marker-carrefour')
    markers.forEach(marker => {
      marker.addEventListener('click', () => {
        this.selectTarget.value = marker.id
      })
    })
  }
}