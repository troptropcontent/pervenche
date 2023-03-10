import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "hiddenInputs", "hiddenInputsGroup", "inputButton", "loader", "inputButtonContent", "inputWithAssociatedHiddenInput" ]
  connect() {
  }
  updateHiddenInput({ params: {hiddenInputValue, hiddenInputName} }) {
    const createNewHiddenInput = (name, value) => {
      let input = document.createElement("input");
      input.setAttribute("type", "hidden");
      input.setAttribute("name", name);
      input.setAttribute("value", value);
      input.dataset.formTarget = 'hiddenInputs'
      this.hiddenInputsGroupTarget.appendChild(input);
    }
    if (Array.isArray(hiddenInputValue)) {
      hiddenInputName.slice(-2) != '[]' && (hiddenInputName = hiddenInputName + '[]')
      const hidden_inputs = this.hiddenInputsTargets.filter((hidden_input) => hidden_input.name === hiddenInputName)  
      hidden_inputs.forEach((hidden_input) => hidden_input.remove())
      hiddenInputValue.forEach((value) => {
        createNewHiddenInput(hiddenInputName, value)
      })
    } else {
      const hidden_input = this.hiddenInputsTargets.find((hidden_input) => hidden_input.name === hiddenInputName)  
      hidden_input.remove()
      createNewHiddenInput(hiddenInputName, hiddenInputValue)
    }
  }
  addHiddenInputs(hiddenInputValue, hiddenInputName) {
    const createNewHiddenInput = (name, value) => {
      let input = document.createElement("input");
      input.setAttribute("type", "hidden");
      input.setAttribute("name", name);
      input.setAttribute("value", value);
      input.dataset.formTarget = 'hiddenInputs'
      this.hiddenInputsGroupTarget.appendChild(input);
    }
    if (Array.isArray(hiddenInputValue)) {
      hiddenInputName.slice(-2) != '[]' && (hiddenInputName = hiddenInputName + '[]')
      const hidden_inputs = this.hiddenInputsTargets.filter((hidden_input) => hidden_input.name === hiddenInputName)  
      hidden_inputs && hidden_inputs.forEach((hidden_input) => hidden_input.remove())
      hiddenInputValue.forEach((value) => {
        createNewHiddenInput(hiddenInputName, value)
      })
    } else {
      const hidden_input = this.hiddenInputsTargets.find((hidden_input) => hidden_input.name === hiddenInputName)  
      hidden_input && hidden_input.remove() 
      createNewHiddenInput(hiddenInputName, hiddenInputValue)
    }
  }

  toggleSubmitButtonLoading() {
    this.inputButtonContentTarget.classList.add("visually-hidden")
    this.loaderTarget.classList.remove("visually-hidden")
  }

  addAssociatedHiddenInputsToData (e) {
    this.inputWithAssociatedHiddenInputTargets.filter(input => input.checked).forEach((input) => {
      this.addHiddenInputs(input.dataset.formHiddenInputValueParam, input.dataset.formHiddenInputNameParam)
    })
  }
}
