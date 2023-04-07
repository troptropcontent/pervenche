import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clickable-svg"
export default class extends Controller {
  static targets = [ "clickable", 'image' ]
  connect() {
  }

  toggleCheckedAttribute(event) {
    const clickables = this.clickableTargets
    const group = clickables.find(group => group.id === event.params.groupId )
    const image = this.imageTarget
    const is_checked = !!group.attributes.checked
    if (is_checked) {
      image.insertBefore(group, image.children[0])
      group.removeAttribute('checked')
    } else {
      image.insertBefore(group, null)
      group.setAttribute('checked', '')
    }

  }
}
