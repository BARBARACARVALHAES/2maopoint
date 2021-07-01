import { Controller } from 'stimulus'; 
import mapboxgl from 'mapbox-gl';


export default class extends Controller {
  static targets = [ "select", "mapbox", 'text', 'h1' ]

  connect() {
    this.markers = JSON.parse(this.mapboxTarget.dataset.markers)
    this.accessToken = this.mapboxTarget.dataset.mapboxApiKey
    this.defaultText = this.textTarget.innerHTML
    this.defaultH1 = this.h1Target.innerText
    // Wait for controller to connect before activate the function
    setTimeout(() => {
      this.clickablePopup()
    }, 500);
  }

  async selectUnit() {
    const fitMapToMarkers = (map, markers) => {
      const bounds = new mapboxgl.LngLatBounds();
      markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
      map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
    };

    // Reset the markers on the map
    document.querySelector('.mapboxgl-canvas-container').innerHTML = ''
      
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10'
    });

    let markersUsers = JSON.parse(this.mapboxTarget.dataset.markersUsers);
    markersUsers = markersUsers.filter(marker => marker.lat && marker.lng)
      markersUsers.forEach((marker) => {
        if(marker.current) {
          var popup = new mapboxgl.Popup()
          .setText('Você està aqui')
          .addTo(map);
        }
        if(marker.hasOwnProperty('lng') && marker.hasOwnProperty('lat')) {
          new mapboxgl.Marker({
            color: marker.current ? 'red' : 'purple',
          })
            .setLngLat([ marker.lng, marker.lat ])
            .addTo(map)
            .setPopup(popup)
        }
      });

    // Se a gente selecionou uma opção
    if(this.selectTarget.value) {
      const selectedMarker = this.markers.find(marker => marker.id === +this.selectTarget.value)

      this.mapboxTarget.dataset.markers = selectedMarker

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

      const markersAll = markersUsers.concat(selectedMarker)

      fitMapToMarkers(map, markersAll);

      // Se o primeiro usuario tem lng and lat
      if(markersUsers.length > 0 && markersUsers[0].hasOwnProperty('lng') && markersUsers[0].hasOwnProperty('lat')) {
        const responseSeller = await fetch(`https://api.mapbox.com/directions/v5/mapbox/driving/${markersUsers[0].lng},${markersUsers[0].lat};${selectedMarker.lng},${selectedMarker.lat}?geometries=geojson&access_token=${this.accessToken }`)
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
        });  
      }

      // Se o segundo usuario tem lng and lat
      if (markersUsers.length > 1 && (markersUsers[1].hasOwnProperty('lng') && markersUsers[1].hasOwnProperty('lat'))) {
        const responseBuyer = await fetch(`https://api.mapbox.com/directions/v5/mapbox/driving/${markersUsers[1].lng},${markersUsers[1].lat};${selectedMarker.lng},${selectedMarker.lat}?geometries=geojson&access_token=${this.accessToken }`)
        .then(response => response.json())

        // Add path and labels on the map
        map.on('load', function () {        
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

      // Change text at the top of the page
      this.changeText()
    } 
    // Se nada for selecionado botamos de novo as 10 opções mais próximas
    else 
    {
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
      
      // Put default text
      this.textTarget.innerHTML = this.defaultText
      this.h1Target.innerText = this.defaultH1
    
    }
    this.clickablePopup()
  }

  changeText() {
    // Change text at the top of the page
    const optionArray = []
    document.querySelectorAll('option').forEach(option => {
      if(option.value == this.selectTarget.value) {
        optionArray.push(option) 
      }
    })
    this.textTarget.innerHTML = `<b>${optionArray[0].innerText}</b> que fica em <b>${optionArray[0].dataset.address}</b>`
    this.h1Target.innerText = 'Você escolheu'
  }

  clickablePopup() {
    const markers = document.querySelectorAll('.marker-carrefour')
    markers.forEach(marker => {
      marker.addEventListener('click', () => {
        this.selectTarget.value = marker.id

        setTimeout(() => this.changeText(), 200)
      })
    })
  }
}