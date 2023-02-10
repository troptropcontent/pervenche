import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "loadable" ]
  connect() {
  }
  toggleLoading() {
    this.loadableTarget.innerHTML = '<div class="loader--ring"><div></div><div></div><div></div><div></div></div>'
  }
}
