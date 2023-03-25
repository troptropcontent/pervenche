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
      hiddenInputValue.forEach((value) => {
        createNewHiddenInput(hiddenInputName, value)
      })
    } else {
      createNewHiddenInput(hiddenInputName, hiddenInputValue)
    }
  }

  toggleSubmitButtonLoading() {
    this.inputButtonContentTarget.classList.add("visually-hidden")
    this.loaderTarget.classList.remove("visually-hidden")
  }

  createAssociatedHiddenInputs(input) {
    const inputObject = JSON.parse(input.dataset.formAssociatedHiddenInputs)
    Object.entries(inputObject).forEach ( ([key, value]) => {
      console.log({key, value})
      this.addHiddenInputs(value, key)
      }
    )
  }

  addAssociatedHiddenInputsToData () { 
    const checkedElements = this.inputWithAssociatedHiddenInputTargets.filter(el => el.attributes.getNamedItem('checked') || el.checked)
    console.log({checkedElements})
    checkedElements.forEach((input) => {
      this.createAssociatedHiddenInputs(input)
    })
  }
}
