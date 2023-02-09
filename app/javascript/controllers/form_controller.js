import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "hiddenInput" ]
  connect() {
  }
  updateHiddenInput({ params: {hiddenInputValue} }) {
    this.hiddenInputTarget.value = hiddenInputValue
  }
}
