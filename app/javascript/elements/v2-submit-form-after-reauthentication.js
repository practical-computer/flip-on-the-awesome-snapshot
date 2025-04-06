import {getReauthenticationToken} from '@practical-computer/practical-framework/js/handlers/passkey-reauthentication-handler';

async function submitFormEvent(event){
  event.preventDefault()
  event.stopImmediatePropagation()
  let form = event.currentTarget
  await getReauthenticationToken(form)

  window.mrujs.fetch(form.action, {
    submitter: form,
    dispatchEvents: true,
    body: new FormData(form),
    method: form.method,
    headers: {
      "Accept": "application/json"
    }
  })
}

class SubmitFormAfterReauthenticationElement extends HTMLElement {
  constructor() {
    super();
  }

  connectedCallback() {
    if(!this.isConnected){ return }
    this.form.addEventListener(`submit`, submitFormEvent)
  }

  get form() {
    return this.querySelector(`:scope form`)
  }
}

if (!window.customElements.get('submit-form-after-reauthentication')) {
  window.SubmitFormAfterReauthenticationElement = SubmitFormAfterReauthenticationElement;
  window.customElements.define('submit-form-after-reauthentication', SubmitFormAfterReauthenticationElement);
}