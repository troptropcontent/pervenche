import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="subscription"
export default class extends Controller {
  connect() {
    const chargebeeSite = document.querySelector("meta[name='chargebee-site']").getAttribute("content")
    this.chargebeeInstance = window.Chargebee.init({ site: chargebeeSite, publishableKey: "test_23H5MhieHi11mEpcsSz1SgVUhcjRozZH" })
  }

  openCheckoutNew(e) {
    e.preventDefault()
    const planId = e.target.dataset.planId
    const hostedPageData = e.target.dataset.hostedPageData
    const hostedPageDataPromise = new Promise((resolve, reject) => {resolve(JSON.parse(hostedPageData));})
    
    this.chargebeeInstance.openCheckout({
      hostedPage: () => hostedPageDataPromise,
      error: (e) => {
        console.log(e)
      }
    })
  }
}
