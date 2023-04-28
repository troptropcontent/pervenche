import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = [ "modal", "closeModalBtn" ]
  connect() {
  }

  open(e) {
    e.preventDefault()
    this.modalTarget.style.display = "block";
  }
  close(e) {
    this.modalTarget.style.display = "none";
  }
}
