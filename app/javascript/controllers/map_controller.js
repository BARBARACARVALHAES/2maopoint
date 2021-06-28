import { Controller } from 'stimulus'; 

export default class extends Controller {
  static targets = [ "select" ]

  selectUnit() {
    console.log(this.selectTarget.value)
  }
}