import { Controller } from 'stimulus'; 

export default class extends Controller {
  static targets = [ "select", "mapbox" ]

  selectUnit() {
    console.log(this.selectTarget.value)
    console.log(this.mapboxTarget)
  }
}