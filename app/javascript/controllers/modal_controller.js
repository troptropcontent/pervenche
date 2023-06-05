import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = [ "modal", "closeModalBtn" ]
  connect() {
  }

  open(e) {
    const {id: modal_id} = e.params
    const modal = this.findModal(modal_id)
    e.preventDefault()
    modal.style.display = "block";
  }

  close(e) {
    const {id: modal_id} = e.params
    const modal = this.findModal(modal_id)
    e.preventDefault()
    modal.style.display = "none";
  }

  findModal(modal_id) {
    return this.modalTargets.find(modal => modal.id === modal_id)
  }
}
