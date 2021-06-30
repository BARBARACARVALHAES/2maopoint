import mapboxgl from 'mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  const fitMapToMarkers = (map, markers) => {
    const bounds = new mapboxgl.LngLatBounds();
    markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
    map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
  };

  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    const markers = JSON.parse(mapElement.dataset.markers);
    // Seleciona só os 10 mais próximos
    const markersClose = markers.slice(0, 10)

    const markersUsers = JSON.parse(mapElement.dataset.markersUsers);
    markersUsers.forEach((marker) => {
      if(marker.current) {
        var popup = new mapboxgl.Popup()
        .setText('Você està aqui')
        .addTo(map);
      }

      new mapboxgl.Marker({
        color: marker.current ? 'red' : 'purple',
      })
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(map)
        .setPopup(popup)
    });
  
    const addMarkersToMap = (map, markers) => {
      markers.forEach((marker) => {
        const el = document.createElement('div');
        el.setAttribute('class', 'mapboxgl-marker mapboxgl-marker-anchor-center marker-carrefour')
        el.setAttribute('id', marker.id);
        el.style.backgroundImage = `url(${require('../../assets/images/marker-carrefour.png')})`;
        el.style.width = '40px';
        el.style.height = '25px';
        el.style.cursor = 'pointer';
        el.style.backgroundSize = 'cover';
        const popup = new mapboxgl.Popup().setHTML(marker.info_window); // add this
    
        new mapboxgl.Marker(el)
          .setLngLat([ marker.lng, marker.lat ])
          .setPopup(popup) // add this
          .addTo(map);
      });
    };

    fitMapToMarkers(map, markersClose.concat(markersUsers));
    addMarkersToMap(map, markersClose)
  }
};

export { initMapbox };