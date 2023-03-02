import { Controller } from "@hotwired/stimulus"
import intlTelInput from 'intl-tel-input';

// Connects to data-controller="phone-input"
export default class extends Controller {
  static targets = [ "input" ]
  connect() {
    intlTelInput(this.inputTarget, {
      initialCountry: 'fr', 
      utilsScript: "https://cdnjs.cloudflare.com/ajax/libs/intl-tel-input/17.0.19/js/utils.min.js",
      hiddenInput: "username"
    })
  }
}
