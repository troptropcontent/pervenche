import { Controller } from "@hotwired/stimulus";
import * as XLSX from 'xlsx';

export default class extends Controller {

  static targets = [ "rowTemplate", "tBody", "dataRow", "footerCount"]
  connect() {
    this.token = document.querySelector(
      'meta[name="csrf-token"]'
    ).content;
  }

  deliverEmails (event) {
    event.preventDefault()
    const {params: {url}} = event
    const requestDeliverEmail = ({to, ...template_data}) => {
      fetch((url), {
        method: 'POST',
        headers: {
          'X-CSRF-Token': this.token,
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin',
        body: JSON.stringify({template: {to, template_data}})}).then (response => response.text())
      .then(html => console.log(html));
    }

    const buildRequestDataFromRow = ({cells}) => {
      const data = [...cells].reduce(
        (accumulator, {dataset: {fieldName}, innerText}) => (accumulator[fieldName] = innerText) && accumulator,
        {}
        );
        return data 
    }

    this.dataRowTargets.forEach( row => {
      const data = buildRequestDataFromRow(row)
      requestDeliverEmail(data)
     
      row.classList.add("table-fillable-with-csv-component__row--completed")
      }
    )
  }
  useCsvFile({target: {files}}) {
    // Deletes any already present dataRows
    this.dataRowTargets.forEach(data_row => data_row.remove())

    // Retrieve the file that we have to parse
    const file = files[0];

    // Change the raw data into an HTML element that can be injected
    const rehydratedRow = (rowData) => {
      const newRow = this.rowTemplateTarget.content.firstElementChild.cloneNode(true) 
      const newRowHtml = newRow.innerHTML.replace(/{{([a-z_]*)}}/gi, (match, placeholder) => rowData[placeholder] || "")
      newRow.innerHTML = newRowHtml
      return newRow
    }

    // Parse the data from the file, translate each row into an HTML row and inject it into the file
    const fillRows = data => {
      const workBook = XLSX.read(data, {raw:true})
      const rows = XLSX.utils.sheet_to_json(workBook.Sheets[workBook.SheetNames[0]])
      const newHtmlRows = document.createDocumentFragment()
      rows.forEach(row => newHtmlRows.appendChild(rehydratedRow(row)))
      this.footerCountTarget.innerText = newHtmlRows.childElementCount
      this.tBodyTarget.appendChild(newHtmlRows)
    }

    file.arrayBuffer().then(fillRows)
  }
}





