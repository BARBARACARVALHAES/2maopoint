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
    // Seleciona só os 3 mais próximos
    const markersClose = markers.length > 3 ? markers.slice(0, 3) : markers

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
    addMarkersToMap(map, markersClose);

    // Draw routes
    const drawRoutes = async () => {
      const selectedMarker = JSON.parse(mapElement.dataset.markers)[0]

      const responseSeller = await fetch(`https://api.mapbox.com/directions/v5/mapbox/driving/${markersUsers[0].lng},${markersUsers[0].lat};${selectedMarker.lng},${selectedMarker.lat}?geometries=geojson&access_token=${mapElement.dataset.mapboxApiKey }`)
          .then(response => response.json())
  
      const responseBuyer = await fetch(`https://api.mapbox.com/directions/v5/mapbox/driving/${markersUsers[1].lng},${markersUsers[1].lat};${selectedMarker.lng},${selectedMarker.lat}?geometries=geojson&access_token=${mapElement.dataset.mapboxApiKey }`)
        .then(response => response.json())
  
      // Add path and labels on the map
      map.on('load', function () {        
        map.addLayer({
          'id': 'routeSeller',
          'type': 'line',
          'source': {
            'type': 'geojson',
            'data': {
              'type': 'Feature',
              'properties': {},
              'geometry': {
                'type': 'LineString',
                'coordinates': responseSeller.routes[0].geometry.coordinates
              }
            }
          },
          'paint': {
            'line-width': 2,
            'line-color': markersUsers[0].current ? 'red' : 'purple'
          },
        });
  
        map.addLayer({
          'id': 'routeBuyer',
          'type': 'line',
          'source': {
            'type': 'geojson',
            'data': {
              'type': 'Feature',
              'properties': {},
              'geometry': {
                'type': 'LineString',
                'coordinates': responseBuyer.routes[0].geometry.coordinates
              }
            }
          },
          'paint': {
            'line-width': 2,
            'line-color': markersUsers[1].current ? 'red' : 'purple'
          }
        });
  
        map.addLayer({
          'id': 'label-route-seller',
          'type': 'symbol',
          'source': {
            'type': 'geojson',
            'data': {
              'type': 'Feature',
              'properties': {
                'distance': `${Math.round(responseSeller.routes[0].distance / 100) / 10} km - ${Math.round(responseSeller.routes[0].duration / 60)} min`,
                'icon': 'car-15'
              },
              'geometry': {
                'type': 'Point',
                // middle of the array
                'coordinates': responseSeller.routes[0].geometry.coordinates[Math.floor(responseSeller.routes[0].geometry.coordinates.length / 2)]
              }
            }
          },
          'layout': {
            'text-field': ['get', 'distance'],
            'text-variable-anchor': ['top', 'bottom', 'left', 'right'],
            'text-radial-offset': 0.5,
            'text-justify': 'auto',
            'icon-image': ['get', 'icon'],
            'icon-size': 1.5
          },
          'paint': {
            "text-halo-color": "white",
            "text-halo-width": 5
          }
        });
  
        map.addLayer({
          'id': 'label-route-buyer',
          'type': 'symbol',
          'source': {
            'type': 'geojson',
            'data': {
              'type': 'Feature',
              'properties': {
                'distance': `${Math.round(responseBuyer.routes[0].distance / 100) / 10} km - ${Math.round(responseBuyer.routes[0].duration / 60)} min`,
                'icon': 'car-15'
              },
              'geometry': {
                'type': 'Point',
                // middle of the array
                'coordinates': responseBuyer.routes[0].geometry.coordinates[Math.floor(responseBuyer.routes[0].geometry.coordinates.length / 2)]
              }
            }
          },
          'layout': {
            'text-field': ['get', 'distance'],
            'text-variable-anchor': ['top', 'bottom', 'left', 'right'],
            'text-radial-offset': 0.5,
            'text-justify': 'auto',
            'icon-image': ['get', 'icon'],
            'icon-size': 1.5
          },
          'paint': {
            "text-halo-color": "white",
            "text-halo-width": 5,
          }
        });
      });
    }


    if(mapElement.hasAttribute('data-draw-routes')) {
      drawRoutes()
    }
    
  }
};

export { initMapbox };