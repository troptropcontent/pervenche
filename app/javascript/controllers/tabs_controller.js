import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = [ "content" ]
  connect() {
  }

  showContent({params: {id}}) {
    const contentToShow = this.contentTargets.find(content => content.id === `tabs_${id}`)
    const contentsToHide = this.contentTargets.filter(content => content.id !== `tabs_${id}`)
    contentsToHide.forEach(content => {
      content.classList.add("visually-hidden");
    });
    contentToShow.classList.remove("visually-hidden")
  }
}
