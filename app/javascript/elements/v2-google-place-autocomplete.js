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

const disableEnterToSubmitEvent = async function(event) {
  if(event.key == "Enter") {
    event.preventDefault();
    return false;
  }
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
    this.inputElement.addEventListener(`keydown`, disableEnterToSubmitEvent)

    this.initializeValue()
  }

  updateAddressConfirmationMessage() {
    const hasData = (this?.googlePlace?.formatted_address != undefined)
    if(hasData && this.googlePlace.formatted_address.toString().trim() != "") {
      this.formattedAddressElement.innerText = this.googlePlace.formatted_address
    } else {
      this.formattedAddressElement.innerText = ""
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
    if(!this.value){ return }
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

  disconnectedCallback(){}
}

if (!window.customElements.get('google-place-autocomplete')) {
  window.GooglePlaceAutocomplete = GooglePlaceAutocomplete;
  window.customElements.define('google-place-autocomplete', GooglePlaceAutocomplete);
}