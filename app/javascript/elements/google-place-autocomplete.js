const markAsDirtyEventHandler = async function(event) {
  this.markAsDirty()
}

const blurEventHandler = async function(event) {
  const autocompleteElement = event.target.closest(`google-place-autocomplete`)
  if(!autocompleteElement.dirty){ return }

  if(event.target.value.trim() == ""){
    autocompleteElement.googlePlace = null
    autocompleteElement.internals_.setFormValue(null, autocompleteElement.inputElement.value)
  }
  autocompleteElement.updateFormValue()
  autocompleteElement.updateAddressConfirmationMessage()
}

class GooglePlaceAutocomplete extends HTMLElement {
  static formAssociated = true;

  constructor() {
    super();
    this.internals_ = this.attachInternals();
  }

  async connectedCallback() {
    if(!this.isConnected){ return }

    if(!this.inputElement){
      this.insertInputElement()
    }

    const {Autocomplete} = await google.maps.importLibrary("places")
    this.autocompleteInstance = new Autocomplete(this.inputElement, {
      componentRestrictions: { country: "us" },
      fields: ["place_id", "formatted_address"],
      strictBounds: false,
    })

    this.autocompleteInstance.addListener("place_changed", () => {
      this.googlePlace = this.autocompleteInstance.getPlace()
      this.updateFormValue()
      this.updateAddressConfirmationMessage()
    })

    this.addEventListener(`input`, markAsDirtyEventHandler)
    this.inputElement.addEventListener(`blur`, blurEventHandler)

    this.initializeValue()
  }

  updateAddressConfirmationMessage() {
    if(this.googlePlace && this.googlePlace.formatted_address.toString().trim() != "") {
      this.formattedAddressElement.innerText = this.googlePlace.formatted_address
      this.showAddressPopoverButtons.forEach(element => { element.removeAttribute(`disabled`) })
    } else {
      this.formattedAddressElement.innerText = ""
      this.showAddressPopoverButtons.forEach(element => { element.setAttribute(`disabled`, true) })
    }
  }

  markAsDirty() {
    this.dirty = true
  }

  updateFormValue() {
    if(this.googlePlace){
      const googlePlaceJSON = JSON.stringify(this.googlePlace)
      this.internals_.setFormValue(googlePlaceJSON, this.inputElement.value)
    } else {
      this.internals_.setFormValue(null, this.inputElement.value)
    }
  }


  initializeValue(){
    if(this.value.toString().trim() != ""){
      const googlePlaceData = JSON.parse(this.value)
      this.googlePlace = googlePlaceData
      this.updateAddressConfirmationMessage()
      this.updateFormValue()
    }
  }

  insertInputElement() {
    const element = document.createElement(`input`)
    element.dataset.autocompleteElement = true
    this.appendChild(element)
  }

  get value() {
    return this.getAttribute(`value`)
  }

  get inputElement(){
    return this.querySelector(`input[data-autocomplete-element]`)
  }

  get formattedAddressElement() {
    return this.querySelector(`slot[name="formatted_address"]`)
  }

  get showAddressPopoverButtons() {
    const popoverID = this.querySelector(`[popover][address-confirmation-popover]`).id
    return document.querySelectorAll(`[popovertarget="${popoverID}"`)
  }

  disconnectedCallback(){}
}

if (!window.customElements.get('google-place-autocomplete')) {
  window.GooglePlaceAutocomplete = GooglePlaceAutocomplete;
  window.customElements.define('google-place-autocomplete', GooglePlaceAutocomplete);
} 