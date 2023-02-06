import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="checkbox"
export default class extends Controller {
  connect() {
    
  }

  submitForm() {
    fetch(this.element.action, {
      method: this.element.method,
      body: new FormData(this.element),
    })
  }
}
