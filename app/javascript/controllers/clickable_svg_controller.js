import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clickable-svg"
export default class extends Controller {
  static targets = [ "clickable", 'image' ]
  connect() {
    this.multiselect = this.element.dataset.clickableSvgMultiselectParam === 'true'
  }

  toggleCheckedAttribute(event) {

    const clickables = this.clickableTargets
    const alreadyCheckedGroups = clickables.filter(group => group.attributes.getNamedItem('checked') || group.checked)
    
    console.log({alreadyCheckedGroups})
    const group = clickables.find(group => group.id === event.params.groupId )
    const image = this.imageTarget

    const checkClickable = (group) => {
      image.insertBefore(group, null)
      group.setAttribute('checked', '')
    }
    const unCheckClickable = (group) => {
      image.insertBefore(group, image.children[0])
      group.removeAttribute('checked')
    }

    const is_checked = !!group.attributes.checked
    if (is_checked) {
      unCheckClickable(group)
    } else {
      checkClickable(group)
      !this.multiselect && alreadyCheckedGroups.map(group => unCheckClickable(group))
    }
  }
}
